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
-- UNIT NAME        : DG_Client_Configuration_File_Management.
--                      Save_Configuration_File
--
-- FILE NAME        : DG_Client_CFM_Save_Configuration_File.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 12, 1994
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

with DG_Client_GUI,
     DIS_Types,
     Numeric_Types,
     Text_IO;

separate (DG_Client_Configuration_File_Management)

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
         -- Exercise parameters
         --

         when SET_APPLICATION_ID =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Exercise_Parameters.
                        Set_Application_ID);

         when DEFAULT_APPLICATION_ID =>

            Unsigned_16_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Exercise_Parameters.
                        Application_ID);

         --
         -- Simulation data parameters
         --

         when MAXIMUM_ENTITIES =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Entities);

         when MAXIMUM_EMITTERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Emitters);

         when MAXIMUM_LASERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Lasers);

         when MAXIMUM_TRANSMITTERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Transmitters);

         when MAXIMUM_RECEIVERS =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Receivers);

         when PDU_BUFFER_SIZE =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.
                        PDU_Buffer_Size);

         --
         -- Hash parameters
         --

         when ENTITY_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Index_Increment);

         when ENTITY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Site_Multiplier);

         when ENTITY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Application_Multiplier);

         when ENTITY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Entity_Multiplier);

         when EMISSION_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Index_Increment);

         when EMISSION_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Site_Multiplier);

         when EMISSION_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Application_Multiplier);

         when EMISSION_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Entity_Multiplier);

         when LASER_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Index_Increment);

         when LASER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Site_Multiplier);

         when LASER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Application_Multiplier);

         when LASER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Entity_Multiplier);

         when RESUPPLY_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Index_Increment);

         when RESUPPLY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Site_Multiplier);

         when RESUPPLY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Application_Multiplier);

         when RESUPPLY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Entity_Multiplier);

         when REPAIR_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Index_Increment);

         when REPAIR_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Site_Multiplier);

         when REPAIR_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Application_Multiplier);

         when REPAIR_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Entity_Multiplier);

         when RECEIVER_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Index_Increment);

         when RECEIVER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Site_Multiplier);

         when RECEIVER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Application_Multiplier);

         when RECEIVER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Entity_Multiplier);

         when TRANSMITTER_HASH_INDEX_INCREMENT =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Index_Increment);

         when TRANSMITTER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Site_Multiplier);

         when TRANSMITTER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Application_Multiplier);

         when TRANSMITTER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Entity_Multiplier);


         --
         -- Error parameters
         --

         when ERROR_MONITOR_ENABLED =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Error_Parameters.
                        Error_Monitor_Enabled);

         when ERROR_LOG_ENABLED =>

            Boolean_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Error_Parameters.
                        Error_Log_Enabled);

         when ERROR_LOG_FILE =>

            Text_IO.Put(
              File => Config_File,
              Item => DG_Client_GUI.Interface.Error_Parameters.
                        Error_Log_File.Name(
                          1..DG_Client_GUI.Interface.Error_Parameters.
                               Error_Log_File.Length));

         --
         -- GUI parameters
         --

         when START_GUI =>

            Boolean_IO.Put(
              File => Config_File,
              Item => Start_GUI_Flag);

         when GUI_PROGRAM_NAME =>

            --
            -- If the GUI is not being automatically started by the Client,
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

      Status := DG_Status.CLICFM_SCF_FAILURE;

end Save_Configuration_File;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
