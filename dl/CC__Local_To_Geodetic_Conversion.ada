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
-- Unit Name:          Local_To_Geodetic_Conversion
--
-- File Name:          CC__Local_To_Geodetic_Conversion.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 28, 1994
--
-- Purpose:
--
--   Converts local X,Y,Z coordinates to geodetic latitude, longitude, and altitude.
--
-- Implementation:
-- 
--   Calculate latitude and longitude in degrees and altitude in meters.
--
--   One of the following status values will be returned:
--
--     DL_Status.SUCCESS - Indicates the unit executed successfully.
--
--     DL_Status.GCC_ENT_FAILURE - Indicates an exception was raised in
--       this unit.
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
--=============================================================================	
with DL_Math,
     Math,
     DL_Types;

separate (Coordinate_Conversions)

procedure Local_To_Geodetic_Conversion(
   Local_Coordinates      : in     DL_Types.THE_LOCAL_COORDINATES;
   Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
   Geodetic_Coordinates   :    out DL_Types.THE_GEODETIC_COORDINATES;
   Status                 :    out DL_Status.STATUS_TYPE) is
   
   --
   -- Declare local variables.
   --
   Latitude : DL_Types.THE_LATITUDE;

begin  -- Local_To_Geodetic_Conversion

   Status      := DL_Status.SUCCESS;

   -- Calculate latitude in degrees, then convert to radians for longitude
   -- trig calculation.
   Latitude  := ((Local_Coordinates.Y / K_Lat_Ft_To_Deg) + Local_Origin.Latitude)
                  * DL_Math.K_Degrees_To_Radians;

   -- Convert back to degrees.
   Geodetic_Coordinates.Latitude  := Latitude * DL_Math.K_Radians_To_Degrees;

   -- Calculate longitude in degrees.
   Geodetic_Coordinates.Longitude := (Local_Coordinates.X 
                                       / (K_Lon_Ft_To_Deg * Math.Cos(Latitude)))
                                       + Local_Origin.Longitude;

   -- Calculate altitude in meters.
   Geodetic_Coordinates.Altitude  := (Local_Coordinates.Z * DL_Math.K_Feet_To_Meters)
                                       + Local_Origin.Altitude;

exception

   when OTHERS       => 
      Status := DL_Status.LOC_GDC_FAILURE;

end Local_To_Geodetic_Conversion;
