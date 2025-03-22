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
-- UNIT NAME:          String_To_Binary_String
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 8, 1994
--
-- PURPOSE:
--   This procedure converts the string passed in and ensures
--   that is in a properly formatted binary integer format
--
-- IMPLEMENTATION NOTES:
--   This function assumes that no illegal characters
--   are present. It simply makes sure that the binary integer 
--   holds is non-null and not negative.
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
procedure String_To_Binary_String(
   Binary_String : in out STRING) is
begin
    --
    -- Strip spaces from the binary string.
    --
    Strip_Spaces (Binary_String);

    --
    -- Make null string hold a "0".
    --
    if (Utilities.Length_Of_String(Binary_String) = 0) then
	Binary_String(Binary_String'first) := '0';
        Binary_String(Binary_String'first + 1) := ASCII.NUL;
    --
    -- Check for a digit following the '-'; -- if it exists, remove it...
    --
    elsif (Binary_String(Binary_String'first) = '-') then
       for Index in Binary_String'first..Binary_String'last-1 loop
	  Binary_String(Index) := Binary_String(Index+1);
       end loop;
    end if;

end String_To_Binary_String;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/08/94   D. Forrest
--      - Initial version
--
-- --

