--                            U N C L A S S I F I E D
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
-- UNIT NAME :         SIGALRM_Handler
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server (OS) CSCI
--
-- AUTHOR :            B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE :  August 16, 1994
--
-- PURPOSE :
--   - This procedure is the signal-catching routine associated with the
--     SIGALRM signal.
--
-- IMPLEMENTATION NOTES :  None.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
separate (OS_Timer)

procedure SIGALRM_Handler(
   Signal :  in INTEGER)
  is

begin  -- SIGALRM_Handler

   -- Remove this procedure as the signal-catching routine for the SIGALRM
   -- signal.  This should permit other SIGALRM-related routines to function
   -- normally again (such as the Verdix Ada "delay" statement).
   SIGALRM_Signal.Restore_Original_Handler;

   -- Indicate that the interval has expired.
   Interval_Expired := TRUE;

end SIGALRM_Handler;
