--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Configuration_Data
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  14 August 94
--
-- PURPOSE :
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors, Numeric_Types, OS_Status and
--     Text_IO.
--   - This procedure is a modified version of a similar unit in the DIS
--     Gateway CSCI which was written by Brett Dufault.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with DIS_Types,
     Munition,
     Numeric_Types,
     OS_Data_Types,
     OS_GUI,
     OS_Simulation_Types,
     Text_IO;

separate (OS_Configuration_Files)

procedure Process_Configuration_Data(
   Keyword_Name  :  in     STRING;
   Keyword_Value :  in     STRING;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Keyword       :  USER_KEYWORD_TYPE;
   Last          :  POSITIVE;
   Valid_Keyword :  BOOLEAN;

   -- Instantiate packages
   package Boolean_IO is new Text_IO.Enumeration_IO(BOOLEAN);
   package Float_32_IO is new Text_IO.Float_IO(Numeric_Types.FLOAT_32_BIT);
   package Float_64_IO is new Text_IO.Float_IO(Numeric_Types.FLOAT_64_BIT);
   package Integer_IO is new Text_IO.Integer_IO(INTEGER);
   package Unsigned_8_IO
     is new Text_IO.Integer_IO(Numeric_Types.UNSIGNED_8_BIT);
   package Unsigned_16_IO
     is new Text_IO.Integer_IO(Numeric_Types.UNSIGNED_16_BIT);
   package Protocol_Version_IO
     is new Text_IO.Integer_IO(DIS_Types.A_PROTOCOL_VERSION);
   package Simulation_State_IO
     is new Text_IO.Enumeration_IO(OS_Simulation_Types.SIMULATION_STATE_TYPE);
   package Dead_Reckoning_IO
     is new Text_IO.Enumeration_IO(DIS_Types.A_DEAD_RECKONING_ALGORITHM);
   package Fly_Out_Model_IO
     is new Text_IO.Enumeration_IO(OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER);
   package Entity_Kind_IO
     is new Text_IO.Enumeration_IO(DIS_Types.AN_ENTITY_KIND);
   package Country_IO
     is new Text_IO.Enumeration_IO(DIS_Types.A_COUNTRY_ID);
   package Guidance_IO
     is new Text_IO.Enumeration_IO(OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER);
   package Illumination_IO
     is new Text_IO.Enumeration_IO(OS_Data_Types.ILLUMINATION_IDENTIFIER);
   package Fuze_IO
     is new Text_IO.Enumeration_IO(DIS_Types.A_FUZE_TYPE);
   package Warhead_IO
     is new Text_IO.Enumeration_IO(DIS_Types.A_WARHEAD_TYPE);
   package Emitter_Name_IO
     is new Text_IO.Enumeration_IO(DIS_Types.AN_EMITTER_SYSTEM);
   package Emitter_Function_IO
     is new Text_IO.Enumeration_IO(DIS_Types.AN_EMISSION_FUNCTION);

   -- Rename interface areas to improve code readability
   Simulation_Parameters  : OS_Simulation_Types.SIMULATION_PARAMETERS_RECORD
     renames OS_GUI.Interface.Simulation_Parameters;
   General_Parameters     : OS_Data_Types.GENERAL_PARAMETERS_RECORD
     renames OS_GUI.Interface.General_Parameters;
   Aerodynamic_Parameters : OS_Data_Types.AERODYNAMIC_PARAMETERS_RECORD
     renames OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters;
   Termination_Parameters : OS_Data_Types.TERMINATION_PARAMETERS_RECORD
     renames OS_GUI.Interface.General_Parameters.Termination_Parameters;
   Error_Parameters       : OS_Data_Types.ERROR_PARAMETERS_RECORD
     renames OS_GUI.Interface.Error_Parameters;
   Emitter_Parameters     : OS_Data_Types.EMITTER_PARAMETERS_RECORD
     renames OS_GUI.Interface.General_Parameters.Emitter_Parameters;

begin -- Process_Configuration_Data

   -- Initialize status
   Status := OS_Status.SUCCESS;


   -- Attempt to convert Keyword_Name string into Keyword enumeral
   Convert_String_To_Keyword:
   begin

      Keyword       := USER_KEYWORD_TYPE'VALUE(Keyword_Name);
      Valid_Keyword := TRUE;

   exception
      when CONSTRAINT_ERROR =>
         Valid_Keyword := FALSE;

   end Convert_String_To_Keyword;

   if Valid_Keyword then

      case Keyword is

         -- Simulation Parameters

         when CONTACT_THRESHOLD =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Contact_Threshold,
              Last => Last);

         when CYCLE_TIME =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Cycle_Time,
              Last => Last);

         when DATABASE_ORIGIN_LATITUDE =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Database_Origin.Latitude,
              Last => Last);

         when DATABASE_ORIGIN_LONGITUDE =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Database_Origin.Longitude,
              Last => Last);

         when DATABASE_ORIGIN_ALTITUDE =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Database_Origin.Altitude,
              Last => Last);

         when EXERCISE_ID =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Exercise_ID,
              Last => Last);

         when HASH_TABLE_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Hash_Table_Increment,
              Last => Last);

         when HASH_TABLE_SIZE =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Hash_Table_Size,
              Last => Last);

         when MODSAF_DATABASE_FILENAME =>

            -- Clear any existing filename
            Simulation_Parameters.ModSAF_Database_Filename
              := (OTHERS => ASCII.NUL);

            -- Set new filename
            Simulation_Parameters.ModSAF_Database_Filename(
              1..Keyword_Value'LAST) := Keyword_Value;

         when MEMORY_LIMIT_FOR_MODSAF_FILE =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Memory_Limit_for_ModSAF_File,
              Last => Last);

         when NUMBER_OF_LOOPS_UNTIL_UPDATE =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Number_of_Loops_Until_Update,
              Last => Last);

         when PARENT_SITE_ID =>

            Unsigned_16_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Parent_Entity_ID.Sim_Address.
                        Site_ID,
              Last => Last);

         when PARENT_APPLICATION_ID =>

            Unsigned_16_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Parent_Entity_ID.Sim_Address.
                        Application_ID,
              Last => Last);

         when PARENT_ENTITY_ID =>

            Unsigned_16_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Parent_Entity_ID.Entity_ID,
              Last => Last);

         when PROTOCOL_VERSION =>

            Protocol_Version_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Protocol_Version,
              Last => Last);

         when SIMULATION_STATE =>

            Simulation_State_IO.Get(
              From => Keyword_Value,
              Item => Simulation_Parameters.Simulation_State,
              Last => Last);

         -- General Parameters

         when DEAD_RECKONING =>

            Dead_Reckoning_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Dead_Reckoning_Algorithm,
              Last => Last);

         when FLY_OUT_MODEL_ID =>

            Fly_Out_Model_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Fly_Out_Model_ID,
              Last => Last);

         -- Entity Type

         when KIND =>

            Entity_Kind_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Entity_Type.Entity_Kind,
              Last => Last);

         when DOMAIN =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Entity_Type.Domain,
              Last => Last);

         when COUNTRY =>

            Country_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Entity_Type.Country,
              Last => Last);

         when CATEGORY =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Entity_Type.Category,
              Last => Last);

         when SUBCATEGORY =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Entity_Type.Subcategory,
              Last => Last);

         when SPECIFIC =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Entity_Type.Specific,
              Last => Last);

         when EXTRA =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => General_Parameters.Entity_Type.Extra,
              Last => Last);

         -- Aerodynamic Parameters

         when BURN_RATE =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Burn_Rate,
              Last => Last);

         when BURN_TIME =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Burn_Time,
              Last => Last);

         when AZIMUTH_DETECTION_ANGLE =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Azimuth_Detection_Angle,
              Last => Last);

         when ELEVATION_DETECTION_ANGLE =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Elevation_Detection_Angle,
              Last => Last);

         when DRAG_COEFFICIENTS_1 =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Drag_Coefficients(1),
              Last => Last);

         when DRAG_COEFFICIENTS_2 =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Drag_Coefficients(2),
              Last => Last);

         when DRAG_COEFFICIENTS_3 =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Drag_Coefficients(3),
              Last => Last);

         when DRAG_COEFFICIENTS_4 =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Drag_Coefficients(4),
              Last => Last);

         when DRAG_COEFFICIENTS_5 =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Drag_Coefficients(5),
              Last => Last);

         when DRAG_COEFFICIENTS_6 =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Drag_Coefficients(6),
              Last => Last);

         when FRONTAL_AREA =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Frontal_Area,
              Last => Last);

         when G_GAIN =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.G_Gain,
              Last => Last);

         when GUIDANCE =>

            Guidance_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Guidance,
              Last => Last);

         when ILLUMINATION_FLAG =>

            Illumination_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Illumination_Flag,
              Last => Last);

         when INITIAL_MASS =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Initial_Mass,
              Last => Last);

         when MAX_GS =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Max_Gs,
              Last => Last);

         when MAX_SPEED =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Max_Speed,
              Last => Last);

         when THRUST =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Aerodynamic_Parameters.Thrust,
              Last => Last);

         -- Termination Parameters

         when FUZE =>

            Fuze_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.Fuze,
              Last => Last);

         when DETONATION_PROXIMITY_DISTANCE =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.Detonation_Proximity_Distance,
              Last => Last);

         when HEIGHT_RELATIVE_TO_SEA_LEVEL_TO_DETONATE =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.
                        Height_Relative_To_Sea_Level_To_Detonate,
              Last => Last);

         when MAX_RANGE =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.Max_Range,
              Last => Last);

         when TIME_TO_DETONATION =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.Time_to_Detonation,
              Last => Last);

         when WARHEAD =>

            Warhead_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.Warhead,
              Last => Last);

         when HARD_KILL =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.Hard_Kill,
              Last => Last);

         when RANGE_TO_DAMAGE =>

            Float_64_IO.Get(
              From => Keyword_Value,
              Item => Termination_Parameters.Range_To_Damage,
              Last => Last);

         -- Error Parameters

         when DISPLAY_ERROR =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => Error_Parameters.Display_Error,
              Last => Last);

         when LOG_ERROR =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => Error_Parameters.Log_Error,
              Last => Last);

         when LOG_FILE =>

            -- Clear out any existing log file name
            Error_Parameters.Log_File.Name := (OTHERS => ASCII.NUL);

            -- Store new log file name
            Error_Parameters.Log_File.Length := Keyword_Value'LENGTH;
            Error_Parameters.Log_File.Name(
              1..Error_Parameters.Log_File.Length) := Keyword_Value;

         -- Emitter Parameters

         when EMITTER_NAME =>

            Emitter_Name_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Emitter_System.Emitter_Name,
              Last => Last);

         when EMITTER_FUNCTION =>

            Emitter_Function_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Emitter_System.Emitter_Function,
              Last => Last);

         when EMITTER_ID =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Emitter_System.Emitter_ID,
              Last => Last);

         when LOCATION_X =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Location.X,
              Last => Last);

         when LOCATION_Y =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Location.Y,
              Last => Last);

         when LOCATION_Z =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Location.Z,
              Last => Last);

         when FREQUENCY =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Fundamental_Parameter_Data.Frequency,
              Last => Last);

         when FREQUENCY_RANGE =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Fundamental_Parameter_Data.
                        Frequency_Range,
              Last => Last);

         when ERP =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Fundamental_Parameter_Data.ERP,
              Last => Last);

         when PRF =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Fundamental_Parameter_Data.PRF,
              Last => Last);

         when PULSE_WIDTH =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Fundamental_Parameter_Data.
                        Pulse_Width,
              Last => Last);

         when BEAM_SWEEP_SYNC =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Fundamental_Parameter_Data.
                        Beam_Sweep_Sync,
              Last => Last);

         when BEAM_PARAMETER_INDEX =>

            Unsigned_16_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Beam_Data.Beam_Parameter_Index,
              Last => Last);

         when BEAM_FUNCTION =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Beam_Data.Beam_Function,
              Last => Last);

         when HIGH_DENSITY_TRACK_JAM =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => Emitter_Parameters.Beam_Data.High_Density_Track_Jam,
              Last => Last);

         -- Munition parameter control

         when ADDITIONAL_CONFIG_FILE =>

            Load_Configuration_File(
              Filename => Keyword_Value,
              Status   => Status);

         when START_MUNITION_DATA =>

            null;  -- This keyword is used only to permit a kind of block
                   -- structuring to be present in configuration files

         when END_MUNITION_DATA =>

            -- Add the current munition information to the database
            Munition.Add_Related_Entity_Data(
              General_Parameters => General_Parameters,
              Status             => Status);

      end case;

   else
      Status := OS_Status.PCD_STRING_NOT_KEYWORD_ERROR;
   end if;

exception
   when OTHERS =>
      Status := OS_Status.PCD_ERROR;

end Process_Configuration_Data;
