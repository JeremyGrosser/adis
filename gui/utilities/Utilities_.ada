--
--                           U N C L A S S I F I E D
--
--  *=======================================================================*
--  |                                                                       |
--  |                        Manned Flight Simulator                        |
--  |               Naval Air Warfare Center Aircraft Division              |
--  |                       Patuxent River, Maryland                        |
--  |                                                                       |
--  *=======================================================================*
--

----------------------------------------------------------------------------
--                                                                        --
--                        Manned Flight Simulator                         --
--                        Bldg 2035                                       --
--                        Patuxent River, MD 20670                        --
--                                                                        --
--      Title:                                                            --
--          ADIS/Utilities.a                                              --
--                                                                        --
--      Description:                                                      --
--          This file contains the utilities source code.                 --
--                                                                        --
--      History:                                                          --
--          15 Jul 94     Daryl Forrest (J.F. Taylor, Inc.)  v1.0         --
--                            Initial version.                            --
--                                                                        --
----------------------------------------------------------------------------

with Calendar;
with System;
with Unchecked_Conversion;

package Utilities is
   K_String_Null           : constant STRING(1..1) := (1 => ASCII.NUL);
   K_String_Separator_Mac  : constant STRING(1..1) := (1 => ASCII.CR);
   K_String_Separator_DOS  : constant STRING(1..2) := (ASCII.CR & ASCII.LF);
   K_String_Separator_UNIX : constant STRING(1..1) := (1 => ASCII.LF);
   K_String_Separator      : constant STRING := K_String_Separator_UNIX;

   type CHAR_ARRAY_TYPE is array(CHARACTER) of CHARACTER;
   K_To_Upper: constant CHAR_ARRAY_TYPE := (
     ASCII.nul, ASCII.soh, ASCII.stx, ASCII.etx,
     ASCII.eot, ASCII.enq, ASCII.ack, ASCII.bel,
     ASCII.bs,  ASCII.ht,  ASCII.lf,  ASCII.vt,
     ASCII.ff,  ASCII.cr,  ASCII.so,  ASCII.si,
     ASCII.dle, ASCII.dc1, ASCII.dc2, ASCII.dc3,
     ASCII.dc4, ASCII.nak, ASCII.syn, ASCII.etb,
     ASCII.can, ASCII.em,  ASCII.sub, ASCII.esc,
     ASCII.fs,  ASCII.gs,  ASCII.rs,  ASCII.us,
     ' ', '!', '"', '#', '$', '%', '&', ''',
     '(', ')', '*', '+', ',', '-', '.', '/',
     '0', '1', '2', '3', '4', '5', '6', '7',
     '8', '9', ':', ';', '<', '=', '>', '?',
     '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
     'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
     'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
     'X', 'Y', 'Z', '[', '\', ']', '^', '_',
     '`', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
     'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
     'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
     'X', 'Y', 'Z', '{', '|', '}', '~', ASCII.del);

   K_To_Lower: constant CHAR_ARRAY_TYPE := (
     ASCII.nul, ASCII.soh, ASCII.stx, ASCII.etx,
     ASCII.eot, ASCII.enq, ASCII.ack, ASCII.bel,
     ASCII.bs,  ASCII.ht,  ASCII.lf,  ASCII.vt,
     ASCII.ff,  ASCII.cr,  ASCII.so,  ASCII.si,
     ASCII.dle, ASCII.dc1, ASCII.dc2, ASCII.dc3,
     ASCII.dc4, ASCII.nak, ASCII.syn, ASCII.etb,
     ASCII.can, ASCII.em,  ASCII.sub, ASCII.esc,
     ASCII.fs,  ASCII.gs,  ASCII.rs,  ASCII.us,
     ' ', '!', '"', '#', '$', '%', '&', ''',
     '(', ')', '*', '+', ',', '-', '.', '/',
     '0', '1', '2', '3', '4', '5', '6', '7',
     '8', '9', ':', ';', '<', '=', '>', '?',
     '@', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
     'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
     'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
     'x', 'y', 'z', '[', '\', ']', '^', '_',
     '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
     'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
     'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
     'x', 'y', 'z', '{', '|', '}', '~', ASCII.del);

   ---------------------------------------------------------
   --                                                     --
   -- Type declarations.                                  --
   --                                                     --
   ---------------------------------------------------------
   type ASTRING is access STRING;
   function Address_to_Int
     is new UNCHECKED_CONVERSION (SYSTEM.ADDRESS, INTEGER);


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Min ()                                  --
   --                                                     --
   -- PURPOSE:    This function returns the minimum of    --
   --             the two passed values.                  --
   --                                                     --
   -- PARAMETERS: Value1 - First value for comparison.    --
   --             Value2 - Second value for comparison.   --
   --                                                     --
   -- RETURNS:    minimum of Value1 and Value2.           --
   --                                                     --
   ---------------------------------------------------------
   function Min(
      Value1 : in     INTEGER;
      Value2 : in     INTEGER) return INTEGER;
   function Min(
      Value1 : in     FLOAT;
      Value2 : in     FLOAT) return FLOAT;

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Max ()                                  --
   --                                                     --
   -- PURPOSE:    This function returns the maximum of    --
   --             the two passed values.                  --
   --                                                     --
   -- PARAMETERS: Value1 - First value for comparison.    --
   --             Value2 - Second value for comparison.   --
   --                                                     --
   -- RETURNS:    maximum of Value1 and Value2.           --
   --                                                     --
   ---------------------------------------------------------
   function Max(
      Value1 : in     INTEGER;
      Value2 : in     INTEGER) return INTEGER;
   function Max(
      Value1 : in     FLOAT;
      Value2 : in     FLOAT) return FLOAT;

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  String_To_Float_String                  --
   --                                                     --
   -- PURPOSE:    This procedure converts the string      --
   --             passed in and ensures that is in a      --
   --             properly formatted float format.        --
   --                                                     --
   -- PARAMETERS: Float_String -  The string to be        --
   --                             converted.              --
   --                                                     --
   ---------------------------------------------------------
   procedure String_To_Float_String(
      Float_String : in out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  String_To_Integer_String                --
   --                                                     --
   -- PURPOSE:    This procedure converts the string      --
   --             passed in and ensures that is in a      --
   --             properly formatted integer format.      --
   --                                                     --
   -- PARAMETERS: Integer_String -  The string to be      --
   --                               converted.            --
   --                                                     --
   ---------------------------------------------------------
   procedure String_To_Integer_String(
      Integer_String : in out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  String_To_Hexadecimal_String            --
   --                                                     --
   -- PURPOSE:    This procedure converts the string      --
   --             passed in and ensures that is in a      --
   --             properly formatted hexadecimal format.  --
   --                                                     --
   -- PARAMETERS: Hexadecimal_String -  The string to be  --
   --                                   converted.        --
   --                                                     --
   ---------------------------------------------------------
   procedure String_To_Hexadecimal_String(
      Hexadecimal_String : in out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  String_To_Binary_String                 --
   --                                                     --
   -- PURPOSE:    This procedure converts the string      --
   --             passed in and ensures that is in a      --
   --             properly formatted binary format.       --
   --                                                     --
   -- PARAMETERS: Binary_String -  The string to be       --
   --                              converted.             --
   --                                                     --
   ---------------------------------------------------------
   procedure String_To_Binary_String(
      Binary_String : in out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Length_Of_String                        --
   --                                                     --
   -- PURPOSE:    This procedure returns the number of    --
   --             characters in the passed string until   --
   --             the character ASCII.NUL is reached.     --
   --                                                     --
   -- PARAMETERS: Source_String - The string whose length --
   --                             is to be determined.    --
   --                                                     --
   ---------------------------------------------------------
   function Length_Of_String(
      Source_String : in     STRING) return INTEGER;

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Integer_From_Text                   --
   --                                                     --
   -- PURPOSE:    This procedure returns the integer      --
   --             equivalent of the passed text in the    --
   --             passed parameter Return_Integer. A      --
   --             BOOLEAN True is returned in Success if  --
   --             the procedure can extract an integer,   --
   --             and False is returned if it fails (i.e. --
   --             the text string is null, empty, or      --
   --             contains an invalid integer string.     --
   --                                                     --
   -- PARAMETERS: Text_String    - The integer string.    --
   --             Return_Value   - The extracted integer. --
   --             Success        - Procedure success or   --
   --                              failure status.        --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Integer_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Float_From_Text                     --
   --                                                     --
   -- PURPOSE:    This procedure returns the float        --
   --             equivalent of the passed text in the    --
   --             passed parameter Return_Float. A        --
   --             BOOLEAN True is returned in Success if  --
   --             the procedure can extract a float,      --
   --             and False is returned if it fails (i.e. --
   --             the text string is null, empty, or      --
   --             contains an invalid float string.       --
   --                                                     --
   -- PARAMETERS: Text_String  - The float string.        --
   --             Return_Value - The extracted float.     --
   --             Success      - Procedure success or     --
   --                            failure status.          --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Float_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out FLOAT;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Hexadecimal_From_Text               --
   --                                                     --
   -- PURPOSE:    This procedure returns the integer      --
   --             equivalent of the passed text in the    --
   --             passed parameter Return_Integer. A      --
   --             BOOLEAN True is returned in Success if  --
   --             the procedure can extract an integer,   --
   --             and False is returned if it fails (i.e. --
   --             the text string is null, empty, or      --
   --             contains an invalid hexadecimal string. --
   --                                                     --
   -- PARAMETERS: Text_String    - The hex. string.       --
   --             Return_Value   - The extracted integer. --
   --             Success        - Procedure success or   --
   --                              failure status.        --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Hexadecimal_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Binary_From_Text                    --
   --                                                     --
   -- PURPOSE:    This procedure returns the integer      --
   --             equivalent of the passed text in the    --
   --             passed parameter Return_Integer. A      --
   --             BOOLEAN True is returned in Success if  --
   --             the procedure can extract an integer,   --
   --             and False is returned if it fails (i.e. --
   --             the text string is null, empty, or      --
   --             contains an invalid binary string.      --
   --                                                     --
   -- PARAMETERS: Text_String    - The binary string.     --
   --             Return_Value   - The extracted integer. --
   --             Success        - Procedure success or   --
   --                              failure status.        --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Binary_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Integer_To_String                       --
   --                                                     --
   -- PURPOSE:    This procedure converts the passed      --
   --             INTEGER into its string equivalent,     --
   --             returning it in the passed STRING       --
   --             parameter.                              --
   --                                                     --
   -- PARAMETERS: Integer_Value - The integer to convert. --
   --             Return_String - The converted string    --
   --                             equivalent of           --
   --                             Integer_Value.          --
   --                                                     --
   ---------------------------------------------------------
   procedure Integer_To_String(
      Integer_Value : in     INTEGER;
      Return_String :    out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Float_To_String                         --
   --                                                     --
   -- PURPOSE:    This procedure converts the passed      --
   --             FLOAT into its string equivalent,       --
   --             returning it in the passed STRING       --
   --             parameter.                              --
   --                                                     --
   -- PARAMETERS: Float_Value - The float to convert.     --
   --             Return_String - The converted string    --
   --                             equivalent of           --
   --                             Float_Value.            --
   --                                                     --
   ---------------------------------------------------------
   procedure Float_To_String(
      Float_Value   : in     FLOAT;
      Return_String :    out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Hexadecimal_To_String                   --
   --                                                     --
   -- PURPOSE:    This procedure converts the passed      --
   --             INTEGER into its hexadecimal string     --
   --             equivalent, returning it in the passed  --
   --             STRING parameter.                       --
   --                                                     --
   -- PARAMETERS: Hexadecimal_Value - The integer to      --
   --                                 convert.            --
   --             Return_String     - The converted hex-  --
   --                                 idecimal string     --
   --                                 equivalent of       --
   --                                 Hexadecimal_Value.  --
   --                                                     --
   ---------------------------------------------------------
   procedure Hexadecimal_To_String(
      Hexadecimal_Value : in     INTEGER;
      Return_String     :    out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Binary_To_String                        --
   --                                                     --
   -- PURPOSE:    This procedure converts the passed      --
   --             INTEGER into its binary string          --
   --             equivalent, returning it in the passed  --
   --             STRING parameter.                       --
   --                                                     --
   -- PARAMETERS: Binary_Value  - The integer to          --
   --                             convert.                --
   --             Return_String - The converted binary    --
   --                             string equivalent of    --
   --                             Binary_Value.           --
   --                                                     --
   ---------------------------------------------------------
   procedure Binary_To_String(
      Binary_Value  : in     INTEGER;
      Return_String :    out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Strip_Spaces                            --
   --                                                     --
   -- PURPOSE:    This procedure strips all leading and   --
   --             trailing spaces from the passed string. --
   --             The non-space portions of the string    --
   --             are moved forward to replace any lead-  --
   --             ing spaces, and trailing spaces are re- --
   --             placed with ASCII.NULL characters.      --
   --                                                     --
   -- PARAMETERS: Value_String - The string from which    --
   --                            all space characters are --
   --                            to be stripped.          --
   --                                                     --
   ---------------------------------------------------------
   procedure Strip_Spaces(
      Value_String  : in out STRING);

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Time_To_String                          --
   --                                                     --
   -- PURPOSE:    This procedure converts a variable of   --
   --             type Calendar.TIME into its STRING      --
   --             equivalent, with the hours, minutes,    --
   --             and seconds padded with zeroes.         --
   --                                                     --
   -- PARAMETERS: Time - the Calendar.TIME to convert.    --
   --                                                     --
   ---------------------------------------------------------
   function Time_To_String(
      Time  : in     Calendar.TIME) return STRING;

end Utilities;

