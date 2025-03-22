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
-- UNIT NAME        : DG_Synchronization.Terminate_Client_Synchronization
--
-- FILE NAME        : DG_Sync_Terminate_Client_Synchronization.ada
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

procedure Terminate_Client_Synchronization(
   Status : out DG_Status.STATUS_TYPE) is

   Sem_Status : INTEGER;

begin  -- Terminate_Client_Synchronization

   Status := DG_Status.SUCCESS;

   Sem_Status
     := System_V_IPC_Sema.SemCtl(
          SemID  => Client_Semaphore_ID,
          SemNum => 1,
          Cmd    => System_V_IPC_Sema.IPC_RMID,
          ArgVal => 0);

   if (Sem_Status = -1) then
      Status := DG_Status.SYNC_TERMCLI_SEMCTL_FAILURE;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.SYNC_TERMCLI_FAILURE;

end Terminate_Client_Synchronization;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
