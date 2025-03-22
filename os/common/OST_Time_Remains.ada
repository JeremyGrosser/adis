--                            U N C L A S S I F I E D
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
-- UNIT NAME :         Time_Remains
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server (OS) CSCI
--
-- AUTHOR :            B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE :  August 18, 1994
--
-- PURPOSE :
--   - This function indicates if there is still time remaining in the
--     interval provided to the last Set_Timer call.
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

function Time_Remains return BOOLEAN is

begin  -- Time_Remains

   return (not Interval_Expired);

end Time_Remains;
