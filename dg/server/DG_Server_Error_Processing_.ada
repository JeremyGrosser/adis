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
-- PACKAGE NAME     : DG_Server_Error_Processing
--
-- FILE NAME        : DG_Server_Error_Processing_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June dd, 1994
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

with DG_Error_Processing_Types,
     DG_Status,
     Text_IO;

package DG_Server_Error_Processing is

   --
   -- Error log file, if not defaulting to standard output
   --

   Error_Log_File     : Text_IO.FILE_TYPE;
   Use_Error_Log_File : BOOLEAN := FALSE;

   ---------------------------------------------------------------------------
   -- Report_Error
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Report_Error(
      Error : in DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Error
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Get_Error(
      Overflow      : out BOOLEAN;
      Error_Present : out BOOLEAN;
      Error_Entry   : out DG_Error_Processing_Types.ERROR_QUEUE_ENTRY_TYPE);

end DG_Server_Error_Processing;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
