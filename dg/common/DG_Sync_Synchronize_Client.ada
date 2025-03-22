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
-- UNIT NAME        : DG_Synchronization.Synchronize_Client
--
-- FILE NAME        : DG_Sync_Synchronize_Clients.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 10, 1994
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

with System_V_IPC_Sema;

separate (DG_Synchronization)

procedure Synchronize_Client(
   Semaphore_ID : in     INTEGER;
   Status       :    out DG_Status.STATUS_TYPE) is

   Sem_Status : INTEGER;

begin  -- Synchronize_Client

   Status := DG_Status.SUCCESS;

   Sem_Status
     := System_V_IPC_Sema.SemCtl(
          SemID  => Semaphore_ID,
          SemNum => 0,
          Cmd    => System_V_IPC_Sema.SETVAL,
          ArgVal => 0);

   if (Sem_Status = -1) then
      Status := DG_Status.SYNC_CLI_SEMCTL_FAILURE;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.SYNC_CLI_FAILURE;

end Synchronize_Client;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
