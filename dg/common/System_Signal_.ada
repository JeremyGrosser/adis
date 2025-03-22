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
-- PACKAGE NAME     : System_Signal
--
-- FILE NAME        : System_Signal_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
--
-- PURPOSE:
--   - Provide access to the system signal handling routines.
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

generic

   Signal_Handled : INTEGER;   -- One of the signals from OS_Signal

   with
     procedure Handler_Routine(
        Signal : in INTEGER);  -- One of the signals from OS_Signal

package System_Signal is

   ---------------------------------------------------------------------------
   -- Set_Handler
   ---------------------------------------------------------------------------

   procedure Set_Handler;

   ---------------------------------------------------------------------------
   -- Restore_Original_Handler
   ---------------------------------------------------------------------------

   procedure Restore_Original_Handler;

   ---------------------------------------------------------------------------
   -- Ignore_Signal
   ---------------------------------------------------------------------------

   procedure Ignore_Signal;

   ---------------------------------------------------------------------------
   -- Pause
   ---------------------------------------------------------------------------

   procedure Pause;

   pragma INTERFACE(C, Pause);

end System_Signal;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
