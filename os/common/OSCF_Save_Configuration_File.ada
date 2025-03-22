--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Save_Configuration_File
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 August 94
--
-- PURPOSE :
--   - The SCF CSU saves the configuration file data from the GUI to the
--     specified configuration file.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Errors, OS_Status, and Text_IO.
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
     OS_Status,
     Text_IO;

separate (OS_Configuration_Files)

procedure Save_Configuration_File(
   Filename :  in     STRING;
   Status   :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Config_File :  Text_IO.FILE_TYPE;
   Current_Ptr :  OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR
                    := Munition.Top_of_Entity_Data_List_Pointer;

   -- Instantiate packages
   package Boolean_IO is new Text_IO.Enumeration_IO(BOOLEAN);
   package Float_32_IO is new Text_IO.Float_IO(Numeric_Types.FLOAT_32_BIT);
   package Float_64_IO is new Text_IO.Float_IO(Numeric_Types.FLOAT_64_BIT);
   package Integer_IO is new Text_IO.Integer_IO(INTEGER);
   package Parameter_IO
     is new Text_IO.Enumeration_IO(OS_Configuration_Files.USER_KEYWORD_TYPE);
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

   -- Rename functions
   function "="(Left, Right : OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR)
     return BOOLEAN
       renames OS_Data_Types."=";

begin -- Save_Configuration_File

   -- Initialize status
   Status := OS_Status.SUCCESS;

   Text_IO.Create(
     File => Config_File,
     Mode => Text_IO.OUT_FILE,
     Name => Filename);

   -- Write out non-ordnance parameters
   Write_Parameters:
   for Parameter_Index in USER_KEYWORD_TYPE loop

      Parameter_IO.Put(
        File => Config_File,
        Item => Parameter_Index);

      Text_IO.Put(
        File => Config_File,
        Item => " = ");

      case Parameter_Index is

         -- Simulation Parameters

         when CONTACT_THRESHOLD =>

            Float_64_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Contact_Threshold);

         when CYCLE_TIME =>

            Float_32_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Cycle_Time);

         when DATABASE_ORIGIN_LATITUDE =>

            Float_64_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Database_Origin.Latitude);

         when DATABASE_ORIGIN_LONGITUDE =>

            Float_64_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Database_Origin.Longitude);

         when DATABASE_ORIGIN_ALTITUDE =>

            Float_64_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Database_Origin.Altitude);

         when EXERCISE_ID =>

            Unsigned_8_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Exercise_ID);

         when HASH_TABLE_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Hash_Table_Increment);

         when HASH_TABLE_SIZE =>

            Integer_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Hash_Table_Size);

         when MODSAF_DATABASE_FILENAME =>

            Text_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.ModSAF_Database_Filename);

         when MEMORY_LIMIT_FOR_MODSAF_FILE =>

            Integer_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Memory_Limit_for_ModSAF_File);

         when NUMBER_OF_LOOPS_UNTIL_UPDATE =>

            Integer_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Number_of_Loops_Until_Update);

         when PARENT_SITE_ID =>

            Unsigned_16_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Parent_Entity_ID.Sim_Address.
                        Site_ID);

         when PARENT_APPLICATION_ID =>

            Unsigned_16_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Parent_Entity_ID.Sim_Address.
                        Application_ID);

         when PARENT_ENTITY_ID =>

            Unsigned_16_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Parent_Entity_ID.Entity_ID);

         when PROTOCOL_VERSION =>

            Protocol_Version_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Protocol_Version);

         when SIMULATION_STATE =>

            Simulation_State_IO.Put(
              File => Config_File,
              Item => Simulation_Parameters.Simulation_State);


         -- Ordnance parameters are processed later in this routine.
         when DEAD_RECKONING                           |
              FLY_OUT_MODEL_ID                         |
              KIND                                     |
              DOMAIN                                   |
              COUNTRY                                  |
              CATEGORY                                 |
              SUBCATEGORY                              |
              SPECIFIC                                 |
              EXTRA                                    |
              BURN_RATE                                |
              BURN_TIME                                |
              AZIMUTH_DETECTION_ANGLE                  |
              ELEVATION_DETECTION_ANGLE                |
              DRAG_COEFFICIENTS_1                      |
              DRAG_COEFFICIENTS_2                      |
              DRAG_COEFFICIENTS_3                      |
              DRAG_COEFFICIENTS_4                      |
              DRAG_COEFFICIENTS_5                      |
              DRAG_COEFFICIENTS_6                      |
              FRONTAL_AREA                             |
              G_GAIN                                   |
              GUIDANCE                                 |
              ILLUMINATION_FLAG                        |
              INITIAL_MASS                             |
              MAX_GS                                   |
              MAX_SPEED                                |
              THRUST                                   |
              FUZE                                     |
              DETONATION_PROXIMITY_DISTANCE            |
              HEIGHT_RELATIVE_TO_SEA_LEVEL_TO_DETONATE |
              MAX_RANGE                                |
              TIME_TO_DETONATION                       |
              WARHEAD                                  |
              HARD_KILL                                |
              RANGE_TO_DAMAGE                          |
              EMITTER_NAME                             |
              EMITTER_FUNCTION                         |
              EMITTER_ID                               |
              LOCATION_X                               |
              LOCATION_Y                               |
              LOCATION_Z                               |
              FREQUENCY                                |
              FREQUENCY_RANGE                          |
              ERP                                      |
              PRF                                      |
              PULSE_WIDTH                              |
              BEAM_SWEEP_SYNC                          |
              BEAM_PARAMETER_INDEX                     |
              BEAM_FUNCTION                            |
              HIGH_DENSITY_TRACK_JAM                   =>

            null;

         when DISPLAY_ERROR =>

            Boolean_IO.Put(
              File => Config_File,
              Item => Error_Parameters.Display_Error);

         when LOG_ERROR =>

            Boolean_IO.Put(
              File => Config_File,
              Item => Error_Parameters.Log_Error);

         when LOG_FILE =>

            Text_IO.Put(
              File => Config_File,
              Item => Error_Parameters.Log_File.Name(
                        1..Error_Parameters.Log_File.Length));

         -- Configuration management keywords that are not used in
         -- this section.
         when ADDITIONAL_CONFIG_FILE |
              START_MUNITION_DATA    |
              END_MUNITION_DATA      =>

            null;

      end case;

      Text_IO.New_Line(
        File => Config_File);

   end loop Write_Parameters;

   -- Write out ordnance parameters

   Ordnance_Data_Loop:
   while (Current_Ptr /= NULL) loop

      Text_IO.New_Line(
        File => Config_File);

      Text_IO.Put_Line(
        File => Config_File,
        Item => "START_MUNITION_DATA = TRUE");

      Write_Ordnance_Parameters:
      for Parameter_Index in USER_KEYWORD_TYPE loop

         Parameter_IO.Put(
           File => Config_File,
           Item => Parameter_Index);

         Text_IO.Put(
           File => Config_File,
           Item => " = ");

         case Parameter_Index is

            -- Simulation Parameters

            when CONTACT_THRESHOLD            |
                 CYCLE_TIME                   |
                 DATABASE_ORIGIN_LATITUDE     |
                 DATABASE_ORIGIN_LONGITUDE    |
                 DATABASE_ORIGIN_ALTITUDE     |
                 EXERCISE_ID                  |
                 HASH_TABLE_INCREMENT         |
                 HASH_TABLE_SIZE              |
                 MODSAF_DATABASE_FILENAME     |
                 MEMORY_LIMIT_FOR_MODSAF_FILE |
                 NUMBER_OF_LOOPS_UNTIL_UPDATE |
                 PARENT_SITE_ID               |
                 PARENT_APPLICATION_ID        |
                 PARENT_ENTITY_ID             |
                 PROTOCOL_VERSION             |
                 SIMULATION_STATE             =>

               null;

            -- General Parameters

            when DEAD_RECKONING =>

               Dead_Reckoning_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Dead_Reckoning_Algorithm);

            when FLY_OUT_MODEL_ID =>

               Fly_Out_Model_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Fly_Out_Model_ID);

            -- Entity Type

            when KIND =>

               Entity_Kind_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Entity_Type.Entity_Kind);

            when DOMAIN =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Entity_Type.Domain);

            when COUNTRY =>

               Country_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Entity_Type.Country);

            when CATEGORY =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Entity_Type.Category);

            when SUBCATEGORY =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Entity_Type.Subcategory);

            when SPECIFIC =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Entity_Type.Specific);

            when EXTRA =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => General_Parameters.Entity_Type.Extra);

            -- Aerodynamic Parameters

            when BURN_RATE =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Burn_Rate);

            when BURN_TIME =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Burn_Time);

            when AZIMUTH_DETECTION_ANGLE =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Azimuth_Detection_Angle);

            when ELEVATION_DETECTION_ANGLE =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Elevation_Detection_Angle);

            when DRAG_COEFFICIENTS_1 =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Drag_Coefficients(1));

            when DRAG_COEFFICIENTS_2 =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Drag_Coefficients(2));

            when DRAG_COEFFICIENTS_3 =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Drag_Coefficients(3));

            when DRAG_COEFFICIENTS_4 =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Drag_Coefficients(4));

            when DRAG_COEFFICIENTS_5 =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Drag_Coefficients(5));

            when DRAG_COEFFICIENTS_6 =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Drag_Coefficients(6));

            when FRONTAL_AREA =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Frontal_Area);

            when G_GAIN =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.G_Gain);

            when GUIDANCE =>

               Guidance_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Guidance);

            when ILLUMINATION_FLAG =>

               Illumination_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Illumination_Flag);

            when INITIAL_MASS =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Initial_Mass);

            when MAX_GS =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Max_Gs);

            when MAX_SPEED =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Max_Speed);

            when THRUST =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Aerodynamic_Parameters.Thrust);

            -- Termination Parameters

            when FUZE =>

               Fuze_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.Fuze);

            when DETONATION_PROXIMITY_DISTANCE =>

               Float_64_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.
                           Detonation_Proximity_Distance);

            when HEIGHT_RELATIVE_TO_SEA_LEVEL_TO_DETONATE =>

               Float_64_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.
                           Height_Relative_To_Sea_Level_To_Detonate);

            when MAX_RANGE =>

               Float_64_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.Max_Range);

            when TIME_TO_DETONATION =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.Time_to_Detonation);

            when WARHEAD =>

               Warhead_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.Warhead);

            when HARD_KILL =>

               Float_64_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.Hard_Kill);

            when RANGE_TO_DAMAGE =>

               Float_64_IO.Put(
                 File => Config_File,
                 Item => Termination_Parameters.Range_To_Damage);

            -- Emitter Parameters

            when EMITTER_NAME =>

               Emitter_Name_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Emitter_System.Emitter_Name);

            when EMITTER_FUNCTION =>

               Emitter_Function_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Emitter_System.Emitter_Function);

            when EMITTER_ID =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Emitter_System.Emitter_ID);

            when LOCATION_X =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Location.X);

            when LOCATION_Y =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Location.Y);

            when LOCATION_Z =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Location.Z);

            when FREQUENCY =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Fundamental_Parameter_Data.
                           Frequency);

            when FREQUENCY_RANGE =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Fundamental_Parameter_Data.
                           Frequency_Range);

            when ERP =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Fundamental_Parameter_Data.ERP);

            when PRF =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Fundamental_Parameter_Data.PRF);

            when PULSE_WIDTH =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Fundamental_Parameter_Data.
                           Pulse_Width);

            when BEAM_SWEEP_SYNC =>

               Float_32_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Fundamental_Parameter_Data.
                           Beam_Sweep_Sync);

            when BEAM_PARAMETER_INDEX =>

               Unsigned_16_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Beam_Data.Beam_Parameter_Index);

            when BEAM_FUNCTION =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Beam_Data.Beam_Function);

            when HIGH_DENSITY_TRACK_JAM =>

               Unsigned_8_IO.Put(
                 File => Config_File,
                 Item => Emitter_Parameters.Beam_Data.High_Density_Track_Jam);

            -- Error parameters were written out previously
            when DISPLAY_ERROR |
                 LOG_ERROR     |
                 LOG_FILE      =>

               null;

            when ADDITIONAL_CONFIG_FILE |
                 START_MUNITION_DATA    |
                 END_MUNITION_DATA      =>

               null;

         end case;

         Text_IO.New_Line(
           File => Config_File);

      end loop Write_Ordnance_Parameters;

      Text_IO.Put_Line(
        File => Config_File,
        Item => "END_MUNITION_DATA = TRUE");

      Current_Ptr := Current_Ptr.Next;

   end loop Ordnance_Data_Loop;

exception
   when OTHERS =>
      Status := OS_Status.SCF_ERROR;

end Save_Configuration_File;
