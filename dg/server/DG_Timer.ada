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
-- FILE NAME        : DG_Timer.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 14, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with OS_Signal,
     System_ITimer,
     System_Signal;

package body DG_Timer is

   --
   -- Timer_Values stores data needed to set the system interval timers
   --
   Timer_Values : System_ITimer.ITIMERVAL;

   --
   -- Define flag to check determine overrun.  This flag is set when the
   -- SIGALRM_Handler routine is invoked, and cleared within the Synchronize
   -- routine.  If the Synchronize routine is not invoked before the
   -- SIGALRM_Handler routine is invoked, then an overrun condition has
   -- occurred (i.e., the DG Server did not complete all its processing within
   -- the specified timeslice).
   --
   SIGALRM_Flag : BOOLEAN := FALSE;

   --
   -- Define status variable for the SIGALRM_Handler routine.  Since this
   -- routine is invoked by the system, and not directly by the Server,
   -- any errors in the routine are set in SIGALRM_Status, and reported by
   -- the Synchronize routine when it is called by the Server.
   --
   SIGALRM_Status : DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

   --
   -- Declare SIGALRM_Handler specification and use to instantiate signal
   -- handling package.
   --
   procedure SIGALRM_Handler(Signal : in INTEGER);

   package SIGALRM_Signal is
     new System_Signal(OS_Signal.SIGALRM, SIGALRM_Handler);

   ---------------------------------------------------------------------------
   -- SIGALRM_Handler
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure SIGALRM_Handler(Signal : in INTEGER)
     is separate;

   ---------------------------------------------------------------------------
   -- Initialize_Timer
   ---------------------------------------------------------------------------

   procedure Initialize_Timer(
      Seconds      : in     INTEGER;
      Microseconds : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Change_Timer
   ---------------------------------------------------------------------------

   procedure Change_Timer(
      Seconds      : in     INTEGER;
      Microseconds : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Synchronize
   ---------------------------------------------------------------------------

   procedure Synchronize(
      Overrun : out BOOLEAN;
      Status  : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Terminate_Timer
   ---------------------------------------------------------------------------

   procedure Terminate_Timer(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

end DG_Timer;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
