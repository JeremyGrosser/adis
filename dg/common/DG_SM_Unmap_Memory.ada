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
-- UNIT NAME        : DG_Shared_Memory.Unmap_Memory
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 02, 1994
--
-- PURPOSE:
--   - Unmaps the shared memory area.  This renders the shared memory area
--     unreachable by the current process, but does not destroy any data in
--     the shared memory area, and does not effect any other process which
--     has mapped the same area.
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

with Unchecked_Conversion;

separate (DG_Shared_Memory)

procedure Unmap_Memory(
   Mem_Ptr : in out SHARED_MEMORY_PTR_TYPE;
   Status  :    out DG_Status.STATUS_TYPE) is

   --
   -- Instantiate conversion between Mem_Ptr type and IPC pointer type
   --
   function Mem_Ptr_To_IPC_Ptr is
     new Unchecked_Conversion(
       SHARED_MEMORY_PTR_TYPE, DG_IPC_ShMem.AREA_ACCESS_TYPE);

begin  -- Unmap_Memory

   Status := DG_Status.SUCCESS;

   if (DG_IPC_ShMem.ShMDt(Mem_Ptr_To_IPC_Ptr(Mem_Ptr)) = -1) then
      Status := DG_Status.SM_UNMAPMEM_SHMDT_FAILURE;
   end if;

   Mem_Ptr := NULL;

exception

   when OTHERS =>

      Mem_Ptr := NULL;
      Status  := DG_Status.SM_UNMAPMEM_FAILURE;

end Unmap_Memory;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
