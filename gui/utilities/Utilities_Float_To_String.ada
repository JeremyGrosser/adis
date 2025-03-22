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
-- UNIT NAME:          Float_To_String
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 2, 1994
--
-- PURPOSE:
--   This procedure converts the passed FLOAT into its string
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
procedure Float_To_String(
   Float_Value   : in     FLOAT;
   Return_String :    out STRING) is

   package Float_IO is
     new Text_IO.Float_IO(FLOAT);

   Value_String : STRING(Return_String'range) := (OTHERS => ASCII.NUL);

begin

   --
   -- Convert the integer into it's Ada STRING equivalent
   --
   Float_IO.Put(
     TO   => Value_String,
     ITEM => Float_Value,
     AFT  => 5,
     EXP  => 0);

   --
   -- String the spaces out of Value_String to make it valid for
   -- Float_IO.Get().
   --
   Strip_Spaces (Value_String);

   --
   -- Assign to Return_String our stripped Value_String
   --
   Return_String := Value_String;

exception

   when OTHERS =>
      Text_IO.Put_Line("Error converting FLOAT to STRING in"
	& "procedure Utilities.Float_To_String.");

      Return_String := (OTHERS => ASCII.NUL);

end Float_To_String;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/02/94   D. Forrest
--      - Initial version
--
-- --

