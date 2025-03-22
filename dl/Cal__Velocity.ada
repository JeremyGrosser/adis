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
-- Unit Name:          Velocity
--
-- File Name:          Cal__Velocity.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 23, 1994 
--
-- Purpose:
--
--   Calculates the magnitude of an input linear velocity vector.
--	
-- 
-- Implementation:
--
--    Uses the following formula to calculate the magnitude of the
--    linear velocity vector:
--
--         Magnitude = Square Root ( (X Squared) + (Y Squared) + (Z Squared) ) 
--	   
--     where
--
--        X,Y,Z - are the  X,Y,Z components of the linear velocity vector.
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
 
separate (Calculate)

procedure Velocity (
   Linear_Velocity    : in     DIS_Types.A_VECTOR;
   Velocity_Magnitude :    out Numeric_Types.FLOAT_32_BIT;
   Status             :    out DL_Status.STATUS_TYPE) is

begin -- Velocity

   Status := DL_Status.SUCCESS;
      
   Velocity_Magnitude := Math.Sqrt(
                           (Linear_Velocity.X * Linear_Velocity.X)
                           + (Linear_Velocity.Y * Linear_Velocity.Y) 
                           + (Linear_Velocity.Z * Linear_Velocity.Z));
     
exception 
         
   when OTHERS =>
      Status := DL_Status.CALC_VELOCITY_FAILURE; 
      
end Velocity;
