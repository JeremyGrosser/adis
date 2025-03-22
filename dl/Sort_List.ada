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
-- File Name:          Sort_List.ada
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

with DL_Status;

package body Sort_List is

   --==========================================================================
   -- GET_DETONATION_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.SORT_DIST_DETON_FAILURE for the unit that sorts a
   --   list of Detonation PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Detonation_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_DETON_FAILURE;
   end Get_Detonation_Distance_Status;

   --==========================================================================
   -- GET_ENTITY_STATE_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.SORT_DIST_ENT_ST_FAILURE for the unit that sorts a
   --   list of Entity_State PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_ENT_ST_FAILURE;
   end Get_Entity_State_Distance_Status;

  --==========================================================================
   -- GET_Fire_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.SORT_DIST_FIRE_FAILURE for the unit that sorts a
   --   list of Fire PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Fire_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_FIRE_FAILURE;
   end Get_Fire_Distance_Status;

  --==========================================================================
   -- GET_LASER_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.SORT_DIST_LASER_FAILURE for the unit that sorts a
   --   list of Laser PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Laser_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_LASER_FAILURE;
   end Get_Laser_Distance_Status;

  --==========================================================================
   -- GET_TRANSMITTER_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.SORT_DIST_TRANS_FAILURE for the unit that sorts a
   --   list of Detonation PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Transmitter_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_TRANS_FAILURE;
   end Get_Transmitter_Distance_Status;

   --==========================================================================
   -- GET_ENTITY_STATE_VEL_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.SORT_VEL_ENT_ST_FAILURE for the unit that sorts
   --   a list of Entity State PDUs by velocity.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_Vel_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_VEL_ENT_ST_FAILURE;
   end Get_Entity_State_Vel_Status;   

   --==========================================================================
   -- DETONATION_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Detonation_Location( 
      PDU: in  DIS_PDU_Pointer_Types.DETONATION_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.World_Location;
   end Detonation_Location;

   --==========================================================================
   -- ENTITY_STATE_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Entity_State_Location( 
      PDU: in  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.Location;
   end Entity_State_Location;

   --==========================================================================
   -- FIRE_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Fire_Location( 
      PDU: in  DIS_PDU_Pointer_Types.FIRE_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.World_Location;
   end Fire_Location;
  
   --==========================================================================
   -- LASER_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Laser_Location( 
      PDU: in  DIS_PDU_Pointer_Types.LASER_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.Laser_Spot_Location;
   end Laser_Location;

   --==========================================================================
   -- TRANSMITTER_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Transmitter_Location( 
      PDU: in  DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.Antenna_Location.Antenna_Location;
   end Transmitter_Location;

   --==========================================================================
   -- ENTITY_STATE_VELOCITY_VECTOR
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's velocity vector from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Entity_State_Velocity_Vector(
      PDU: in  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR) 
     return DIS_Types.A_VECTOR is 

   begin
      return PDU.Linear_Velocity;
   end Entity_State_Velocity_Vector;

   --==========================================================================
   -- NULL_DETONATION_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Detonation_PDU_Pointer
     return DIS_PDU_Pointer_Types.DETONATION_PDU_PTR is

      PDU_Pointer : DIS_PDU_Pointer_Types.DETONATION_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Detonation_PDU_Pointer;

   --==========================================================================
   -- NULL_ENTITY_STATE_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Entity_State_PDU_Pointer
     return DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR is

    PDU_Pointer : DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Entity_State_PDU_Pointer;

   --==========================================================================
   -- NULL_FIRE_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Fire_PDU_Pointer
     return DIS_PDU_Pointer_Types.FIRE_PDU_PTR is

    PDU_Pointer : DIS_PDU_Pointer_Types.FIRE_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Fire_PDU_Pointer;

   --==========================================================================
   -- NULL_LASER_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Laser_PDU_Pointer
     return DIS_PDU_Pointer_Types.LASER_PDU_PTR is

    PDU_Pointer : DIS_PDU_Pointer_Types.LASER_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Laser_PDU_Pointer;

   --==========================================================================
   -- NULL_ENTITY_STATE_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Transmitter_PDU_Pointer
     return DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR is

      PDU_Pointer : DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR:= NULL;

   begin
      return PDU_Pointer;
   end Null_Transmitter_PDU_Pointer;
  
end Sort_List;
