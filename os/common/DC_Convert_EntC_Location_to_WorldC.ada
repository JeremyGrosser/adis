--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Convert_EntC_Location_to_WorldC
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  9 November 94
--
-- PURPOSE :
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors, Numeric_Types, OS_Data_Types,
--     and OS_Status.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with Errors,
     Numeric_Types;

separate (DCM_Calculations)

procedure Convert_EntC_Location_to_WorldC(
   Offset_to_ECS      :  in     DIS_Types.A_WORLD_COORDINATE;
   EntC_to_WorldC_DCM :  in     OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
   Location_in_EntC   :  in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Location_in_WorldC :     out DIS_Types.A_WORLD_COORDINATE;
   Status             :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Returned_Status            :  OS_Status.STATUS_TYPE;
   Rotated_Location_in_WorldC :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;

   -- Local exceptions
   MMAV_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT:  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Convert_EntC_Location_to_WorldC

   -- Initialize status
   Status := OS_Status.SUCCESS;

   Multiply_Matrix_and_Vector(
     Matrix           => EntC_to_WorldC_DCM,
     Vector           => Location_in_EntC,
     Resulting_Vector => Rotated_Location_in_WorldC,
     Status           => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise MMAV_ERROR;
   end if;

   Location_in_WorldC.X := Numeric_Types.FLOAT_64_BIT(
     Rotated_Location_in_WorldC.X) + Offset_to_ECS.X;
   Location_in_WorldC.Y := Numeric_Types.FLOAT_64_BIT(
     Rotated_Location_in_WorldC.Y) + Offset_to_ECS.Y;
   Location_in_WorldC.Z := Numeric_Types.FLOAT_64_BIT(
     Rotated_Location_in_WorldC.Z) + Offset_to_ECS.Z;

exception
   when MMAV_ERROR =>
      Status := Returned_Status;
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.CELTW_ERROR;

end Convert_EntC_Location_to_WorldC;
