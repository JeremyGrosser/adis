--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--  
--  
--  ADIS / NUMERIC_TYPES.ADA
--  
--  
--  DESCRIPTION:
--  
-- 	This package body implements the basic opperators that are not
--	inherited for the DIS base number types.
--	[tbs]...
--  
--  
--  MODIFICATION HISTORY:
--   
--  11 Apr 1994 / Larry Ullom
--  	  Initial Baseline Version V1.0
--  16 May 1994 / Brett Dufault
--        Added +-*/mod functions for UNSIGNED_8/16/32_BIT types.
--  {change_entry}...
--  
--  ===========================================================================

with UNARY_OPERATORS,
     Unchecked_Conversion,
     Unsigned_Types;
 
--  *===================================*
--  |                                   |
--  |   NUMERIC_TYPES			|
--  |                                   |
--  *===================================*
 
package body NUMERIC_TYPES is
-- 
--|
--| Implementation Notes:
--|
--	All the routines in this package are mearly calls on the overloaded
--	generic functions of UNARY_OPERATORS.
--	[tbs]...
--|

------------------------------------------------------------------------------------------------------------------------------------
  package U1_BIT is new UNARY_OPERATORS(UNSIGNED_1_BIT);
  use U1_BIT;
  package U5_BIT is new UNARY_OPERATORS(UNSIGNED_5_BIT);
  use U5_BIT;
  package U8_BIT is new UNARY_OPERATORS(UNSIGNED_8_BIT);
  use U8_BIT;
  package U16_BIT is new UNARY_OPERATORS(UNSIGNED_16_BIT);
  use U16_BIT;
  package U26_BIT is new UNARY_OPERATORS(UNSIGNED_26_BIT);
  use U26_BIT;
  package U31_BIT is new UNARY_OPERATORS(UNSIGNED_31_BIT);
  use U31_BIT;
  package U32_BIT is new UNARY_OPERATORS(UNSIGNED_32_BIT);
  use U32_BIT;
