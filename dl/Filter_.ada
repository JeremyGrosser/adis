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
-- Package Name:       Filter 
--
-- File Name:          Filter_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   June 27, 1994
--
-- Purpose:
--
--   Contains routines to determine whether or not data is within a specified
--   threshold. 
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
     Numeric_Types;

package Filter is

   --==========================================================================
   -- AZ_AND_EL  (Azimuth and Elevation)
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the azimuth and elevation of an entity or event with 
   --   respect to a reference entity are within the specified threshold ranges.
   -- 
   --   Input Parameters:
   --
   --     Az_Angle_1           - Specifies the first angle (in degrees) in the
   --                            azimuth threshold range.
   --
   --     Az_Angle_2           - Specifies the second angle (in degrees) in the 
   --                            azimuth threshold range. 
   --     
   --     El_Angle_1           - Specifies the first angle (in degrees) in the
   --                            elevation threshold range.
   --
   --     El_Angle_2           - Specifies the second angle (in degrees) in the 
   --                            elevation threshold range. 
   --
   --     Entity_State_PDU     - Describes the entity and its geocentric 
   --                            position in meters.
   --
   --     Position_Of_Interest - Holds a geocentric position (in meters) which is
   --                            translated into the entity coordinate system
   --                            of the entity described by the
   --                            Entity_State_PDU.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.FILT_AZ_AND_EL_FAILURE - Indicates an exception 
   --               was raised in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned. 
   --
   --      Within_Threshold - Returns "TRUE" if both the elevation and azimuth 
   --                         angles are within the specified threshold ranges.
   --                        
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Az_And_El(
      Az_Angle_1           : in     Numeric_Types.FLOAT_32_BIT;
      Az_Angle_2           : in     Numeric_Types.FLOAT_32_BIT;   
      El_Angle_1           : in     Numeric_Types.FLOAT_32_BIT;
      El_Angle_2           : in     Numeric_Types.FLOAT_32_BIT;  
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Status               :    out DL_Status.STATUS_TYPE;
      Within_Threshold     :    out BOOLEAN);

   --==========================================================================
   -- AZIMUTH
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the azimuth of an entity or event with respect to a 
   --   reference entity is within a specified threshold range.
   --
   --   Input Parameters:
   --
   --     Angle_1              - Specifies the first angle (in degrees) in the 
   --                            azimuth threshold range.
   --
   --     Angle_2              - Specifies the second angle (in degrees) in the 
   --                            azimuth threshold range.  
   --    
   --     Entity_State_PDU     - Describes the entity which is located at the 
   --                            origin of the entity coordinate system in 
   --                            geocentric coordinates in meters.
   --
   --     Position_Of_Interest - Holds a geocentric position (in meters) which is
   --                            translated into the entity coordinate system
   --                            of the entity described by the
   --                            Entity_State_PDU. 
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.FILT_AZ_FAILURE - Indicates an exception was 
   --               raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the
   --               procedure will terminate and the status (error code) for
   --               the failed routine wil be returned.
   --
   --      Within_Threshold - Returns "TRUE" if the azimuth angle is within the
   --                         specified threshold range.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Azimuth(
      Angle_1              : in     Numeric_Types.FLOAT_32_BIT;
      Angle_2              : in     Numeric_Types.FLOAT_32_BIT;   
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Status               :    out DL_Status.STATUS_TYPE;
      Within_Threshold     :    out BOOLEAN);

   --==========================================================================
   -- DISTANCE
   --==========================================================================
   -- 
   -- Purpose:
   --
   --   Determines whether the distance between two entities/events is 
   --   within a specified maximum distance threshold value.
   --
   --   Input Parameters:
   --
   --     Position_1 - A vector position of an entity or event in meters.
   --
   --     Position_2 - A vector position of an entity or event in meters.
   --
   --     Threshold  - The maximum distance between the entities/events in
   --                  meters.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.FILT_DIST_FAILURE - Indicates an exception was 
   --               raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the
   --               procedure will terminate and the status (error code) for 
   --               the failed routine will be returned.
   --		
   --      Within_Threshold - Returns "TRUE" if the distance between the two input
   --                         positions is less than or equal to the specified
   --                         maximum distance threshold value.
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================
   procedure Distance(
      Position_1       : in     DIS_Types.A_WORLD_COORDINATE;
      Position_2       : in     DIS_Types.A_WORLD_COORDINATE;
      Threshold        : in     Numeric_Types.FLOAT_64_BIT;  
      Status           :    out DL_Status.STATUS_TYPE;
      Within_Threshold :    out BOOLEAN);

   --==========================================================================
   -- ELEVATION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Determines whether the elevation of an entity or event with respect to a 
   --   reference entity is within a specified threshold range.
   --
   --   Input Parameters:
   -- 
   --
   --     Angle_1              - Specifies the first angle (in degrees) in the 
   --                            elevation threshold range.
   --
   --     Angle_2              - Specifies the second angle (in degrees) in the 
   --                            elevation threshold range.
   --  
   --     Entity_State_PDU     - Describes the entity which is located at the 
   --                            origin of the entity coordinate system in 
   --                            geocentric coordinates in meters.
   --
   --     Position_Of_Interest - Holds a geocentric position (in meters) which is
   --                            translated into the entity coordinate system
   --                            of the entity described by the
   --                            Entity_State_PDU.     
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.FILT_EL_FAILURE - Indicates an exception was 
   --               raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the 
   --               procedure will terminate and the status (error code) for
   --               the failed routine will be returned.
   --
   --      Within_Threshold - Returns "TRUE" if the elevation angle is within the
   --                         specified threshold range.
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================
   procedure Elevation(
      Angle_1              : in     Numeric_Types.FLOAT_32_BIT;
      Angle_2              : in     Numeric_Types.FLOAT_32_BIT;   
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Status               :    out DL_Status.STATUS_TYPE;
      Within_Threshold     :    out BOOLEAN);

   --==========================================================================
   -- MAXIMUM_VELOCITY
   --==========================================================================
   --
   -- Purpose:
   --
   --   Determines whether the velocity magnitude of an entity or event is within
   --   the specified maximum velocity threshold.
   --
   --   Input Parameters:
   --
   --     Threshold - The maximum velocity in meters per second.
   -- 
   --     Velocity  - Specifies the velocity of an entity or event in terms of 
   --                 it's X,Y,Z components in meters per second.
   --
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.FILT_MAX_VEL_FAILURE - Indicates an exception was
   --               raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the
   --               procedure will terminate and the status (error code) for
   --               the failed routine will be returned.
   --
   --
   --      Within_Threshold - Returns "TRUE" if the velocity is equal to or less
   --                         than the specified maximum velocity threshold 
   --                         value.
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================
   procedure Maximum_Velocity(
      Threshold        : in     Numeric_Types.FLOAT_32_BIT;
      Velocity         : in     DIS_Types.A_VECTOR;
      Status           :    out DL_Status.STATUS_TYPE;
      Within_Threshold :    out BOOLEAN);

   --==========================================================================
   -- MINIMUM_VELOCITY
   --==========================================================================
   --
   -- Purpose:
   --
   --   Determines whether the velocity magnitude of an entity or event is within
   --   the specified minimum velocity threshold.
   --
   --   Input Parameters:
   -- 
   --     Threshold - The minimum velocity in meters per second.
   --
   --     Velocity  - Specifies the velocity of an entity or event in terms of 
   --                 it's X,Y,Z components in meters per second.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.FILT_MIN_VEL_FAILURE - Indicates an exception was
   --               raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the
   --               procedure will terminate and the status (error code) for 
   --               the failed routine will be returned.
   --
   --      Within_Threshold - Returns "TRUE" if the velocity is equal to or 
   --                         greater than the specified minimum velocity 
   --                         threshold value.
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================
   procedure Minimum_Velocity(
      Threshold        : in     Numeric_Types.FLOAT_32_BIT;
      Velocity         : in     DIS_Types.A_VECTOR;
      Status           :    out DL_Status.STATUS_TYPE;
      Within_Threshold :    out BOOLEAN);


end Filter;
