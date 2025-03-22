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
-- Unit Name:          Calculate_Azimuth
--
-- File Name:          Cal__Calculate_Azimuth.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 24, 1994
--
-- Purpose
--
--   Calculates the azimuth of a position vector.  The result will be an
--   angle measuring between 0.0 and 360 - (2 to the -23) degrees.
--      
--
-- Implementation:
--
--   Calculates the azimuth using the following formula:
--
--         Azimuth = Arctan (Y/X)
--
--         where
--         
--           Azimuth - is an angle.
--
--           Y       - is the Y component of the input position vector.  
--
--           X       - is the X component of the input position vector.
--
--    and the following adjustments to bearing are made:
--
--           If X is negative, then add 180.0
--
--           If X is positive and Y is negative, then add 360.0
--
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
--	None
--
--
-- Modifications:
--  11/6/94 J. DiCola
--  Corrected "correction" for negative angles
--    
--  11/13/94 J. DiCola
--  Put in check for x and y of 0.0 before doing Atan2
--=============================================================================
with DL_Math;
 
separate (Calculate)
    
procedure Calculate_Azimuth( 
   Vector_Position : in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Azimuth         :    out Numeric_Types.FLOAT_32_BIT;
   Status          :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare Local variables
   -- 

   Azimuth_Degrees : Numeric_Types.FLOAT_32_BIT;
   Azimuth_Radians : Numeric_Types.FLOAT_32_BIT;

begin  -- Calculate_Azimuth
   
   Status := DL_Status.SUCCESS;
 
   -- Calculate_Azimuth in radians.  If both inputs are zero a zero will
   -- be returned. 
   if Vector_Position.Y = 0.0 and then Vector_Position.X = 0.0 then
       Azimuth_Radians := 0.0;
   else
       Azimuth_Radians := DL_Math.Atan2(Vector_Position.Y, Vector_Position.X);
   end if;

   -- Convert azimuth to degrees.
   Azimuth_Degrees := Azimuth_Radians * DL_Math.K_Radians_To_Degrees;

   -- If needed, make adjustments.
   if Vector_Position.Y < 0.0 then
 
      Azimuth := Azimuth_Degrees + 360.0;

   else
 
      Azimuth := Azimuth_Degrees;
 
   end if;

exception

   when OTHERS => 
      Status := DL_Status.CALCULATE_AZ_FAILURE;
 
end Calculate_Azimuth;
