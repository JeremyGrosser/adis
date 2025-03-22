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
-- Package Name:       DL_Linked_List_Types
--
-- File Name:          DL_Linked_List_Types_.ada 
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 7, 1994
--
-- Purpose:
--
--    Provides instantiations of the Generic_List and Generic_List_Utilities
--    packages which contain units to manage a generic double linked list (see
--    package specifications).  The packages are instantiated for a pointer
--    to a PDU node that is stored in shared memory.  Since the DG will be
--    handling this shared memory no method of freeing the pointer to the 
--    shared memory location is provided. (This could be done if needed, but
--    I decided that it would be better not include it since someone might use
--    it when it should not be used.)  A method of freeing the pointer to the
--    generic list nodes is provided.
--    
--    Notes: To use procedures or function from a generic package
--           use the package name and the function name (e.g., just as you
--           do with instantiations of Text_IO)
--         
--           For example -
--             The following is a call to a unit from the
--             Generic_List package as instantiated by the 
--             DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR:
--
--               List             : DL_Linked_List_Types.Entity_State_List.PTR;
--               Entity_State_PDU : DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
--
--               DL_Linked_List_Types.Entity_State_List.Construct_Top(
--                 The_Item => Entity_State_PDU,
--                 Head     => List);
-- 
--             and the following is a function call from 
--             Generic_List_Utilities package
--
--             Top_Of_List : DL_Linked_List_Types.Entity_State_List.PTR;
--
--             Top_Of_List := DL_Linked_List_Types.
--                            Entity_State_List_Utilities.Head_Of(List);
--	
-- Effects:
--	None
--
-- Exceptions:
--	None
--
-- Portability Issues:
--	None
--
-- Anticipated Changes:
--	None
--
--=============================================================================	

with DIS_PDU_Pointer_Types,
     Generic_List,
     Generic_List_Utilities;
  
