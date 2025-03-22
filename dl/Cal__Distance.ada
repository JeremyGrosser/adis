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
-- Unit Name:          Distance 
--
-- File Name:          Cal__Distance.ada
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
--   Calculates the distance between two positions, each of which
--   represents entities or events in the same orthogonal coordinate
--   system. 
--
-- Implementation:
--
--   Uses the following  distance formula to determine the distance between
--   two vector input positions:
--
--      Distance = Square Root( 
--                 (X2-X1)Squared + (Y2-Y1)Squared + (Z2-Z1)Squared)
--
--   where
--      
--      X1,Y1,Z1 are the components of the first position vector.
--      X2,Y2,Z2 are the components of the second position vector.
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
with Math;

separate(Calculate)

procedure Distance (
   Position_1 : in     DIS_Types.A_WORLD_COORDINATE;
   Position_2 : in     DIS_Types.A_WORLD_COORDINATE;
   Distance   :    out Numeric_Types.FLOAT_64_BIT; 
   Status     :    out DL_Status.STATUS_TYPE) is
   
   -- 
   -- Declare local variables required for calculations.
   --
  
   X_Distance    : Numeric_Types.FLOAT_64_BIT;
   Y_Distance    : Numeric_Types.FLOAT_64_BIT;
   Z_Distance    : Numeric_Types.FLOAT_64_BIT;

begin -- Distance
 
   Status        := DL_Status.SUCCESS;
 
   X_Distance    := Position_2.X - Position_1.X;
   Y_Distance    := Position_2.Y - Position_1.Y;
   Z_Distance    := Position_2.Z - Position_1.Z;
 
 
   Distance      := Math.Sqrt(
                       (X_Distance * X_Distance)
                     + (Y_Distance * Y_Distance)
                     + (Z_Distance * Z_Distance));

exception
 
   when OTHERS => 
      Status := DL_Status.CALC_DISTANCE_FAILURE;

end Distance;
