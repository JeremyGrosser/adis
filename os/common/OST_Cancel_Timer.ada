--                            U N C L A S S I F I E D
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
-- UNIT NAME :         Cancel_Timer
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server (OS) CSCI
--
-- AUTHOR :            B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE :  June 14, 1994
--
-- PURPOSE:
--   - This procedure cancels the interval timer started by the Set_Timer
--     call.
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

procedure Cancel_Timer(
   Status :  out OS_Status.STATUS_TYPE)
  is

   Set_Status : INTEGER;

begin  -- Cancel_Timer

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Stop the interval timer from generating SIGALRM signals.
   Timer_Values := (
     IT_Interval => (
       TV_Sec  => 0,
       TV_USec => 0),
     IT_Value => (
       TV_Sec  => 0,
       TV_USec => 0));

   Set_Status
     := System_ITimer.SetITimer(
          Which => System_ITimer.ITIMER_REAL,
          Value => Timer_Values'ADDRESS);

   if Set_Status = -1 then

      Status := OS_Status.CT_SETITIMER_FAILED_ERROR;

   end if;

   if not Interval_Expired then
      -- Remove the SIGALRM_Handler procedure as the signal-catching routine
      -- for the SIGALRM signal.  This should permit other SIGALRM-related
      -- routines to function normally again (such as the Verdix Ada "delay"
      -- statement).
      SIGALRM_Signal.Restore_Original_Handler;

      -- Indicate that the time interval has expired.
      Interval_Expired := TRUE;

   end if;

exception
   when OTHERS =>
      Status := OS_Status.CT_ERROR;

end Cancel_Timer;
