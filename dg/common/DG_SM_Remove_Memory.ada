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
-- UNIT NAME        : DG_Shared_Memory.Remove_Memory
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 02, 1994
--
-- PURPOSE:
--   - Removes a shared memory area from the system.  This renders the shared
--     memory area unreachable by all processes, and destroys any data in the
--     area.  Only one process (usually the creator of the area) should call
--     this routine.
--
-- IMPLEMENTATION NOTES:
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

separate (DG_Shared_Memory)

procedure Remove_Memory(
   Mem_Key : in     INTEGER;
   Status  :    out DG_Status.STATUS_TYPE) is

   Mem_ID : INTEGER;

begin  -- Remove_Memory

   Status := DG_Status.SUCCESS;

   --
   -- Obtain the shared memory area's ID
   --
   Mem_ID := DG_IPC_ShMem.ShMGet(
                Key    => Mem_Key,
                ShMFlg => DG_IPC_ShMem.K_Global_Read_Write);

   if (Mem_ID /= -1) then

      if (DG_IPC_ShMem.ShMCtl(Mem_ID, DG_IPC_ShMem.IPC_RMID) = -1) then
         Status := DG_Status.SM_REMMEM_SHMCTL_FAILURE;
      end if;

   else

      Status := DG_Status.SM_REMMEM_SHMGET_FAILURE;

   end if;

exception

   when OTHERS =>

      Status := DG_Status.SM_REMMEM_FAILURE;

end Remove_Memory;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
