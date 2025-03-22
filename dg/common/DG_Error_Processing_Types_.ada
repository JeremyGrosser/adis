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
-- PACKAGE NAME     : DG_Error_Processing_Types
--
-- FILE NAME        : DG_Error_Processing_Types_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 12, 1994
--
-- PURPOSE:
--   - 
--
-- EFFECTS:
--   - The expected usage is:
--     1. 
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

with Calendar,
     DG_Status;

package DG_Error_Processing_Types is

   type ERROR_QUEUE_ENTRY_TYPE is record
       Error           : DG_Status.STATUS_TYPE;
       Occurrence_Time : Calendar.TIME;
     end record;

   type ERROR_QUEUE_TYPE is
     array (INTEGER range <>) of ERROR_QUEUE_ENTRY_TYPE;

   type ERROR_HISTORY_ENTRY_TYPE is
     record
       Occurrence_Count     : INTEGER;
       Last_Occurrence_Time : Calendar.TIME;
     end record;

   type ERROR_HISTORY_TYPE is
     array (DG_Status.STATUS_TYPE) of ERROR_HISTORY_ENTRY_TYPE;

end DG_Error_Processing_Types;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
