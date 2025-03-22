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
with Unchecked_Conversion;
with Xlib;
with Xm;
with Xmdef;
with Xtdef;
with Xt;

separate (Motif_Utilities)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Get_Integer_From_Text_Widget
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   July 26, 1994
--
-- PURPOSE:
--   This procedure returns the integer equivalent of the text
--   contained in the passed text widget, via the passed 
--   parameter Return_Value. A BOOLEAN True is returned in Success
--   if the procedure can extract an integer, and False is returned
--   if it fails (i.e. the text widget in null, empty, or contains
--   an invalid integer string.
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
procedure Get_Integer_From_Text_Widget(
   Text_Widget  : in     Xt.WIDGET;
   Return_Value :    out INTEGER;
   Success      :    out BOOLEAN) is

   Text               : Xm.STRING_PTR := NULL;
   Interim_Integer    : INTEGER       := 0;
   Interim_Success    : BOOLEAN       := TRUE;

   WRONG_WIDGET_CLASS : EXCEPTION;

   function XmSTRING_PTR_To_XtPOINTER
     is new Unchecked_Conversion (Xm.STRING_PTR, Xt.POINTER);

begin

   --
   -- Get the text length and contents of the specified Text widget.
   --
   if (not Xt."="(Text_Widget, Xt.XNULL)) then

      if (Xm.IsTextField(Text_Widget)) then
         Text := Xm.TextFieldGetString (Text_Widget);
      elsif (Xm.IsText(Text_Widget)) then
         Text := Xm.TextGetString (Text_Widget);
      else
         raise WRONG_WIDGET_CLASS;
      end if;

      Utilities.Get_Integer_From_Text (
         Text_String  => Text.all,
         Return_Value => Interim_Integer,
         Success      => Interim_Success);

      --
      -- Don't free this (as you normally would), because Verdix Ada
      -- corrupts memory when you do...
      --
      --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Text));

   else

      Interim_Integer := 0;
      Interim_Success := FALSE;

   end if;
   
   Return_Value := Interim_Integer;
   Success      := Interim_Success;

exception

   when WRONG_WIDGET_CLASS =>
      Return_Value := 0;
      Success      := False;

   when OTHERS =>
      Return_Value := 0;
      Success      := False;

end Get_Integer_From_Text_Widget;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   07/26/94   D. Forrest
--      - Initial version
--
-- --