package DL_Linked_List_Types is
  
   --==========================================================================
   -- INSTANTIATE GENERICS FOR DETONATION PDUS
   --==========================================================================
  
   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If it is used, replace the body of this function with a specific
   -- body for the sort routine.
   function Detonation_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.DETONATION_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.DETONATION_PDU_PTR)
   return BOOLEAN;

   package Detonation_List is new Generic_List(
     ITEM => DIS_PDU_Pointer_Types.DETONATION_PDU_PTR);

   package Detonation_List_Utilities is new Generic_List_Utilities(
      ITEM             => DIS_PDU_Pointer_Types.DETONATION_PDU_PTR, 
      PTR              => Detonation_List.PTR,
      Change_Item      => Detonation_List.Change_Item,
      Clear_List       => Detonation_List.Clear_List,
      Clear_Previous   => Detonation_List.Clear_Previous,
      Clear_Next       => Detonation_List.Clear_Next,
      Clear_Node       => Detonation_List.Clear_Node,
      Construct_Bottom => Detonation_List.Construct_Bottom,
      Construct_Top    => Detonation_List.Construct_Top,
      Copy             => Detonation_List.Copy,
      Free             => Detonation_List.Free,
      Set_Head         => Detonation_List.Set_Head,
      Swap_Tail        => Detonation_List.Swap_Tail,
      Is_Equal         => Detonation_List.Is_Equal,
      Is_Null          => Detonation_List.Is_Null,
      Length_Of        => Detonation_List.Length_Of,
      Predecessor_Of   => Detonation_List.Predecessor_Of,
      Tail_Of          => Detonation_List.Tail_Of,
      Value_Of         => Detonation_List.Value_Of,
      "<"              => Detonation_Less_Than);

   --==========================================================================
   -- INSTANTIATE GENERICS FOR ENTITY STATE PDUS
   --==========================================================================
 
   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If it is used, replace the body of this function with a specific
   -- body for the sort routine.
   function Entity_State_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR)
   return BOOLEAN;

   package Entity_State_List is new Generic_List(
     ITEM => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR);

   package Entity_State_List_Utilities is new Generic_List_Utilities(
      ITEM             => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR, 
      PTR              => Entity_State_List.PTR,
      Change_Item      => Entity_State_List.Change_Item,
      Clear_List       => Entity_State_List.Clear_List,
      Clear_Previous   => Entity_State_List.Clear_Previous,
      Clear_Next       => Entity_State_List.Clear_Next,
      Clear_Node       => Entity_State_List.Clear_Node,
      Construct_Bottom => Entity_State_List.Construct_Bottom,
      Construct_Top    => Entity_State_List.Construct_Top,
      Copy             => Entity_State_List.Copy,
      Free             => Entity_State_List.Free,
      Set_Head         => Entity_State_List.Set_Head,
      Swap_Tail        => Entity_State_List.Swap_Tail,
      Is_Equal         => Entity_State_List.Is_Equal,
      Is_Null          => Entity_State_List.Is_Null,
      Length_Of        => Entity_State_List.Length_Of,
      Predecessor_Of   => Entity_State_List.Predecessor_Of,
      Tail_Of          => Entity_State_List.Tail_Of,
      Value_Of         => Entity_State_List.Value_Of,
      "<"              => Entity_State_Less_Than);

   --==========================================================================
   -- INSTANTIATE GENERICS FOR FIRE PDUS
   --==========================================================================

   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If it is used, replace the body of this function with a specific
   -- body for the sort routine.
   function Fire_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.FIRE_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.FIRE_PDU_PTR)
   return BOOLEAN;

   package Fire_List is new Generic_List(
     ITEM => DIS_PDU_Pointer_Types.FIRE_PDU_PTR);

   package Fire_List_Utilities is new Generic_List_Utilities(
      ITEM             => DIS_PDU_Pointer_Types.FIRE_PDU_PTR, 
      PTR              => Fire_List.PTR,
      Change_Item      => Fire_List.Change_Item,
      Clear_List       => Fire_List.Clear_List,
      Clear_Previous   => Fire_List.Clear_Previous,
      Clear_Next       => Fire_List.Clear_Next,
      Clear_Node       => Fire_List.Clear_Node,
      Construct_Bottom => Fire_List.Construct_Bottom,
      Construct_Top    => Fire_List.Construct_Top,
      Copy             => Fire_List.Copy,
      Free             => Fire_List.Free,
      Set_Head         => Fire_List.Set_Head,
      Swap_Tail        => Fire_List.Swap_Tail,
      Is_Equal         => Fire_List.Is_Equal,
      Is_Null          => Fire_List.Is_Null,
      Length_Of        => Fire_List.Length_Of,
      Predecessor_Of   => Fire_List.Predecessor_Of,
      Tail_Of          => Fire_List.Tail_Of,
      Value_Of         => Fire_List.Value_Of,
      "<"              => Fire_Less_Than);

   --==========================================================================
   -- INSTANTIATE GENERICS FOR LASER PDUS
   --==========================================================================
   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If it is used, replace the body of this function with a specific
   -- body for the sort routine.
   function Laser_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.LASER_PDU_PTR)
   return BOOLEAN;

   package Laser_List is new Generic_List(
      ITEM => DIS_PDU_Pointer_Types.LASER_PDU_PTR);

   package Laser_List_Utilities is new Generic_List_Utilities(
      ITEM             => DIS_PDU_Pointer_Types.LASER_PDU_PTR, 
      PTR              => Laser_List.PTR,
      Change_Item      => Laser_List.Change_Item,
      Clear_List       => Laser_List.Clear_List,
      Clear_Previous   => Laser_List.Clear_Previous,
      Clear_Next       => Laser_List.Clear_Next,
      Clear_Node       => Laser_List.Clear_Node,
      Construct_Bottom => Laser_List.Construct_Bottom,
      Construct_Top    => Laser_List.Construct_Top,
      Copy             => Laser_List.Copy,
      Free             => Laser_List.Free,
      Set_Head         => Laser_List.Set_Head,
      Swap_Tail        => Laser_List.Swap_Tail,
      Is_Equal         => Laser_List.Is_Equal,
      Is_Null          => Laser_List.Is_Null,
      Length_Of        => Laser_List.Length_Of,
      Predecessor_Of   => Laser_List.Predecessor_Of,
      Tail_Of          => Laser_List.Tail_Of,
      Value_Of         => Laser_List.Value_Of,
      "<"              => Laser_Less_Than);

   --==========================================================================
   -- INSTANTIATE GENERICS FOR TRANSMITTER PDUS
   --==========================================================================
    
   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If it is used, replace the body of this function with a specific
   -- body for the sort routine.
   function Transmitter_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR)
   return BOOLEAN;

   package Transmitter_List is new Generic_List(
     ITEM => DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR);

   package Transmitter_List_Utilities is new Generic_List_Utilities(
      ITEM             => DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR, 
      PTR              => Transmitter_List.PTR,
      Change_Item      => Transmitter_List.Change_Item,
      Clear_List       => Transmitter_List.Clear_List,
      Clear_Previous   => Transmitter_List.Clear_Previous,
      Clear_Next       => Transmitter_List.Clear_Next,
      Clear_Node       => Transmitter_List.Clear_Node,
      Construct_Bottom => Transmitter_List.Construct_Bottom,
      Construct_Top    => Transmitter_List.Construct_Top,
      Copy             => Transmitter_List.Copy,
      Free             => Transmitter_List.Free,
      Set_Head         => Transmitter_List.Set_Head,
      Swap_Tail        => Transmitter_List.Swap_Tail,
      Is_Equal         => Transmitter_List.Is_Equal,
      Is_Null          => Transmitter_List.Is_Null,
      Length_Of        => Transmitter_List.Length_Of,
      Predecessor_Of   => Transmitter_List.Predecessor_Of,
      Tail_Of          => Transmitter_List.Tail_Of,
      Value_Of         => Transmitter_List.Value_Of,
      "<"              => Transmitter_Less_Than);

end DL_Linked_List_Types; 

--==============================================================================
-- 
-- Modification History
--
--
--
--
--=============================================================================== 
