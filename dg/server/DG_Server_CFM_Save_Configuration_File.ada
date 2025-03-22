--
--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--
------------------------------------------------------------------------------
--
-- UNIT NAME        : DG_Server_Configuration_File_Management.
--                      Save_Configuration_File
--
-- FILE NAME        : DG_Server_CFM_Save_Configuration_File.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 01, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - 
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Server_GUI,
     DIS_Types,
     Numeric_Types,
     Text_IO;

separate (DG_Server_Configuration_File_Management)

procedure Save_Configuration_File(
   Filename : in     STRING;
   Status   :    out DG_Status.STATUS_TYPE) is

   Config_File : Text_IO.FILE_TYPE;

   package Integer_IO is
     new Text_IO.Integer_IO(INTEGER);

   package Unsigned_16_IO is
     new Text_IO.Integer_IO(Numeric_Types.UNSIGNED_16_BIT);

   package Unsigned_8_IO is
     new Text_IO.Integer_IO(Numeric_Types.UNSIGNED_8_BIT);

   package Boolean_IO is
     new Text_IO.Enumeration_IO(BOOLEAN);

   package Float_32_IO is
     new Text_IO.Float_IO(Numeric_Types.FLOAT_32_BIT);

   package Parameter_IO is
     new Text_IO.Enumeration_IO(SERVER_PARAMETER_KEYWORD_TYPE);

