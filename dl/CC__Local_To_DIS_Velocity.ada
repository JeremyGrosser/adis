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
-- Unit Name:          Local_To_DIS_Velocity
--
-- File Name:          CC__Local_To_DIS_Velocity.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Larry Ullom
--                     US NAVY (NAWCAD PATUXENT RIVER)
--
-- Origination Date:   Nov 3, 1994
--
-- Purpose:
--
--
-- Implementation:
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
-- Modifications:
--   Added conversion to change Lat/Lon degrees to radians
--   11/23/94 J. DiCola
--============================================================================= 

with DL_Math,
     Math,
     Numeric_Types,
     DL_Types;

separate (Coordinate_Conversions)

procedure Local_To_DIS_Velocity(
      Local_Velocity : in     DIS_Types.A_VECTOR;
      Local_Position : in     DL_Types.THE_LOCAL_ORIGIN;
      DIS_Velocity   :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Status         :    out DL_Status.STATUS_TYPE) is

  Cos_Lat, Sin_Lat, Cos_Lon, Sin_Lon : FLOAT;
  Sin_Sin, Sin_Cos, Cos_Sin, Cos_Cos : FLOAT;
  Simvel : DIS_Types.A_VECTOR;
  Geodetic_Position : DL_Types.THE_LOCAL_ORIGIN;

begin
  Status := DL_STATUS.SUCCESS;
  -- convert position lat and lon from degrees to radians
  Geodetic_Position.Latitude := Local_Position.Latitude * DL_Math.K_Degrees_To_Radians;
  Geodetic_Position.Longitude := Local_Position.Longitude * DL_Math.K_Degrees_To_Radians;

  Simvel.x := Local_Velocity.x * DL_Math.K_Feet_To_Meters;
  Simvel.y := Local_Velocity.y * DL_Math.K_Feet_To_Meters;
  Simvel.z := Local_Velocity.z * DL_Math.K_Feet_To_Meters;
  Cos_Lat := Math.Cos(Geodetic_Position.Latitude);
  Sin_Lat := Math.Sin(Geodetic_Position.Latitude);
  Cos_Lon := Math.Cos(Geodetic_Position.Longitude);
  Sin_Lon := Math.Sin(Geodetic_Position.Longitude);
  Sin_Sin := Sin_Lat * Sin_Lon;
  Sin_Cos := Sin_Lat * Cos_Lon;
  Cos_Sin := Cos_Lat * Sin_Lon;
  Cos_Cos := Cos_Lat * Cos_Lon;
  DIS_Velocity.x := Numeric_Types.FLOAT_32_BIT(FLOAT(Simvel.x) * (-Sin_Lon) -
                    FLOAT(Simvel.y) * Sin_Cos +
                    FLOAT(Simvel.z) * Cos_Cos);
  DIS_Velocity.y := Numeric_Types.FLOAT_32_BIT(FLOAT(Simvel.x) * Cos_Lon -
                    FLOAT(Simvel.y) * Sin_Sin +
                    FLOAT(Simvel.z) * Cos_Sin);
  DIS_Velocity.z := Numeric_Types.FLOAT_32_BIT(FLOAT(Simvel.y) * Cos_Lat +
                    FLOAT(Simvel.z) * Sin_Lat);
exception
  when others =>
    Status := DL_STATUS.ADA_EXCEPTION_RAISED;
end Local_To_DIS_Velocity;
