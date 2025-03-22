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
-- PURPOSE:
--   - This package provides timing information to the Ordnance Server.
--
-- EFFECTS:
--
-- EXCEPTIONS:
--
-- PORTABILITY ISSUES:
--
-- ANTICIPATED CHANGES:
--
------------------------------------------------------------------------------

with OS_Status;

package OS_Timer is

   procedure Set_Timer(
      Seconds      : in     INTEGER;
      Microseconds : in     INTEGER;
      Status       :    out OS_Status.STATUS_TYPE);

   function Time_Remains
     return BOOLEAN;

   procedure Cancel_Timer(
      Status : out OS_Status.STATUS_TYPE);

end OS_Timer;
