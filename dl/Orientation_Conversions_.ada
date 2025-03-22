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
-- Package Name:       Orientation_Conversions
--
-- File Name:          Orientation_Conversions_.ada
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
--   Contains routines that convert between Euler Angles to local orientation
--   of roll, pitch and heading and vice versa.
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
with DL_Status,
     DL_Types,
     DIS_Types;

package Orientation_Conversions is

   --==========================================================================
   -- EULERS_TO_LOCAL_ORIENTATION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from Euler Angles to roll, pitch, and heading.
   --
   --    Input Parameters:
   --
   --      Euler_Angles - Defines the reference entity's location in the 
   --                     geocentric coordinate system in terms of pitch
   --                     (rotation about the lateral or X axis), roll 
   --                     (rotation about the longitudinal or Y axis), and
   --                     yaw (rotation about the altitude or Z axis).
   --                     Angles are defined in degrees.
   --
   --       Geodetic_Position - Defines an entity or events position in terms
   --                           of latitude (degrees), longitude (degrees),
   --                           and Altitude (Meters).
   -- 
   --    Output Parameters:
   --
   --      Local_Orientation - Defines an entity's orientation in terms of 
   --                          roll (degees), pitch (degrees), and 
   --                          heading (degrees).
   --
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned.
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.EUL_ORI_FAILURE - Indicates an exception was raised
   --               in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the 
   --               procedure will terminate and the status (error code) for the
   --               failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Eulers_To_Local_Orientation( 
      Euler_Angles         : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Geodetic_Coordinates : in     DL_Types.THE_GEODETIC_COORDINATES;
      Local_Orientation    :    out DL_Types.LOCAL_ORIENTATION;
      Status               :    out DL_Status.STATUS_TYPE);

  
   --==========================================================================
   -- LOCAL_ORIENTATION_TO_EULERS
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from roll, pitch and heading to Euler Angles. 
   --
   --    Input Parameters:
   --
   --      Local_Orientation - Defines an entity's orientation in terms of 
   --                          roll (degrees), pitch (degrees), and 
   --                          heading (degrees).
   --
   --      Geodetic_Position - Defines an entity or events position in terms
   --                          of latitude (degrees), longitude (degrees),
   --                          and Altitude (Meters).
   -- 
   --    Output Parameters:
   --
   --      Euler_Angles - Defines the reference entity's location in the 
   --                     geocentric coordinate system in terms of pitch
   --                     (rotation about the lateral or X axis), roll 
   --                     (rotation about the longitudinal or Y axis), and
   --                     yaw (rotation about the altitude or Z axis).
   --                     Angles are defined in degrees.
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned.
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.EUL_ORI_FAILURE - Indicates an exception was raised
   --               in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the 
   --               procedure will terminate and the status (error code) for the
   --               failed routine will be returned.
   --
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Local_Orientation_To_Eulers( 
      Geodetic_Coordinates : in     DL_Types.THE_GEODETIC_COORDINATES;
      Local_Orientation    : in     DL_Types.LOCAL_ORIENTATION;
      Euler_Angles         :    out DIS_Types.AN_EULER_ANGLES_RECORD;
      Status               :    out DL_Status.STATUS_TYPE);

  


 end Orientation_Conversions;
