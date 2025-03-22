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
-- UNIT NAME:          Strip_Spaces
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 31, 1994
--
-- PURPOSE:            This procedure strips all leading and
--                     trailing spaces from the passed string.
--                     The non-space portions of the string
--                     are moved forward to replace any lead-
--                     ing spaces, and trailing spaces are re-
--                     placed with ASCII.NULL characters.
--
-- IMPLEMENTATION NOTES:
--   None.
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
procedure Strip_Spaces(
   Value_String : in out STRING) is

   Temp_String       : STRING(Value_String'range) := (OTHERS => ASCII.NUL);
   Temp_String_Index : INTEGER := Temp_String'first;

begin

   Strip_Spaces_Loop:
   for Value_String_Index in Value_String'first..Value_String'last loop

      if (Value_String(Value_String_Index) /= ' ') then

	 if (Temp_String_Index <= Temp_String'last) then

	    Temp_String(Temp_String_Index)
	      := Value_String(Value_String_Index);
	    Temp_String_Index := Temp_String_Index + 1;

	 end if;

      end if;

   end loop Strip_Spaces_Loop;

   Value_String := Temp_String;

exception

   when OTHERS =>
      null;

end Strip_Spaces;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/31/94   D. Forrest
--      - Initial version
--
-- --

