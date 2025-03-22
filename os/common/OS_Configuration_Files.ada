--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_Configuration_Files
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  22 August 94
--
-- PURPOSE :
--
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
package body OS_Configuration_Files is

   procedure Process_Configuration_Data(
      Keyword_Name  :  in     STRING;
      Keyword_Value :  in     STRING;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Load_Configuration_File(
      Filename :  in     STRING;
      Status   :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Save_Configuration_File(
      Filename :  in     STRING;
      Status   :     out OS_Status.STATUS_TYPE)
     is separate;

end OS_Configuration_Files;
