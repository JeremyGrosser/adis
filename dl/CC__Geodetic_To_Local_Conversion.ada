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
-- Unit Name:          Geodetic_To_Local_Conversion
--
-- File Name:          CC__Geodetic_To_Local_Conversion.ada
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
--   Converts geodetic latitude (in degrees), longitude (in degrees), and 
--   altitude (in meters) to local X,Y,Z coordinates in feet.
--
-- Implementation:
-- 
--   Calculate latitude, longitude and altitude in feet.
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
with DL_Math,
     Math;

separate (Coordinate_Conversions)

procedure Geodetic_To_Local_Conversion(
   Geodetic_Coordinates   : in     DL_Types.THE_GEODETIC_COORDINATES; 
   Local_Origin            : in    DL_Types.THE_LOCAL_ORIGIN;         
   Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;    
   Status                 :    out DL_Status.STATUS_TYPE) is
   
   --
   -- Declare local variables.
   --

   -- Define a local latitude converted to radians.
   Cos_Lat        : DL_Types.THE_LATITUDE 
                      :=  Geodetic_Coordinates.Latitude * DL_Math.K_Degrees_To_Radians;
                  
begin  -- Geodetic_To_Local_Conversion

   Status      := DL_Status.SUCCESS;

   -- Calculate the latitude then convert degrees to feet.
   Local_Coordinates.Y := (Geodetic_Coordinates.Latitude - Local_Origin.Latitude)
                            * K_Lat_Ft_To_Deg;

   -- Calculate the longitude then convert degrees to feet.
   Cos_Lat  := Math.Cos(Cos_Lat);

   Local_Coordinates.X := Cos_Lat * K_Lon_Ft_To_Deg 
                           * (Geodetic_Coordinates.Longitude - Local_Origin.Longitude);
                           
   -- Calculate the altitude and covert from meters to feet. 
   Local_Coordinates.Z := (Geodetic_Coordinates.Altitude - Local_Origin.Altitude) 
                            * DL_Math.K_Meters_To_Feet;

exception
 
   when OTHERS       => 
      Status := DL_Status.GDC_LOC_FAILURE;

end Geodetic_To_Local_Conversion;
