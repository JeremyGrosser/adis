--=============================================================================
--                                UNCLASSIFIED
--
-- *==========================================================================*
-- |                                                                          |
-- |                       Manned Flight Simulator                            |
-- |               Naval Air Warfare Center Aircraft Division                 |
-- |                       Patuxent River, Maryland                           |
-- *==========================================================================*
--
--=============================================================================
--
-- Package Name:       Hashing
--
-- File Name:          Hashing_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 23, 1994
--
-- Purpose:
--
--  Contains units to add, delete and get records from an unbounded hash table.
--  Collisions are handled via a linked list of all the items which hash to the
--  same cell.
--	
-- Effects:
--   None
--
-- Exceptions:
--   None
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--=============================================================================	

with DL_Status,
     DIS_Types,
     Generic_List,
     Generic_List_Utilities,
     Numeric_Types;

package Hashing is

   K_Maximum_Table_Size : constant INTEGER := 1000;

   type POSITION_OFFSETS is
     record
       X : Numeric_Types.FLOAT_64_BIT;
       Y : Numeric_Types.FLOAT_64_BIT;
       Z : Numeric_Types.FLOAT_64_BIT;
     end record;

  type VELOCITY_OFFSETS is
     record
       X : Numeric_Types.FLOAT_32_BIT;
       Y : Numeric_Types.FLOAT_32_BIT;
       Z : Numeric_Types.FLOAT_32_BIT;
     end record;

   type VECTOR_OFFSETS is
     record
        Position : POSITION_OFFSETS;
        Velocity : VELOCITY_OFFSETS;
     end record;
      

   type ENTITY_STATE_INFORMATION is
     record

        -- DIS entity identifier
        Identifier         : DIS_Types.AN_ENTITY_IDENTIFIER;

        -- The stored position from which dead-reckoning will be calculated.
        Position           : DIS_Types.A_WORLD_COORDINATE;

        -- The position currently displayed on the screen.
        Displayed_Position : DIS_Types.A_WORLD_COORDINATE;
     
        -- The stored velocity from which dead-reckoning will be calculated.
        Velocity           : DIS_Types.A_LINEAR_VELOCITY_VECTOR; 
    
        -- Orientation of the last output which is used to determine if the 
        -- entity has changed course from the last update which would allow 
        -- for the current position to be less than the displayed position.
        Orientation        : DIS_Types.AN_EULER_ANGLES_RECORD; 

        -- Used to incrementally smooth the data.  
        Offsets            : VECTOR_OFFSETS;

        -- The number of timeslices the offsets should be added.
        Smooth_Timeslices  : INTEGER;

        -- The number of timeslices since the last Entity State PUD was received. 
        Timeslices         : INTEGER; 

        -- Flag that when set TRUE means that the currently displayed poistion
        -- is greater than the actualy position from the last Entity State PDU.
        Overshot           : BOOLEAN;

        -- Flag that when set TRUE means that the velocity changed between 
        -- Entity State PDU receipt and the last dead-reckoned position.
        Velocity_Changed   : BOOLEAN; 

     end record;  

   type ENTITY_STATE_INFO_PTR is access ENTITY_STATE_INFORMATION;

   package Hash_List is new Generic_List (
      ITEM                => ENTITY_STATE_INFO_PTR);

   function Less_Than(
      Item_1 : in ENTITY_STATE_INFO_PTR;
      Item_2 : in ENTITY_STATE_INFO_PTR)
   return BOOLEAN;

   package Hash_List_Utilities is new Generic_List_Utilities(
      ITEM             => ENTITY_STATE_INFO_PTR, 
      PTR              => Hash_List.PTR,
      Change_Item      => Hash_List.Change_Item,
      Clear_List       => Hash_List.Clear_List,
      Clear_Previous   => Hash_List.Clear_Previous,
      Clear_Next       => Hash_List.Clear_Next,
      Clear_Node       => Hash_List.Clear_Node,
      Construct_Bottom => Hash_List.Construct_Bottom,
      Construct_Top    => Hash_List.Construct_Top,
      Copy             => Hash_List.Copy,
      Free             => Hash_List.Free,
      Set_Head         => Hash_List.Set_Head,
      Swap_Tail        => Hash_List.Swap_Tail,
      Is_Equal         => Hash_List.Is_Equal,
      Is_Null          => Hash_List.Is_Null,
      Length_Of        => Hash_List.Length_Of,
      Predecessor_Of   => Hash_List.Predecessor_Of,
      Tail_Of          => Hash_List.Tail_Of,
      Value_Of         => Hash_List.Value_Of,
      "<"              => Less_Than);

  
   -- Create an array of pointers to linked list.  If an item hashes to the same
   -- address (array index) as an already stored item, it will be added to the 
   -- end of the linked list.
   type HASH_TABLE is array (1..K_Maximum_Table_Size) 
     of Hash_List.PTR;

   --
   -- GLOBAL DATA
   --
   Entity_State_History : HASH_TABLE;

   Initialize_Vector_Offsets : VECTOR_OFFSETS
                                := (Position => (X => 0.0,
                                                 Y => 0.0,
                                                 Z => 0.0),
                                    Velocity => (X => 0.0,
                                                 Y => 0.0,
                                                 Z => 0.0));
   
   --==========================================================================
   -- ADD_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Inserts a new node with an entity's location data into the hash table.
   --
   --   Input Parameters:
   --
   --     Entity_State_PDU - Contains the information about the entity needed
   --                        to store the location information into the hash 
   --                        table.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.  
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.ADD_ITEM_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the 
   --              failed routine will be returned.
   --  
   --
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Add_Item(
      Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status           :    out DL_Status.STATUS_TYPE); 

   --==========================================================================
   -- DELETE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Deletes the entity from the Hash Table.
   --
   --   Input Parameters:
   --
   --     Entity_State_PDU - Contains the information about the entity needed
   --                        to delete entity from the hash table.
   --
   --
   --   Output Parameters:
   --
   --    Status - Indicates whether this unit encountered an error condition. 
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   -- 
   --              DL_Status.ITEM_NOT_FOUND - Indicates that the entity state 
   --              information record was not found.
   --
   --              DL_Status.DELETE_FREE_FAILURE - Indicates an exception was
   --              raised in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the 
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Delete_Item(
      Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status           :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GET_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Retrieves the pointer to the desired record of entity state information.
   --
   --   Input Parameters:
   --
   --     Entity Identifier - Represents the unique identifer for a DIS entity,
   --                         consisting of the Site ID, Application ID and 
   --                         Entity ID.
   --
   --   Output Parameters:
   --
   --     Location_Data - A pointer to the stored entity location information record.
   --
   --     Status - Indicates whether this unit encountered an error condition. 
    --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --     
   --              DL_Status.ITEM_NOT_FOUND - Indicates that the entity state 
   --              information record was not found.
   --
   --              DL_Status.GET_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the 
   --              failed routine will be returned.
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Get_Item(
      Entity_ID         : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Entity_State_Data :    out ENTITY_STATE_INFO_PTR;
      Status            :    out DL_Status.STATUS_TYPE);

end Hashing;
