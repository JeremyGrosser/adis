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
-- FILE NAME        : DG_Client_Tracking.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Hash_Table_Support,
     DG_Network_Interface_Support,
     DG_Shared_Memory,
     DG_Synchronization,
     Generic_Linked_List,
     Unchecked_Conversion,
     Unchecked_Deallocation;

package body DG_Client_Tracking is

   --
   -- Instantiate the generic linked list package to support tracking of
   -- Client information.
   --
   package Client_List is
     new Generic_Linked_List(CLIENT_TRACKING_DATA_PTR);

   --
   -- Declare pointer to track current client for Top_Of_List and Next_Client
   -- routines.
   --
   Current_Client : Client_List.LIST_NODE_PTR;

   --
   -- Rename the equality function from Client_List to improve subsequent
   -- code readability.
   --
   function "="(Left, Right : Client_List.LIST_NODE_PTR)
     return BOOLEAN
       renames Client_List."=";

   --
   -- Instantiate a deallocator for the Client tracking information type.
   --
   procedure Free is
     new Unchecked_Deallocation(
           CLIENT_TRACKING_DATA, CLIENT_TRACKING_DATA_PTR);

   ---------------------------------------------------------------------------
   -- Add_Client
   ---------------------------------------------------------------------------
   -- Purpose: Adds the information for a Client to the list of existing
   --          Clients.
   ---------------------------------------------------------------------------

   procedure Add_Client(
      Client_Data : in     CLIENT_TRACKING_DATA;
      Status      :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Remove_Client
   ---------------------------------------------------------------------------
   -- Purpose: Removes the Client from the list of existing Clients, and
   --          deallocates resources
   ---------------------------------------------------------------------------

   procedure Remove_Client(
      Client_ID : in     INTEGER;
      Status    :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Process_Login_Queue
   ---------------------------------------------------------------------------

   procedure Process_Login_Queue(
      Server_Info : in     DG_Login_Queue.SERVER_INFO_TYPE;
      Status      :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Synchronize_Clients
   ---------------------------------------------------------------------------
   -- Purpose: Synchronizes all clients.
   ---------------------------------------------------------------------------

   procedure Synchronize_Clients(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Process_Client_Interfaces
   ---------------------------------------------------------------------------

   procedure Process_Client_Interfaces(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Shutdown_Clients
   ---------------------------------------------------------------------------

   procedure Shutdown_Clients(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

end DG_Client_Tracking;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
