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
-- Package Name:       Filter_By_PDU_Components 
--
-- File Name:          Filter_By_PDU_Components.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   August 12, 1994
--
-- Purpose:
--
--   Contains routines to determine whether or not data is within a specified
--   threshold.   
--
--   Note: These routines are the same as Filter package except the parameter
--         list has the reference entity's component data instead of the entire
--         Entity_State_PDU.
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

package body Filter_By_PDU_Components is

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   --==========================================================================
   -- AZ_AND_EL (Azimuth and Elevation)
   --==========================================================================
   procedure Az_And_El(
      Az_Angle_1           : in     Numeric_Types.FLOAT_32_BIT;
      Az_Angle_2           : in     Numeric_Types.FLOAT_32_BIT;   
      El_Angle_1           : in     Numeric_Types.FLOAT_32_BIT;
      El_Angle_2           : in     Numeric_Types.FLOAT_32_BIT; 
      Location             : in     DIS_Types.A_WORLD_COORDINATE;
      Orientation          : in     DIS_Types.AN_EULER_ANGLES_RECORD; 
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Status               :    out DL_Status.STATUS_TYPE;
      Within_Threshold     :    out BOOLEAN)
     is separate;
 

end Filter_By_PDU_Components;
