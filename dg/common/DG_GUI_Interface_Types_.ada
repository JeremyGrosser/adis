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
-- PACKAGE NAME     : DG_GUI_Interface_Types
--
-- FILE NAME        : DG_GUI_Interface_Types_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 21, 1994
--
-- PURPOSE:
--   - Defines data types common to both the DG Server/GUI Interface and the
--     DG Client/GUI Interface.
--
-- EFFECTS:
--   - None.
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

with DG_Error_Processing_Types;

package DG_GUI_Interface_Types is

   ---------------------------------------------------------------------------
   -- Define type to specify the configuration filename
   ---------------------------------------------------------------------------

   type CONFIGURATION_FILE_COMMAND_TYPE is (
      SAVE,   -- GUI requesting DG to save a configuration file
      LOAD,   -- GUI requesting DG to load a configuration file
      NONE);  -- DG reporting to GUI that load/save command is complete

   K_Max_Configuration_Filename_Length : constant := 100;

   subtype CONFIGURATION_FILENAME_LENGTH_TYPE is
     INTEGER range 0..K_Max_Configuration_Filename_Length;

   type CONFIGURATION_FILE_TYPE is
     record
       Length : CONFIGURATION_FILENAME_LENGTH_TYPE;
       Name   : STRING(1..K_Max_Configuration_Filename_Length);
     end record;

   ---------------------------------------------------------------------------
   -- Define type to specify the error handling parameters.
   ---------------------------------------------------------------------------

   K_Max_Error_Log_Filename_Length : constant := 100;

   subtype ERROR_LOG_FILENAME_LENGTH_TYPE is
     INTEGER range 0..K_Max_Error_Log_Filename_Length;

   type ERROR_LOG_FILE_TYPE is
     record
       Length : ERROR_LOG_FILENAME_LENGTH_TYPE;
       Name   : STRING(1..K_Max_Error_Log_Filename_Length);
     end record;

   type ERROR_PARAMETERS_TYPE is
     record
       Error_Monitor_Enabled : BOOLEAN;
       Error_Log_Enabled     : BOOLEAN;
       Error_Log_File        : ERROR_LOG_FILE_TYPE;
     end record;

   ---------------------------------------------------------------------------
   -- Define type to specify the parameters of simulation data.
   ---------------------------------------------------------------------------

   type SIMULATION_DATA_PARAMETERS_TYPE is
     record
       Maximum_Entities     : INTEGER;
       Maximum_Emitters     : INTEGER;
       Maximum_Lasers       : INTEGER;
       Maximum_Transmitters : INTEGER;
       Maximum_Receivers    : INTEGER;
       PDU_Buffer_Size      : INTEGER;
     end record;

   ---------------------------------------------------------------------------
   -- Define type to store hash table parameters
   ---------------------------------------------------------------------------

   type HASH_TABLE_PARAMETERS_TYPE is
     record
       Index_Increment        : INTEGER;
       Site_Multiplier        : INTEGER;
       Application_Multiplier : INTEGER;
       Entity_Multiplier      : INTEGER;
     end record;

   type HASH_PARAMETERS_TYPE is
     record
       Entity_Hash_Table      : HASH_TABLE_PARAMETERS_TYPE;
       Emission_Hash_Table    : HASH_TABLE_PARAMETERS_TYPE;
       Laser_Hash_Table       : HASH_TABLE_PARAMETERS_TYPE;
       Resupply_Hash_Table    : HASH_TABLE_PARAMETERS_TYPE;
       Repair_Hash_Table      : HASH_TABLE_PARAMETERS_TYPE;
       Receiver_Hash_Table    : HASH_TABLE_PARAMETERS_TYPE;
       Transmitter_Hash_Table : HASH_TABLE_PARAMETERS_TYPE;
     end record;

   ---------------------------------------------------------------------------
   -- Import error tracking types
   ---------------------------------------------------------------------------

   K_Error_Queue_Size : constant := 10;

   type ERROR_MONITOR_TYPE is
     record
       Error_Queue          : DG_Error_Processing_Types.
                                ERROR_QUEUE_TYPE(1..K_Error_Queue_Size);
       Error_Queue_Overflow : BOOLEAN;
       Error_History        : DG_Error_Processing_Types.ERROR_HISTORY_TYPE;
     end record;

end DG_GUI_Interface_Types;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
