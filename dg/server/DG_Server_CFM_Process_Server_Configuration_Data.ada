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
--                      Process_Server_Configuration_Data
--
-- FILE NAME        : DG_Server_CFM_Process_Server_Configuration_Data.ada
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

procedure Process_Server_Configuration_Data(
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

begin  -- Process_Server_Configuration_Data

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
         -- General parameters
         --

         when TIMESLICE =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Timeslice,
              Last => Last);

         --
         -- Network parameters
         --

         when UDP_PORT =>

            Unsigned_16_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Network_Parameters.UDP_Port,
              Last => Last);

         when BROADCAST_IP_ADDRESS =>

            Text_IO.Put_Line("No support for BROADCAST_IP_ADDRESS parameter");

         when DATA_RECEPTION_ENABLED =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Network_Parameters.
                        Data_Reception_Enabled,
              Last => Last);

         when DATA_TRANSMISSION_ENABLED =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Network_Parameters.
                        Data_Transmission_Enabled,
              Last => Last);

         --
         -- Threshold parameters
         --

         when DISTANCE_THRESHOLD =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.Distance,
              Last => Last);

         when ORIENTATION_THRESHOLD =>

            Float_32_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Orientation,
              Last => Last);

         when ENTITY_UPDATE_THRESHOLD =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Entity_Update,
              Last => Last);

         when ENTITY_EXPIRATION_THRESHOLD =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Entity_Expiration,
              Last => Last);

         when EMISSION_UPDATE_THRESHOLD =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Emission_Update,
              Last => Last);

         when LASER_UPDATE_THRESHOLD =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Laser_Update,
              Last => Last);

         when TRANSMITTER_UPDATE_THRESHOLD =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Transmitter_Update,
              Last => Last);

         when RECEIVER_UPDATE_THRESHOLD =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Threshold_Parameters.
                        Receiver_Update,
              Last => Last);

         --
         -- Exercise parameters
         --

         when SET_EXERCISE_ID =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Set_Exercise_ID,
              Last => Last);

         when DEFAULT_EXERCISE_ID =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.Exercise_ID,
              Last => Last);

         when SET_SITE_ID =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.Set_Site_ID,
              Last => Last);

         when DEFAULT_SITE_ID =>

            Unsigned_16_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.Site_ID,
              Last => Last);

         when AUTOMATIC_TIMESTAMP =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Automatic_Timestamp,
              Last => Last);

         when IITSEC_BIT_23_SUPPORT =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        IITSEC_Bit_23_Support,
              Last => Last);

         when EXPERIMENTAL_PDU_SUPPORT =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Exercise_Parameters.
                        Experimental_PDU_Support,
              Last => Last);

         --
         -- Simulation data parameters
         --

         when MAXIMUM_ENTITIES =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Entities,
              Last => Last);

         when MAXIMUM_EMITTERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Emitters,
              Last => Last);

         when MAXIMUM_LASERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Lasers,
              Last => Last);

         when MAXIMUM_TRANSMITTERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Transmitters,
              Last => Last);

         when MAXIMUM_RECEIVERS =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        Maximum_Receivers,
              Last => Last);

         when PDU_BUFFER_SIZE =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Simulation_Data_Parameters.
                        PDU_Buffer_Size,
              Last => Last);

         --
         -- Hash parameters
         --

         when ENTITY_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Index_Increment,
              Last => Last);

         when ENTITY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Site_Multiplier,
              Last => Last);

         when ENTITY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Application_Multiplier,
              Last => Last);

         when ENTITY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Entity_Hash_Table.Entity_Multiplier,
              Last => Last);

         when EMISSION_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Index_Increment,
              Last => Last);

         when EMISSION_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Site_Multiplier,
              Last => Last);

         when EMISSION_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Application_Multiplier,
              Last => Last);

         when EMISSION_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Emission_Hash_Table.Entity_Multiplier,
              Last => Last);

         when LASER_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Index_Increment,
              Last => Last);

         when LASER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Site_Multiplier,
              Last => Last);

         when LASER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Application_Multiplier,
              Last => Last);

         when LASER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Laser_Hash_Table.Entity_Multiplier,
              Last => Last);

         when RESUPPLY_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Index_Increment,
              Last => Last);

         when RESUPPLY_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Site_Multiplier,
              Last => Last);

         when RESUPPLY_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Application_Multiplier,
              Last => Last);

         when RESUPPLY_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Resupply_Hash_Table.Entity_Multiplier,
              Last => Last);

         when REPAIR_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Index_Increment,
              Last => Last);

         when REPAIR_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Site_Multiplier,
              Last => Last);

         when REPAIR_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Application_Multiplier,
              Last => Last);

         when REPAIR_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Repair_Hash_Table.Entity_Multiplier,
              Last => Last);


         when RECEIVER_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Index_Increment,
              Last => Last);

         when RECEIVER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Site_Multiplier,
              Last => Last);

         when RECEIVER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Application_Multiplier,
              Last => Last);

         when RECEIVER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Receiver_Hash_Table.Entity_Multiplier,
              Last => Last);

         when TRANSMITTER_HASH_INDEX_INCREMENT =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Index_Increment,
              Last => Last);

         when TRANSMITTER_HASH_SITE_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Site_Multiplier,
              Last => Last);

         when TRANSMITTER_HASH_APPLICATION_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Application_Multiplier,
              Last => Last);

         when TRANSMITTER_HASH_ENTITY_MULTIPLIER =>

            Integer_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Hash_Parameters.
                        Transmitter_Hash_Table.Entity_Multiplier,
              Last => Last);

         --
         -- Filter parameters
         --

         when KEEP_EXERCISE_ID =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Exercise_ID,
              Last => Last);

         when KEEP_EXERCISE_ID_NUMBER =>

            Unsigned_8_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Exercise_ID,
              Last => Last);

         when KEEP_OTHER_FORCE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Other_Force,
              Last => Last);

         when KEEP_FRIENDLY_FORCE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Friendly_Force,
              Last => Last);

         when KEEP_NEUTRAL_FORCE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.
                        Keep_Neutral_Force,
              Last => Last);

         when KEEP_ENTITY_STATE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ENTITY_STATE),
              Last => Last);

         when KEEP_FIRE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.FIRE),
              Last => Last);

         when KEEP_DETONATION =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.DETONATION),
              Last => Last);

         when KEEP_COLLISION =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.COLLISION),
              Last => Last);

         when KEEP_SERVICE_REQUEST =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.SERVICE_REQUEST),
              Last => Last);

         when KEEP_RESUPPLY_OFFER =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RESUPPLY_OFFER),
              Last => Last);

         when KEEP_RESUPPLY_RECEIVED =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RESUPPLY_RECEIVED),
              Last => Last);

         when KEEP_RESUPPLY_CANCEL =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RESUPPLY_CANCEL),
              Last => Last);

         when KEEP_REPAIR_COMPLETE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.REPAIR_COMPLETE),
              Last => Last);

         when KEEP_REPAIR_RESPONSE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.REPAIR_RESPONSE),
              Last => Last);

         when KEEP_CREATE_ENTITY =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ENTITY_STATE),
              Last => Last);

         when KEEP_REMOVE_ENTITY =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.REMOVE_ENTITY),
              Last => Last);

         when KEEP_START_OR_RESUME =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.START_OR_RESUME),
              Last => Last);

         when KEEP_STOP_OR_FREEZE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.STOP_OR_FREEZE),
              Last => Last);

         when KEEP_ACKNOWLEDGE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ACKNOWLEDGE),
              Last => Last);

         when KEEP_ACTION_REQUEST =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ACTION_REQUEST),
              Last => Last);

         when KEEP_ACTION_RESPONSE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.ACTION_RESPONSE),
              Last => Last);

         when KEEP_DATA_QUERY =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.DATA_QUERY),
              Last => Last);

         when KEEP_SET_DATA =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.SET_DATA),
              Last => Last);

         when KEEP_DATA =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.DATA),
              Last => Last);

         when KEEP_EVENT_REPORT =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.EVENT_REPORT),
              Last => Last);

         when KEEP_MESSAGE =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.MESSAGE),
              Last => Last);

         when KEEP_EMISSION =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.EMISSION),
              Last => Last);

         when KEEP_LASER =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.LASER),
              Last => Last);

         when KEEP_TRANSMITTER =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.TRANSMITTER),
              Last => Last);

         when KEEP_SIGNAL =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.SIGNAL),
              Last => Last);

         when KEEP_RECEIVER =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
                        DIS_Types.RECEIVER),
              Last => Last);

         when ERROR_MONITOR_ENABLED =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Error_Parameters.
                        Error_Monitor_Enabled,
              Last => Last);

         when ERROR_LOG_ENABLED =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => DG_Server_GUI.Interface.Error_Parameters.
                        Error_Log_Enabled,
              Last => Last);

         when ERROR_LOG_FILE =>

            DG_Server_GUI.Interface.Error_Parameters.Error_Log_File.Length
              := Keyword_Value'LENGTH;

            DG_Server_GUI.Interface.Error_Parameters.Error_Log_File.Name(
              1..DG_Server_GUI.Interface.Error_Parameters.Error_Log_File.
                   Length) := Keyword_Value;

         when START_GUI =>

            Boolean_IO.Get(
              From => Keyword_Value,
              Item => Start_GUI_Flag,
              Last => Last);

         when GUI_PROGRAM_NAME =>

            GUI_Program := new STRING'(Keyword_Value);

      end case;

   else

      Status := DG_Status.SRVCFM_PSCD_KEYWORD_FAILURE;

   end if;  -- (Valid_Keyword)

exception

   when OTHERS =>

      Status := DG_Status.SRVCFM_PSCD_FAILURE;

end Process_Server_Configuration_Data;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
