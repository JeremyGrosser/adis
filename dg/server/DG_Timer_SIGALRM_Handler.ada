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
-- UNIT NAME        : DG_Timer.SIGALRM_Handler
--
-- FILE NAME        : DG_Timer_SIGALRM_Handler.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
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

procedure SIGALRM_Handler(
   Signal : in INTEGER) is

   Set_Status : INTEGER;

begin  -- SIGALRM_Handler

   --
   -- Reset SIGALRM handler
   --
   SIGALRM_Signal.Set_Handler;

   --
   -- Indicate that the handler has been invoked.
   --
   SIGALRM_Flag := TRUE;

   --
   -- Requeue the interval timer signal request
   --
   Set_Status
     := System_ITimer.SetITimer(
          Which  => System_ITimer.ITIMER_REAL,
          Value  => Timer_Values'ADDRESS);

   if (Set_Status = -1) then
      SIGALRM_Status := DG_Status.TIMER_SIGALRM_SETITIMER_FAILURE;
   end if;

exception

   when OTHERS =>

      SIGALRM_Status := DG_Status.TIMER_SIGALRM_FAILURE;

end SIGALRM_Handler;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
