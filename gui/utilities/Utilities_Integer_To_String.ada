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
-- UNIT NAME:          Integer_To_String
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 2, 1994
--
-- PURPOSE:
--   This procedure converts the passed INTEGER into its string
--   equivalent, returning it in the passed STRING parameter.
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
procedure Integer_To_String(
   Integer_Value : in     INTEGER;
   Return_String :    out STRING) is

   package Integer_IO is
     new Text_IO.Integer_IO(INTEGER);

   Value_String : STRING(Return_String'range) := (OTHERS => ASCII.NUL);

begin

   --
   -- Convert the integer into it's Ada STRING equivalent
   --
   Integer_IO.Put(
     TO   => Value_String,
     ITEM => Integer_Value,
     BASE => 10);

   --
   -- String the spaces out of Value_String to make it valid for
   -- INTEGER'image(Value_String).
   --
   Strip_Spaces (Value_String);

   --
   -- Assign to Return_String our stripped Value_String
   --
   Return_String := Value_String;

exception

   when OTHERS =>
      Text_IO.Put_Line ("Error converting INTEGER to STRING in"
	& "procedure Utilities.Integer_To_String.");
      Return_String := (OTHERS => ASCII.NUL);

end Integer_To_String;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/02/94   D. Forrest
--      - Initial version
--
-- --

