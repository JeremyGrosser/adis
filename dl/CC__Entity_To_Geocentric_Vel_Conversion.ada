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
-- Unit Name:          Entity_To_Geocentric_Vel_Conversion
--
-- File Name:          CC__Entity_To_Geocentric_Vel_Conversion.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   June 30, 1994
--
-- Purpose:
--
--
--   Converts from the entity of interest coordinate system to a geocentric
--   coordinate system.
--
-- Implementation:
--
--
--   Software based on algorithms developed by IST
--
--   Uses the Euler Angle's trigometric values to calculate the 
--   transformation into the geocentric coordinate system.  See section 
--   4.1.1.8.2.9 of the DL SDD for the transformation equations.
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
     Numeric_Types;

separate (Coordinate_Conversions)

procedure Entity_To_Geocentric_Vel_Conversion (
   Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
   Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
   Entity_Coordinates              : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
   Geocentric_Coordinates          :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
   Status                          :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables.
   --
   
   -- Define a local variable for the euler angles used to calculate the
   -- axis rotation trig function values.
   Angles                       : DIS_Types.AN_EULER_ANGLES_RECORD 
                                    := Euler_Angles;

   Call_Status                  : DL_Status.STATUS_TYPE;

   -- Define storage for the axis rotation trig function values.
   Trig                         : DL_Math.EULER_TRIG_32_BIT := (OTHERS => 0.0);

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE                 : EXCEPTION; 


begin -- Entity_To_Geocentric_Conversion

   Status := DL_Status.SUCCESS;

   -- Calculate the Euler Angle trig functions.
   DL_Math.Calculate_Euler_Trig(
     Euler_Angles => Angles,
     Trig_Values  => Trig,
     Status       => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if;

   -- Calculate the X coordinate in meters.     
   Geocentric_Coordinates.X := 

     Entity_Coordinates.X * (Trig(DL_Math.COS_PSI) * Trig(DL_Math.COS_THETA)) 
 
     + Entity_Coordinates.Y * (Trig(DL_Math.COS_PSI_SIN_PHI) 
         * Trig(DL_Math.SIN_THETA) - Trig(DL_Math.SIN_PSI_COS_PHI))

     + Entity_Coordinates.Z * (Trig(DL_Math.COS_PSI_COS_PHI) 
         * Trig(DL_Math.SIN_THETA) + Trig(DL_Math.SIN_PSI_SIN_PHI));

   -- Calculate the Y coordinate in meters.
   Geocentric_Coordinates.Y := 

     Entity_Coordinates.X * (Trig(DL_Math.SIN_PSI)  * Trig(DL_Math.COS_THETA))
      
     + Entity_Coordinates.Y * (Trig(DL_Math.SIN_PSI_SIN_PHI) 
         * Trig(DL_Math.SIN_THETA) + Trig(DL_Math.COS_PSI_COS_PHI))
      
     + Entity_Coordinates.Z * (Trig(DL_Math.SIN_PSI_COS_PHI)
         * Trig(DL_Math.SIN_THETA) - Trig(DL_Math.COS_PSI_SIN_PHI));

    -- Calculate the Z coordinate in meters.
    Geocentric_Coordinates.Z := 

      - Entity_Coordinates.X * Trig(DL_Math.SIN_THETA) 
        
      + Entity_Coordinates.Y * Trig(DL_Math.COS_THETA) * Trig(DL_Math.SIN_PHI)

      + Entity_Coordinates.Z * Trig(DL_Math.COS_THETA) * Trig(DL_Math.COS_PHI);
   
exception
  
   when CALL_FAILURE =>
      Status := Call_Status;

   when OTHERS       => 
      Status := DL_Status.ENT_GCC_VEL_FAILURE;
        
end Entity_To_Geocentric_Vel_Conversion;

------------------------------------------------------------------------------
-- MODIFICATION HISTORY
------------------------------------------------------------------------------
--
-- 24-Nov-1994, B. Dufault
--   - Removed Entity_Coordinate_System_Center translational bias from
--     calculations, leaving only rotational transformations in place.
--
------------------------------------------------------------------------------
