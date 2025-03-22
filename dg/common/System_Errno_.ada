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
-- PACKAGE NAME     : System_Errno
--
-- FILE NAME        : System_Errno_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : Jun 02, 1994
--
-- PURPOSE:
--   - Provides access to the C global variable "errno", which is used to
--     return additional information for many routines when an error condition
--     is encountered.
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

package System_Errno is

   --
   -- Provide access to the "errno" variable.  "Errno" is an external variable
   -- containing additional information regarding unsuccessful completion of
   -- may system routines.
   --
   Errno : INTEGER;

   pragma INTERFACE_NAME(Errno, "errno");

   ---------------------------------------------------------------------------
   -- Error_Message
   ---------------------------------------------------------------------------
   -- Purpose : Provides a string message corresponding to an errno value.
   ---------------------------------------------------------------------------

   function Error_Message(ErrNum : INTEGER := Errno)
     return STRING;

end System_Errno;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
