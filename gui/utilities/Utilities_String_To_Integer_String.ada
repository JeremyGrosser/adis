--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--

with Text_IO;

separate (Utilities)

---------------------------------------------------------------------------
--
-- UNIT NAME:          String_To_Integer_String
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   July 22, 1994
--
-- PURPOSE:
--   This procedure converts the string passed in and ensures
--   that is in a properly formatted float format
--
-- IMPLEMENTATION NOTES:
--   This function assumes that no illegal (alphabetic) characters
--   are present. It simply makes sure that the float string is in the 
--   format [digit(s)].[Digit(s)].
--
-- EXCEPTIONS:
--   None.
--
-- PORTABILITY ISSUES:
--   None.
--
-- ANTICIPATED CHANGES:
--   None.
--
---------------------------------------------------------------------------
procedure String_To_Integer_String(
   Integer_String : in out STRING) is
begin

    --
    -- Make null string hold a "0".
    --
    if (Utilities.Length_Of_String(Integer_String) = 0) then
	Integer_String(Integer_String'first) := '0';
        Integer_String(Integer_String'first + 1) := ASCII.NUL;
    --
    -- Check for a digit following the '-'; -- if missing, append a '0'.
    --
    elsif (Integer_String(Integer_String'first) = '-'
      and then (Integer_String(Integer_String'first + 1) = ASCII.NUL)) then
         Integer_String(Integer_String'first + 1) := '0';
         Integer_String(Integer_String'first + 2) := ASCII.NUL;
    end if;

end String_To_Integer_String;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   07/22/94   D. Forrest
--      - Initial version
--
-- --

