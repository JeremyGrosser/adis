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
-- Package Name:       Calculate
--
-- File Name:          Calculate.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 5, 1994
--
-- Purpose:
--
--   Contains routines to calculate azimuth, distance, elevation
--   and velocity.
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
	
package body Calculate is
   
   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   --==========================================================================
   -- CALCULATE_AZIMUTH
   --==========================================================================
   procedure Calculate_Azimuth(
      Vector_Position : in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
      Azimuth         :    out Numeric_Types.FLOAT_32_BIT;
      Status          :    out DL_Status.STATUS_TYPE)
     is separate;

    --=========================================================================
    -- CALCULATE_ELEVATION
    --=========================================================================
      procedure Calculate_Elevation(
       Vector_Position : in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
       Elevation       :    out Numeric_Types.FLOAT_32_BIT;
       Status          :    out DL_Status.STATUS_TYPE)
      is separate;

    --=========================================================================
    -- AZIMUTH
    --=========================================================================
    procedure Azimuth(
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Azimuth              :    out Numeric_Types.FLOAT_32_BIT;
      Status               :    out DL_Status.STATUS_TYPE)
     is separate;

   --==========================================================================
   -- AZ_AND_EL (Azimuth and Elevation)
   --==========================================================================
   procedure Az_And_El(
      Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
      Azimuth              :    out Numeric_Types.FLOAT_32_BIT;
      Elevation            :    out Numeric_Types.FLOAT_32_BIT;
      Status               :    out DL_Status.STATUS_TYPE)
     is separate;

    --=========================================================================
    -- DISTANCE
    --=========================================================================
    procedure Distance(
       Position_1 : in     DIS_Types.A_WORLD_COORDINATE;
       Position_2 : in     DIS_Types.A_WORLD_COORDINATE;
       Distance   :    out Numeric_Types.FLOAT_64_BIT; 
       Status     :    out DL_Status.STATUS_TYPE)
      is separate;

    --=========================================================================
    -- ELEVATION
    --=========================================================================
    procedure Elevation(
       Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
       Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
       Elevation            :    out Numeric_Types.FLOAT_32_BIT;
       Status               :    out DL_Status.STATUS_TYPE) 
      is separate;

    --=========================================================================
    -- VELOCITY
    --=========================================================================
    procedure Velocity(
       Linear_Velocity    : in     DIS_Types.A_VECTOR;
       Velocity_Magnitude :    out Numeric_Types.FLOAT_32_BIT;
       Status             :    out DL_Status.STATUS_TYPE) 
      is separate;

 end Calculate;
