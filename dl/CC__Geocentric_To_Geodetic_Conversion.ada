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
-- Unit Name:          Geocentric_To_Geodetic_Conversion
--
-- File Name:          CC__Geocentric_To_Geodetic_Conversion.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 20, 1994
--
-- Purpose:
--
--   Converts geocentric X,Y,Z components to geodetic latitude,
--   longitude and altitude.
--
-- Implementation:
--
--
--   Software based on algorithms developed by IST
--
--   (from file convertMath.c, unit WCStoGeodeticM)
--
--   Uses WGS-84 ellipsoidal earth model parameters.  Uses approximation
--   method for solution of geodetic latitude and altitude.  See section
--   4.1.1.1.2.9 of the DL SDD for the transformation equations.
--
--   Notes:  Worst case error due to approximation method occurs at around
--           65 degrees North or South latitude where error is approx 0.5
--           meters at the earth's surface.  Error increases below surface
--           and decreases with altitude.  Error decreases to zero at poles
--           and at equator.  Only latitude and altitude are effected by
--           error.
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

procedure Geocentric_To_Geodetic_Conversion (
   Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
   Geodetic_Coordinates   :    out DL_Types.THE_GEODETIC_COORDINATES;
   Status                 :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables.
   --
   
   Call_Status     : DL_Status.STATUS_TYPE;

   -- Define storage for the results of latitude trig functions.
   Cos_Lat         : Numeric_Types.FLOAT_64_BIT;
   Sin_Lat         : Numeric_Types.FLOAT_64_BIT;

   -- Define a latitude/longitude that can be used in calculations.
   Latitude        : DL_Types.THE_LATITUDE;
   Longitude       : DL_Types.THE_LONGITUDE;

   -- Greek letter used as a place holder for calculated dated
   MU              : Numeric_Types.FLOAT_64_BIT;

   -- The data calculated in MU times the Z value.
   MUZ             : Numeric_Types.FLOAT_64_BIT;

   Radius          : Numeric_Types.FLOAT_64_BIT;
   Radius_Modified : Numeric_Types.FLOAT_64_BIT;

  
 
   -- X squared plus Y squared.
   X_Sq_Plus_Y_Sq  : Numeric_Types.FLOAT_64_BIT;
   
   -- Z squared.
   Z_Sq            : Numeric_Types.FLOAT_64_BIT;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE    : EXCEPTION;
 
begin  -- Geocentric_To_Geodetic_Conversion
    
   Status := DL_Status.SUCCESS;
      
   -- Compute Latitude in radians. 
   X_Sq_Plus_Y_Sq  := (Geocentric_Coordinates.X * Geocentric_Coordinates.X)
                        + (Geocentric_Coordinates.Y * Geocentric_Coordinates.Y);

   Z_Sq := Geocentric_Coordinates.Z * Geocentric_Coordinates.Z;
  
   MU   := (Math.Sqrt(X_Sq_Plus_Y_Sq 
              + (DL_Math.K_One_Minus_Eccentricity_Sq * Z_Sq))
              / DL_Math.K_Equatorial_Earth_Radius)
              + (DL_Math.K_Eccen_Sq_Divided_By_Equat_Earth_Radius_Sq
              * Z_Sq);

   Radius := Math.Sqrt(X_Sq_Plus_Y_Sq);
    
   Radius_Modified := Math."ABS"((MU - DL_Math.K_Eccentricity_Sq) * Radius); 
 
   MUZ := MU * Geocentric_Coordinates.Z;
     
   -- If both inputs are zero, a zero will be returned. 
   Latitude := DL_Math.Atan2(MUZ, Radius_Modified);
     
   -- Convert Latitude to degrees. 
   Geodetic_Coordinates.Latitude := Latitude * DL_Math.K_Radians_To_Degrees; 
      
   -- Compute Longitude in radians.  If both inputs are zero, a zero will
   -- be returned.
   Longitude := DL_Math.Atan2(Geocentric_Coordinates.Y, 
                  Geocentric_Coordinates.X);
     
   -- Convert Longitude to degrees.
   Geodetic_Coordinates.Longitude := Longitude * DL_Math.K_Radians_To_Degrees;
 
   -- Compute Altitude in meters.
   DL_Math.Sin_Cos_Lat(
     Angle     => Latitude, 
     Cos_Angle => Cos_Lat,
     Sin_Angle => Sin_Lat, 
     Status    => Call_Status);
     
   if Call_Status /= DL_Status.SUCCESS then
     raise CALL_FAILURE;
   end if;
 
   Geodetic_Coordinates.Altitude := (Radius * Cos_Lat) 
                                      + (Geocentric_Coordinates.Z * Sin_Lat) 
                                      - (DL_Math.K_Equatorial_Earth_Radius 
                                          * Math.Sqrt(1.0 
                                            - (DL_Math.K_Eccentricity_Sq 
                                              * Sin_Lat * Sin_Lat)));
   
exception

   when CALL_FAILURE => 
      Status := Call_Status;
 
   when OTHERS       => 
      Status := DL_Status.GCC_GDC_FAILURE;

end Geocentric_To_Geodetic_Conversion;
