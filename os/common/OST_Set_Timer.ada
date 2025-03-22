--                            U N C L A S S I F I E D
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
-- UNIT NAME :         Set_Timer
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server (OS) CSCI
--
-- AUTHOR :            B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE :  August 18, 1994
--
-- PURPOSE :
--   - This procedure starts a timer running for the interval given by the
--     Seconds and Microseconds parameters.
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

procedure Set_Timer(
   Seconds      : in     INTEGER;
   Microseconds : in     INTEGER;
   Status       :    out OS_Status.STATUS_TYPE)
  is

   Set_Status : INTEGER;

begin  -- Set_Timer

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Set SIGALRM signal handler
   SIGALRM_Signal.Set_Handler;

   -- Set up SIGALRM generation by the system interval timer
   Timer_Values := (
     IT_Interval => (  -- An IT_Interval of 0 specifies that the interval
       TV_Sec  => 0,   -- timer is *not* automatically restarted when the
       TV_USec => 0),  -- interval expires.
     IT_Value => (
       TV_Sec  => Seconds,
       TV_USec => Microseconds));

   Set_Status
     := System_ITimer.SetITimer(
          Which  => System_ITimer.ITIMER_REAL,
          Value  => Timer_Values'ADDRESS);

   if Set_Status = -1 then
      Status := OS_Status.ST_SETITIMER_FAILED_ERROR;
   end if;

   -- Indicate that there is time remaining until the SIGALRM signal is
   -- asserted.
   Interval_Expired := FALSE;

exception
   when OTHERS =>
      Status := OS_Status.ST_ERROR;

end Set_Timer;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
