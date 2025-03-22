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
-- Package Name:       Calculate
--
-- File Name:          Calculate_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 5, 1994
--
-- Purpose:
--
--   Contains routines to calculate azimuth, distance, elevation
--   and velocity.
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

package Calculate is

   --==========================================================================
   -- AZ_AND_EL (Azimuth and Elevation)
   --==========================================================================
   --
   -- Purpose
   --
   --   Calculates the azimuth and elevation of an entity or event with respect
   --   to an entity.  The results will be two angles.  The azimuth angle will
   --   measure between 0.0 and 360.0 -(2 to the -23) and the elevation angle
   --   will measure between -180.0 + (2 to the -23) and 180.0 degrees.
   --
   --   Input Parameters:
   --
   --     Entity_State_PDU - Describes the reference entity and its geocentric
   --                        coordinates in meters.
   --
   --     Position_Of_Interest - Holds a geocentric position in meters which is
   --                            translated into the entity coordinate system
   --                            of the entity described by the
   --                            Entity_State_PDU.
   --
   --   Output Parameters:
   --
  --      Azimuth - Represents the relative angle in degrees of the position
   --               of interest to the heading of the entity described by the
   --               Entity_State_PDU.
   --
   --     Elevation - Represents the relative angle of the position of interest
   --                 in degrees to the pitch of the entity described by the
   --                 Entity_State_PDU.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALC_AZ_AND_EL_FAILURE - Indicates an exception was
   --              raised in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --                      procedure will terminate and the status (error code)
   --                      for the failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Az_And_El(
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Azimuth              :    out Numeric_Types.FLOAT_32_BIT;
      Elevation            :    out Numeric_Types.FLOAT_32_BIT;
      Status               :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- AZIMUTH
   --==========================================================================
   --
   -- Purpose
   --
   --   Calculates the azimuth of an entity or event with respect to an
   --   entity.  The result will be an angle measuring between 0.0 and
   --   360 - (2 to the -23) degrees.
   --
   --   Input Parameters:
   --
   --     Entity_State_PDU - Describes the reference entity and its geocentric
   --                        coordinates in meters.
   --
   --     Position_Of_Interest - Holds a geocentric position in meters which is
   --                            translated into the entity coordinate system
   --                            of the entity described by the
   --                            Entity_State_PDU. 
   --
   --    Output Parameters:
   --
   --      Azimuth - Represents the relative angle (in degrees) of the position
   --                of interest to the heading of the entity described by the
   --                Entity_State_PDU. 
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.CALC_AZIMUTH_FAILURE - Indicates an exception was
   --               raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the 
   --               procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --    			
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Azimuth(
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Azimuth              :    out Numeric_Types.FLOAT_32_BIT;
      Status               :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- CALCULATE_AZIMUTH
   --==========================================================================
   --
   -- Purpose
   --
   --   Calculates the azimuth of a position vector.  The result will be an
   --   angle measuring between 0.0 and 360 - (2 to the -23) degrees.
   --
   --   Input Parameters:
   --
   --     Vector_Position - An entity coordinate vector position in meters.
   --
   --   Output Parameters:
   --
   --     Azimuth - Angle calculated for the input position in degrees.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALCULATE_AZ_FAILURE - Indicates an exception was
   --              raised in this unit.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Calculate_Azimuth(
      Vector_Position : in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
      Azimuth         :    out Numeric_Types.FLOAT_32_BIT;
      Status          :    out DL_Status.STATUS_TYPE);

    --=========================================================================
    -- CALCULATE_ELEVATION
    --=========================================================================
    --
    -- Purpose
    --
    --   Calculates the elevation of a position vector.  The result will be an
    --   angle measuring between -180.0 + (2 to the -23) to 180.0 degrees.
    --
    --   Input Parameters:
    --
    --     Vector_Position - An entity coordinate vector position in meters.
    --
    --   Output Parameters:
    --
    --     Elevation - Angle calculated for the input position in degrees.
    --
    --   Input/Output Parameters:
    --
    --     Status - Indicates whether this unit encountered an error condition.
    --              One of the following status values will be returned:
    --
    --              DL_Status.SUCCESS - Indicates the unit executed successfully.
    --
    --              DL_Status.CALCULATE_EL_FAILURE - Indicates an exception was
    --              raised in this unit.
    --				 		
    --
    --=========================================================================
    procedure Calculate_Elevation(
       Vector_Position : in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
       Elevation       :    out Numeric_Types.FLOAT_32_BIT;
       Status          :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- DISTANCE
   --==========================================================================
   -- 
   -- Purpose:
   --
   --   Calculates the distance between two positions, each of which
   --   represents entities or events in the same orthogonal coordinate
   --   system.
   --
   --   Input Parameters:
   --
   --     Position_1 - An entity or event's vector position in meters.
   --
   --     Position_2 - An entity or event's vector position in meters.
   --
   --   Output Parameters:
   --
   --     Distance - The distance in meters between the two input positions.
   --
   --     Status - Indicates whether this unit encountered an error condition
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALC_DISTANCE_FAILURE - Indicates an exception was
   --              raised in this unit.
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================
   procedure Distance(
      Position_1 : in     DIS_Types.A_WORLD_COORDINATE;
      Position_2 : in     DIS_Types.A_WORLD_COORDINATE;
      Distance   :    out Numeric_Types.FLOAT_64_BIT; 
      Status     :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- ELEVATION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Calculates the elevation of an entity or event with respect to an
   --   entity.  The result will be an angle measuring between -180.0 + (2
   --   to the -23) to 180 degrees.
   --
   --   Input Parameters:
   --
   --     Entity_State_PDU - Describes the reference entity and its geocentric
   --                        coordinates in meters.
   --
   --     Position_Of_Interest - Holds a geocentric position in meters which is
   --                            translated into the entity coordinate system
   --                            of the entity described by the
   --                            Entity_State_PDU.
   --
   --   Output Parameters:
   --
   --     Azimuth - Represents the relative angle in degrees of the position
   --               of interest to the heading of the entity described by the
   --               Entity_State_PDU.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALC_ELEVATION_FAILURE - Indicates an exception was
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
   procedure Elevation(
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Elevation            :    out Numeric_Types.FLOAT_32_BIT;
      Status               :    out DL_Status.STATUS_TYPE);


   --==========================================================================
   -- VELOCITY
   --==========================================================================
   --
   -- Purpose:
   --
   --   Calculates the magnitude of an input linear velocity vector.
   --
   --   Input Parameters:
   --
   --     Linear_Velocity - Specifies the velocity of an entity or event in
   --                       terms of it's X,Y,Z components in meters per 
   --                       second.
   --
   --
   --   Output Parameters:
   --
   --     Velocity_Magnitude - The magnitude of the entity or event's
   --                          velocity vector in meters per second.
   --
   --     Status - Indicates whether this unit encountered an error condition. 
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALC_VELOCITY_FAILURE - Indicates an exception was
   --              raised in this unit.
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================
   procedure Velocity(
      Linear_Velocity    : in     DIS_Types.A_VECTOR;
      Velocity_Magnitude :    out Numeric_Types.FLOAT_32_BIT;
      Status             :    out DL_Status.STATUS_TYPE);


--==============================================================================
--
-- MODIFICATIONS
--
-- 18 July 1994 - Charlotte Mildren - Moved the Calculate_Azimuth and 
--                                    Calculate_Elevation basic units to package
--                                    specification so they could be called by 
--                                    the filter azimuth and elevation routine.
--                                    (In this unit, if the azimuth is out of 
--                                     bounds the elevation does not need to be
--                                     calculated.)
--
--
--==============================================================================
end Calculate;
