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
-- PACKAGE NAME     : DG_Shared_Memory
--
-- FILE NAME        : DG_Shared_Memory.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 02, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with System_V_IPC_ShMem;

package body DG_Shared_Memory is

   --
   -- Instantiate System V IPC shared memory package to support the DG
   --
   package DG_IPC_ShMem is new System_V_IPC_ShMem(SHARED_MEMORY_TYPE);

   ---------------------------------------------------------------------------
   -- Map_Memory
   ---------------------------------------------------------------------------

   procedure Map_Memory(
      Mem_Key : in     INTEGER;
      Create  : in     BOOLEAN := FALSE;
      Mem_Ptr :    out SHARED_MEMORY_PTR_TYPE;
      Status  :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Unmap_Memory
   ---------------------------------------------------------------------------

   procedure Unmap_Memory(
      Mem_Ptr : in out SHARED_MEMORY_PTR_TYPE;
      Status  :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Remove_Memory
   ---------------------------------------------------------------------------

   procedure Remove_Memory(
      Mem_Key : in     INTEGER;
      Status :    out DG_Status.STATUS_TYPE)
     is separate;

end DG_Shared_Memory;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
