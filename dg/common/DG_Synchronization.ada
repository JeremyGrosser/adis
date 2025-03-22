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
-- FILE NAME        : DG_Synchronization.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 10, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

package body DG_Synchronization is

   --
   -- Declare storage for the client's semaphore ID
   --
   Client_Semaphore_ID : INTEGER;

   ---------------------------------------------------------------------------
   -- Initialize_Server_Synchronization
   ---------------------------------------------------------------------------

   procedure Initialize_Server_Synchronization(
      Client_ID    : in     INTEGER;
      Semaphore_ID :    out INTEGER;
      Status       :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Synchronize_Clients
   ---------------------------------------------------------------------------

   procedure Synchronize_Client(
      Semaphore_ID : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Initialize_Client_Synchronization
   ---------------------------------------------------------------------------

   procedure Initialize_Client_Synchronization(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Synchronize_With_Server
   ---------------------------------------------------------------------------

   procedure Synchronize_With_Server(
      Overrun : out BOOLEAN;
      Status  : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Terminate_Client_Synchronization
   ---------------------------------------------------------------------------

   procedure Terminate_Client_Synchronization(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

end DG_Synchronization;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
