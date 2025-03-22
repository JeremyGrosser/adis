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
-- UNIT NAME:          Binary_To_String
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 8, 1994
--
-- PURPOSE:
--   This procedure converts the passed INTEGER into its binary string
--   equivalent (Note: this does NOT return the string "2#00001100#" for 
--   decimal 12, it returns "00001100"), returning it in the passed STRING
--   parameter.
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
procedure Binary_To_String(
   Binary_Value  : in     INTEGER;
   Return_String :    out STRING) is

   package Integer_IO is
     new Text_IO.Integer_IO(INTEGER);

   K_Base       : constant INTEGER := 2;

   Value_String : STRING(Return_String'range) := (OTHERS => ASCII.NUL);

begin

   --
   -- Convert the integer into it's Ada STRING equivalent
   --
   Integer_IO.Put(
     TO   => Value_String,
     ITEM => Binary_Value,
     BASE => K_Base);

   --
   -- Strip the spaces out of Value_String to make it valid for
   -- INTEGER'image(Value_String).
   --
   Strip_Spaces (Value_String);

   --
   -- Assign to Return_String our stripped Value_String
   --
   Return_String := Value_String;

exception

   when OTHERS =>
      Text_IO.Put_Line ("Error converting binary integer to STRING in"
	& "procedure Utilities.Binary_To_String.");
      Return_String := (OTHERS => ASCII.NUL);

end Binary_To_String;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/08/94   D. Forrest
--      - Initial version
--
-- --

