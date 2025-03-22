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
-- UNIT NAME        : DG_Synchronization.Initialize_Client_Synchronization
--
-- FILE NAME        : DG_Sync_Initialize_Client_Synchronization.ada
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

with System_V_IPC_Sema,
     Unix;

separate (DG_Synchronization)

procedure Initialize_Client_Synchronization(
   Status : out DG_Status.STATUS_TYPE) is

   Sem_Status : INTEGER;

begin  -- Initialize_Client_Synchronization

   Status := DG_Status.SUCCESS;

   --
   -- Allocate a semaphore from the system
   --
   Client_Semaphore_ID
     := System_V_IPC_Sema.SemGet(
          Key    => Unix.GetPID,
          NSems  => 1,
          SemFlg => System_V_IPC_Sema.IPC_CREAT
                      + System_V_IPC_Sema.K_Global_Read_Write);

   if (Client_Semaphore_ID /= -1) then

      --
      -- Initialize semaphore to 1.  This is used for overrun detection by the
      -- Synchronize_With_Server routines.
      --
      Sem_Status
        := System_V_IPC_Sema.SemCtl(
             SemID  => Client_Semaphore_ID,
             SemNum => 0,
             Cmd    => System_V_IPC_Sema.SETVAL,
             ArgVal => 1);

      if (Sem_Status = -1) then
        Status := DG_Status.SYNC_INITCLI_SEMCTL_FAILURE;
      end if;

   else  -- (Client_Semaphore_ID = -1)

      Status := DG_Status.SYNC_INITCLI_SEMGET_FAILURE;

   end if;

exception

   when OTHERS =>

      Status := DG_Status.SYNC_INITCLI_FAILURE;

end Initialize_Client_Synchronization;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
