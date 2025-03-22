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
-- PACKAGE NAME     : System_Environment
--
-- FILE NAME        : System_Environment_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 24, 1994
--
-- PURPOSE:
--   - Provides access to system routines for manipulating the process
--     environment.
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

with C_Strings;

package System_Environment is

   ---------------------------------------------------------------------------
   -- PutEnv
   ---------------------------------------------------------------------------
   -- Purpose: Change or add value to environment.
   -- Returns: 0 if unsuccessful, non-zero if successful.
   ---------------------------------------------------------------------------

   function PutEnv(Variable : in C_Strings.C_STRING)
     return INTEGER;

   pragma INTERFACE(C, PutEnv);

   ---------------------------------------------------------------------------
   -- GetEnv
   ---------------------------------------------------------------------------
   -- Purpose: Return value for environment name.
   -- Returns: Pointer to value of Name, or NULL if Name is not found.
   ---------------------------------------------------------------------------

   function GetEnv(Name : in C_Strings.C_STRING)
     return C_Strings.C_STRING;

   pragma INTERFACE(C, GetEnv);

end System_Environment;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
