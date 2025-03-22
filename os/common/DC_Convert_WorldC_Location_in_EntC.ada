--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Convert_WorldC_Location_to_EntC
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  9 November 94
--
-- PURPOSE :
--   - The CWLTE CSU convert a world coordinate system location into an entity
--     coordinate system using the world-to-entity DCM specified.
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

separate(DCM_Calculations)

procedure Convert_WorldC_Location_to_EntC(
   Offset_to_ECS      :  in     DIS_Types.A_WORLD_COORDINATE;
   WorldC_to_EntC_DCM :  in     OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
   Location_in_WorldC :  in     DIS_Types.A_WORLD_COORDINATE;
   Location_in_EntC   :     out DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Status             :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Translated_Location_in_WorldC :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Returned_Status               :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   MMAV_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT:  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Convert_WorldC_Location_to_EntC

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   Translated_Location_in_WorldC.X := Numeric_Types.FLOAT_32_BIT(
     Location_in_WorldC.X - Offset_to_ECS.X);
   Translated_Location_in_WorldC.Y := Numeric_Types.FLOAT_32_BIT(
     Location_in_WorldC.Y - Offset_to_ECS.Y);
   Translated_Location_in_WorldC.Z := Numeric_Types.FLOAT_32_BIT(
     Location_in_WorldC.Z - Offset_to_ECS.Z);

   Multiply_Matrix_and_Vector(
     Matrix           => WorldC_to_EntC_DCM,
     Vector           => Translated_Location_in_WorldC,
     Resulting_Vector => Location_in_EntC,
     Status           => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise MMAV_ERROR;
   end if;

exception
   when MMAV_ERROR =>
      Status := Returned_Status;
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.CWLTE_ERROR;

end Convert_WorldC_Location_to_EntC;
