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
with Xlib;
with XlibR5;
with Xm;
with Xmdef;
with Xtdef;
with Xt;
with XtR5;

separate (Motif_Utilities)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Install_Text_Restrictions_With_Integer_Range
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   July 15, 1994
--
-- PURPOSE:
--   This callback function restrict the passed text widget to only accept as
--   valid input text matching the passed criteria.
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
procedure Install_Text_Restrictions_With_Integer_Range(
   Parent           : in     Xt.WIDGET;
   Text_Type        : in     Motif_Utilities.TEXT_RESTRICTION_ENUM;
   Characters_Count : in     INTEGER;
   Minimum_Integer  : in     INTEGER;
   Maximum_Integer  : in     INTEGER) is

   --
   -- Local Variable Declarations
   --
   Text_Restrictions_Ptr : Motif_Utilities.ATEXT_RESTRICTION_RECORD;

   --
   -- Renamed functions
   --
   function "=" (left, right: Xt.Widget)
     return BOOLEAN renames Xt."=";

begin

   --
   -- Extract the help string from the parent widget.
   --
   if (Parent /= Xt.XNULL) then

      Text_Restrictions_Ptr := new Motif_Utilities.TEXT_RESTRICTION_RECORD (
	Text_Type_Enum => Text_Type);
      Text_Restrictions_Ptr.Characters_Count := Characters_Count;
      case Text_Type is
	 when TEXT_NUMERIC_INTEGER 
	    | TEXT_NUMERIC_INTEGER_POSITIVE
	    | TEXT_NUMERIC_INTEGER_NONNEGATIVE =>
	      Text_Restrictions_Ptr.Minimum_Valid_Integer := Minimum_Integer;
	      Text_Restrictions_Ptr.Maximum_Valid_Integer := Maximum_Integer;
	 when TEXT_NUMERIC_FLOAT 
	    | TEXT_NUMERIC_FLOAT_POSITIVE
	    | TEXT_NUMERIC_FLOAT_NONNEGATIVE =>
	      Text_Restrictions_Ptr.Minimum_Valid_Float
		:= FLOAT(Minimum_Integer);
	      Text_Restrictions_Ptr.Maximum_Valid_Float
		:= FLOAT(Maximum_Integer);
         when OTHERS =>
            Text_Restrictions_Ptr.Minimum_Valid_Integer := Minimum_Integer;
            Text_Restrictions_Ptr.Maximum_Valid_Integer := Maximum_Integer;
      end case;

      Xt.AddCallback (Parent, Xmdef.NmodifyVerifyCallback,
        Motif_Utilities.Text_Restrict_CB'address, 
	Motif_Utilities.ATEXT_RESTRICTION_RECORD_to_XtPOINTER (
	  Text_Restrictions_Ptr));

   end if;

end Install_Text_Restrictions_With_Integer_Range;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   07/15/94   D. Forrest
--      - Initial version
--
-- --

