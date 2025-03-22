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
-- UNIT NAME        : DG_Synchronization.Initialize_Server_Synchronization
--
-- FILE NAME        : DG_Sync_Initialize_Server_Synchronization.ada
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

procedure Initialize_Server_Synchronization(
   Client_ID    : in     INTEGER;
   Semaphore_ID :    out INTEGER;
   Status       :    out DG_Status.STATUS_TYPE) is

   Local_Semaphore_ID : INTEGER;
   Sem_Status         : INTEGER;

begin  -- Initialize_Server_Synchronization

   Status := DG_Status.SUCCESS;

   --
   -- Allocate a semaphore from the system
   --
   Local_Semaphore_ID
     := System_V_IPC_Sema.SemGet(
          Key    => Client_ID,
          NSems  => 1,
          SemFlg => System_V_IPC_Sema.K_Global_Read_Write);

   if (Local_Semaphore_ID = -1) then

      Status := DG_Status.SYNC_INISRV_SEMGET_FAILURE;

   else

      Semaphore_ID := Local_Semaphore_ID;

   end if;

exception

   when OTHERS =>

      Status := DG_Status.SYNC_INISRV_FAILURE;

end Initialize_Server_Synchronization;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
