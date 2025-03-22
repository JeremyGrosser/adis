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
-- Package Name:       Filter_List
--
-- File Name:          Filter_List.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 13, 1994
--
-- Purpose:
--
--   Instantiates the generic filter packages which contains routines to 
--   evaluate each PDU in a list and remove those PDUs which do not meet a 
--   specified requirement.
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

package body Filter_List is

   --==========================================================================
   -- GET_ENTITY_STATE_AZ_AND_EL_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_AZ_EL_ENT_ST_FAILURE for the unit that filters a
   --   list of Detonation PDUs by azimuth and elevation.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_Az_And_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_EL_ENT_ST_FAILURE;
   end Get_Entity_State_Az_And_El_Status;

   --==========================================================================
   -- GET_DETONATION_AZ_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_AZ_DETON_FAILURE for the unit that filters a
   --   list of Detonation PDUs by azimuth.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Detonation_Az_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_DETON_FAILURE;
   end Get_Detonation_Az_Status;
 --==========================================================================
   -- GET_ENTITY_STATE_AZ_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_AZ_ENT_ST_FAILURE for the unit that filters a
   --   list of Entity_State PDUs by azimuth.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_Az_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_ENT_ST_FAILURE;
   end Get_Entity_State_Az_Status;

   --==========================================================================
   -- GET_FIRE_AZ_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_AZ_FIRE_FAILURE for the unit that filters a
   --   list of Fire PDUs by azimuth.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Fire_Az_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_FIRE_FAILURE;
   end Get_Fire_Az_Status;      

   --==========================================================================
   -- GET_DETONATION_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_DIST_DETON_FAILURE for the unit that filters a
   --   list of Detonation PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Detonation_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_DETON_FAILURE;
   end Get_Detonation_Distance_Status;

   --==========================================================================
   -- GET_ENTITY_STATE_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_DIST_ENT_ST_FAILURE for the unit that filters a
   --   list of Entity_State PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_ENT_ST_FAILURE;
   end Get_Entity_State_Distance_Status;

  --==========================================================================
   -- GET_Fire_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_DIST_FIRE_FAILURE for the unit that filters a
   --   list of Fire PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Fire_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_FIRE_FAILURE;
   end Get_Fire_Distance_Status;

  --==========================================================================
   -- GET_LASER_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_DIST_LASER_FAILURE for the unit that filters a
   --   list of Laser PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Laser_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_LASER_FAILURE;
   end Get_Laser_Distance_Status;

  --==========================================================================
   -- GET_TRANSMITTER_DISTANCE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_DIST_TRANS_FAILURE for the unit that filters a
   --   list of Detonation PDUs by distance.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Transmitter_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_TRANS_FAILURE;
   end Get_Transmitter_Distance_Status;

   --==========================================================================
   -- GET_DETONATION_EL_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_EL_DETON_FAILURE for the unit that filters a
   --   list of Detonation PDUs by elevation.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Detonation_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_EL_DETON_FAILURE;
   end Get_Detonation_El_Status;

  --==========================================================================
   -- GET_ENTITY_STATE_EL_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_EL_ENT_ST_FAILURE for the unit that filters a
   --   list of Entity_State PDUs by elevation.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_EL_ENT_ST_FAILURE;
   end Get_Entity_State_El_Status;

   --==========================================================================
   -- GET_EL_FIRE_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_EL_FIRE_FAILURE for the unit that filters a
   --   list of Detonation PDUs by elevation.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Fire_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_EL_FIRE_FAILURE;
   end Get_Fire_El_Status;

   --==========================================================================
   -- GET_ENTITY_STATE_MAX_VEL_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_MAX_VEL_ENT_ST_FAILURE for the unit that filters
   --   a list of Entity State PDUs by maximum velocity.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_Max_Vel_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_MAX_VEL_ENT_ST_FAILURE;
   end Get_Entity_State_Max_Vel_Status;   

   --==========================================================================
   -- GET_ENTITY_STATE_MIN_VEL_STATUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns DL_Status.FILT_MIN_VEL_ENT_ST_FAILURE for the unit that filters
   --   a list of Entity State PDUs by minimum velocity.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Get_Entity_State_Min_Vel_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_MIN_VEL_ENT_ST_FAILURE;
   end Get_Entity_State_Min_Vel_Status;

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
   -- ENTITY_STATE_VELOCITY
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
   function Entity_State_Velocity(
      PDU: in  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR) 
     return DIS_Types.A_VECTOR is --(LINEAR_VELOCITY IS 
                                  -- A_LINEAR_VELOCITY_VECTOR A SUBTYPE OF
                                  --   A_VECTOR)
   begin
      return PDU.Linear_Velocity;
   end Entity_State_Velocity;

end Filter_List;
