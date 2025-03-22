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
-- PACKAGE NAME     : DG_Client_Configuration_File_Management
--
-- FILE NAME        : DG_Client_Configuration_File_Management.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 12, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Client_Error_Processing,
     DG_Client_GUI,
     DG_Configuration_File_Management;

package body DG_Client_Configuration_File_Management is

   type SERVER_PARAMETER_KEYWORD_TYPE is (

      -- Exercise parameters

      SET_APPLICATION_ID,                         -- boolean
      DEFAULT_APPLICATION_ID,                     -- integer

      -- Simulation data parameters

      MAXIMUM_ENTITIES,                           -- integer
      MAXIMUM_EMITTERS,                           -- integer
      MAXIMUM_LASERS,                             -- integer
      MAXIMUM_TRANSMITTERS,                       -- integer
      MAXIMUM_RECEIVERS,                          -- integer
      PDU_BUFFER_SIZE,                            -- integer

      -- Hash parameters

      ENTITY_HASH_INDEX_INCREMENT,                -- integer
      ENTITY_HASH_SITE_MULTIPLIER,                -- integer
      ENTITY_HASH_APPLICATION_MULTIPLIER,         -- integer
      ENTITY_HASH_ENTITY_MULTIPLIER,              -- integer

      EMISSION_HASH_INDEX_INCREMENT,              -- integer
      EMISSION_HASH_SITE_MULTIPLIER,              -- integer
      EMISSION_HASH_APPLICATION_MULTIPLIER,       -- integer
      EMISSION_HASH_ENTITY_MULTIPLIER,            -- integer

      LASER_HASH_INDEX_INCREMENT,                 -- integer
      LASER_HASH_SITE_MULTIPLIER,                 -- integer
      LASER_HASH_APPLICATION_MULTIPLIER,          -- integer
      LASER_HASH_ENTITY_MULTIPLIER,               -- integer

      RESUPPLY_HASH_INDEX_INCREMENT,              -- integer
      RESUPPLY_HASH_SITE_MULTIPLIER,              -- integer
      RESUPPLY_HASH_APPLICATION_MULTIPLIER,       -- integer
      RESUPPLY_HASH_ENTITY_MULTIPLIER,            -- integer

      REPAIR_HASH_INDEX_INCREMENT,                -- integer
      REPAIR_HASH_SITE_MULTIPLIER,                -- integer
      REPAIR_HASH_APPLICATION_MULTIPLIER,         -- integer
      REPAIR_HASH_ENTITY_MULTIPLIER,              -- integer

      RECEIVER_HASH_INDEX_INCREMENT,              -- integer
      RECEIVER_HASH_SITE_MULTIPLIER,              -- integer
      RECEIVER_HASH_APPLICATION_MULTIPLIER,       -- integer
      RECEIVER_HASH_ENTITY_MULTIPLIER,            -- integer

      TRANSMITTER_HASH_INDEX_INCREMENT,           -- integer
      TRANSMITTER_HASH_SITE_MULTIPLIER,           -- integer
      TRANSMITTER_HASH_APPLICATION_MULTIPLIER,    -- integer
      TRANSMITTER_HASH_ENTITY_MULTIPLIER,         -- integer

      -- Error processing parameters

      ERROR_MONITOR_ENABLED,                      -- boolean
      ERROR_LOG_ENABLED,                          -- boolean
      ERROR_LOG_FILE,                             -- string(1..100)

      -- Other parameters separate from the shared memory Client<->GUI
      -- interface.

      START_GUI,                                  -- boolean
      GUI_PROGRAM_NAME);                          -- string(1..80)

   ---------------------------------------------------------------------------
   -- Process_Client_Configuration_Data
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Process_Client_Configuration_Data(
      Keyword_Name  : in     STRING;
      Keyword_Value : in     STRING;
      Status        :    out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Instantiate generic configuration file management package to support
   -- the DG Client.
   --

   package Configuration_File_Management is
     new DG_Configuration_File_Management(
           Interpret_Configuration_Data => Process_Client_Configuration_Data,
           Report_Error                 => DG_Client_Error_Processing.
                                             Report_Error);

   ---------------------------------------------------------------------------
   -- Load_Configuration_File
   ---------------------------------------------------------------------------

   procedure Load_Configuration_File(
      Filename : in     STRING;
      Status   :    out DG_Status.STATUS_TYPE) is

   begin  -- Load_Configuration_File

      Configuration_File_Management.Load_Configuration_File(
        Filename  => Filename,
        Status    => Status);

   end Load_Configuration_File;

   ---------------------------------------------------------------------------
   -- Save_Configuration_File
   ---------------------------------------------------------------------------

   procedure Save_Configuration_File(
      Filename : in     STRING;
      Status   :    out DG_Status.STATUS_TYPE)
     is separate;

end DG_Client_Configuration_File_Management;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
