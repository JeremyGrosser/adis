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
-- UNIT NAME        : DG_Shared_Memory.Map_Memory
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 02, 1994
--
-- PURPOSE:
--   - Initializes a pointer to a shared memory area.  The Mem_Key parameter
--     must be a value unique to a particular interface.
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

procedure Map_Memory(
   Mem_Key : in     INTEGER;
   Create  : in     BOOLEAN := FALSE;
   Mem_Ptr :    out SHARED_MEMORY_PTR_TYPE;
   Status  :    out DG_Status.STATUS_TYPE) is

   Mem_ID              : INTEGER;
   Shared_Memory_Flags : INTEGER := DG_IPC_ShMem.K_Global_Read_Write;
   Temp_Ptr            : SHARED_MEMORY_PTR_TYPE;

   --
   -- Define conversions between DG_IPC_ShMem pointer type and other types
   --
   function IPC_Ptr_To_Mem_Ptr is
     new Unchecked_Conversion(
       DG_IPC_ShMem.AREA_ACCESS_TYPE, SHARED_MEMORY_PTR_TYPE);

   function Mem_Ptr_To_Integer is
     new Unchecked_Conversion(SHARED_MEMORY_PTR_TYPE, INTEGER);

begin  -- Map_Memory

   Status := DG_Status.SUCCESS;

   --
   -- Specify if shared memory area should be created if it does not
   -- already exist.
   --
   if (Create) then
      Shared_Memory_Flags := Shared_Memory_Flags + DG_IPC_ShMem.IPC_CREAT;
   end if;

   --
   -- Obtain the shared memory area's ID
   --
   Mem_ID := DG_IPC_ShMem.ShMGet(
                Key    => Mem_Key,
                ShMFlg => Shared_Memory_Flags);

   if (Mem_ID /= -1) then

      --
      -- Attach the shared memory area to pointer
      --
      Temp_Ptr := IPC_Ptr_To_Mem_Ptr(DG_IPC_ShMem.ShMAt(ShMID => Mem_ID));

      if (Mem_Ptr_To_Integer(Temp_Ptr) /= -1) then

         Mem_Ptr := Temp_Ptr;

      else -- Temp_Ptr = -1

         Mem_Ptr := NULL;
         Status  := DG_Status.SM_MAPMEM_SHMAT_FAILURE;

      end if;

   else  -- Mem_ID = -1

      Mem_Ptr := NULL;
      Status  := DG_Status.SM_MAPMEM_SHMGET_FAILURE;

   end if;

exception

   when OTHERS =>

      Mem_Ptr := NULL;
      Status  := DG_Status.SM_MAPMEM_FAILURE;

end Map_Memory;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
