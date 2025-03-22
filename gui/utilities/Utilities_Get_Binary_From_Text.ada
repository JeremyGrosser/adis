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

with BasicTypes;
with Text_IO;

separate (Utilities)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Get_Binary_From_Text
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 8, 1994
--
-- PURPOSE:
--   This procedure returns the integer equivalent of the passed
--   text in the passed parameter Return_Value. A BOOLEAN True
--   is returned in Success if the procedure can extract an integer,
--   and False is returned if it fails (i.e. the text string is null,
--   empty, or contains an invalid integer string.
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
procedure Get_Binary_From_Text(
   Text_String    : in     STRING;
   Return_Value   :    out INTEGER;
   Success        :    out BOOLEAN) is

   K_Binary_Prefix         : constant STRING  := "2#";
   K_Binary_Prefix_Length  : constant INTEGER 
     := K_Binary_Prefix'last - K_Binary_Prefix'first + 1;

   K_Binary_Postfix        : constant STRING  := "#";
   K_Binary_Postfix_Length : constant INTEGER 
     := K_Binary_Postfix'last - K_Binary_Postfix'first + 1;

   K_Binary_Digits_Per_Integer  : constant INTEGER := 32;
   K_New_Text_Length_Extra      : constant INTEGER
     := 32 + K_Binary_Prefix_Length + K_Binary_Postfix_Length;

   K_Text_Length   : constant INTEGER := Text_String'length;

   Temp_Text       : STRING(Text_String'range) := Text_String;
   New_Text        : STRING(1..K_Text_Length+K_New_Text_Length_Extra)
     := (OTHERS => ASCII.NUL);
   New_Text_Length : INTEGER  := 0;

   Interim_Integer : INTEGER  := 0;
   Interim_Success : BOOLEAN  := TRUE;
   Temp_Last_Index : POSITIVE := 1;

   --
   -- Instantiated Packages
   --
   package Integer_IO is
     new Text_IO.Integer_IO (INTEGER);

begin

   --
   -- Make sure that Temp_Text is a properly formatted binary string.
   --
   Utilities.String_To_Binary_String (Temp_Text);

   --
   -- Change the binary format from "00001100000011000000110000001100"
   -- to "2#00001100000011000000110000001100#"
   -- in order to use Ada's Integer_IO.Get function.
   --
   New_Text(1..K_Binary_Prefix_Length + Utilities.Length_Of_String (
     Temp_Text) + K_Binary_Postfix_Length) 
       := K_Binary_Prefix & Temp_Text(1..Utilities.Length_Of_String(
	 Temp_Text)) & K_Binary_Postfix;

   --
   -- Calculate the length of New_Text.
   --
   New_Text_Length := Utilities.Length_Of_String (New_Text);

   --
   -- Extract the integer value from the binary string.
   --
   if (New_Text_Length >= 0) then
      --
      -- Handle case where bit 0 (leftmost bit) is one. This is a problem
      -- because Verdix Ada does not have a true 32 bit unsigned integer
      -- type... So we'll take the 2's complement of the number and get
      -- the bit equivalent of the unsigned equivalent of our binary number
      -- string.
      --
      if ((New_Text_Length = K_New_Text_Length_Extra)
	and (New_Text(3) = '1')) then

	 --
	 -- Flip all bits.
	 --
	 for Index in 3..(3 + K_Binary_Digits_Per_Integer - 1) loop
	    if (New_Text(Index) = '0') then
	       New_Text(Index) := '1';
	    elsif (New_Text(Index) = '1') then
	       New_Text(Index) := '0';
	    end if;
	 end loop;

	 --
	 -- Extract the integer equivalent of this number.
	 --
	 Integer_IO.Get (
	   FROM => New_Text,
	   ITEM => Interim_Integer,
	   LAST => Temp_Last_Index);

	 --
	 -- Add one
	 --
	 Interim_Integer := Interim_Integer + 1;

	 --
	 -- Negate
	 --
	 Interim_Integer := -Interim_Integer;

	 Interim_Success := TRUE;
      --
      -- Since bit 0 is zero, we can let the standard integer io package
      -- do its job...
      else
	 Integer_IO.Get (
	   FROM => New_Text,
	   ITEM => Interim_Integer,
	   LAST => Temp_Last_Index);
	 Interim_Success := TRUE;
      end if;
   else 
      Interim_Integer := 0;
      Interim_Success := FALSE;
   end if;

   -- Normally you free here, but Ada crashes when you do so
   -- BasicTypes.FreeAdaString (Text);

   Return_Value := Interim_Integer;
   Success      := Interim_Success;

exception

   when OTHERS =>
      Text_IO.Put_Line ("There was a problem reading the binary number.");
      Return_Value := 0;
      Success      := False;

end Get_Binary_From_Text;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/08/94   D. Forrest
--      - Initial version
--
-- --

