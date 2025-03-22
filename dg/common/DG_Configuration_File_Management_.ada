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
-- FILE NAME        : DG_Configuration_File_Management_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 27, 1994
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

generic

   ---------------------------------------------------------------------------
   -- Interpret_Configuration_Data
   ---------------------------------------------------------------------------
   -- Purpose: This is an external generic routine which takes appropriate
   --          action for the keyword and its associated value.
   ---------------------------------------------------------------------------

   with
     procedure Interpret_Configuration_Data(
        Keyword_Name  : in     STRING;
        Keyword_Value : in     STRING;
        Status        :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Report_Error
   ---------------------------------------------------------------------------
   -- Purpose: This is an external generic routine which should be called by
   --          Load_Configuration_File if an error is detected.
   ---------------------------------------------------------------------------

   with
     procedure Report_Error(
       Error : in DG_Status.STATUS_TYPE);

package DG_Configuration_File_Management is

   ---------------------------------------------------------------------------
   -- Load_Configuration_File
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Load_Configuration_File(
      Filename  : in     STRING;
      Status    :    out DG_Status.STATUS_TYPE);

end DG_Configuration_File_Management;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
