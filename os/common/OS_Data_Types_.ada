--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_Data_Types
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  27 May 94
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
with Calendar,
     DIS_Types,
     DL_Linked_List_Types,
     Numeric_Types,
     OS_Status,
     Text_IO;

package OS_Data_Types is

   --
   -- Define Constants
   -- 
   -- Size of circular error buffer
   K_Circular_Buffer_Size   :  constant INTEGER  := 20;
   -- Gravitational acceleration
   K_g  :  constant Numeric_Types.FLOAT_32_BIT := 9.8066; -- m/sec^2
   -- Pi
   K_PI     :  constant Numeric_Types.FLOAT_32_BIT := 3.14159267;
   K_PI_DP  :  constant Numeric_Types.FLOAT_64_BIT := 3.14159267;
   K_2PI    :  constant Numeric_Types.FLOAT_32_BIT := K_PI * 2.0;
   K_2PI_DP :  constant Numeric_Types.FLOAT_64_BIT := K_PI_DP * 2.0;
   -- Conversion factors
   K_Degrees_in_Circle         :  constant Numeric_Types.FLOAT_32_BIT := 360.0;
   K_Degrees_in_Circle_DP      :  constant Numeric_Types.FLOAT_64_BIT := 360.0;
   K_Degrees_in_Semi_Circle    :  constant Numeric_Types.FLOAT_32_BIT := 180.0;
   K_Degrees_in_Semi_Circle_DP :  constant Numeric_Types.FLOAT_64_BIT := 180.0;
   K_Degrees_to_Radians        :  constant Numeric_Types.FLOAT_32_BIT
     := K_PI / K_Degrees_in_Semi_Circle;
   K_Degrees_to_Radians_DP     :  constant Numeric_Types.FLOAT_64_BIT
     := K_PI_DP / K_Degrees_in_Semi_Circle_DP;
   K_Radians_to_Degrees        :  constant Numeric_Types.FLOAT_32_BIT
     := 1.0 / K_Degrees_to_Radians;
   K_Radians_to_Degrees_DP     :  constant Numeric_Types.FLOAT_64_BIT
     := 1.0 / K_Degrees_to_Radians_DP;

   type ARTICULATION_PARAMS_PTR	is
     access DIS_Types.AN_ARTICULATION_PARAMETER_LIST;

   subtype DEGREES is Numeric_Types.FLOAT_32_BIT;

   -- Degrees of a semi-circle centered about zero
   subtype DEGREES_SEMI is Numeric_Types.FLOAT_32_BIT
     range -90.0..90.0;

   -- Degrees of a cirle centered about zero
   subtype DEGREES_CIRC is Numeric_Types.FLOAT_32_BIT
     range (-180.0 + Numeric_Types.FLOAT_32_BIT'SMALL)..180.0;

   subtype DEGREES_PER_SECOND is Numeric_Types.FLOAT_32_BIT;

   type DIRECTION_COSINE_MATRIX_RECORD is
     record
       D_11 :  Numeric_Types.FLOAT_32_BIT;
       D_12 :  Numeric_Types.FLOAT_32_BIT;
       D_13 :  Numeric_Types.FLOAT_32_BIT;
       D_21 :  Numeric_Types.FLOAT_32_BIT;
       D_22 :  Numeric_Types.FLOAT_32_BIT;
       D_23 :  Numeric_Types.FLOAT_32_BIT;
       D_31 :  Numeric_Types.FLOAT_32_BIT;
       D_32 :  Numeric_Types.FLOAT_32_BIT;
       D_33 :  Numeric_Types.FLOAT_32_BIT;
     end record;

   subtype DRAG_COEFFICIENT_TYPE is Numeric_Types.FLOAT_32_BIT;

   type DRAG_COEFFICIENTS_ARRAY is array (1..6) of DRAG_COEFFICIENT_TYPE;

   subtype STRING_SIZE is INTEGER range 0..160;  -- Error types to allow
   type V_STRING (N :  STRING_SIZE := 0) is      -- variable length messages
     record
       Text :  STRING(1..N);
     end record;

   subtype ERROR_MESSAGE_TYPE is V_STRING;  -- Array of error messages
   type ERROR_MESSAGE_ARRAY is
     array (OS_Status.STATUS_TYPE) of ERROR_MESSAGE_TYPE;

   type ERROR_QUEUE_ENTRY_TYPE is           -- Circular buffer for errors
     record
       Detonation_Flag :  BOOLEAN;
       Error           :  OS_Status.STATUS_TYPE;
       Occurrence_Time :  Calendar.TIME;
     end record;
   type ERROR_QUEUE_ARRAY is
     array (1..OS_Data_Types.K_Circular_Buffer_Size) of ERROR_QUEUE_ENTRY_TYPE;

   type ERROR_HISTORY_ENTRY_TYPE is         -- Array to store error history
     record
       Occurrence_Count     :  INTEGER;
       Last_Occurrence_Time :  Calendar.TIME;
     end record;
   type ERROR_HISTORY_TYPE is
     array (OS_Status.STATUS_TYPE) of ERROR_HISTORY_ENTRY_TYPE;

   type FLY_OUT_MODEL_IDENTIFIER is (FOM_AAM, FOM_ASM, FOM_SAM, FOM_KINEMATIC,
     FOM_DRA_FPW);

   type GUIDANCE_MODEL_IDENTIFIER is (BEAM_RIDER, COLLISION, PURSUIT);

   type ILLUMINATION_IDENTIFIER is (MUNITION, PARENT, LASER);

   subtype KILOGRAMS is Numeric_Types.FLOAT_32_BIT;

   subtype KILOGRAMS_PER_SECOND is Numeric_Types.FLOAT_32_BIT;

   subtype METERS is Numeric_Types.FLOAT_32_BIT;

   subtype METERS_DP is Numeric_Types.FLOAT_64_BIT;

   subtype METERS_PER_SECOND is Numeric_Types.FLOAT_32_BIT;

   subtype NEWTONS is Numeric_Types.FLOAT_32_BIT;

   subtype RADIANS is Numeric_Types.FLOAT_32_BIT;

   subtype RADIANS_DP is Numeric_Types.FLOAT_64_BIT;

   subtype RADIANS_PER_SECOND is Numeric_Types.FLOAT_32_BIT;

   subtype SECONDS is Numeric_Types.FLOAT_32_BIT;

   type FIRING_DATA_RECORD is
     record
       Location_in_WorldC    :  DIS_Types.A_WORLD_COORDINATE;
       Orientation           :  DIS_Types.AN_EULER_ANGLES_RECORD;
     end record;

  type FUNDAMENTAL_DATA_RECORD is
    record
      Frequency             : Numeric_Types.FLOAT_32_BIT;
      Frequency_Range       : Numeric_Types.FLOAT_32_BIT;
      ERP                   : Numeric_Types.FLOAT_32_BIT;
      PRF                   : Numeric_Types.FLOAT_32_BIT;
      Pulse_Width           : Numeric_Types.FLOAT_32_BIT;
      Beam_Azimuth_Center   : Numeric_Types.FLOAT_32_BIT;
      Beam_Elevation_Center : Numeric_Types.FLOAT_32_BIT;
      Beam_Sweep_Sync       : Numeric_Types.FLOAT_32_BIT;
    end record;

   type PARTIAL_BEAM_DATA_RECORD is
     record
       Beam_ID_Number         :  Numeric_Types.UNSIGNED_8_BIT := 1;
       Beam_Parameter_Index   :  Numeric_Types.UNSIGNED_16_BIT;
       Beam_Function          :  Numeric_Types.UNSIGNED_8_BIT;
       High_Density_Track_Jam :  Numeric_Types.UNSIGNED_8_BIT;
       Jamming_Mode_Sequence  :  Numeric_Types.UNSIGNED_32_BIT;
     end record;

   type TARGET_DATA_RECORD is
     record
       Azimuth_Heading    :  RADIANS;
       Elevation_Heading  :  RADIANS;
       Location_in_WorldC :  DIS_Types.A_WORLD_COORDINATE;
       Location_in_EntC   :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
       Velocity_in_WorldC :  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
       Velocity_Magnitude :  METERS_PER_SECOND;
     end record;

   type TRIG_OF_EULER_ANGLES_RECORD is
     record
       Cos_Psi   :  Numeric_Types.FLOAT_32_BIT;
       Sin_Psi   :  Numeric_Types.FLOAT_32_BIT;
       Cos_Theta :  Numeric_Types.FLOAT_32_BIT;
       Sin_Theta :  Numeric_Types.FLOAT_32_BIT;
       Cos_Phi   :  Numeric_Types.FLOAT_32_BIT;
       Sin_Phi   :  Numeric_Types.FLOAT_32_BIT;
     end record;

   type NETWORK_PARAMETERS_RECORD is
     record
       Alternate_Entity_Type     :  DIS_Types.AN_ENTITY_TYPE_RECORD;
       Articulation_Parameters   :  ARTICULATION_PARAMS_PTR;
       Burst_Descriptor          :  DIS_Types.A_BURST_DESCRIPTOR;
       Capabilities              :  DIS_Types.AN_ENTITY_CAPABILITIES_RECORD;
       Dead_Reckoning_Parameters :  DIS_Types.A_DEAD_RECKONING_PARAMETER;
       Entity_Appearance         :  DIS_Types.AN_ENTITY_APPEARANCE;
       Entity_ID                 :  DIS_Types.AN_ENTITY_IDENTIFIER;
       Entity_Marking            :  DIS_Types.AN_ENTITY_MARKING;
       Entity_Orientation        :  DIS_Types.AN_EULER_ANGLES_RECORD;
       Event_ID                  :  DIS_Types.AN_EVENT_IDENTIFIER;
       Firing_Entity_ID          :  DIS_Types.AN_ENTITY_IDENTIFIER;
       Force_ID                  :  DIS_Types.A_FORCE_ID;
       Location_in_WorldC        :  DIS_Types.A_WORLD_COORDINATE;
       Target_Entity_ID          :  DIS_Types.AN_ENTITY_IDENTIFIER;
       Velocity_in_WorldC        :  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
     end record;

   type AERODYNAMIC_PARAMETERS_RECORD is
     record
       Burn_Rate                 :  KILOGRAMS_PER_SECOND;
       Burn_Time                 :  SECONDS;
       Azimuth_Detection_Angle   :  DEGREES_CIRC;
       Elevation_Detection_Angle :  DEGREES_CIRC;
       Drag_Coefficients         :  DRAG_COEFFICIENTS_ARRAY; 
       Frontal_Area              :  Numeric_Types.FLOAT_32_BIT;
       G_Gain                    :  Numeric_Types.FLOAT_32_BIT;
       Guidance                  :  GUIDANCE_MODEL_IDENTIFIER;
       Illumination_Flag         :  ILLUMINATION_IDENTIFIER;
       Initial_Mass              :  KILOGRAMS;
       Laser_Code                :  Numeric_Types.UNSIGNED_8_BIT;
       Max_Gs                    :  Numeric_Types.FLOAT_32_BIT;
       Max_Speed                 :  METERS_PER_SECOND;
       Thrust                    :  NEWTONS;
     end record;

   type FLIGHT_PARAMETERS_RECORD is
     record
       Current_Mass               :  KILOGRAMS;
       Cycle_Time                 :  SECONDS;
       DCM                        :  DIRECTION_COSINE_MATRIX_RECORD;
       Fly_Out_Model_ID           :  FLY_OUT_MODEL_IDENTIFIER;
       Greq                       :  Numeric_Types.FLOAT_32_BIT;
       Firing_Data                :  FIRING_DATA_RECORD;
       Inverse_DCM                :  DIRECTION_COSINE_MATRIX_RECORD;
       Location_in_EntC           :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
       Loop_Counter               :  INTEGER := 0;
       Max_Turn                   :  RADIANS_PER_SECOND;
       Munition_Azimuth_Heading   :  RADIANS;
       Munition_Elevation_Heading :  RADIANS;
       Possible_Targets_List      :  DL_Linked_List_Types.
                                     Entity_State_List.PTR;
       Previous_Update_Time       :  Calendar.TIME;
       Range_to_Target            :  METERS_DP;
       Target                     :  TARGET_DATA_RECORD;
       Time_in_Flight             :  SECONDS;
       Velocity_in_EntC           :  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
       Velocity_Magnitude         :  METERS_PER_SECOND; -- in Entity Coords
     end record;

   type EMITTER_PARAMETERS_RECORD is
     record
       Emitter_System             :  DIS_Types.AN_EMITTER_SYSTEM_RECORD;
       Location                   :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
       Fundamental_Parameter_Data :  FUNDAMENTAL_DATA_RECORD;
       Beam_Data                  :  PARTIAL_BEAM_DATA_RECORD;
     end record;

   type TERMINATION_PARAMETERS_RECORD is
     record
       Current_Range                            :  METERS_DP;
       Detonation_Proximity_Distance            :  METERS_DP;
       Fuze                                     :  DIS_Types.A_FUZE_TYPE;
       Hard_Kill                                :  METERS_DP;
       Height_Relative_to_Sea_Level_to_Detonate :  METERS_DP;
       Max_Range                                :  METERS_DP;
       Previous_Range                           :  METERS_DP;
       Range_to_Damage                          :  METERS_DP;
       Time_to_Detonation                       :  SECONDS;
       Warhead                                  :  DIS_Types.A_WARHEAD_TYPE;
     end record;

   type GENERAL_PARAMETERS_RECORD is
     record
       Aerodynamic_Parameters   :  AERODYNAMIC_PARAMETERS_RECORD;
       Alternate_Entity_Type    :  DIS_Types.AN_ENTITY_TYPE_RECORD;
       Articulation_Parameters  :  ARTICULATION_PARAMS_PTR;
       Capabilities             :  DIS_Types.AN_ENTITY_CAPABILITIES_RECORD;
       Dead_Reckoning_Algorithm :  DIS_Types.A_DEAD_RECKONING_ALGORITHM;
       Emitter_Parameters       :  EMITTER_PARAMETERS_RECORD;
       Entity_Appearance        :  DIS_Types.AN_ENTITY_APPEARANCE;
       Entity_Marking           :  DIS_Types.AN_ENTITY_MARKING;
       Entity_Type              :  DIS_Types.AN_ENTITY_TYPE_RECORD;
       Fly_Out_Model_ID         :  FLY_OUT_MODEL_IDENTIFIER;
       Termination_Parameters   :  TERMINATION_PARAMETERS_RECORD;
     end record;
   type GENERAL_PARAMETERS_RECORD_PTR is access GENERAL_PARAMETERS_RECORD;

   type USER_SUPPLIED_DATA_RECORD;
   type USER_SUPPLIED_DATA_RECORD_PTR is access USER_SUPPLIED_DATA_RECORD;
   type USER_SUPPLIED_DATA_RECORD is
     record
       Prev               :  USER_SUPPLIED_DATA_RECORD_PTR;
       Next               :  USER_SUPPLIED_DATA_RECORD_PTR;
       General_Parameters :  GENERAL_PARAMETERS_RECORD_PTR;
     end record;

   K_Max_Log_Filename_Length : constant := 100;

   subtype LOG_FILENAME_LENGTH_TYPE is
     INTEGER range 0..K_Max_Log_Filename_Length;

   type LOG_FILE_TYPE is
     record
       Length : LOG_FILENAME_LENGTH_TYPE;
       Name   : STRING(1..K_Max_Log_Filename_Length);
     end record;

   Log_File : Text_IO.FILE_TYPE;

   type ERROR_PARAMETERS_RECORD is
     record
       Display_Error  :  BOOLEAN;
       Log_Error      :  BOOLEAN;
       Log_File       :  LOG_FILE_TYPE;
       History        :  ERROR_HISTORY_TYPE;
       Queue          :  ERROR_QUEUE_ARRAY;
       Queue_Overflow :  BOOLEAN;
       Read_Index     :  INTEGER;
       Write_Index    :  INTEGER;
     end record;

   K_Max_Configuration_Filename_Length : constant := 100;

   subtype CONFIGURATION_FILENAME_LENGTH_TYPE is
     INTEGER range 0..K_Max_Configuration_Filename_Length;

   type CONFIGURATION_FILE_TYPE is
     record
       Length : CONFIGURATION_FILENAME_LENGTH_TYPE;
       Name   : STRING(1..K_Max_Configuration_Filename_Length);
     end record;

   type CONFIGURATION_COMMAND_TYPE is (LOAD, SAVE, NONE);

end OS_Data_Types;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
--  3 NOV 94 -- KJN:  Added LASER to ILLUMINATION_IDENTIFIER and added
--           Laser_Code to AERODYNAMIC_PARAMETERS_RECORD.
-- 11 NOV 94 -- KJN:  Removed Velocity_Magnitude from Flight_Parameters.
--           Firing_Data.
