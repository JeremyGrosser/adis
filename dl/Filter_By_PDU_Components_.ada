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
-- File Name:          Filter_By_PDU_Components_.ada
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
with DL_Status,
     DIS_Types,
     Numeric_Types;

package Filter_By_PDU_Components is

   --==========================================================================
   -- AZ_AND_EL (Azimuth and Elevation)
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the azimuth and elevation of an entity or event with 
   --   respect to a reference entity are within the specified threshold ranges.
   -- 
   --   Input Parameters:
   --
   --     Az_Angle_1           - Specifies the first angle (in degrees) in the
   --                            azimuth threshold range.
   --
   --     Az_Angle_2           - Specifies the second angle (in degrees) in the 
   --                            azimuth threshold range. 
   --     
   --     El_Angle_1           - Specifies the first angle (in degrees) in the
   --                            elevation threshold range.
   --
   --     El_Angle_2           - Specifies the second angle (in degrees) in the 
   --                            elevation threshold range. 
   --
   --     Location            -  Entity's geocentric position in meters.
   --
   --     Orientation         -  Entity's orientation as defined by Euler Angles.
   --
   --     Position_Of_Interest - Holds a geocentric position in meters which is
   --                            translated into the entity coordinate system
   --                            of the entity described by the
   --                            Entity_State_PDU.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.FILT_PDU_AZ_AND_EL_FAILURE - Indicates an 
   --               exception was raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the
   --               procedure will terminate and the status (error code) for
   --               the failed routine will be returned.
   
   --      Within_Threshold - Returns "TRUE" if the position of both elevation 
   --                         and azimuth is at an angle that is within
   --                         the specified threshold ranges.
   -- Exceptions:
   --   None.
   -- 
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
      Within_Threshold     :    out BOOLEAN);
 

end Filter_By_PDU_Components;
