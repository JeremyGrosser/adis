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
-- UNIT NAME:          String_To_Float_String
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
procedure String_To_Float_String(
   Float_String : in out STRING) is

   Decimal_Point_Count : INTEGER := 0;

begin

   --
   -- Count the number of decimal places
   --
   DECIMAL_POINT_COUNTER_LOOP:
   for counter in Float_String'first..Float_String'last loop
      if Float_String(counter) = '.' then
	 Decimal_Point_Count := Decimal_Point_Count +1;
      end if;
   end loop DECIMAL_POINT_COUNTER_LOOP;

   --
   -- Check for a "."; if missing, append one.
   --
   if (Decimal_Point_Count = 0) then
      PREPEND_DECIMAL_POINT_BLOCK:
      declare
         counter : INTEGER;
      begin
         counter := Float_String'first;
         while (Float_String(counter) /= ASCII.NUL
           and counter <= Float_String'last) loop
              counter := counter + 1;
         end loop;
         if (Float_String(counter) = ASCII.NUL) then
            Float_String(counter) := '.';
            if (counter < Float_String'last) then
               Float_String(counter+1) := ASCII.NUL;
            end if;
         end if;
      end PREPEND_DECIMAL_POINT_BLOCK;
   end if;

   --
   -- Check for a digit preceeding the '.';
   -- if missing, prepend a '0'.
   --
   if (Float_String(Float_String'first) = '.'
     or (Float_String(Float_String'first) = '-'
       and then Float_String(Float_String'first + 1) = '.')) then
          PREPEND_ZERO_LOOP:
          for counter in reverse
            (Float_String'first+1)..(Float_String'last) loop
               if (Float_String(counter-1) /= '-') then
                  Float_String(counter) := Float_String(counter-1);
               end if;
          end loop PREPEND_ZERO_LOOP;
          if (Float_String(Float_String'first) /= '-') then
             Float_String(Float_String'first) := '0';
          else
             Float_String(Float_String'first + 1) := '0';
          end if;
   end if;

   --
   -- Check for a digit trailing the '.';
   -- if missing, append a '0'.
   --
   APPEND_ZERO_LOOP:
   for counter in Float_String'first..Float_String'last loop
      if (Float_String(counter) = '.') then
         if (Float_String(counter+1) = ASCII.NUL) then
            Float_String(counter+1) := '0';
         end if;
      end if;
   end loop APPEND_ZERO_LOOP;

end String_To_Float_String;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   07/22/94   D. Forrest
--      - Initial version
--
-- --

