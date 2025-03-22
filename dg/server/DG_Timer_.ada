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
-- PACKAGE NAME     : DG_Timer
--
-- FILE NAME        : DG_Timer_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 14, 1994
--
-- PURPOSE:
--   - 
--
-- EFFECTS:
--   - The expected usage is:
--     1. 
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

package DG_Timer is

   ---------------------------------------------------------------------------
   -- Initialize_Timer
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Initialize_Timer(
      Seconds      : in     INTEGER;
      Microseconds : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Change_Timer
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Change_Timer(
      Seconds      : in     INTEGER;
      Microseconds : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Synchronize
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Synchronize(
      Overrun : out BOOLEAN;
      Status  : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Terminate_Timer
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Terminate_Timer(
      Status : out DG_Status.STATUS_TYPE);

end DG_Timer;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
