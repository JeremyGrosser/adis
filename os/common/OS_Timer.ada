--                            U N C L A S S I F I E D
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
-- PACKAGE NAME     :  OS_Timer
--
-- PROJECT          :  Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server (OS) CSCI
--
-- AUTHOR           :  B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE :  August 16, 1994
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with OS_Signal,
     System_ITimer,
     System_Signal;

package body OS_Timer is

   -- Timer_Values stores data needed to set the system interval timers
   Timer_Values :  System_ITimer.ITIMERVAL;

   -- Declare flag to indicate if the interval has expired.
   Interval_Expired :  BOOLEAN := FALSE;

   -- Declare SIGALRM_Handler specification and use to instantiate signal
   -- handling package.
   procedure SIGALRM_Handler(
      Signal :  in INTEGER);

   package SIGALRM_Signal is
     new System_Signal(OS_Signal.SIGALRM, SIGALRM_Handler);

   procedure SIGALRM_Handler(
      Signal :  in INTEGER)
     is separate;

   procedure Set_Timer(
      Seconds      :  in     INTEGER;
      Microseconds :  in     INTEGER;
      Status       :     out OS_Status.STATUS_TYPE)
     is separate;

   function Time_Remains
     return BOOLEAN
       is separate;

   procedure Cancel_Timer(
      Status :  out OS_Status.STATUS_TYPE)
     is separate;

end OS_Timer;
