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
-- Package Name:       DL_Math
--
-- File Name:          DL_Math.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 16, 1994
--
-- Purpose
--
--      Contains data math types and routines used by the DL CSCI.
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

with DL_Types,
     Math;
    
package body DL_Math is

   --==========================================================================
   -- SIN_COS_LAT
   --==========================================================================
   --   
   -- Purpose:
   -- 
   --    Simultaneous sine and cosine calculation to be used in place of
   --    Math Library Sine and Cosine functions when the angle is known
   --    to be between -pi/2 and pi/2 radians (such as latitude).
   --
   -- Implementation: 
   --
   --    Calls Math functions to do both calculations in radians.
   --
   --
   --==========================================================================
   procedure Sin_Cos_Lat (
      Angle     : in     HALF_PI_ANGLE;
      Cos_Angle :    out Numeric_Types.FLOAT_64_BIT;
      Sin_Angle :    out Numeric_Types.FLOAT_64_BIT;
      Status    :    out DL_Status.STATUS_TYPE) is
      
      --
      -- Declare local variables.
      --

      -- Define variable for sine of the angle that can be used to calculate
      -- the cosine value.
      Temp_Sin_Angle : Numeric_Types.FLOAT_64_BIT;

   begin
        
      Status         := DL_Status.SUCCESS;
 
      -- Calculate the sine of the input angle.
      Temp_Sin_Angle := Math.Sin(Angle);
      Sin_Angle      := Temp_Sin_Angle;

      -- Calculate the cosine of the input angle        
      Cos_Angle      := Math.Sqrt(1.0 - Temp_Sin_Angle * Temp_Sin_Angle);

   exception

      when OTHERS =>
         Status := DL_Status.SIN_COS_LAT_FAILURE;

   end Sin_Cos_Lat;

   --==========================================================================
   -- SIN_COS_LON
   --==========================================================================
   -- 
   -- Purpose:
   --
   --    Simultaneous sine and cosine calculation to be used in place of
   --    Math Sine and Cosine functions when the angle is known to be
   --    between -pi and +pi radians (such as longitude).
   --
   -- Implementation:
   --
   --    Calls Math functions to do both calculations in radians.
   -- 
   --==========================================================================
   procedure Sin_Cos_Lon (
      Angle     : in     PI_ANGLE;
      Cos_Angle :    out Numeric_Types.FLOAT_64_BIT;
      Sin_Angle :    out Numeric_Types.FLOAT_64_BIT;
      Status    :    out DL_Status.STATUS_TYPE) is
        
      -- 
      -- Declare local variables.
      --
    
      -- Define variable for the cosine of the angle that can be used to 
      -- calculate the sine value.
      Temp_Cos_Angle : Numeric_Types.FLOAT_64_BIT;

      -- Define variable for sine of the angle that can be used to negate
      -- the sine if needed.
      Temp_Sin_Angle : Numeric_Types.FLOAT_64_BIT;
 
   begin
           
      Status         := DL_Status.SUCCESS;

      -- Calculate Cosine.         
      Temp_Cos_Angle := Math.Cos(Angle);
      Cos_Angle      := Temp_Cos_Angle;

      --Calculate Sine
      Temp_Sin_Angle := Math.Sqrt(1.0 - (Temp_Cos_Angle * Temp_Cos_Angle)); 
           
      if Angle >= 0.0 then
         Sin_Angle := Temp_Sin_Angle;
      else
         Sin_Angle := -Temp_Sin_Angle;
      end if;

   exception
 
       when OTHERS => 
          Status := DL_Status.SIN_COS_LON_FAILURE;
     
   end Sin_Cos_Lon;

   --==========================================================================
   --  CALCULATE_EULER_TRIG
   --==========================================================================
   -- 
   -- Purpose:
   -- 
   --   Since the transformation matrix to convert between entity and
   --   geocentric coordinates uses many of the same math functions multiple
   --   times, this unit stores these values for use in other calculations.
   --
   -- Implementation:
   --
   --    Converts the Euler Angles from degrees to radians then calls the 
   --    predefined Math Library trigonometric functions to do calculations
   --    in radians.
   --
   --==========================================================================
   procedure Calculate_Euler_Trig (
      Euler_Angles : in      DIS_Types.AN_EULER_ANGLES_RECORD;
      Trig_Values  :    out  EULER_TRIG_32_BIT;
      Status       :    out  DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables.
      --
      Trig  : EULER_TRIG_32_BIT 
                := (OTHERS => 0.0);
      
      Psi   : Numeric_Types.FLOAT_32_BIT 
                 := Euler_Angles.Psi;

      Theta : Numeric_Types.FLOAT_32_BIT 
                 := Euler_Angles.Theta;

      Phi   : Numeric_Types.FLOAT_32_BIT 
                 := Euler_Angles.Phi;
 
   begin

      Status := DL_Status.SUCCESS;
  
      Trig(SIN_PSI)   := Math.Sin(Psi);
      
      Trig(SIN_THETA) := Math.Sin(Theta);
      
      Trig(SIN_PHI)   := Math.Sin(Phi);
      
      Trig(COS_PSI)   := Math.Cos(Psi);
      
      Trig(COS_THETA) := Math.Cos(Theta);
      
      Trig(COS_PHI)   := Math.Cos(Phi);

      Trig(SIN_PSI_SIN_PHI) := Trig(SIN_PSI) * Trig(SIN_PHI);
                                         
      Trig(SIN_PSI_COS_PHI) := Trig(SIN_PSI) * Trig(COS_PHI);

      Trig(COS_PSI_SIN_PHI) := Trig(COS_PSI) * Trig(SIN_PHI);

      Trig(COS_PSI_COS_PHI) := Trig(COS_PSI) * Trig(COS_PHI);
 
      Trig_Values := Trig;
 
   exception

       when OTHERS =>
          Status := DL_Status.CAL_EULER_TRIG_FAILURE; 

   end Calculate_Euler_Trig;

   --==========================================================================
   --  CALCULATE_EULER_TRIG
   --==========================================================================
   --
   -- Purpose:
   --
   --   Since the transformation matrix to convert between entity and
   --   geocentric coordinates uses many of the same math functions multiple
   --   times, this unit stores these values for use in other calculations.
   --
   -- Implementation:
   -- 
   --    Converts the Euler Angles from degrees to radians then calls the 
   --    predefined Math Library trigonometric functions to do calculations
   --    in radians.
   --
   --
   --==========================================================================
   procedure Calculate_Euler_Trig (
      Euler_Angles : in      DIS_Types.AN_EULER_ANGLES_RECORD;
      Trig_Values  :    out  EULER_TRIG_64_BIT;
      Status       :    out  DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables.
      --
      Trig  : EULER_TRIG_64_BIT 
                := (OTHERS => 0.0);

      Psi   : Numeric_Types.FLOAT_64_BIT 
                := Numeric_Types.FLOAT_64_BIT(
                     Euler_Angles.Psi);

      Theta : Numeric_Types.FLOAT_64_BIT 
                := Numeric_Types.FLOAT_64_BIT(
                     Euler_Angles.Theta);

      Phi  : Numeric_Types.FLOAT_64_BIT 
               := Numeric_Types.FLOAT_64_BIT (
                    Euler_Angles.Phi);
 
 
   begin

      Status := DL_Status.SUCCESS;

      Trig(SIN_PSI)   := Math.Sin(Psi);
  
      Trig(SIN_THETA) := Math.Sin(Theta);
  
      Trig(SIN_PHI)   := Math.Sin(Phi);
  
      Trig(COS_PSI)   := Math.Cos(Psi);
  
      Trig(COS_THETA) := Math.Cos(Theta);
  
      Trig(COS_PHI)   := Math.Cos(Phi);

      Trig(SIN_PSI_SIN_PHI) := Trig(SIN_PSI) * Trig(SIN_PHI);
                                         
      Trig(SIN_PSI_COS_PHI) := Trig(SIN_PSI) * Trig(COS_PHI);

      Trig(COS_PSI_SIN_PHI) := Trig(COS_PSI) * Trig(SIN_PHI);

      Trig(COS_PSI_COS_PHI) := Trig(COS_PSI) * Trig(COS_PHI);
      
      Trig_Values := Trig;
         
   exception
         
      when OTHERS => 
         Status := DL_Status.CAL_EULER_TRIG_FAILURE;

   end Calculate_Euler_Trig;

end DL_Math;
