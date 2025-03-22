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
-- PACKAGE NAME     : System_Exec
--
-- FILE NAME        : System_Exec_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 25, 1994
--
-- PURPOSE:
--   - Provides access to system routines related to process execution.
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

with C_Strings,
     System;

package System_Exec is

   type C_STRING_ARRAY is
     array (INTEGER range <>) of C_Strings.C_STRING;

   ---------------------------------------------------------------------------
   -- ExecVE
   ---------------------------------------------------------------------------
   -- Purpose: Execute a file.
   ---------------------------------------------------------------------------

   function ExecVE(
      Path : in C_Strings.C_STRING;
      ArgV : in System.ADDRESS;      -- C_STRING_ARRAY'ADDRESS
      EnvP : in System.ADDRESS)      -- C_STRING_ARRAY'ADDRESS
     return INTEGER;

   pragma INTERFACE(C, ExecVE);

end System_Exec;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
