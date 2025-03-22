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
-- UNIT NAME        : DG_Synchronization.Synchronize_With_Server
--
-- FILE NAME        : DG_Sync_Synchronize_With_Server.ada
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

procedure Synchronize_With_Server(
   Overrun : out BOOLEAN;
   Status  : out DG_Status.STATUS_TYPE) is

   Sem_Op     : System_V_IPC_Sema.SEMBUF;
   Sem_Status : INTEGER;
   Sem_Value  : INTEGER;

   LOCAL_FAILURE : EXCEPTION;

begin  -- Synchronize_With_Server

   Status := DG_Status.SUCCESS;

   --
   -- Check to see if the semaphore has already been cleared.  This would
   -- indicate that the client arrived at the sync point *after* the server
   -- had synchronized for the start of the next timeslice.
   --
   Sem_Value
     := System_V_IPC_Sema.SemCtl(
          SemID  => Client_Semaphore_ID,
          SemNum => 0,
          Cmd    => System_V_IPC_Sema.GETVAL,
          ArgVal => 0);

   if (Sem_Value = -1) then
      Status := DG_Status.SYNC_SRV_SEMCTL_FAILURE;
      raise LOCAL_FAILURE;
   end if;

   if (Sem_Value = 1) then  -- Server has *not* zeroed flag yet (no overrun)

      Overrun := FALSE;

      --
      -- Wait for the Server to reset the semaphore to zero.
      --
      Sem_Op := (
        SemNum  => 0,
        Sem_Op  => 0,
        Sem_Flg => 0);

      Sem_Status
        := System_V_IPC_Sema.SemOp(
             SemID => Client_Semaphore_ID,
             SOps  => Sem_Op'ADDRESS,
             NSOps => 1);

      if (Sem_Status = -1) then
         Status := DG_Status.SYNC_SRV_SEMOP_FAILURE;
         raise LOCAL_FAILURE;
      end if;

   end if;

   --
   -- Set semaphore to 1.  If the client does not overrun, then this will
   -- still be set the next time this routine is called.  Otherwise, the
   -- Overrun flag will be set TRUE.
   --
   Sem_Status
     := System_V_IPC_Sema.SemCtl(
          SemID  => Client_Semaphore_ID,
          SemNum => 0,
          Cmd    => System_V_IPC_Sema.SETVAL,
          ArgVal => 1);

   if (Sem_Status = -1) then
      Status := DG_Status.SYNC_SRV_SEMCTL_FAILURE;
   end if;

exception

   when LOCAL_FAILURE =>

      null;  -- Status has already been set at point of failure

   when OTHERS =>

      Status := DG_Status.SYNC_SRV_FAILURE;

end Synchronize_With_Server;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
