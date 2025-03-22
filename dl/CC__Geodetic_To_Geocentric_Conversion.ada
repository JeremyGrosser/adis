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
-- Unit Name:          Geodetic_To_Geocentric_Conversion
--
-- File Name:          CC__Geodetic_To_Geocentric_Conversion.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 26, 1994
--
-- Purpose:
--
--   Converts geodetic latitude, longitude, and altitude to geocentric X,Y,Z 
--   coordinate components.
--
-- Implementation:
--
--   Software based on algorithms developed by IST
--
--   Uses WGS-84 ellipsoidal earth model parameters.    See section
--   4.1.1.1.2.9 of the DL SDD for the transformation equations.
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
     Math,
     Numeric_Types;

separate (Coordinate_Conversions)

procedure Geodetic_To_Geocentric_Conversion (
   Geodetic_Coordinates   : in     DL_Types.THE_GEODETIC_COORDINATES;
   Geocentric_Coordinates :    out DIS_Types.A_WORLD_COORDINATE;
   Status                 :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables.
   --
   
   Call_Status  : DL_Status.STATUS_TYPE;

   -- Define storage for trig function results.
   Cos_Lat      : Numeric_Types.FLOAT_64_BIT;
   Sin_Lat      : Numeric_Types.FLOAT_64_BIT;

   Cos_Lon      : Numeric_Types.FLOAT_64_BIT;
   Sin_Lon      : Numeric_Types.FLOAT_64_BIT;

   -- Define latitude in radians.
   Latitude     : DL_Types.THE_LATITUDE
                    := Geodetic_Coordinates.Latitude * DL_Math.K_Degrees_To_Radians;

   -- Define Longitude in radians.
   Longitude    : DL_Types.THE_LONGITUDE
                    := Geodetic_Coordinates.Longitude * DL_Math.K_Degrees_To_Radians;
 
   -- Define geocentric coordinates.
   X            : Numeric_Types.FLOAT_64_BIT;
   Y            : Numeric_Types.FLOAT_64_BIT;
   Z            : Numeric_Types.FLOAT_64_BIT;


   RhoP         : Numeric_Types.FLOAT_64_BIT;

 
   W            : Numeric_Types.FLOAT_64_BIT;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE : EXCEPTION;
  
begin  -- Geodetic_To_Geocentric_Conversion

   Status := DL_Status.SUCCESS;
      
   -- Compute trig values for Latitude and longitude in radians. 
   DL_Math.Sin_Cos_Lat(
     Angle     => Latitude, 
     Cos_Angle => Cos_Lat,
     Sin_Angle => Sin_Lat,
     Status    => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 

   Cos_Lon := Math.Cos(Longitude);
   
   -- Compute earth's prime radius of curvature at reference latitude.
   RhoP :=  DL_Math.K_Equatorial_Earth_Radius / Math.Sqrt( 
              1.0 - DL_Math.K_Eccentricity_Sq * Sin_Lat * Sin_Lat);

   -- Compute the distance from the polar axis.
   w := (RhoP + Geodetic_Coordinates.Altitude) * Cos_Lat;

   -- Compute the Geocentric Coordinate values.
   X := W * Cos_Lon;

   Y := Math.Sqrt(W*W - X * X);

   if Longitude < 0.0 or else Longitude > DL_Math.K_Pi then
      Y := - Y;
   end if;
   
   Z := ((Rhop * DL_Math.K_One_Minus_Eccentricity_Sq) 
          + Geodetic_Coordinates.Altitude) * Sin_Lat;
   
   Geocentric_Coordinates.X := X;
   Geocentric_Coordinates.Y := Y;
   Geocentric_Coordinates.Z := Z;

exception

   when CALL_FAILURE => 
      Status := Call_Status;
 
   when OTHERS       => 
      Status := DL_Status.GCC_GDC_FAILURE;

end Geodetic_To_Geocentric_Conversion;