------------------------------------------------------------------------------------------------------------------------------------

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  function "not" (Number : UNSIGNED_1_BIT) return UNSIGNED_1_BIT is
  begin
    return U_not(Number);
  end "not";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "and" (Left,Right : UNSIGNED_1_BIT) return UNSIGNED_1_BIT is
  begin
    return U_and(Left,Right);
  end "and";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "or"  (Left,Right : UNSIGNED_1_BIT) return UNSIGNED_1_BIT is
  begin
    return U_or(Left,Right);
  end "or";
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  function "not" (Number : UNSIGNED_5_BIT) return UNSIGNED_5_BIT is
  begin
    return U_not(Number);
  end "not";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "and" (Left,Right : UNSIGNED_5_BIT) return UNSIGNED_5_BIT is
  begin
    return U_and(Left,Right);
  end "and";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "or"  (Left,Right : UNSIGNED_5_BIT) return UNSIGNED_5_BIT is
  begin
    return U_or(Left,Right);
  end "or";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Left (Number : UNSIGNED_5_BIT; By : INTEGER) return UNSIGNED_5_BIT is
  begin
    return L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Right (Number : UNSIGNED_5_BIT; By : INTEGER) return UNSIGNED_5_BIT is
  begin
    return R_Shift(Number,By);
  end Shift_Right;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Left (Number : in out UNSIGNED_5_BIT; By : in INTEGER) is
  begin
    Number := L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Right (Number : in out UNSIGNED_5_BIT; By : in INTEGER) is
  begin
    Number := R_Shift(Number,By);
  end Shift_Right;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  function As_Character (Number : UNSIGNED_8_BIT) return CHARACTER is
  begin
    return CHARACTER'val(Number);
  end As_Character;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function As_Unsigned_8 (Char : CHARACTER) return UNSIGNED_8_BIT is
  begin
    return CHARACTER'pos(Char);
  end As_Unsigned_8;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "not" (Number : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
  begin
    return U_not(Number);
  end "not";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "and" (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
  begin
    return U_and(Left,Right);
  end "and";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "or"  (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
  begin
    return U_or(Left,Right);
  end "or";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Left (Number : UNSIGNED_8_BIT; By : INTEGER) return UNSIGNED_8_BIT is
  begin
    return L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Right (Number : UNSIGNED_8_BIT; By : INTEGER) return UNSIGNED_8_BIT is
  begin
    return R_Shift(Number,By);
  end Shift_Right;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Left (Number : in out UNSIGNED_8_BIT; By : in INTEGER) is
  begin
    Number := L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Right (Number : in out UNSIGNED_8_BIT; By : in INTEGER) is
  begin
    Number := R_Shift(Number,By);
  end Shift_Right;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  function "not" (Number : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
  begin
    return U_not(Number);
  end "not";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "and" (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
  begin
    return U_and(Left,Right);
  end "and";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "or"  (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
  begin
    return U_or(Left,Right);
  end "or";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Left (Number : UNSIGNED_16_BIT; By : INTEGER) return UNSIGNED_16_BIT is
  begin
    return L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Right (Number : UNSIGNED_16_BIT; By : INTEGER) return UNSIGNED_16_BIT is
  begin
    return R_Shift(Number,By);
  end Shift_Right;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Left (Number : in out UNSIGNED_16_BIT; By : in INTEGER) is
  begin
    Number := L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Right (Number : in out UNSIGNED_16_BIT; By : in INTEGER) is
  begin
    Number := R_Shift(Number,By);
  end Shift_Right;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  function "not" (Number : UNSIGNED_26_BIT) return UNSIGNED_26_BIT is
  begin
    return U_not(Number);
  end "not";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "and" (Left,Right : UNSIGNED_26_BIT) return UNSIGNED_26_BIT is
  begin
    return U_and(Left,Right);
  end "and";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "or"  (Left,Right : UNSIGNED_26_BIT) return UNSIGNED_26_BIT is
  begin
    return U_or(Left,Right);
  end "or";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Left (Number : UNSIGNED_26_BIT; By : INTEGER) return UNSIGNED_26_BIT is
  begin
    return L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Right (Number : UNSIGNED_26_BIT; By : INTEGER) return UNSIGNED_26_BIT is
  begin
    return R_Shift(Number,By);
  end Shift_Right;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Left (Number : in out UNSIGNED_26_BIT; By : in INTEGER) is
  begin
    Number := L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Right (Number : in out UNSIGNED_26_BIT; By : in INTEGER) is
  begin
    Number := R_Shift(Number,By);
  end Shift_Right;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  function "not" (Number : UNSIGNED_31_BIT) return UNSIGNED_31_BIT is
  begin
    return U_not(Number);
  end "not";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "and" (Left,Right : UNSIGNED_31_BIT) return UNSIGNED_31_BIT is
  begin
    return U_and(Left,Right);
  end "and";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "or"  (Left,Right : UNSIGNED_31_BIT) return UNSIGNED_31_BIT is
  begin
    return U_or(Left,Right);
  end "or";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Left (Number : UNSIGNED_31_BIT; By : INTEGER) return UNSIGNED_31_BIT is
  begin
    return L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Right (Number : UNSIGNED_31_BIT; By : INTEGER) return UNSIGNED_31_BIT is
  begin
    return R_Shift(Number,By);
  end Shift_Right;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Left (Number : in out UNSIGNED_31_BIT; By : in INTEGER) is
  begin
    Number := L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Right (Number : in out UNSIGNED_31_BIT; By : in INTEGER) is
  begin
    Number := R_Shift(Number,By);
  end Shift_Right;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  function "not" (Number : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
  begin
    return U_not(Number);
  end "not";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "and" (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
  begin
    return U_and(Left,Right);
  end "and";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function "or"  (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
  begin
    return U_or(Left,Right);
  end "or";
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Left (Number : UNSIGNED_32_BIT; By : INTEGER) return UNSIGNED_32_BIT is
  begin
    return L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  function Shift_Right (Number : UNSIGNED_32_BIT; By : INTEGER) return UNSIGNED_32_BIT is
  begin
    return R_Shift(Number,By);
  end Shift_Right;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Left (Number : in out UNSIGNED_32_BIT; By : in INTEGER) is
  begin
    Number := L_Shift(Number,By);
  end Shift_Left;
------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------
  procedure Shift_Right (Number : in out UNSIGNED_32_BIT; By : in INTEGER) is
  begin
    Number := R_Shift(Number,By);
  end Shift_Right;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

   --
   -- functions for UNSIGNED_8_BIT type
   --

   function Unsigned_8_To_Unsigned_Tiny
     is new Unchecked_Conversion(
       UNSIGNED_8_BIT, Unsigned_Types.UNSIGNED_TINY_INTEGER);

   function Unsigned_Tiny_To_Unsigned_8
     is new Unchecked_Conversion(
       Unsigned_Types.UNSIGNED_TINY_INTEGER, UNSIGNED_8_BIT);

   function "+"(Left, Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
   begin
      return Unsigned_Tiny_To_Unsigned_8(
        Unsigned_Types."+"(
           Unsigned_8_To_Unsigned_Tiny(Left),
           Unsigned_8_To_Unsigned_Tiny(Right)));
   end "+";

   function "-"(Left, Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
   begin
      return Unsigned_Tiny_To_Unsigned_8(
        Unsigned_Types."-"(
           Unsigned_8_To_Unsigned_Tiny(Left),
           Unsigned_8_To_Unsigned_Tiny(Right)));
   end "-";

   function "*"(Left, Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
   begin
      return Unsigned_Tiny_To_Unsigned_8(
        Unsigned_Types."*"(
           Unsigned_8_To_Unsigned_Tiny(Left),
           Unsigned_8_To_Unsigned_Tiny(Right)));
   end "*";

   function "/"(Left, Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
   begin
      return Unsigned_Tiny_To_Unsigned_8(
        Unsigned_Types."/"(
           Unsigned_8_To_Unsigned_Tiny(Left),
           Unsigned_8_To_Unsigned_Tiny(Right)));
   end "/";

   function "mod"(Left, Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT is
   begin
      return Unsigned_Tiny_To_Unsigned_8(
        Unsigned_Types."mod"(
           Unsigned_8_To_Unsigned_Tiny(Left),
           Unsigned_8_To_Unsigned_Tiny(Right)));
   end "mod";

   --
   -- functions for UNSIGNED_16_BIT type
   --

   function Unsigned_16_To_Unsigned_Short
     is new Unchecked_Conversion(
       UNSIGNED_16_BIT, Unsigned_Types.UNSIGNED_SHORT_INTEGER);

   function Unsigned_Short_To_Unsigned_16
     is new Unchecked_Conversion(
       Unsigned_Types.UNSIGNED_SHORT_INTEGER, UNSIGNED_16_BIT);

   function "+"(Left, Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
   begin
      return Unsigned_Short_To_Unsigned_16(
        Unsigned_Types."+"(
           Unsigned_16_To_Unsigned_Short(Left),
           Unsigned_16_To_Unsigned_Short(Right)));
   end "+";

   function "-"(Left, Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
   begin
      return Unsigned_Short_To_Unsigned_16(
        Unsigned_Types."-"(
           Unsigned_16_To_Unsigned_Short(Left),
           Unsigned_16_To_Unsigned_Short(Right)));
   end "-";

   function "*"(Left, Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
   begin
      return Unsigned_Short_To_Unsigned_16(
        Unsigned_Types."*"(
           Unsigned_16_To_Unsigned_Short(Left),
           Unsigned_16_To_Unsigned_Short(Right)));
   end "*";

   function "/"(Left, Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
   begin
      return Unsigned_Short_To_Unsigned_16(
        Unsigned_Types."/"(
           Unsigned_16_To_Unsigned_Short(Left),
           Unsigned_16_To_Unsigned_Short(Right)));
   end "/";

   function "mod"(Left, Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT is
   begin
      return Unsigned_Short_To_Unsigned_16(
        Unsigned_Types."mod"(
           Unsigned_16_To_Unsigned_Short(Left),
           Unsigned_16_To_Unsigned_Short(Right)));
   end "mod";

   --
   -- functions for UNSIGNED_32_BIT type
   --

   function Unsigned_32_To_Unsigned_Integer
     is new Unchecked_Conversion(
       UNSIGNED_32_BIT, Unsigned_Types.UNSIGNED_INTEGER);

   function Unsigned_Integer_To_Unsigned_32
     is new Unchecked_Conversion(
       Unsigned_Types.UNSIGNED_INTEGER, UNSIGNED_32_BIT);

   function "+"(Left, Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
   begin
      return Unsigned_Integer_To_Unsigned_32(
        Unsigned_Types."+"(
           Unsigned_32_To_Unsigned_Integer(Left),
           Unsigned_32_To_Unsigned_Integer(Right)));
   end "+";

   function "-"(Left, Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
   begin
      return Unsigned_Integer_To_Unsigned_32(
        Unsigned_Types."-"(
           Unsigned_32_To_Unsigned_Integer(Left),
           Unsigned_32_To_Unsigned_Integer(Right)));
   end "-";

   function "*"(Left, Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
   begin
      return Unsigned_Integer_To_Unsigned_32(
        Unsigned_Types."*"(
           Unsigned_32_To_Unsigned_Integer(Left),
           Unsigned_32_To_Unsigned_Integer(Right)));
   end "*";

   function "/"(Left, Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
   begin
      return Unsigned_Integer_To_Unsigned_32(
        Unsigned_Types."/"(
           Unsigned_32_To_Unsigned_Integer(Left),
           Unsigned_32_To_Unsigned_Integer(Right)));
   end "/";

   function "mod"(Left, Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT is
   begin
      return Unsigned_Integer_To_Unsigned_32(
        Unsigned_Types."mod"(
           Unsigned_32_To_Unsigned_Integer(Left),
           Unsigned_32_To_Unsigned_Integer(Right)));
   end "mod";

end NUMERIC_TYPES;
