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
-- Unit Name:          Local_To_Geocentric_Conversion
--
-- File Name:          CC__Local_To_Geocentric_Conversion.ada
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
--    Calls Local_To_Geodetic to convert the local X,Y,Z coordinates to geodetic
--    latitude,longitude and altitude.  Then calls Geodetic_To_Geocentric to 
--    convert the geodetic coordinates to geocentric coordinates.
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

separate (Coordinate_Conversions)

procedure Local_To_Geocentric_Conversion(
      Local_Coordinates      : in     DL_Types.THE_LOCAL_COORDINATES;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Geocentric_Coordinates :    out DIS_Types.A_WORLD_COORDINATE; 
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

   Local_To_Geodetic_Conversion(
     Local_Coordinates    => Local_Coordinates,
     Local_Origin         => Local_Origin,
     Geodetic_Coordinates => Geodetic_Coordinates,
     Status               => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 

   Geodetic_To_Geocentric_Conversion(
      Geodetic_Coordinates   => Geodetic_Coordinates,
      Geocentric_Coordinates => Geocentric_Coordinates,
      Status                 => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 
   
exception

   when CALL_FAILURE => 
      Status := Call_Status;
 
   when OTHERS       => 
      Status := DL_Status.LOC_GCC_FAILURE;
 
end Local_To_Geocentric_Conversion;
