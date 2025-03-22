--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Calculate_Inverse_DCM
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  21 October 94
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

procedure Calculate_Inverse_DCM(
   DCM_Values         :  in     OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
   Inverse_DCM_Values :     out OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
   Status             :     out OS_Status.STATUS_TYPE)
  is

begin -- Calculate_Inverse_DCM

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Because direction cosine matrices are orthonormal, the inverse is equal
   -- to its transpose
   Inverse_DCM_Values.D_11 := DCM_Values.D_11;
   Inverse_DCM_Values.D_12 := DCM_Values.D_21;
   Inverse_DCM_Values.D_13 := DCM_Values.D_31;
   Inverse_DCM_Values.D_21 := DCM_Values.D_12;
   Inverse_DCM_Values.D_22 := DCM_Values.D_22;
   Inverse_DCM_Values.D_23 := DCM_Values.D_32;
   Inverse_DCM_Values.D_31 := DCM_Values.D_13;
   Inverse_DCM_Values.D_32 := DCM_Values.D_23;
   Inverse_DCM_Values.D_33 := DCM_Values.D_33;

exception
   when OTHERS =>
      Status := OS_Status.CIDCM_ERROR;

end Calculate_Inverse_DCM;
