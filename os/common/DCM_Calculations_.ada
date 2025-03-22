--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      DCM_Calculations (spec)
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
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with DIS_Types,
     OS_Data_Types,
     OS_Status;

package DCM_Calculations is

   procedure Calculate_DCM(
      Trig_of_Eulers :  in     OS_Data_Types.TRIG_OF_EULER_ANGLES_RECORD;
      DCM_Values     :     out OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
      Status         :     out OS_Status.STATUS_TYPE);

   procedure Calculate_Euler_Angles(
      Hashing_Index :  in     INTEGER;
      Euler_Angles  :     out DIS_Types.AN_EULER_ANGLES_RECORD;
      Status        :     out OS_Status.STATUS_TYPE);

   procedure Calculate_Firing_Orientation(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE);

   procedure Calculate_Inverse_DCM(
      DCM_Values         :  in     OS_Data_Types.
                                   DIRECTION_COSINE_MATRIX_RECORD;
      Inverse_DCM_Values :     out OS_Data_Types.
                                   DIRECTION_COSINE_MATRIX_RECORD;
      Status             :     out OS_Status.STATUS_TYPE);

   procedure Convert_Loc_Vel_to_WorldC(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE);

   procedure Convert_EntC_Location_to_WorldC(
      Offset_to_ECS      :  in     DIS_Types.A_WORLD_COORDINATE;
      EntC_to_WorldC_DCM :  in     OS_Data_Types.
                                   DIRECTION_COSINE_MATRIX_RECORD;
      Location_in_EntC   :  in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
      Location_in_WorldC :     out DIS_Types.A_WORLD_COORDINATE;
      Status             :     out OS_Status.STATUS_TYPE);

   procedure Convert_WorldC_Location_to_EntC(
      Offset_to_ECS      :  in     DIS_Types.A_WORLD_COORDINATE;
      WorldC_to_EntC_DCM :  in     OS_Data_Types.
                                   DIRECTION_COSINE_MATRIX_RECORD;
      Location_in_WorldC :  in     DIS_Types.A_WORLD_COORDINATE;
      Location_in_EntC   :     out DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
      Status             :     out OS_Status.STATUS_TYPE);

   procedure Multiply_Matrix_and_Vector(
      Matrix           :  in     OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
      Vector           :  in     DIS_Types.A_VECTOR;
      Resulting_Vector :     out DIS_Types.A_VECTOR;
      Status           :     out OS_Status.STATUS_TYPE);

end DCM_Calculations;
