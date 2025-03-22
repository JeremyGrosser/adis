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
-- UNIT NAME:          Get_Hexadecimal_From_Text
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 6, 1994
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
procedure Get_Hexadecimal_From_Text(
   Text_String    : in     STRING;
   Return_Value   :    out INTEGER;
   Success        :    out BOOLEAN) is

   K_Hexadecimal_Prefix         : constant STRING  := "16#";
   K_Hexadecimal_Prefix_Length  : constant INTEGER 
     := K_Hexadecimal_Prefix'last - K_Hexadecimal_Prefix'first + 1;

   K_Hexadecimal_Postfix        : constant STRING  := "#";
   K_Hexadecimal_Postfix_Length : constant INTEGER 
     := K_Hexadecimal_Postfix'last - K_Hexadecimal_Postfix'first + 1;

   K_Hex_Digits_Per_Integer     : constant INTEGER := 8;
   K_New_Text_Length_Extra      : constant INTEGER
     := K_Hex_Digits_Per_Integer + K_Hexadecimal_Prefix_Length
       + K_Hexadecimal_Postfix_Length;

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
   -- Make sure that Temp_Text is a properly formatted hexadecimal string.
   --
   Utilities.String_To_Hexadecimal_String (Temp_Text);

   --
   -- Change the hexadecimal format from "12AB3F21" to "16#12AB3F21#"
   -- in order to use Ada's Integer_IO.Get function.
   --
   New_Text(1..K_Hexadecimal_Prefix_Length + Utilities.Length_Of_String (
     Temp_Text) + K_Hexadecimal_Postfix_Length) 
       := K_Hexadecimal_Prefix & Temp_Text(1..Utilities.Length_Of_String(
	 Temp_Text)) & K_Hexadecimal_Postfix;

   --
   -- Calculate the length of New_Text.
   --
   New_Text_Length := Utilities.Length_Of_String (New_Text);

   --
   -- Extract the integer value from the hexadecimal string.
   --
   if (New_Text_Length >= 0) then

      if (New_Text_Length = K_New_Text_Length_Extra) then
	 --
	 -- Handle case where bit 0 (leftmost bit) is one. This is a problem
	 -- because Verdix Ada does not have a true 32 bit unsigned integer
	 -- type... So we'll take the 2's complement of the number and get
	 -- the bit equivalent of the unsigned equivalent of our binary number
	 -- string.
	 --
	 case New_Text(4) is
	     when '8' | '9' | 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
	       | 'a' | 'b' | 'c' | 'd' | 'e' | 'f' =>

		--
		-- Flip all bits.
		--
		for Index in 4..(4 + K_Hex_Digits_Per_Integer - 1) loop

		   case New_Text(Index) is
		      when '0'       => New_Text(Index) := 'F';
		      when '1'       => New_Text(Index) := 'E';
		      when '2'       => New_Text(Index) := 'D';
		      when '3'       => New_Text(Index) := 'C';
		      when '4'       => New_Text(Index) := 'B';
		      when '5'       => New_Text(Index) := 'A';
		      when '6'       => New_Text(Index) := '9';
		      when '7'       => New_Text(Index) := '8';
		      when '8'       => New_Text(Index) := '7';
		      when '9'       => New_Text(Index) := '6';
		      when 'A' | 'a' => New_Text(Index) := '5';
		      when 'B' | 'b' => New_Text(Index) := '4';
		      when 'C' | 'c' => New_Text(Index) := '3';
		      when 'D' | 'd' => New_Text(Index) := '2';
		      when 'E' | 'e' => New_Text(Index) := '1';
		      when 'F' | 'f' => New_Text(Index) := '0';
		      when OTHERS    => New_Text(Index) := '0';
		   end case;

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

	     when OTHERS =>

		Integer_IO.Get (
		  FROM => New_Text,
		  ITEM => Interim_Integer,
		  LAST => Temp_Last_Index);
		Interim_Success := TRUE;

	 end case;

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
      Text_IO.Put_Line ("There was a problem reading the hexadecimal number.");
      Return_Value := 0;
      Success      := False;

end Get_Hexadecimal_From_Text;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/06/94   D. Forrest
--      - Initial version
--
-- --

