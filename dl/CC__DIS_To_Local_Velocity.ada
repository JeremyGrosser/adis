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
-- Unit Name:          DIS_To_Local_Velocity
--
-- File Name:          CC__DIS_To_Local_Velocity.ada
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
--============================================================================= 

with DL_Math,
     Math,
     Numeric_Types,
     DL_Types;

separate (Coordinate_Conversions)

procedure DIS_To_Local_Velocity(
      DIS_Velocity   : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Local_Position : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Velocity :    out DIS_Types.A_VECTOR;
      Status         :    out DL_Status.STATUS_TYPE) is

  Cos_Lat, Sin_Lat, Cos_Lon, Sin_Lon : FLOAT;
  Sin_Sin, Sin_Cos, Cos_Sin, Cos_Cos : FLOAT;
  Simvel : DIS_Types.A_VECTOR;
begin
  Status := DL_STATUS.SUCCESS;
  Cos_Lat := Math.Cos(Local_Position.Latitude);
  Sin_Lat := Math.Sin(Local_Position.Latitude);
  Cos_Lon := Math.Cos(Local_Position.Longitude);
  Sin_Lon := Math.Sin(Local_Position.Longitude);
  Sin_Sin := Sin_Lat * Sin_Lon;
  Sin_Cos := Sin_Lat * Cos_Lon;
  Cos_Sin := Cos_Lat * Sin_Lon;
  Cos_Cos := Cos_Lat * Cos_Lon;
  Simvel.x := Numeric_Types.FLOAT_32_BIT(FLOAT(DIS_Velocity.x) * (-Sin_Lon) +
              FLOAT(DIS_Velocity.y) * Cos_Lon);
  Simvel.y := Numeric_Types.FLOAT_32_BIT(FLOAT(DIS_Velocity.x) * (-Sin_Cos) -
              FLOAT(DIS_Velocity.y) * Sin_Sin +
              FLOAT(DIS_Velocity.z) * Cos_Lat);
  Simvel.z := Numeric_Types.FLOAT_32_BIT(FLOAT(DIS_Velocity.x) * Cos_Cos +
              FLOAT(DIS_Velocity.y) * Cos_Sin +
              FLOAT(DIS_Velocity.z) * Sin_Lat);
  Local_Velocity.x := Simvel.x * DL_Math.K_Meters_To_Feet;
  Local_Velocity.y := Simvel.y * DL_Math.K_Meters_To_Feet;
  Local_Velocity.z := Simvel.z * DL_Math.K_Meters_To_Feet;
exception
  when others =>
    Status := DL_STATUS.ADA_EXCEPTION_RAISED;
end DIS_To_Local_Velocity;
