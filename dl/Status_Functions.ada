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
-- Package Name:       Status_Functions
--
-- File Name:          Status_Functions.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   Sept 2, 1994
--
-- Purpose:
--
--   Contains functions that return status codes for units that are generic
--   instantiations.
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

package body Status_Functions is

--
-- * Staus codes for FILTER_LIST package *
--
   --==========================================================================
   --   FILT_ENTITY_STATE_AZ_AND_EL_STATUS
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
   function Filt_Entity_State_Az_And_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_EL_ENT_ST_FAILURE;
   end Filt_Entity_State_Az_And_El_Status;

   --==========================================================================
   --   FILT_DETONATION_AZ_STATUS
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
   function Filt_Detonation_Az_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_DETON_FAILURE;
   end Filt_Detonation_Az_Status;

 --==========================================================================
   --   FILT_ENTITY_STATE_AZ_STATUS
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
   function Filt_Entity_State_Az_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_ENT_ST_FAILURE;
   end Filt_Entity_State_Az_Status;

   --==========================================================================
   --   FILT_FIRE_AZ_STATUS
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
   function Filt_Fire_Az_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_AZ_FIRE_FAILURE;
   end Filt_Fire_Az_Status;      

   --==========================================================================
   --   FILT_DETONATION_DISTANCE_STATUS
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
   function Filt_Detonation_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_DETON_FAILURE;
   end Filt_Detonation_Distance_Status;

   --==========================================================================
   --   FILT_ENTITY_STATE_DISTANCE_STATUS
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
   function Filt_Entity_State_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_ENT_ST_FAILURE;
   end Filt_Entity_State_Distance_Status;

  --==========================================================================
   --   FILT_FIRE_DISTANCE_STATUS
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
   function Filt_Fire_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_FIRE_FAILURE;
   end Filt_Fire_Distance_Status;

  --==========================================================================
   --   FILT_LASER_DISTANCE_STATUS
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
   function Filt_Laser_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_LASER_FAILURE;
   end Filt_Laser_Distance_Status;

  --==========================================================================
   --   FILT_TRANSMITTER_DISTANCE_STATUS
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
   function Filt_Transmitter_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_DIST_TRANS_FAILURE;
   end Filt_Transmitter_Distance_Status;

   --==========================================================================
   --   FILT_DETONATION_EL_STATUS
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
   function Filt_Detonation_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_EL_DETON_FAILURE;
   end Filt_Detonation_El_Status;

  --==========================================================================
   --   FILT_ENTITY_STATE_EL_STATUS
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
   function Filt_Entity_State_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_EL_ENT_ST_FAILURE;
   end Filt_Entity_State_El_Status;

   --==========================================================================
   --   FILT_FIRE_EL_STATUS
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
   function Filt_Fire_El_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_EL_FIRE_FAILURE;
   end Filt_Fire_El_Status;

   --==========================================================================
   --   FILT_ENTITY_STATE_MAX_VEL_STATUS
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
   function Filt_Entity_State_Max_Vel_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_MAX_VEL_ENT_ST_FAILURE;
   end Filt_Entity_State_Max_Vel_Status;   

   --==========================================================================
   --   FILT_ENTITY_STATE_MIN_VEL_STATUS
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
   function Filt_Entity_State_Min_Vel_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.FILT_MIN_VEL_ENT_ST_FAILURE;
   end Filt_Entity_State_Min_Vel_Status;

--
-- * Status codes for SORT_LIST package *
--
   --==========================================================================
   --   SORT_DETONATION_DISTANCE_STATUS
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
   function Sort_Detonation_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_DETON_FAILURE;
   end Sort_Detonation_Distance_Status;

   --==========================================================================
   --   SORT_ENTITY_STATE_DISTANCE_STATUS
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
   function Sort_Entity_State_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_ENT_ST_FAILURE;
   end Sort_Entity_State_Distance_Status;

  --==========================================================================
   --   SORT_Fire_DISTANCE_STATUS
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
   function Sort_Fire_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_FIRE_FAILURE;
   end Sort_Fire_Distance_Status;

  --==========================================================================
   --   SORT_LASER_DISTANCE_STATUS
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
   function Sort_Laser_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_LASER_FAILURE;
   end Sort_Laser_Distance_Status;

  --==========================================================================
   --   SORT_TRANSMITTER_DISTANCE_STATUS
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
   function Sort_Transmitter_Distance_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_DIST_TRANS_FAILURE;
   end Sort_Transmitter_Distance_Status;

   --==========================================================================
   --   SORT_ENTITY_STATE_VEL_STATUS
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
   function Sort_Entity_State_Vel_Status 
     return DL_Status.STATUS_TYPE is

   begin
      return DL_Status.SORT_VEL_ENT_ST_FAILURE;
   end Sort_Entity_State_Vel_Status;   

 end Status_Functions;
