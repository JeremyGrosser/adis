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
-- PACKAGE NAME     : DG_Client_Tracking
--
-- FILE NAME        : DG_Client_Tracking_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
--
-- PURPOSE:
--   - This package defines types and routines to facilitate the tracking
--     of DG Clients logged into the DG Server.
--
-- EFFECTS:
--   - The expected usage is:
--     1. 
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

with Calendar,
     DG_Client_Interface,
     DG_Login_Queue,
     DG_Status;

package DG_Client_Tracking is

   --
   -- Declare counter for number of active clients.
   --
   Number_Of_Clients : INTEGER := 0;

   --
   -- Client entity tracking data
   --

   type CLIENT_ENTITY_TRACKING_DATA_ENTRY is
     record
       Server_Hash_Index  : INTEGER;
     end record;

   type CLIENT_ENTITY_TRACKING_DATA is
     array (INTEGER range <>) of CLIENT_ENTITY_TRACKING_DATA_ENTRY;

   type CLIENT_ENTITY_TRACKING_DATA_PTR is
     access CLIENT_ENTITY_TRACKING_DATA;

   --
   -- Define type for tracking a DG Client's information, and access
   -- type for the tracking type.
   --
   type CLIENT_TRACKING_DATA is
     record
       Interface         : DG_Client_Interface.CLIENT_INTERFACE_PTR_TYPE;
       Buffer_Read_Index : INTEGER;
       Sync_Semaphore    : INTEGER;
       Login_Info        : DG_Login_Queue.CLIENT_INFO_TYPE;
       Entity_Data       : CLIENT_ENTITY_TRACKING_DATA_PTR;
       Laser_Data        : CLIENT_ENTITY_TRACKING_DATA_PTR;
     end record;

   type CLIENT_TRACKING_DATA_PTR is access CLIENT_TRACKING_DATA;

   ---------------------------------------------------------------------------
   -- Create_Login_Queue
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Create_Login_Queue(
      Status : out DG_Status.STATUS_TYPE)
     renames DG_Login_Queue.Create_Login_Queue;

   ---------------------------------------------------------------------------
   -- Process_Login_Queue
   ---------------------------------------------------------------------------
   -- Purpose: Checks the Server login queue for Client logins and logouts,
   --          and updates the Client information database accordingly.
   ---------------------------------------------------------------------------

   procedure Process_Login_Queue(
      Server_Info : in     DG_Login_Queue.SERVER_INFO_TYPE;
      Status      :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Remove_Login_Queue
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Remove_Login_Queue(
      Status : out DG_Status.STATUS_TYPE)
     renames DG_Login_Queue.Remove_Login_Queue;

   ---------------------------------------------------------------------------
   -- Synchronize_Clients
   ---------------------------------------------------------------------------
   -- Purpose: Synchronizes all clients.
   ---------------------------------------------------------------------------

   procedure Synchronize_Clients(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Process_Client_Interfaces
   ---------------------------------------------------------------------------
   -- Purpose: Check for updated information in client interfaces
   ---------------------------------------------------------------------------

   procedure Process_Client_Interfaces(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Shutdown_Clients
   ---------------------------------------------------------------------------
   -- Purpose: Performs orderly shutdown of all active Clients.
   ---------------------------------------------------------------------------

   procedure Shutdown_Clients(
      Status : out DG_Status.STATUS_TYPE);

end DG_Client_Tracking;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
