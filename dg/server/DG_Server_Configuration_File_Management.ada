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
-- PACKAGE NAME     : DG_Server_Configuration_File_Management
--
-- FILE NAME        : DG_Server_Configuration_File_Management.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 29, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Configuration_File_Management,
     DG_Server_Error_Processing;

package body DG_Server_Configuration_File_Management is

   type SERVER_PARAMETER_KEYWORD_TYPE is (

      -- General parameters

      TIMESLICE,                                  -- integer (msecs)

      -- Network parameters

      UDP_PORT,                                   -- integer
      BROADCAST_IP_ADDRESS,                       -- dotted quad
      DATA_RECEPTION_ENABLED,                     -- boolean
      DATA_TRANSMISSION_ENABLED,                  -- boolean

      -- Threshold parameters

      DISTANCE_THRESHOLD,                         -- float (meters)
      ORIENTATION_THRESHOLD,                      -- float (degrees)
      ENTITY_UPDATE_THRESHOLD,                    -- integer (seconds)
      ENTITY_EXPIRATION_THRESHOLD,                -- integer (seconds)
      EMISSION_UPDATE_THRESHOLD,                  -- integer (msecs)
      LASER_UPDATE_THRESHOLD,                     -- integer (msecs)
      TRANSMITTER_UPDATE_THRESHOLD,               -- integer (msecs)
      RECEIVER_UPDATE_THRESHOLD,                  -- integer (msecs)

      -- Exercise parameters

      SET_EXERCISE_ID,                            -- boolean
      DEFAULT_EXERCISE_ID,                        -- integer
      SET_SITE_ID,                                -- boolean
      DEFAULT_SITE_ID,                            -- integer
      AUTOMATIC_TIMESTAMP,                        -- boolean
      IITSEC_BIT_23_SUPPORT,                      -- boolean
      EXPERIMENTAL_PDU_SUPPORT,                   -- boolean

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

      -- Filter parameters

      KEEP_EXERCISE_ID,                           -- boolean
      KEEP_EXERCISE_ID_NUMBER,                    -- integer
      KEEP_OTHER_FORCE,                           -- boolean
      KEEP_FRIENDLY_FORCE,                        -- boolean
      KEEP_NEUTRAL_FORCE,                         -- boolean
      KEEP_ENTITY_STATE,                          -- boolean
      KEEP_FIRE,                                  -- boolean
      KEEP_DETONATION,                            -- boolean
      KEEP_COLLISION,                             -- boolean
      KEEP_SERVICE_REQUEST,                       -- boolean
      KEEP_RESUPPLY_OFFER,                        -- boolean
      KEEP_RESUPPLY_RECEIVED,                     -- boolean
      KEEP_RESUPPLY_CANCEL,                       -- boolean
      KEEP_REPAIR_COMPLETE,                       -- boolean
      KEEP_REPAIR_RESPONSE,                       -- boolean
      KEEP_CREATE_ENTITY,                         -- boolean
      KEEP_REMOVE_ENTITY,                         -- boolean
      KEEP_START_OR_RESUME,                       -- boolean
      KEEP_STOP_OR_FREEZE,                        -- boolean
      KEEP_ACKNOWLEDGE,                           -- boolean
      KEEP_ACTION_REQUEST,                        -- boolean
      KEEP_ACTION_RESPONSE,                       -- boolean
      KEEP_DATA_QUERY,                            -- boolean
      KEEP_SET_DATA,                              -- boolean
      KEEP_DATA,                                  -- boolean
      KEEP_EVENT_REPORT,                          -- boolean
      KEEP_MESSAGE,                               -- boolean
      KEEP_EMISSION,                              -- boolean
      KEEP_LASER,                                 -- boolean
      KEEP_TRANSMITTER,                           -- boolean
      KEEP_SIGNAL,                                -- boolean
      KEEP_RECEIVER,                              -- boolean

      -- Error processing parameters

      ERROR_MONITOR_ENABLED,                      -- boolean
      ERROR_LOG_ENABLED,                          -- boolean
      ERROR_LOG_FILE,                             -- string(1..100)

      -- Other parameters separate from the shared memory Server<->GUI
      -- interface.

      START_GUI,                                  -- boolean
      GUI_PROGRAM_NAME);                          -- string(1..80)

   ---------------------------------------------------------------------------
   -- Process_Server_Configuration_Data
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Process_Server_Configuration_Data(
      Keyword_Name  : in     STRING;
      Keyword_Value : in     STRING;
      Status        :    out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Instantiate generic configuration file management package to support
   -- the DG Server.
   --

   package Configuration_File_Management is
     new DG_Configuration_File_Management(
           Interpret_Configuration_Data => Process_Server_Configuration_Data,
           Report_Error                 => DG_Server_Error_Processing.
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

end DG_Server_Configuration_File_Management;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
