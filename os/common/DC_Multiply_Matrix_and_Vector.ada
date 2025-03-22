--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Multiply_Matrix_and_Vector
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 October 94
--
-- PURPOSE :
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, OS_Data_Types, and OS_Status.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
separate (DCM_Calculations)

procedure Multiply_Matrix_and_Vector(
   Matrix           :  in     OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
   Vector           :  in     DIS_Types.A_VECTOR;
   Resulting_Vector :     out DIS_Types.A_VECTOR;
   Status           :     out OS_Status.STATUS_TYPE)
  is

begin -- Multiply_Matrix_and_Vector

   -- Initialize status
   Status := OS_Status.SUCCESS;

   Resulting_Vector.X := Matrix.D_11 * Vector.X + Matrix.D_12 * Vector.Y
     + Matrix.D_13 * Vector.Z;
   Resulting_Vector.Y := Matrix.D_21 * Vector.X + Matrix.D_22 * Vector.Y
     + Matrix.D_23 * Vector.Z;
   Resulting_Vector.Z := Matrix.D_31 * Vector.X + Matrix.D_32 * Vector.Y
     + Matrix.D_33 * Vector.Z;

exception
   when OTHERS =>
      Status := OS_Status.MMAV_ERROR;

end Multiply_Matrix_and_Vector;
