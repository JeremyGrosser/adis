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
-- PACKAGE NAME     : System_ITimer
--
-- FILE NAME        : System_ITimer_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 14, 1994
--
-- PURPOSE:
--   - Provides access to the system interval timer routines.
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

with System;

package System_ITimer is

   --
   -- Define TIMEVAL type
   --
   -- Note:  Based on struct timeval in <sys/time.h>
   --
   type TIMEVAL is
     record
       TV_Sec  : INTEGER;
       TV_USec : INTEGER;
     end record;

   --
   -- Define ITIMERVAL type
   --
   -- Note:  Based on struct itimerval in <sys/time.h>
   --
   type ITIMERVAL is
     record
       IT_Interval : TIMEVAL;
       IT_Value    : TIMEVAL;
     end record;

   --
   -- Define ITIMER_TYPE values
   --
   -- Note:  Based on #define's in <sys/time.h>
   --
   type ITIMER_TYPE is (
      ITIMER_REAL,     -- Real time intervals
      ITIMER_VIRTUAL,  -- Virtual time intervals
      ITIMER_PROF);    -- User and system virtual time

   ---------------------------------------------------------------------------
   -- GetITimer
   ---------------------------------------------------------------------------
   --
   -- Purpose: Get value of interval timer
   --
   -- Note   : Based on manpage for getitimer
   --
   ---------------------------------------------------------------------------

   function GetITimer(
      Which : in ITIMER_TYPE;
      Value : in System.ADDRESS)  -- ITIMERVAL'ADDRESS
     return INTEGER;

   pragma INTERFACE(C, GetITimer);

   ---------------------------------------------------------------------------
   -- SetITimer
   ---------------------------------------------------------------------------
   --
   -- Purpose: Set value of interval timer.
   --
   -- Note   : Based on manpage for setitimer
   --
   ---------------------------------------------------------------------------

   function SetITimer(
      Which  : in ITIMER_TYPE;
      Value  : in System.ADDRESS;                    -- ITIMERVAL'ADDRESS
      OValue : in System.ADDRESS := System.NO_ADDR)  -- ITIMERVAL'ADDRESS
     return INTEGER;

   pragma INTERFACE(C, SetITimer);

end System_ITimer;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
