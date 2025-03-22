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
-- PACKAGE NAME     : DG_Synchronization
--
-- FILE NAME        : DG_Synchronization_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 10, 1994
--
-- PURPOSE:
--   - Provide synchronization between the DG Server and the DG Clients.
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

with DG_Status;

package DG_Synchronization is

   ---------------------------------------------------------------------------
   -- Initialize_Server_Synchronization
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Initialize_Server_Synchronization(
      Client_ID    : in     INTEGER;
      Semaphore_ID :    out INTEGER;
      Status       :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Synchronize_Clients
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Synchronize_Client(
      Semaphore_ID : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Initialize_Client_Synchronization
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Initialize_Client_Synchronization(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Synchronize_With_Server
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Synchronize_With_Server(
      Overrun : out BOOLEAN;
      Status  : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Terminate_Client_Synchronization
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Terminate_Client_Synchronization(
      Status : out DG_Status.STATUS_TYPE);

end DG_Synchronization;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
