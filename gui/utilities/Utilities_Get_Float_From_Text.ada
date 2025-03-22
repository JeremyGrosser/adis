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
-- UNIT NAME:          Get_Float_From_Text
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   July 26, 1994
--
-- PURPOSE:
--   This procedure returns the float equivalent of the passed
--   text in the passed parameter Return_Value. A BOOLEAN True
--   is returned in Success if the procedure can extract a float,
--   and False is returned if it fails (i.e. the text string is null,
--   empty, or contains an invalid float string.
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
procedure Get_Float_From_Text(
   Text_String  : in     STRING;
   Return_Value :    out FLOAT;
   Success      :    out BOOLEAN) is

   K_New_Text_Length_Extra : constant INTEGER := 32;

   Text_Length     : INTEGER            := 0;
   New_Text        : Utilities.ASTRING  := NULL;
   New_Text_Length : INTEGER            := 0;

   Interim_Float   : FLOAT    := 0.0;
   Interim_Success : BOOLEAN  := TRUE;
   Temp_Last_Index : POSITIVE := 1;

   --
   -- Instantiated Packages
   --
   package Float_IO is
     new Text_IO.Float_IO (FLOAT);


begin

   Text_Length  := Text_String'length;
   New_Text     := new STRING(1..Text_Length+K_New_Text_Length_Extra);
   New_Text.all := (OTHERS => ASCII.NUL);

   New_Text(New_Text'first..(Text_String'last-Text_String'first+1)) :=
     Text_String(Text_String'first..Text_String'last);

   Utilities.String_To_Float_String (New_Text.all);

   New_Text_Length := Utilities.Length_Of_String (New_Text.all);

   if (New_Text_Length >= 0) then
      Float_IO.Get (
        FROM => New_Text.all,
        ITEM => Interim_Float,
        LAST => Temp_Last_Index);
      Interim_Success := TRUE;
   else 
      Interim_Float   := 0.0;
      Interim_Success := FALSE;
   end if;

   Return_Value := Interim_Float;
   Success      := Interim_Success;

exception

   when OTHERS =>
      Return_Value := 0.0;
      Success      := False;

end Get_Float_From_Text;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   07/26/94   D. Forrest
--      - Initial version
--
-- --

