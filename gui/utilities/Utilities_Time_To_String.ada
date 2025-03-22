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

with Calendar;
with Text_IO;

separate (Utilities)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Time_To_String
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--                     based on code by Brett Dufault ((J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   July 22, 1994
--
-- PURPOSE:
--   This procedure converts a variable of type Calendar.TIME into
--   its STRING equivalent, with the hours, minutes, and seconds
--   padded with zeroes.
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
function Time_To_String(
   Time  : in     Calendar.TIME) return STRING is

   Time_Hours   : INTEGER;
   Time_Minutes : INTEGER;
   Time_Seconds : INTEGER;
   Time_String  : STRING(1..8) := "HH:MM:SS";

begin

   --
   -- Grab hours, minutes, and seconds out of the Time record.
   --
   Time_Seconds := INTEGER(Calendar.Seconds(Time));
   Time_Hours   := Time_Seconds / (60 * 60);
   Time_Seconds := Time_Seconds - (Time_Hours * 60 * 60);
   Time_Minutes := Time_Seconds / 60;
   Time_Seconds := Time_Seconds - (Time_Minutes * 60);

   --
   -- Build time string
   --
   BUILD_TIME_STRING_BLOCK:
   declare
      K_Hours_String   : constant STRING := INTEGER'image(Time_Hours);
      K_Minutes_String : constant STRING := INTEGER'image(Time_Minutes);
      K_Seconds_String : constant STRING := INTEGER'image(Time_Seconds);
   begin

      --
      -- Build the hours substring of the time string.
      --
      if (Time_Hours < 10) then
	 Time_String(1..1) := "0";
	 Time_String(2..2) := K_Hours_String (
	   K_Hours_String'first+1..K_Hours_String'first+1);
      else
	 Time_String(1..2) := K_Hours_String (
	   K_Hours_String'first+1..K_Hours_String'first+2);
      end if;

      --
      -- Build the minutes substring of the time string.
      --
      if (Time_Minutes < 10) then
	 Time_String(4..4) := "0";
	 Time_String(5..5) := K_Minutes_String (
	   K_Minutes_String'first+1..K_Minutes_String'first+1);
      else
	 Time_String(4..5) := K_Minutes_String (
	   K_Minutes_String'first+1..K_Minutes_String'first+2);
      end if;

      --
      -- Build the seconds substring of the time string.
      --
      if (Time_Seconds < 10) then
	 Time_String(7..7) := "0";
	 Time_String(8..8) := K_Seconds_String (
	   K_Seconds_String'first+1..K_Seconds_String'first+1);
      else
	 Time_String(7..8) := K_Seconds_String (
	   K_Seconds_String'first+1..K_Seconds_String'first+2);
      end if;

   end BUILD_TIME_STRING_BLOCK;

   return Time_String;

exception

   when OTHERS =>
      Text_IO.Put_Line ("Unknown exception raised in "
	& "Utilities.Time_To_String; Time_String is `" 
	  & Time_String & "'.");
      return Time_String;

end Time_To_String;

