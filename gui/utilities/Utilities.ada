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

with BasicTypes;
with Calendar;
with Character_Type;
with Unchecked_Conversion;
with Strlen;
with Text_IO;

package body Utilities is
 
   ---------------------------------------------------------
   --                                                     --
   -- UNIT NAME:  Min ()                                  --
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
   function Min (
      Value1 : in     INTEGER;
      Value2 : in     INTEGER) return INTEGER is
   begin
      --
      -- Return the minimum of Value1 and Value2.
      --
      if (Value1 < Value2) then
	 return Value1;
      else
	 return Value2;
      end if;
   end Min;

   function Min (
      Value1 : in     FLOAT;
      Value2 : in     FLOAT) return FLOAT is
   begin
      --
      -- Return the minimum of Value1 and Value2.
      --
      if (Value1 < Value2) then
	 return Value1;
      else
	 return Value2;
      end if;
   end Min;

 
   ---------------------------------------------------------
   --                                                     --
   -- UNIT NAME:  Max ()                                  --
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
   function Max (
      Value1 : in     INTEGER;
      Value2 : in     INTEGER) return INTEGER is
   begin
      --
      -- Return the maximum of Value1 and Value2.
      --
      if (Value1 > Value2) then
	 return Value1;
      else
	 return Value2;
      end if;
   end Max;

   function Max (
      Value1 : in     FLOAT;
      Value2 : in     FLOAT) return FLOAT is
   begin
      --
      -- Return the maximum of Value1 and Value2.
      --
      if (Value1 > Value2) then
	 return Value1;
      else
	 return Value2;
      end if;
   end Max;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  String_To_Float_String
   --
   ---------------------------------------------------------
   procedure String_To_Float_String(
      Float_String : in out STRING)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  String_To_Integer_String
   --
   ---------------------------------------------------------
   procedure String_To_Integer_String(
      Integer_String : in out STRING)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  String_To_Hexadecimal_String
   --
   ---------------------------------------------------------
   procedure String_To_Hexadecimal_String(
      Hexadecimal_String : in out STRING)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  String_To_Binary_String
   --
   ---------------------------------------------------------
   procedure String_To_Binary_String(
      Binary_String : in out STRING)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Length_Of_String
   --
   ---------------------------------------------------------
   function Length_Of_String(
      Source_String : in     STRING) return INTEGER
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Get_Integer_From_Text
   --
   ---------------------------------------------------------
   procedure Get_Integer_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Get_Float_From_Text
   --
   ---------------------------------------------------------
   procedure Get_Float_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out FLOAT;
      Success      :    out BOOLEAN)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Get_Hexadecimal_From_Text
   --
   ---------------------------------------------------------
   procedure Get_Hexadecimal_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Get_Binary_From_Text
   --
   ---------------------------------------------------------
   procedure Get_Binary_From_Text(
      Text_String  : in     STRING;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Integer_To_String
   --
   ---------------------------------------------------------
   procedure Integer_To_String(
      Integer_Value : in     INTEGER;
      Return_String :    out STRING)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Float_To_String
   --
   ---------------------------------------------------------
   procedure Float_To_String(
      Float_Value : in       FLOAT;
      Return_String :    out STRING)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Hexadecimal_To_String
   --
   ---------------------------------------------------------
   procedure Hexadecimal_To_String(
      Hexadecimal_Value : in     INTEGER;
      Return_String     :    out STRING)
     is separate;

   ---------------------------------------------------------
   --
   -- UNIT NAME:  Binary_To_String
   --
   ---------------------------------------------------------
   procedure Binary_To_String(
      Binary_Value  : in     INTEGER;
      Return_String :    out STRING)
     is separate;

   ---------------------------------------------------------
   --                                                     --
   -- UNIT NAME:  Strip_Spaces                            --
   --                                                     --
   ---------------------------------------------------------
   procedure Strip_Spaces(
      Value_String  : in out STRING)
     is separate;

   ---------------------------------------------------------
   --                                                     --
   -- UNIT NAME:  Time_To_String                          --
   --                                                     --
   ---------------------------------------------------------
   function Time_To_String(
      Time  : in     Calendar.TIME) return STRING
     is separate;

end Utilities;

