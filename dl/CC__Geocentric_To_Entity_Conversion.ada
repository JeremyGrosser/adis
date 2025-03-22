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
-- Unit Name:          Geocentric_To_Entity_Conversion
--
-- File Name:          CC__Geocentric_To_Entity_Conversion.ada
--
-- Project:            Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 5, 1994
--
-- Purpose:
--
--
-- Implementation:
--
--   Software based on algorithms developed by IST
--
--  Calculate the distance from the entity to the reference point in the
--  geocentric coordinates.  Use this distance plus the Euler Angle's 
--  trigometric values to calculate the transformation to the entity 
--  coordinate system.  See section 4.1.1.4.2.9 of the DL SDD for the
--  transformation equations.
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

procedure Geocentric_To_Entity_Conversion (
   Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
   Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
   Geocentric_Coordinates          : in     DIS_Types.A_WORLD_COORDINATE;
   Entity_Coordinates              :    out DIS_Types. 
                                              AN_ENTITY_COORDINATE_VECTOR;
   Status                          :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables.
   --
  
   -- Define a local variable for the euler angles used to calculate the
   -- axis rotation trig function values.
   Angles             : DIS_Types.AN_EULER_ANGLES_RECORD := Euler_Angles;

   Call_Status        : DL_Status.STATUS_TYPE; 

   -- Distance from entity to reference point in the geocentric coordinate
   -- system (32 bit float in meters).
   Distance           : DIS_Types.A_VECTOR;

   -- Distance from entity to reference point in the geocentric coordinate
   -- system (as 64 bit float in meters).
   Temporary_Distance : DIS_Types.A_WORLD_COORDINATE;

   -- Define storage for the intermediate Euler trigometric calculations. 
   Trig               : DL_Math.EULER_TRIG_32_BIT := (OTHERS => 0.0);

   -- Define an exception to allow for exiting if the called routine fails. 
   CALL_FAILURE       : EXCEPTION;


begin -- Geocentric_To_Entity_Conversion

   Status := DL_Status.SUCCESS;

   -- Calculate the distance from the entity to the reference point in the 
   -- geocentric coordinate system in meters.
   Temporary_Distance.X := Geocentric_Coordinates.X
                             - Entity_Coordinate_System_Center.X;

   Temporary_Distance.Y := Geocentric_Coordinates.Y 
                             - Entity_Coordinate_System_Center.Y; 
     
   Temporary_Distance.Z := Geocentric_Coordinates.Z  
                             - Entity_Coordinate_System_Center.Z;
  
   -- Convert to a 32 bit float for entity coordinate system calculation.    
   Distance.X := Numeric_Types.FLOAT_32_BIT(Temporary_Distance.X);
   Distance.Y := Numeric_Types.FLOAT_32_BIT(Temporary_Distance.Y);
   Distance.Z := Numeric_Types.FLOAT_32_BIT(Temporary_Distance.Z);

   -- Calculate the Euler Angle trig functions.
   DL_Math.Calculate_Euler_Trig(
     Euler_Angles => Angles,
     Trig_Values  => Trig,
     Status       => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if;

   -- Calculate X in meters.
   Entity_Coordinates.X := 
       Distance.X * Trig(DL_Math.COS_PSI) * Trig(DL_Math.COS_THETA)
     + Distance.Y * Trig(DL_Math.SIN_PSI) * Trig(DL_Math.COS_THETA)
     - Distance.Z * Trig(DL_Math.SIN_THETA);

   -- Calculate Y in meters. 
   Entity_Coordinates.Y := 
       Distance.X * (Trig(DL_Math.COS_PSI_SIN_PHI) * Trig(DL_Math.SIN_THETA)
         - Trig(DL_Math.SIN_PSI_COS_PHI))

     + Distance.Y * (Trig(DL_Math.SIN_PSI_SIN_PHI) * Trig(DL_Math.SIN_THETA)
         + Trig(DL_Math.COS_PSI_COS_PHI))
 
     + Distance.Z * (Trig(DL_Math.COS_THETA) * Trig(DL_Math.SIN_PHI));

   -- Calculate Z in meters.
   Entity_Coordinates.Z := 
       Distance.X * (Trig(DL_Math.COS_PSI_COS_PHI) * Trig(DL_Math.SIN_THETA)
         + Trig(DL_Math.SIN_PSI_SIN_PHI))

     + Distance.Y * (Trig(DL_Math.SIN_PSI_COS_PHI) * Trig(DL_Math.SIN_THETA) 
         - Trig(DL_Math.COS_PSI_SIN_PHI)) 
 
     + Distance.Z * (Trig(DL_Math.COS_THETA) * Trig(DL_Math.COS_PHI));

exception
     
   when CALL_FAILURE =>
      Status := Call_Status; 
       
   when OTHERS => 
      Status := DL_Status.GCC_ENT_FAILURE;

end Geocentric_To_Entity_Conversion;
