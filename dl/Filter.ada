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
-- Package Name:       Filter 
--
-- File Name:          Filter.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   June 28, 1994
--
-- Purpose:
--
--   Contains routines to determine whether or not data is within a specified
--   threshold. 
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

package body Filter is

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
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Status               :    out DL_Status.STATUS_TYPE;
      Within_Threshold     :    out BOOLEAN)
     is separate;

   --==========================================================================
   -- AZIMUTH
   --==========================================================================
   procedure Azimuth(
      Angle_1              : in     Numeric_Types.FLOAT_32_BIT;
      Angle_2              : in     Numeric_Types.FLOAT_32_BIT; 
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;  
      Status               :    out DL_Status.STATUS_TYPE;
      Within_Threshold     :    out BOOLEAN)
     is separate;

 
   --==========================================================================
   -- DISTANCE
   --==========================================================================
   procedure Distance(
      Position_1       : in     DIS_Types.A_WORLD_COORDINATE;
      Position_2       : in     DIS_Types.A_WORLD_COORDINATE;
      Threshold        : in     Numeric_Types.FLOAT_64_BIT;  
      Status           :    out DL_Status.STATUS_TYPE;
      Within_Threshold :    out BOOLEAN)
     is separate;

   --==========================================================================
   -- ELEVATION
   --===========================================================================
   procedure Elevation(
      Angle_1              : in     Numeric_Types.FLOAT_32_BIT;
      Angle_2              : in     Numeric_Types.FLOAT_32_BIT;   
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Status               :    out DL_Status.STATUS_TYPE;
      Within_Threshold     :    out BOOLEAN)
     is separate;

   --==========================================================================
   -- MAXIMUM_VELOCITY
   --==========================================================================
   procedure Maximum_Velocity(
      Threshold        : in     Numeric_Types.FLOAT_32_BIT;
      Velocity         : in     DIS_Types.A_VECTOR;
      Status           :    out DL_Status.STATUS_TYPE;
      Within_Threshold :    out BOOLEAN)
     is separate;

   --==========================================================================
   -- MINIMUM_VELOCITY
   --==========================================================================
   procedure Minimum_Velocity(
      Threshold        : in     Numeric_Types.FLOAT_32_BIT;
      Velocity         : in     DIS_Types.A_VECTOR;
      Status           :    out DL_Status.STATUS_TYPE;
      Within_Threshold :    out BOOLEAN)
     is separate;


end Filter;
