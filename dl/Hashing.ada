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
-- File Name:          Hashing.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 25, 1994
--
-- Purpose:
--
--  Contains units to add, delete and get records from an unbounded hash table.
--  Collisions are handled via a linked list of all the items which hash to the
--  same cell.
--	
--
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

package body Hashing is

   --
   -- Import functions to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";


   function "="(Left, Right : DIS_Types.AN_ENTITY_IDENTIFIER) 
     return BOOLEAN
     renames DIS_Types."=";

   --==========================================================================
   -- CALCULATE_HASH_TABLE_ADDRESS
   --==========================================================================
   --
   -- Purpose
   --
   --   Calculates an index into the hash table based on the size of the hash 
   --   table and the entity's unique DIS identifier.
   --
   -- Implementation:
   --
   --  	Uses the following equation:
   --     (((Entiy Site_ID * Multiplier)mod Table_Size) 
   --     + 
   --     ((Entity Application_ID * Multiplier) mod Table_Size))
   --     + (Entity ID mod Table_Size);
   --
   --   Input Parameters:
   --
   --     Entity Identifier - Represents the unique identifer for a DIS entity,
   --                         consisting of the Site ID, Application ID and 
   --                         Entity ID.
   --
   --   Output Parameters:
   --
   --     Address - Represents the cell within the hash table where the entity
   --               information should be stored or retrieved.
   --
   --     Status - Indicates whether this unit encountered an error 
   --              condition. One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CAL_HASH_ADDRESS_FAILURE - Indicates an exception was
   --               raised in this unit.  
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
   --==========================================================================
   procedure Calculate_Hash_Table_Address(
      Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Address   :    out INTEGER;
      Status    :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables
      --
      -- Define a multiplier to spread out the storage of similar IDs.
      K_Multiplier : constant INTEGER := 10;
  

   begin

      Status  := DL_Status.SUCCESS;

      Address := (((INTEGER(Entity_ID.Sim_Address.Site_ID) * K_Multiplier)
                   mod K_Maximum_Table_Size) + 
                   ((INTEGER(Entity_ID.Sim_Address.Application_ID) 
                   * K_Multiplier) mod K_Maximum_Table_Size))
                   + INTEGER(Entity_ID.Entity_ID) mod K_Maximum_Table_Size;
   exception 
         
      when OTHERS =>
        Status := DL_Status.CAL_HASH_ADDRESS_FAILURE; 
      
   end Calculate_Hash_Table_Address;

   --==========================================================================
   -- ADD_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Inserts the location data into the hash table.
   --
   -- Implementation:
   -- 
   --   Calls Calculate_Address to determine where to store the entity 
   --   information.  Creates the new node and adds the entity state information,
   --   then calls Generic_List instantiation of Construct_Top to add the new
   --   node to the top of the linked list at the array index.
   -- 	
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
   --==========================================================================
   procedure Add_Item(
      Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status           :    out DL_Status.STATUS_TYPE) is
   
      --
      -- Declare local variables
      --

      -- Sub-routine returned status.
      Call_Status       : DL_Status.STATUS_TYPE;
   
      -- Index into the hash table array.
      Index             : INTEGER;
 
      -- Define a new list node for the hash table array of list.
      New_Node          : ENTITY_STATE_INFO_PTR;

      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE      : EXCEPTION;

   begin

      Status  := DL_Status.SUCCESS;
  
      Calculate_Hash_Table_Address(
        Entity_ID => Entity_State_PDU.Entity_ID,
        Address   => Index,
        Status    => Call_Status);
        
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      New_Node  := new ENTITY_STATE_INFORMATION'(
                     Identifier         => Entity_State_PDU.Entity_ID,
                     Position           => Entity_State_PDU.Location,
                     Displayed_Position => Entity_State_PDU.Location,
                     Velocity           => Entity_State_PDU.Linear_Velocity,
                     Orientation        => Entity_State_PDU.Orientation,
                     Offsets            => Initialize_Vector_Offsets,
                     Smooth_Timeslices  => 0,
                     Timeslices         => 0,
                     Overshot           => FALSE,
                     Velocity_Changed   => FALSE);

      Hash_List.Construct_Top(
        The_Item => New_Node,
        Head     => Entity_State_History(Index));


   exception 
 
      when OTHERS =>
        Status := DL_Status.ADD_ITEM_FAILURE;
 
   end Add_Item;

   --==========================================================================
   -- DELETE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Delete the node for the entity from the hash table.  This unit will be
   --   called by the Gateway for housekeeping when entity's are removed from
   --   the simulation.
   --
   -- Implementation:
   -- 
   --   Calls Calculate_Address to find the list that the entity is store in.
   --   Searched list for the pointer to the entity and then calls an
   --   instantiation of Generic_List_Utilities.Delete_Item_And_Free_Storage
   --   to delete the item and free the storage.
   -- 
   --   The following status values may be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
  
   --
   --     Other - If an error occurs in a call to a sub-routine, the procedure 
   --       will terminate and the status (error code) for the failed routine will
   --       be returned.
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
   --==========================================================================
   procedure Delete_Item(
      Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status           :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables
      --

      -- Sub-routine returned status.
      Call_Status       : DL_Status.STATUS_TYPE;
  
      -- Index into the hash table array.
      Index             : INTEGER;
 
      -- Pointer to the location information
      Entity_State_Data : ENTITY_STATE_INFO_PTR;
  
      -- Flag to denote that the Entity's last update information is not in the
      -- hash table.
      Found             : BOOLEAN := FALSE;

      -- List of records that hashed to the same address.
      The_List          : Hash_List.PTR;

      -- Loal Exceptions
      --
      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE      : EXCEPTION;

      -- Entity was not in the list.
      NOT_FOUND         : EXCEPTION;

   begin

      Status  := DL_Status.SUCCESS;
  
      Calculate_Hash_Table_Address(
        Entity_ID => Entity_State_PDU.Entity_ID,
        Address   => Index,
        Status    => Call_Status);
        
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      The_List := Entity_State_History(Index);

      while not Hash_List.Is_Null(The_List) loop 

         Entity_State_Data := Hash_List.Value_Of(The_List);

         if Entity_State_Data.Identifier = Entity_State_PDU.Entity_ID then
            Found := TRUE;
            exit;
         end if;

         -- Get next node.
         The_List := Hash_List.Tail_Of(The_List);

      end loop;

      if not Found then
         raise NOT_FOUND;
      end if;

      Hash_List_Utilities.Delete_Item_And_Free_Storage(
       The_List    => The_List,
       At_Position => Hash_List_Utilities.Position_of(
                        Entity_State_Data, The_List),
       Status      => Call_Status);
      
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

   exception 
 
      when CALL_FAILURE =>
         Status := Call_Status;

      when NOT_FOUND    =>
         Status := DL_Status.ITEM_NOT_FOUND;

      when OTHERS       =>
         Status := DL_Status.DELETE_FREE_FAILURE;
 
   end Delete_Item;

   --==========================================================================
   -- GET_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Retrieves the pointer to the desired record of entity state information.
   --
   -- Implementation:
   --  	
   --   Loops through the list at the array index until it finds the matching
   --   entity identifier and returns the pointer to that record.
   --	
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
   --==========================================================================
   procedure Get_Item(
      Entity_ID            : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Entity_State_Data    :    out ENTITY_STATE_INFO_PTR;
      Status               :    out DL_Status.STATUS_TYPE) is
   
      --
      -- Declare local variables
      --

      -- Sub-routine returned status.
      Call_Status       : DL_Status.STATUS_TYPE;

      -- Pointer to the location information
      Entity_State_Info : ENTITY_STATE_INFO_PTR;
      
      -- Flag to denote that the Entity's last update information is not in the
      -- hash table.
      Found             : BOOLEAN := FALSE;

       -- Index into the hash table array.
      Index             : INTEGER;
 
      -- List of records that hashed to the same address.
      The_List          : Hash_List.PTR;

      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE      : EXCEPTION;
     
   begin

      Status  := DL_Status.SUCCESS;
  
      Calculate_Hash_Table_Address(
        Entity_ID => Entity_ID,
        Address   => Index,
        Status    => Call_Status);
        
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      The_List := Entity_State_History(Index);

      while not Hash_List.Is_Null(The_List) loop 

         Entity_State_Info := Hash_List.Value_Of(The_List);

         if Entity_ID = Entity_State_Info.Identifier then
            Entity_State_Data := Entity_State_Info;
            Found := TRUE;
            exit;
         end if;

         -- Get next node.
         The_List := Hash_List.Tail_Of(The_List);

      end loop;

      if not Found then
         Status := DL_Status.ITEM_NOT_FOUND;
      end if;

   exception 
 
      when OTHERS =>
        Status := DL_Status.GET_ITEM_FAILURE;
 
   end Get_Item; 

   --==========================================================================
   -- LESS_THAN
   --==========================================================================
   --
   -- Purpose
   --
   --   Retrieves the pointer to the desired record of entity state information.
   --
   -- Implementation:
   --  	
   --   Loops through the list at the array index until it finds the matching
   --   entity identifier and returns the pointer to that record.
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
   --==========================================================================
   function Less_Than(
      Item_1 : in ENTITY_STATE_INFO_PTR;
      Item_2 : in ENTITY_STATE_INFO_PTR)
   return BOOLEAN is
  
   begin -- Less_Than

      if Item_1.Position.X < Item_2.Position.X 
        and
         Item_1.Position.Y < Item_2.Position.Y
        and
         Item_1.Position.Z < Item_2.Position.Z
        and 
         Item_1.Velocity.X < Item_2.Velocity.X
        and 
         Item_1.Velocity.Y < Item_2.Velocity.Y
        and 
         Item_1.Velocity.Z < Item_2.Velocity.Z
      
      then
         return TRUE;
      else
         return FALSE;
      end if;

   end Less_Than;

end Hashing;
