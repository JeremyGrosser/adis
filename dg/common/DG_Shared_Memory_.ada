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
-- FILE NAME        : DG_Shared_Memory_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 02, 1994
--
-- PURPOSE:
--   - Map shared memory interface for the DIS Gateway
--
-- EFFECTS:
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

with DG_Status;

generic

   type SHARED_MEMORY_TYPE is limited private;

package DG_Shared_Memory is

   ---------------------------------------------------------------------------
   -- Declare access type for shared memory area.
   ---------------------------------------------------------------------------

   type SHARED_MEMORY_PTR_TYPE is access SHARED_MEMORY_TYPE;

   ---------------------------------------------------------------------------
   -- Map_Memory
   ---------------------------------------------------------------------------
   -- Purpose : Initializes a pointer to a shared memory area.  The Mem_Key
   --           parameter must be a value unique to a particular interface.
   ---------------------------------------------------------------------------

   procedure Map_Memory(
      Mem_Key : in     INTEGER;
      Create  : in     BOOLEAN := FALSE;
      Mem_Ptr :    out SHARED_MEMORY_PTR_TYPE;
      Status  :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Unmap_Memory
   ---------------------------------------------------------------------------
   -- Purpose : Unmaps the shared memory area.  This renders the shared memory
   --           area unreachable by the current process, but does not destroy
   --           any data in the shared memory area, and does not effect any
   --           other process which has mapped the same area.
   ---------------------------------------------------------------------------

   procedure Unmap_Memory(
      Mem_Ptr : in out SHARED_MEMORY_PTR_TYPE;
      Status  :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Remove_Memory
   ---------------------------------------------------------------------------
   -- Purpose : Removes a shared memory area from the system.  This renders
   --           the shared memory area unreachable by all processes, and
   --           destroys any data in the area.  Only one process (usually
   --           the creator of the area) should call this routine.
   ---------------------------------------------------------------------------

   procedure Remove_Memory(
      Mem_Key : in     INTEGER;
      Status  :    out DG_Status.STATUS_TYPE);

end DG_Shared_Memory;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
