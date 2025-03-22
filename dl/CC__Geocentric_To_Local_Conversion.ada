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
-- Unit Name:          Geocentric_To_Local_Conversion
--
-- File Name:          CC__Geocentric_To_Local_Conversion.ada
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
--   Converts coordinate components between geocentric and local coordinate systems.
--
-- Implementation:
--   
--    Call Geocentric_To_Geodetic to convert the geocentric coordinates into geodetic 
--    latitude, longitude and altitude.  Then calls Geodetic_To_Local to convert to
--    local coordinates.
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
     Numeric_Types;

separate (Coordinate_Conversions)

procedure Geocentric_To_Local_Conversion(
      Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE) is

   
   --
   -- Declare local variables.
   --
  
   Call_Status          : DL_Status.STATUS_TYPE;

   Geodetic_Coordinates : DL_Types.THE_GEODETIC_COORDINATES;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE : EXCEPTION;
  
begin  -- Geocentric_To_Local_Conversion

   Status      := DL_Status.SUCCESS;
   
   -- Convert geocentric X, Y, Z to latitude (degrees), longitude (degrees), 
   -- and altitude (meters).
   Geocentric_To_Geodetic_Conversion(
      Geocentric_Coordinates => Geocentric_Coordinates,
      Geodetic_Coordinates   => Geodetic_Coordinates,
      Status                 => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 

   -- Convert latitude, longitude, and altitude to local X, Y, Z in feet.
   Geodetic_To_Local_Conversion(
      Geodetic_Coordinates => Geodetic_Coordinates,
      Local_Origin         => Local_Origin,
      Local_Coordinates    => Local_Coordinates,
      Status               => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 
  
exception

   when CALL_FAILURE => 
      Status := Call_Status;
 
   when OTHERS       => 
      Status := DL_Status.GCC_LOC_FAILURE;

end Geocentric_To_Local_Conversion;