begin  -- Save_Configuration_File

   Status := DG_Status.SUCCESS;

   Text_IO.Create(
     File => Config_File,
     Mode => Text_IO.OUT_FILE,
     Name => Filename);

   Write_Parameters:
   for Parameter_Index in SERVER_PARAMETER_KEYWORD_TYPE loop

      Parameter_IO.Put(
        File => Config_File,
        Item => Parameter_Index);

      Text_IO.Put(
        File => Config_File,
        Item => " = ");

      case (Parameter_Index) is

         --
         -- General parameters
         --

         when TIMESLICE =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Timeslice);

         --
         -- Network parameters
         --

         when UDP_PORT =>

            Unsigned_16_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Network_Parameters.UDP_Port);

         when BROADCAST_IP_ADDRESS =>

            Write_IP_Components:
            for Component in DG_Server_GUI.IP_DOT_ADDRESS_TYPE'RANGE loop

               --
               -- Print component without leading whitespace
               --
               IP_Component_String:
               declare

                  Component_String : constant STRING
                                       := Numeric_Types.UNSIGNED_8_BIT'IMAGE(
                                            DG_Server_GUI.Interface.
                                              Network_Parameters.
                                                Broadcast_IP_Address(
                                                  Component));

               begin  -- IP_Component_String

                  Text_IO.Put(
                    File => Config_File,
                    Item => Component_String(2..Component_String'LAST));

               end IP_Component_String;

               if (Component /= DG_Server_GUI.IP_DOT_ADDRESS_TYPE'LAST) then

                  Text_IO.Put(
                    File => Config_File,
                    Item => ".");

               end if;

            end loop Write_IP_Components;

         when DATA_RECEPTION_ENABLED =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Network_Parameters.
                        Data_Reception_Enabled);

         when DATA_TRANSMISSION_ENABLED =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Network_Parameters.
                        Data_Transmission_Enabled);

         --
         -- Threshold parameters
         --

         when DISTANCE_THRESHOLD =>

            Float_32_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.Distance);

         when ORIENTATION_THRESHOLD =>

            Float_32_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Orientation);

         when ENTITY_UPDATE_THRESHOLD =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Entity_Update);

         when ENTITY_EXPIRATION_THRESHOLD =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Entity_Expiration);

         when EMISSION_UPDATE_THRESHOLD =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Emission_Update);

         when LASER_UPDATE_THRESHOLD =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Laser_Update);

         when TRANSMITTER_UPDATE_THRESHOLD =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Transmitter_Update);

         when RECEIVER_UPDATE_THRESHOLD =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Receiver_Update);

         --
         -- Exercise parameters
         --

         when SET_EXERCISE_ID =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Set_Exercise_ID);

         when DEFAULT_EXERCISE_ID =>

            Unsigned_8_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Exercise_ID);

         when SET_SITE_ID =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Set_Site_ID);

         when DEFAULT_SITE_ID =>

            Unsigned_16_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.Site_ID);

         when AUTOMATIC_TIMESTAMP =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Automatic_Timestamp);

         when IITSEC_BIT_23_SUPPORT =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        IITSEC_Bit_23_Support);

         when EXPERIMENTAL_PDU_SUPPORT =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Experimental_PDU_Support);

         --
         -- Simulation data parameters
         --

         when MAXIMUM_ENTITIES =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Entities);

         when MAXIMUM_EMITTERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Emitters);

         when MAXIMUM_LASERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Lasers);

         when MAXIMUM_TRANSMITTERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Transmitters);

         when MAXIMUM_RECEIVERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Receivers);

         when PDU_BUFFER_SIZE =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        PDU_Buffer_Size);

         --
         -- Hash parameters
         --

         when ENTITY_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Index_Increment);

         when ENTITY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Site_Multiplier);

         when ENTITY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Application_Multiplier);

         when ENTITY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Entity_Multiplier);

         when EMISSION_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Index_Increment);

         when EMISSION_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Site_Multiplier);

         when EMISSION_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Application_Multiplier);

         when EMISSION_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Entity_Multiplier);

         when LASER_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Index_Increment);

         when LASER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Site_Multiplier);

         when LASER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Application_Multiplier);

         when LASER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Entity_Multiplier);

         when RESUPPLY_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Index_Increment);

         when RESUPPLY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Site_Multiplier);

         when RESUPPLY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Application_Multiplier);

         when RESUPPLY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Entity_Multiplier);

         when REPAIR_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Index_Increment);

         when REPAIR_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Site_Multiplier);

         when REPAIR_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Application_Multiplier);

         when REPAIR_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Entity_Multiplier);

         when RECEIVER_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Index_Increment);

         when RECEIVER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Site_Multiplier);

         when RECEIVER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Application_Multiplier);

         when RECEIVER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Entity_Multiplier);

         when TRANSMITTER_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Index_Increment);

         when TRANSMITTER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Site_Multiplier);

         when TRANSMITTER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Application_Multiplier);

         when TRANSMITTER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Entity_Multiplier);

         --
         -- Filter parameters
         --

         when KEEP_EXERCISE_ID =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Exercise_ID);

         when KEEP_EXERCISE_ID_NUMBER =>

            Unsigned_8_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Exercise_ID);

         when KEEP_OTHER_FORCE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Other_Force);

         when KEEP_FRIENDLY_FORCE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Friendly_Force);

         when KEEP_NEUTRAL_FORCE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Neutral_Force);

         when KEEP_ENTITY_STATE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ENTITY_STATE));

         when KEEP_FIRE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.FIRE));

         when KEEP_DETONATION =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.DETONATION));

         when KEEP_COLLISION =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.COLLISION));

         when KEEP_SERVICE_REQUEST =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.SERVICE_REQUEST));

         when KEEP_RESUPPLY_OFFER =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RESUPPLY_OFFER));

         when KEEP_RESUPPLY_RECEIVED =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RESUPPLY_RECEIVED));

         when KEEP_RESUPPLY_CANCEL =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RESUPPLY_CANCEL));

         when KEEP_REPAIR_COMPLETE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.REPAIR_COMPLETE));

         when KEEP_REPAIR_RESPONSE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.REPAIR_RESPONSE));

         when KEEP_CREATE_ENTITY =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ENTITY_STATE));

         when KEEP_REMOVE_ENTITY =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.REMOVE_ENTITY));

         when KEEP_START_OR_RESUME =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.START_OR_RESUME));

         when KEEP_STOP_OR_FREEZE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.STOP_OR_FREEZE));

         when KEEP_ACKNOWLEDGE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ACKNOWLEDGE));

         when KEEP_ACTION_REQUEST =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ACTION_REQUEST));

         when KEEP_ACTION_RESPONSE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ACTION_RESPONSE));

         when KEEP_DATA_QUERY =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.DATA_QUERY));

         when KEEP_SET_DATA =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.SET_DATA));

         when KEEP_DATA =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.DATA));

         when KEEP_EVENT_REPORT =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.EVENT_REPORT));

         when KEEP_MESSAGE =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.MESSAGE));

         when KEEP_EMISSION =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.EMISSION));

         when KEEP_LASER =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.LASER));

         when KEEP_TRANSMITTER =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.TRANSMITTER));

         when KEEP_SIGNAL =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.SIGNAL));

         when KEEP_RECEIVER =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RECEIVER));

         when ERROR_MONITOR_ENABLED =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Error_Parameters.
                        Error_Monitor_Enabled);

         when ERROR_LOG_ENABLED =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Error_Parameters.
                        Error_Log_Enabled);

         when ERROR_LOG_FILE =>

            Text_IO.Put(
              File => Config_File,
              Item => DG_Server_GUI.Interface.Error_Parameters.
                        Error_Log_File.Name(
                          1..DG_Server_GUI.Interface.Error_Parameters.
                               Error_Log_File.Length));

         when START_GUI =>

            Boolean_IO.Put(
              File => Config_File,
              Item => Start_GUI_Flag);

         when GUI_PROGRAM_NAME =>

            --
            -- If the GUI is not being automatically started by the Server,
            -- then there is no reason to save the GUI program name.
            --
            if (Start_GUI_Flag) then

               Text_IO.Put(
                 File => Config_File,
                 Item => GUI_Program.ALL);

            end if;

      end case;

      Text_IO.New_Line(
        File => Config_File);

   end loop Write_Parameters;

exception

   when OTHERS =>

      Status := DG_Status.SRVCFM_SCF_FAILURE;

end Save_Configuration_File;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
