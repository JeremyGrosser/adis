
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
-- UNIT NAME:          Update_Help_Field_EH
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 25, 1994
--
-- PURPOSE:
--   This procedure updates the text widget passed into Help_Text_Widget
--   with the string held in the User_Data field of the callback's
--   parent widget.
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
procedure Update_Help_Field_EH(
   Parent                      : in     Xt.WIDGET;
   Help_Text_String            : in out Xt.POINTER;
   Event                       : in out Xlib.EVENT;
   Continue_To_Dispatch_Return : in out BOOLEAN) is

   --
   -- Constant Declarations
   --
   K_Arglist_Max     : constant INTEGER := 9;   -- Max aruments per arglist

   --
   -- Type Declarations
   --

   --
   -- Miscellaneous declarations
   --
   Arglist          : Xt.ArgList (1..K_Arglist_Max);  -- X argument list
   Argcount         : Xt.Int := 0;                    -- number of arguments
   Help_Text_Widget : Xt.WIDGET;
   Blank_String     : constant STRING(1..256) := (others => ' ');

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

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData, Help_Text_Widget'address);
      Xt.GetValues (Parent, Arglist, Argcount);

   end if;

   --
   -- Set the help text widget to display the help string.
   --
   if (Help_Text_Widget /= Xt.XNULL) then
      
      if (Help_Text_String /= Xt.XNULL) then
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, Help_Text_String);
         Xt.SetValues (Help_Text_Widget, Arglist, Argcount);
      else
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, Blank_String);
         Xt.SetValues (Help_Text_Widget, Arglist, Argcount);
      end if;

   end if;

end Update_Help_Field_EH;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/25/94   D. Forrest
--      - Initial version
--
-- --

