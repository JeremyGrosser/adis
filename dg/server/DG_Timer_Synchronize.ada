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
-- UNIT NAME        : DG_Timer.Synchronize
--
-- FILE NAME        : DG_Timer_Synchronize.ada
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

procedure Synchronize(
   Overrun : out BOOLEAN;
   Status  : out DG_Status.STATUS_TYPE) is

begin  -- Synchronize

   Status := DG_Status.SUCCESS;

   --
   -- If SIGALRM_Flag is FALSE, then the SIGALRM_Handler has not been called
   -- yet, and the synchronization point has been reached within the specified
   -- timeslice.  Otherwise, an overrun condition has occurred.
   --
   Overrun := SIGALRM_Flag;

   --
   -- Other signals (such as the SIGIO signal used to process the UDP port)
   -- could cause the Pause statement to complete.  The SIGALRM_Flag is used
   -- to ensure that the Synchronize routine does not exit unless the timer's
   -- signal is asserted.  This loop will also exit if there is an error in
   -- the SIGALRM_Handler routine.
   --
   Wait_For_SIGALRM_Signal:
   while ((not SIGALRM_Flag) and (DG_Status.Success(SIGALRM_Status))) loop

      SIGALRM_Signal.Pause;

   end loop Wait_For_SIGALRM_Signal;

   --
   -- If there was an error in SIGALRM_Handler, report it.
   --
   if (DG_Status.Failure(SIGALRM_Status)) then
      Status := SIGALRM_Status;
   end if;

   --
   -- Reset the overrun detection flag.
   --
   SIGALRM_Flag := FALSE;

exception

   when OTHERS =>

      Status := DG_Status.TIMER_SYNC_FAILURE;

end Synchronize;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
