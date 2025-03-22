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
-- UNIT NAME:          Install_Active_Help
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 25, 1994
--
-- PURPOSE:
--   This procedure installs active help for the specified widget.
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
procedure Install_Active_Help(
   Parent                      : in out Xt.WIDGET;
   Help_Text_Widget            : in out Xt.WIDGET;
   Help_Text_Message           : in     STRING) is

   Arglist          : Xt.ArgList (1..9);  -- X argument list
   Argcount         : Xt.Int := 0;        -- number of arguments

   function ADDRESS_To_XtPOINTER
     is new Unchecked_Conversion (System.ADDRESS, Xt.POINTER);

begin

   --
   -- Put the help string pointer into the Parent widget's UserData field.
   --
   Argcount := 0;
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NuserData, Help_Text_Widget);
   Xt.SetValues (Parent, Arglist, Argcount);

   --
   -- Add the event handler which display the help message upon entering 
   -- the widget's window.
   --
   Xt.AddEventHandler (
     W           => Parent,
     Event_Mask  => Xlib.EnterWindowMask,
     Nonmaskable => False,
     Proc        => Motif_Utilities.Update_Help_Field_EH'address,
     Client_Data => ADDRESS_To_XtPOINTER(Help_Text_Message'address));

   --
   -- Add the event handler which clear the help message upon leaving 
   -- the widget's window.
   --
   Xt.AddEventHandler (
     W           => Parent,
     Event_Mask  => Xlib.LeaveWindowMask,
     Nonmaskable => False,
     Proc        => Motif_Utilities.Update_Help_Field_EH'address,
     Client_Data => Xt.XNULL);

end Install_Active_Help;


----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/25/94   D. Forrest
--      - Initial version
--
-- --

