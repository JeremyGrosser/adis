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
-- PACKAGE NAME     : DG_Server_Configuration_File_Management
--
-- FILE NAME        : DG_Server_Configuration_File_Management_.ada
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

with DG_Status;

package DG_Server_Configuration_File_Management is

   --
   -- Additional configuration file parameters which are not stored in
   -- the Server<->GUI parameter area.
   --

   type STRING_PTR is access STRING;

   Start_GUI_Flag : BOOLEAN := FALSE;

   GUI_Program    : STRING_PTR;

   ---------------------------------------------------------------------------
   -- Load_Configuration_File
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Load_Configuration_File(
      Filename : in     STRING;
      Status   :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Save_Configuration_File
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Save_Configuration_File(
      Filename : in     STRING;
      Status   :    out DG_Status.STATUS_TYPE);

end DG_Server_Configuration_File_Management;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
