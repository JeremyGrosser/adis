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
-- Package Name:       Coordinate_Conversions
--
-- File Name:          Coordinate_Conversions.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 13, 1994
--
-- Purpose:
--
--   Contains routines that convert between geocentric coordinate
--   systems and entity, local, geodetic and UTM coordinate systems and
--   vice-versa.
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
--
--	Currently Latitude and Longitude feet to degree conversion factors
--      are set to the same value.  The longitude constant should be
--      changed to a more accurate conversion factor for longitude
--
--===========================================================================	
   
package body Coordinate_Conversions is
   --
   -- Define Global Constants
   --

      -- Factor to convert latitude feet to degrees.
      K_Lat_Ft_To_Deg : constant := 364566.9;

     -- Factor to convert longitude feet to degrees.
      K_Lon_Ft_To_Deg : constant := 364566.9;

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";
 
   --=========================================================================
   -- ENTITY_TO_GEOCENTRIC_CONVERSION
   --=========================================================================
   procedure Entity_To_Geocentric_Conversion(
      Euler_Angles                    : in     DIS_Types.
                                                 AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Entity_Coordinates              : in     DIS_Types. 
                                                 AN_ENTITY_COORDINATE_VECTOR;
      Geocentric_Coordinates          :    out DIS_Types.A_WORLD_COORDINATE;
      Status                          :    out DL_Status.STATUS_TYPE)
     is separate;
   --==========================================================================
   -- ENTITY_TO_GEOCENTRIC_VEL_CONVERSION
   --==========================================================================
   procedure Entity_To_Geocentric_Vel_Conversion( 
      Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Entity_Coordinates              : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Geocentric_Coordinates          :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Status                          :    out DL_Status.STATUS_TYPE)
     is separate;

   --=========================================================================
   -- GEOCENTRIC_TO_ENTITY_CONVERSION
   --=========================================================================
   procedure Geocentric_To_Entity_Conversion( 
      Euler_Angles                    : in     DIS_Types.
                                                 AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Geocentric_Coordinates          : in     DIS_Types.A_WORLD_COORDINATE;
      Entity_Coordinates              :    out DIS_Types.
                                                 AN_ENTITY_COORDINATE_VECTOR;
      Status                          :    out DL_Status.STATUS_TYPE)
     is separate;

   --==========================================================================
   -- GEOCENTRIC_TO_ENTITY_VEL_CONVERSION
   --==========================================================================
   procedure Geocentric_To_Entity_Vel_Conversion( 
      Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Geocentric_Coordinates          : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Entity_Coordinates              :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Status                          :    out DL_Status.STATUS_TYPE)
     is separate;

   --========================================================================
   -- GEOCENTRIC_TO_GEODETIC_CONVERSION
   --========================================================================
   procedure Geocentric_To_Geodetic_Conversion( 
      Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
      Geodetic_Coordinates   :    out DL_Types.THE_GEODETIC_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE)
     is separate;

   --==========================================================================
   -- GEOCENTRIC_TO_LOCAL_CONVERSION
   --==========================================================================
   procedure Geocentric_To_Local_Conversion(
      Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE)
     is separate;

   --==========================================================================
   -- GEOCENTRIC_TO_LOCAL_IN_METERS_CONVERSION
   --==========================================================================
   procedure Geocentric_To_Local_In_Meters_Conversion(
      Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE)
     is separate;

   --========================================================================
   -- GEODETIC_TO_GEOCENTRIC_CONVERSION
   --========================================================================
   procedure Geodetic_To_Geocentric_Conversion( 
      Geodetic_Coordinates   : in     DL_Types.THE_GEODETIC_COORDINATES;
      Geocentric_Coordinates :    out DIS_Types.A_WORLD_COORDINATE;
      Status                 :    out DL_Status.STATUS_TYPE)
     is separate;

   --========================================================================
   -- GEODETIC_TO_LOCAL_CONVERSION
   --========================================================================
   procedure Geodetic_To_Local_Conversion(
      Geodetic_Coordinates   : in     DL_Types.THE_GEODETIC_COORDINATES;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE)
    is separate;

   --==========================================================================
   -- LOCAL_TO_GEOCENTRIC_CONVERSION
   --==========================================================================
   procedure Local_To_Geocentric_Conversion(
      Local_Coordinates      : in     DL_Types.THE_LOCAL_COORDINATES;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Geocentric_Coordinates :    out DIS_Types.A_WORLD_COORDINATE;
      Status                 :    out DL_Status.STATUS_TYPE)
    is separate;

   --==========================================================================
   -- LOCAL_TO_GEODETIC_CONVERSION
   --==========================================================================
   procedure Local_To_Geodetic_Conversion(
      Local_Coordinates      : in     DL_Types.THE_LOCAL_COORDINATES;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Geodetic_Coordinates   :    out DL_Types.THE_GEODETIC_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE)
     is separate;

   --==========================================================================
   -- LOCAL_TO_DIS_VELOCITY
   --==========================================================================
   procedure Local_To_DIS_Velocity(
      Local_Velocity : in     DIS_Types.A_VECTOR;
      Local_Position : in     DL_Types.THE_LOCAL_ORIGIN;
      DIS_Velocity   :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Status         :    out DL_Status.STATUS_TYPE)
    is separate;

   --==========================================================================
   -- DIS_TO_LOCAL_VELOCITY
   --==========================================================================
   procedure DIS_To_Local_Velocity(
      DIS_Velocity   : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Local_Position : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Velocity :    out DIS_Types.A_VECTOR;
      Status         :    out DL_Status.STATUS_TYPE)
    is separate;

end Coordinate_Conversions;
