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
--                      Process_Client_Configuration_Data
--
-- FILE NAME        : DG_Client_CFM_Process_Client_Configuration_Data.ada
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

with DIS_Types,
     Numeric_Types,
     Text_IO;

separate (DG_Client_Configuration_File_Management)

procedure Process_Client_Configuration_Data(
   Keyword_Name  : in     STRING;
   Keyword_Value : in     STRING;
   Status        :    out DG_Status.STATUS_TYPE) is

   Keyword       : SERVER_PARAMETER_KEYWORD_TYPE;
   Last          : POSITIVE;
   Valid_Keyword : BOOLEAN;

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

begin  -- Process_Client_Configuration_Data

   Status := DG_Status.SUCCESS;

   --
   -- Attempt to convert Keyword_Name string into Keyword enumeral
   --
   Convert_String_To_Keyword:
   begin

      Keyword       := SERVER_PARAMETER_KEYWORD_TYPE'VALUE(Keyword_Name);

      Valid_Keyword := TRUE;

   exception

      when CONSTRAINT_ERROR =>

         Valid_Keyword := FALSE;

   end Convert_String_To_Keyword;

   if (Valid_Keyword) then

      case (Keyword) is

         --
         -- Exercise parameters
         --

         when SET_APPLICATION_ID =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Exercise_Parameters.Set_Application_ID,
              Last => Last);

         when DEFAULT_APPLICATION_ID =>

            Unsigned_16_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Exercise_Parameters.Application_ID,
              Last => Last);

         --
         -- Simulation data parameters
         --

         when MAXIMUM_ENTITIES =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.Maximum_Entities,
              Last => Last);

         when MAXIMUM_EMITTERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.Maximum_Emitters,
              Last => Last);

         when MAXIMUM_LASERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.Maximum_Lasers,
              Last => Last);

         when MAXIMUM_TRANSMITTERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Transmitters,
              Last => Last);

         when MAXIMUM_RECEIVERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.Maximum_Receivers,
              Last => Last);

         when PDU_BUFFER_SIZE =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Simulation_Data_Parameters.PDU_Buffer_Size,
              Last => Last);

         --
         -- Hash parameters
         --

         when ENTITY_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Entity_Hash_Table.
                        Index_Increment,
              Last => Last);

         when ENTITY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Entity_Hash_Table.
                        Site_Multiplier,
              Last => Last);

         when ENTITY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Entity_Hash_Table.
                        Application_Multiplier,
              Last => Last);

         when ENTITY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Entity_Hash_Table.
                        Entity_Multiplier,
              Last => Last);

         when EMISSION_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Emission_Hash_Table.
                        Index_Increment,
              Last => Last);

         when EMISSION_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Emission_Hash_Table.
                        Site_Multiplier,
              Last => Last);

         when EMISSION_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Emission_Hash_Table.
                        Application_Multiplier,
              Last => Last);

         when EMISSION_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Emission_Hash_Table.
                        Entity_Multiplier,
              Last => Last);

         when LASER_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Laser_Hash_Table.
                        Index_Increment,
              Last => Last);

         when LASER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Laser_Hash_Table.
                        Site_Multiplier,
              Last => Last);

         when LASER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Laser_Hash_Table.
                        Application_Multiplier,
              Last => Last);

         when LASER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Laser_Hash_Table.
                        Entity_Multiplier,
              Last => Last);

         when RESUPPLY_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Resupply_Hash_Table.
                        Index_Increment,
              Last => Last);

         when RESUPPLY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Resupply_Hash_Table.
                        Site_Multiplier,
              Last => Last);

         when RESUPPLY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Resupply_Hash_Table.
                        Application_Multiplier,
              Last => Last);

         when RESUPPLY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Resupply_Hash_Table.
                        Entity_Multiplier,
              Last => Last);

         when REPAIR_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Repair_Hash_Table.
                        Index_Increment,
              Last => Last);

         when REPAIR_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Repair_Hash_Table.
                        Site_Multiplier,
              Last => Last);

         when REPAIR_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Repair_Hash_Table.
                        Application_Multiplier,
              Last => Last);

         when REPAIR_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Repair_Hash_Table.
                        Entity_Multiplier,
              Last => Last);


         when RECEIVER_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Receiver_Hash_Table.
                        Index_Increment,
              Last => Last);

         when RECEIVER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Receiver_Hash_Table.
                        Site_Multiplier,
              Last => Last);

         when RECEIVER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Receiver_Hash_Table.
                        Application_Multiplier,
              Last => Last);

         when RECEIVER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Receiver_Hash_Table.
                        Entity_Multiplier,
              Last => Last);

         when TRANSMITTER_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Transmitter_Hash_Table.
                        Index_Increment,
              Last => Last);

         when TRANSMITTER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Transmitter_Hash_Table.
                        Site_Multiplier,
              Last => Last);

         when TRANSMITTER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Transmitter_Hash_Table.
                        Application_Multiplier,
              Last => Last);

         when TRANSMITTER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Hash_Parameters.Transmitter_Hash_Table.
                        Entity_Multiplier,
              Last => Last);

         when ERROR_MONITOR_ENABLED =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Error_Parameters.Error_Monitor_Enabled,
              Last => Last);

         when ERROR_LOG_ENABLED =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Client_GUI.Interface.Error_Parameters.Error_Log_Enabled,
              Last => Last);

         when ERROR_LOG_FILE =>

            DG_Client_GUI.Interface.Error_Parameters.Error_Log_File.Length
              := Keyword_Value'LENGTH;

            DG_Client_GUI.Interface.Error_Parameters.Error_Log_File.Name(
              1..DG_Client_GUI.Interface.Error_Parameters.Error_Log_File.Length)
                := Keyword_Value;

         when START_GUI =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => Start_GUI_Flag,
              Last => Last);

         when GUI_PROGRAM_NAME =>

            GUI_Program := new STRING'(Keyword_Value);

      end case;

   else

      Status := DG_Status.CLICFM_PCCD_KEYWORD_FAILURE;

   end if;  -- (Valid_Keyword)

exception

   when OTHERS =>

      Status := DG_Status.CLICFM_PCCD_FAILURE;

end Process_Client_Configuration_Data;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
