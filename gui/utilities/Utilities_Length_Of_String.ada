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
-- UNIT NAME:          Length_Of_String
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   July 25, 1994
--
-- PURPOSE:
--   This procedure returns the number of characters in the passed
--   string until the character ASCII.NUL is reached.
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
function Length_Of_String(
   Source_String : in     STRING) return INTEGER is

   Character_Count : INTEGER := 0;
   counter         : INTEGER := 0;

begin

   if (System."/=" (Source_String'address, System.NO_ADDR)) then
      --
      -- Count the number of characters
      --
      counter := Source_String'first;
      CHARACTER_COUNTER_LOOP:
      while ((counter <= Source_String'last) 
        and (Source_String(counter) /= ASCII.NUL)) loop
	   Character_Count := Character_Count +1;
	   counter         := counter + 1;
      end loop CHARACTER_COUNTER_LOOP;
   end if;

   return Character_Count;

exception

   when OTHERS =>
      Character_Count := 0;
      return Character_Count;
end Length_Of_String;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   07/25/94   D. Forrest
--      - Initial version
--
-- --

