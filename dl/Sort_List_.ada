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
-- Package Name:       Sort_List
--
-- File Name:          Sort_List_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 22, 1994
--
-- Purpose:
--
--   Instantiates the generic sort packages which contain routines to 
--   sort a list of PDU according to some specified criteria.
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

with DIS_PDU_Pointer_Types,
     DIS_Types,
     DL_Linked_List_Types,
     Generic_Sort_List_By_Distance,
     Generic_Sort_List_By_Velocity,
     Get_PDU_Data,
     Numeric_Types,
     Status_Functions;

package Sort_List is
  
   --
   -- SORT DISTANCE
   -- 
   --===========================================================================
   -- Instantiate package to sort a list of Detonation PDUs by distance
   --===========================================================================
   -- procedure Call for the following instantiation is:
   --
   --   Sort_List.Detonation_Distance.Sort_Distance(
   --     The_List           : in out DL_Linked_List_Types.Detonation_List.PTR;
   --     Ascending          : in     BOOLEAN := TRUE;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Status             :    out DL_Status.STATUS_TYPE); 
   --
   --  Note:
   --       The "Ascending" parameter is optional.  If it is omitted, it 
   --       defaults to ascending order.
   --
   --============================================================================
   package Detonation_Distance is new Generic_Sort_List_By_Distance(
      ITEM         => DIS_PDU_Pointer_Types.DETONATION_PDU_PTR,
      PTR          => DL_Linked_List_Types.Detonation_List.PTR,
      Change_Item  => DL_Linked_List_Types.Detonation_List.Change_Item,
      Length_Of    => DL_Linked_List_Types.Detonation_List.Length_Of,
      Is_Null      => DL_Linked_List_Types.Detonation_List.Is_Null,
      Tail_Of      => DL_Linked_List_Types.Detonation_List.Tail_Of,
      Value_Of     => DL_Linked_List_Types.Detonation_List.Value_Of,
      Get_Status   => Status_Functions.Sort_Detonation_Distance_Status,
      PDU_Location => Get_PDU_Data.Detonation_Location,
      Null_Item    => Get_PDU_Data.Null_Detonation_PDU_Pointer);

   --===========================================================================
   -- Instantiate package to sort a list of Entity State PDUs by distance
   --===========================================================================
   -- procedure Call for the following instantiation is:
   --
   --   Sort_List.Entity_State_Distance.Sort_Distance(
   --     The_List           : in out DL_Linked_List_Types.Entity_State_List.PTR;
   --     Ascending          : in     BOOLEAN := TRUE;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Status             :    out DL_Status.STATUS_TYPE); 
   --  Note:
   --       The "Ascending" parameter is optional.  If it is ommitted, it 
   --       defaults to ascending order.
   --
   --============================================================================
   package Entity_State_Distance is new Generic_Sort_List_By_Distance(
      ITEM         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR          => DL_Linked_List_Types.Entity_State_List.PTR,
      Change_Item  => DL_Linked_List_Types.Entity_State_List.Change_Item,
      Length_Of    => DL_Linked_List_Types.Entity_State_List.Length_Of,
      Is_Null      => DL_Linked_List_Types.Entity_State_List.Is_Null,
      Tail_Of      => DL_Linked_List_Types.Entity_State_List.Tail_Of,
      Value_Of     => DL_Linked_List_Types.Entity_State_List.Value_Of,
      Get_Status   => Status_Functions.Sort_Entity_State_Distance_Status,
      PDU_Location => Get_PDU_Data.Entity_State_Location,
      Null_Item    => Get_PDU_Data.Null_Entity_State_PDU_Pointer);

   --===========================================================================
   -- Instantiate package to sort a list of Fire PDUs by distance
   --===========================================================================
   -- procedure Call for the following instantiation is:
   --
   --   Sort_List.Fire_Distance.Sort_Distance(
   --     The_List           : in out DL_Linked_List_Types.Fire_List.PTR;
   --     Ascending          : in     BOOLEAN := TRUE;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Status             :    out DL_Status.STATUS_TYPE); 
   --
   --  Note:
   --       The "Ascending" parameter is optional.  If it is ommitted, it 
   --       defaults to ascending order.
   --
   --============================================================================
   package Fire_Distance is new Generic_Sort_List_By_Distance(
      ITEM         => DIS_PDU_Pointer_Types.FIRE_PDU_PTR,
      PTR          => DL_Linked_List_Types.Fire_List.PTR,
      Change_Item  => DL_Linked_List_Types.Fire_List.Change_Item,
      Length_Of    => DL_Linked_List_Types.Fire_List.Length_Of,
      Is_Null      => DL_Linked_List_Types.Fire_List.Is_Null,
      Tail_Of      => DL_Linked_List_Types.Fire_List.Tail_Of,
      Value_Of     => DL_Linked_List_Types.Fire_List.Value_Of,
      Get_Status   => Status_Functions.Sort_Fire_Distance_Status,
      PDU_Location => Get_PDU_Data.Fire_Location,
      Null_Item    => Get_PDU_Data.Null_Fire_PDU_Pointer);

   --===========================================================================
   -- Instantiate package to sort a list of Laser PDUs by distance
   --===========================================================================
   -- procedure Call for the following instantiation is:
   --
   --   Sort_List.Laser_Distance.Sort_Distance(
   --     The_List           : in out DL_Linked_List_Types.Laser_List.PTR;
   --     Ascending          : in     BOOLEAN := TRUE;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Status             :    out DL_Status.STATUS_TYPE); 
   --
   --  Note:
   --       The "Ascending" parameter is optional.  If it is omitted, it 
   --       defaults to ascending order.
   --
   --============================================================================
   package Laser_Distance is new Generic_Sort_List_By_Distance(
      ITEM         => DIS_PDU_Pointer_Types.LASER_PDU_PTR,
      PTR          => DL_Linked_List_Types.Laser_List.PTR,
      Change_Item  => DL_Linked_List_Types.Laser_List.Change_Item,
      Length_Of    => DL_Linked_List_Types.Laser_List.Length_Of,
      Is_Null      => DL_Linked_List_Types.Laser_List.Is_Null,
      Tail_Of      => DL_Linked_List_Types.Laser_List.Tail_Of,
      Value_Of     => DL_Linked_List_Types.Laser_List.Value_Of,
      Get_Status   => Status_Functions.Sort_Laser_Distance_Status,
      PDU_Location => Get_PDU_Data.Laser_Location,
      Null_Item    => Get_PDU_Data.Null_Laser_PDU_Pointer);

   --===========================================================================
   -- Instantiate package to sort a list of Transmitter PDUs by distance
   --===========================================================================
   -- procedure Call for the following instantiation is:
   --
   --   Sort_List.Transmitter_Distance.Sort_Distance(
   --     The_List           : in out DL_Linked_List_Types.Transmitter_List.PTR;
   --     Ascending          : in     BOOLEAN := TRUE;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Status             :    out DL_Status.STATUS_TYPE); 
   --
   --  Note:
   --       The "Ascending" parameter is optional.  If it is omitted, it 
   --       defaults to ascending order.
   --
   --============================================================================
   package Transmitter_Distance is new Generic_Sort_List_By_Distance(
      ITEM         => DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR,
      PTR          => DL_Linked_List_Types.Transmitter_List.PTR,
      Change_Item  => DL_Linked_List_Types.Transmitter_List.Change_Item,
      Length_Of    => DL_Linked_List_Types.Transmitter_List.Length_Of,
      Is_Null      => DL_Linked_List_Types.Transmitter_List.Is_Null,
      Tail_Of      => DL_Linked_List_Types.Transmitter_List.Tail_Of,
      Value_Of     => DL_Linked_List_Types.Transmitter_List.Value_Of,
      Get_Status   => Status_Functions.Sort_Transmitter_Distance_Status,
      PDU_Location => Get_PDU_Data.Transmitter_Location,
      Null_Item    => Get_PDU_Data.Null_Transmitter_PDU_Pointer);

   --
   -- SORT VELOCITY
   -- 
   --===========================================================================
   -- Instantiate package to sort a list of Entity_State PDUs by velocity
   --===========================================================================
   -- procedure Call for the following instantiation is:
   --
   --   Sort_List.Entity_State_Velocity.Sort_Velocity(
   --     The_List   : in out DL_Linked_List_Types.Entity_State_List.PTR;
   --     Descending : in     BOOLEAN := TRUE;
   --     Status     :    out DL_Status.STATUS_TYPE); 
   --
   --  Note:
   --       The "Descending" parameter is optional.  If it is omitted, it 
   --       defaults to descending order.
   --
   --============================================================================
   package Entity_State_Velocity is new Generic_Sort_List_By_Velocity(
      ITEM         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR          => DL_Linked_List_Types.Entity_State_List.PTR,
      Change_Item  => DL_Linked_List_Types.Entity_State_List.Change_Item,
      Length_Of    => DL_Linked_List_Types.Entity_State_List.Length_Of,
      Is_Null      => DL_Linked_List_Types.Entity_State_List.Is_Null,
      Tail_Of      => DL_Linked_List_Types.Entity_State_List.Tail_Of,
      Value_Of     => DL_Linked_List_Types.Entity_State_List.Value_Of,                                     
      Get_Status   => Status_Functions.Sort_Entity_State_Vel_Status,
      PDU_Velocity => Get_PDU_Data.Entity_State_Velocity,
      Null_Item    => Get_PDU_Data.Null_Entity_State_PDU_Pointer);    
   
end Sort_List;
