
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
-- FILE NAME        : System_Errno.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 07, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with C_Strings;

package body System_Errno is

   --
   -- Import the strerror routine
   --
   -- Note:  Based on manpage for strerror
   --
   -- Purpose - get error message string
   --
   function StrError(
      ErrNum : INTEGER := Errno)
     return C_Strings.C_STRING;

   pragma INTERFACE(C, StrError);

   --
   -- Error_Message
   --
   function Error_Message(ErrNum : INTEGER := Errno)
     return STRING is

   begin  -- Error_Message

      return (C_Strings.Convert_C_To_String(StrError(Errnum)));

   end Error_Message;

end System_Errno;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
