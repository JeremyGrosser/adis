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
-- PACKAGE NAME     : DG_Configuration_File_Management
--
-- FILE NAME        : DG_Configuration_File_Management.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June dd, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

package body DG_Configuration_File_Management is

   ---------------------------------------------------------------------------
   -- Load_Configuration_File
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Load_Configuration_File(
      Filename  : in     STRING;
      Status    :    out DG_Status.STATUS_TYPE)
     is separate;

end DG_Configuration_File_Management;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
