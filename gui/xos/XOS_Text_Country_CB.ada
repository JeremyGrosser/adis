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

with DIS_Types;
with Motif_Utilities;
with Text_IO;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Text_Country_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 11, 1994
--
-- PURPOSE:
--   This procedure reads the integer out of the parent textfield widget and
--   places the equivalent country name (from DIS_Types.A_COUNTRY_ID) into
--   the label widget whose widget ID is passed in as the client data.
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
procedure Text_Country_CB (
   Parent        : in     Xt.WIDGET;
   Country_Label : in out Xt.WIDGET;
   Call_Data     :    out Xm.ANYCALLBACKSTRUCT_PTR) is

   Country_String  : Xm.STRING_PTR := NULL;
   Country_Integer : INTEGER
     := DIS_Types.A_COUNTRY_ID'pos (DIS_Types.A_COUNTRY_ID'first);
   Country         : DIS_Types.A_COUNTRY_ID
     := DIS_Types.A_COUNTRY_ID'val(Country_Integer);

   Success : BOOLEAN;

   Get_Integer_From_Text_Failed : EXCEPTION;

   function XmSTRING_PTR_To_XtPOINTER
     is new Unchecked_Conversion (Xm.STRING_PTR, Xt.POINTER);
begin

   if ((not Xt."="(Parent, Xt.XNULL))
     and (not Xt."="(Country_Label, Xt.XNULL))) then

      --
      -- Extract country integer string from country textfield widget
      -- and convert it into it's INTEGER equivalent. Then convert
      -- this INTEGER equivalent into the actual DIS_Types.A_COUNTRY_ID
      -- enumeration.
      --
      Country_String := Xm.TextFieldGetString (Parent);
      Utilities.Get_Integer_From_Text (
	Text_String  => Country_String.all,
	Return_Value => Country_Integer,
	Success      => Success);
      if (Success) then
         Country := DIS_Types.A_COUNTRY_ID'val(Country_Integer);
      else
	 raise Get_Integer_From_Text_Failed;
      end if;

      --
      -- Put the country name into Country_Label.
      --
      Motif_Utilities.Set_Labelstring (Country_Label, 
	DIS_Types.A_COUNTRY_ID'image(Country));

      --
      -- Free the memory pointed to by Country_String which was
      -- allocated by the X/Motif call Xm.TextfieldGetString().
      --
      -- Don't free this (as you normally would), because Verdix Ada
      -- corrupts memory when you do...
      --
      --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Country_String));

   end if;

exception

   --
   -- Handle Get_Integer_From_Text_Failed exception...
   --
   when Get_Integer_From_Text_Failed =>
      Motif_Utilities.Set_Labelstring (Country_Label, "BAD INTEGER");

   --
   -- Handle OTHERS exceptions...
   --
   when OTHERS =>
      Motif_Utilities.Set_Labelstring (Country_Label, "UNKNOWN");

end Text_Country_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/11/94   D. Forrest
--      - Initial version
--
-- --

