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
-- UNIT NAME        : DG_Timer.Initialize_Timer
--
-- FILE NAME        : DG_Timer_Initialize_Timer
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

separate (DG_Timer)

procedure Initialize_Timer(
   Seconds      : in     INTEGER;
   Microseconds : in     INTEGER;
   Status       :    out DG_Status.STATUS_TYPE) is

   Set_Status : INTEGER;

begin  -- Initialize_Timer

   Status := DG_Status.SUCCESS;

   --
   -- Set SIGALRM signal handler
   --
   SIGALRM_Signal.Set_Handler;

   --
   -- Set up SIGALRM generation by the system interval timer
   --

   Timer_Values := (
--     IT_Interval => (
--       TV_Sec  => Seconds,
--       TV_USec => Microseconds),
     IT_Interval => (
       TV_Sec  => 0,
       TV_USec => 0),
     IT_Value => (
       TV_Sec  => Seconds,
       TV_USec => Microseconds));

   Set_Status
     := System_ITimer.SetITimer(
          Which  => System_ITimer.ITIMER_REAL,
          Value  => Timer_Values'ADDRESS);

   if (Set_Status = -1) then
      Status := DG_Status.TIMER_INIT_SETITIMER_FAILURE;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.TIMER_INIT_FAILURE;

end Initialize_Timer;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
