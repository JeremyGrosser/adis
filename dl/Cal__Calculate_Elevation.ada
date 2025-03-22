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
-- Unit Name:          Calculate_Elevation
--
-- File Name:          Cal__Calculate_Elevation.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 23, 1994
--
-- Purpose
--
--   Calculates the elevation of a position vector.  The result will be an
--   angle measuring between -180.0 + (2 to the -23) to 180.0 degrees.
--
-- Implementation:
--
--   Calculates the elevation using the following formula:
--
--         Elevation = Arctan (Z/X)
--
--    where:
--           Elevation - is an angle.
--
--           Z       - is the Z component of the input position.
--
--           X       - is the X component of the input position.
--
--    and the following adjustments to bearing are made:
--
--           If X is positive, then reverse the sign of elevation
--           If X is negative and Z is positive, then substract 90.0
--           If X is negative and Z is negative, then add 90.0
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
--  11/13/94 J. DiCola
--  Put in check of x and z of 0.0 before calling Atan2
--=============================================================================
with DL_Math;

separate (Calculate)
	
procedure Calculate_Elevation(
   Vector_Position : in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Elevation       :    out Numeric_Types.FLOAT_32_BIT;
   Status          :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables
   --

   Elevation_Degrees : Numeric_Types.FLOAT_32_BIT;
   Elevation_Radians : Numeric_Types.FLOAT_32_BIT;

begin -- Calculate Elevation

   Status := DL_Status.SUCCESS;

   -- Calculate Elevation in radians.  If both inputs are zero a zero will
   -- be returned.
   if Vector_Position.Z = 0.0 and then Vector_Position.X = 0.0 then
       Elevation_Radians := 0.0;
   else
       Elevation_Radians := DL_Math.Atan2(Vector_Position.Z, Vector_Position.X);
   end if;

   -- Convert elevation to degrees.
   Elevation_Degrees := Elevation_Radians * DL_Math.K_Radians_To_Degrees;
 
   -- If needed, make adjustments. 
   if Vector_Position.X >= 0.0 then

      -- Reverse the sign
      Elevation := -Elevation_Degrees;

   else -- X is negative
         
      if Vector_Position.Z >= 0.0 then
         Elevation := Elevation_Degrees - 90.0;
      else
         Elevation := Elevation_Degrees + 90.0;
      end if; -- Z positive
 
   end if; -- X positive

exception
         
   when OTHERS => 
      Status := DL_Status.CALCULATE_EL_FAILURE;
   
end Calculate_Elevation;
