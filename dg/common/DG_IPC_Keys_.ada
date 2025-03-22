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
-- PACKAGE NAME     : DG_IPC_Keys
--
-- FILE NAME        : DG_IPC_Keys.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 24, 1994
--
-- PURPOSE:
--   - This package defines the key values needed by the DG when accessing
--     various System V IPC (Interprocess Communications) mechanisms.  Since
--     IPC resources (shared memory, semaphores, and message queues) are
--     accessed by unique integer keys, the possibility exists that the
--     default DG keys will conflict with some other program's use of IPC
--     resources.  This package creates a central location where the DG
--     key values can be altered to solve such conflicts.
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

with Unix;

package DG_IPC_Keys is

   ---------------------------------------------------------------------------
   --
   -- DG Server Keys
   --
   --    There is only one server, and only one of each of its IPC resources.
   --    The keys have therefore been set to arbitrary constant values.
   --
   ---------------------------------------------------------------------------

   package Server is

      --
      -- Shared Memory
      --

      Server_Client_Key : constant INTEGER := 1;
      Server_GUI_Key    : constant INTEGER := 2;

      --
      -- Message Queues
      --

      Login_Queue_Key : constant INTEGER := 1;

      --
      -- Note:  Client_Server_Key values are provided to the Server by the
      --        Client when it logs in.  Transmission of the key value is
      --        handled in package DG_Login_Queue, and storage/retrieval
      --        of the key is handled by package DG_Client_Tracking.  The
      --        same is true for the Sync_Semaphore_Key values of Clients.

   end Server;

   ---------------------------------------------------------------------------
   --
   -- DG Client Keys
   --
   --    Since there can be multiple clients, there needs to be a way to
   --    generate unique keys for their interfaces.  Since the process ID
   --    will be unique to each client, the keys are based on this value.
   --
   ---------------------------------------------------------------------------

   package Client is

      --
      -- Shared Memory
      --

      Server_Client_Key : constant INTEGER := Server.Server_Client_Key;
      Client_Server_Key : constant INTEGER := Unix.GetPID * 2;
      Client_GUI_Key    : constant INTEGER := Unix.GetPID * 2 + 1;

      --
      -- Semaphores
      --

      Sync_Semaphore_Key : constant INTEGER := Unix.GetPID;

      --
      -- Environmental variable names used to transmit key values to the
      -- Client GUI.
      --

      Client_GUI_Env_Name : constant STRING := "DG_CLIENT_GUI_KEY";

   end Client;

   ---------------------------------------------------------------------------
   --
   -- DG Server GUI Keys
   --
   --    Since the DG Server IPC keys are constant, the DG Server GUI can
   --    access these resources using the same constants.
   --
   ---------------------------------------------------------------------------

   package Server_GUI is

      --
      -- Shared Memory
      --

      Server_GUI_Key : constant INTEGER := Server.Server_GUI_Key;

   end Server_GUI;

   ---------------------------------------------------------------------------
   -- DG Client GUI Keys
   ---------------------------------------------------------------------------

   package Client_GUI is

      --
      -- Shared Memory
      --

      function Client_GUI_Key return INTEGER;

   end Client_GUI;

end DG_IPC_Keys;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
