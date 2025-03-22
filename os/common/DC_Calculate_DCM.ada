--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Calculate_DCM
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 October 94
--
-- PURPOSE :
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires OS_Data_Types, and OS_Status.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
separate (DCM_Calculations)

procedure Calculate_DCM(
   Trig_of_Eulers :  in     OS_Data_Types.TRIG_OF_EULER_ANGLES_RECORD;
   DCM_Values     :     out OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
   Status         :     out OS_Status.STATUS_TYPE)
  is

begin -- Calculate_DCM

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Calculate DCM Values
   DCM_Values.D_11 := Trig_of_Eulers.Cos_Psi * Trig_of_Eulers.Cos_Theta;
   DCM_Values.D_21 := Trig_of_Eulers.Sin_Psi * Trig_of_Eulers.Cos_Theta;
   DCM_Values.D_31 := - Trig_of_Eulers.Sin_Theta;

   DCM_Values.D_12 := Trig_of_Eulers.Cos_Psi
     * Trig_of_Eulers.Sin_Theta * Trig_of_Eulers.Sin_Phi
     - Trig_of_Eulers.Cos_Phi * Trig_of_Eulers.Sin_Psi;
   DCM_Values.D_22 := Trig_of_Eulers.Sin_Psi
     * Trig_of_Eulers.Sin_Theta * Trig_of_Eulers.Sin_Phi
     + Trig_of_Eulers.Cos_Phi * Trig_of_Eulers.Cos_Psi;
   DCM_Values.D_32 := Trig_of_Eulers.Cos_Theta * Trig_of_Eulers.Sin_Phi;

   DCM_Values.D_13 := Trig_of_Eulers.Cos_Psi
     * Trig_of_Eulers.Sin_Theta * Trig_of_Eulers.Cos_Phi
     + Trig_of_Eulers.Sin_Phi * Trig_of_Eulers.Sin_Psi;
   DCM_Values.D_23 := Trig_of_Eulers.Sin_Psi
     * Trig_of_Eulers.Sin_Theta * Trig_of_Eulers.Cos_Phi
     - Trig_of_Eulers.Sin_Phi * Trig_of_Eulers.Cos_Psi;
   DCM_Values.D_33 := Trig_of_Eulers.Cos_Theta * Trig_of_Eulers.Cos_Phi;

exception
   when OTHERS =>
      Status := OS_Status.CDCM_ERROR;

end Calculate_DCM;
