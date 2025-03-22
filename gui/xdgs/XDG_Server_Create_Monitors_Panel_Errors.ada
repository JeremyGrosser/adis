--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--

with DG_Status;
with Motif_Utilities;
with Text_IO;
with Unchecked_Conversion;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Create_Monitors_Panel_Errors
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 6, 1994
--
-- PURPOSE:
--   This procedure displays the Set Parameters Panel 
--   under the passed widget hierarchy.
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
procedure Create_Monitors_Panel_Errors(
   Parent      : in     Xt.WIDGET;
   Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title       : constant STRING :=
     "XDG Server Error History Monitor";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string
   K_Widget_Offset  : constant INTEGER := 10;  -- Offset spacing 
					       --  between widgets.
   K_Time_Column_Title        : constant STRING := "Time";
   K_Occurrences_Column_Title : constant STRING := "#";
   K_Message_Column_Title     : constant STRING := "Error";

   --
   -- Create the constant help strings
   --
   K_Error_History_Help_String : constant STRING :=
     "This is a history of all DG errors for this run.";

   --
   -- Miscellaneous declarations
   --
   Arglist          : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount         : Xt.INT := 0;                    -- number of arguments
   Temp_String      : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString    : Xm.XMSTRING;                    -- Temporary X string

   --
   -- Local widget declarations
   --
   Main_Form                      : Xt.WIDGET;        -- Main window form
   Time_Column_Title_Label        : Xt.WIDGET;        -- Time Col. Title
   Occurrences_Column_Title_Label : Xt.WIDGET;        -- Occurrences Col. Title
   Message_Column_Title_Label     : Xt.WIDGET;        -- Message Col. Title
   Temp_Separator                 : Xt.WIDGET;        -- Temp. separator

   --
   -- Renamed functions
   --
   function "=" (left, right: Xt.WIDGET)
     return BOOLEAN renames Xt."=";
   function ASTRING_To_XtPOINTER
     is new Unchecked_Conversion (Utilities.ASTRING, Xt.POINTER);
   function XtWIDGET_To_INTEGER
     is new Unchecked_Conversion (Xt.WIDGET, INTEGER);
   function ASTRING_To_INTEGER
     is new Unchecked_Conversion (Utilities.ASTRING, INTEGER);

begin


   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Mon_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Mon_Data.Parameter_Active_Hierarchy);
   end if;

   --
   -- If the panel has already been allocated, remanage it.
   --
   if (Mon_Data.Error_History.Shell /= Xt.XNULL) then

      Xm.ScrolledWindowSetAreas (Mon_Data.Parameter_Scrolled_Window,
	Xt.XNULL, Xt.XNULL, Mon_Data.Error_History.Shell);
      Xt.ManageChild (Mon_Data.Error_History.Shell);

      --
      -- Begin/Resume updating of Error History updating
      --
      Update_Error_History (Mon_Data.Error_History);

   --
   -- If the panel has not already been allocated, allocate and manage it.
   --
   else -- (Mon_Data.Error_History.Shell = Xt.XNULL)

      --
      -- Create (Sub)root widget of the simulation parameter widget hierarchy
      -- (the main simulation parameter panel rowcolumn widget).
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginWidth,  INTEGER(2));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginHeight, INTEGER(2));
      Main_Form := Xt.CreateWidget ("Main_Form",
	Xm.FormWidgetClass, Mon_Data.Parameter_Scrolled_Window,
	Arglist, Argcount);
      Mon_Data.Error_History.Shell := Main_Form;

      --------------------------------------------------------------------
      --
      -- Create the error history widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the error history scrolled window
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset,       K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset,      K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset,    K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset,     K_Widget_Offset);
      Mon_Data.Error_History.Error_History_Scrolled_Window
	:= Xt.CreateManagedWidget ("Error_History_Scrolled_Window",
	  Xm.ScrolledWindowWidgetClass, Main_Form, 
	    Arglist, Argcount);

      --
      -- Create the error history form
      --
      Argcount := 0;
      Mon_Data.Error_History.Error_History_Form
	:= Xt.CreateManagedWidget ("Error_History_Form", Xm.FormWidgetClass,
	  Mon_Data.Error_History.Error_History_Scrolled_Window, 
	    Arglist, Argcount);

      --
      -- Create the error history time rowcolumn widget
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset,       K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset,      K_Widget_Offset);
      Mon_Data.Error_History.Error_History_Time_RC
	:= Xt.CreateManagedWidget ("Error_History_Time_RC",
	  Xm.RowColumnWidgetClass, Mon_Data.Error_History.Error_History_Form, 
	    Arglist, Argcount);

      --
      -- Create the error history occurrences rowcolumn widget
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset,       K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
	INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget,
	Mon_Data.Error_History.Error_History_Time_RC);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset,      K_Widget_Offset);
      Mon_Data.Error_History.Error_History_Occurrences_RC
	:= Xt.CreateManagedWidget ("Error_History_Occurrences_RC",
	  Xm.RowColumnWidgetClass, Mon_Data.Error_History.Error_History_Form, 
	    Arglist, Argcount);

      --
      -- Create the error history message rowcolumn widget
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset,       K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
	INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget,
	Mon_Data.Error_History.Error_History_Occurrences_RC);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset,      K_Widget_Offset);
      Mon_Data.Error_History.Error_History_Message_RC
	:= Xt.CreateManagedWidget ("Error_History_Message_RC",
	  Xm.RowColumnWidgetClass, Mon_Data.Error_History.Error_History_Form, 
	    Arglist, Argcount);

      --
      -- Create the Error History column title label widgets.
      --
      Time_Column_Title_Label := Motif_Utilities.Create_Label(
	Mon_Data.Error_History.Error_History_Time_RC,
	  K_Time_Column_Title);
      Occurrences_Column_Title_Label := Motif_Utilities.Create_Label(
	Mon_Data.Error_History.Error_History_Occurrences_RC,
	  K_Occurrences_Column_Title);
      Message_Column_Title_Label := Motif_Utilities.Create_Label(
	Mon_Data.Error_History.Error_History_Message_RC,
	  K_Message_Column_Title);

      --
      -- Create the error history column title label separators
      --
      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget (
	"Time_Column_Title_Separator", Xm.SeparatorGadgetClass,
	  Mon_Data.Error_History.Error_History_Time_RC,
	    Arglist, Argcount);
      Temp_Separator := Xt.CreateManagedWidget (
	"Occurrenaces_Column_Title_Separator", Xm.SeparatorGadgetClass,
	  Mon_Data.Error_History.Error_History_Occurrences_RC,
	    Arglist, Argcount);
      Temp_Separator := Xt.CreateManagedWidget (
	"Message_Column_Title_Separator", Xm.SeparatorGadgetClass,
	  Mon_Data.Error_History.Error_History_Message_RC,
	    Arglist, Argcount);

      --
      -- Build the Error History entry label widgets.
      --
      BUILD_ERROR_HISTORY_ENTRIES:
      declare
	 --
	 -- Allocate a new X String to hold the default label string.
	 --
	 Xmstring : Xm.XMSTRING := Xm.StringCreateSimple ("");
      begin
	 --
	 -- Build the default Arglist for the Error History entry widgets.
	 --
	 Argcount := 0;
	 Argcount := Argcount + 1;
	 Xt.SetArg (Arglist (Argcount), Xmdef.NLabelString,
	   Xt.POINTER(Xmstring));

	 --
	 -- Create the Error History entry widgets.
	 --
	 for Index in DG_Status.STATUS_TYPE loop
	    Mon_Data.Error_History.History(Index).Time
	      := Xt.CreateWidget ("Time", Xm.LabelWidgetClass, 
		Mon_Data.Error_History.Error_History_Time_RC,
		  Arglist, Argcount);
	    Mon_Data.Error_History.History(Index).Occurrences
	      := Xt.CreateWidget ("Occurrences", Xm.LabelWidgetClass, 
		Mon_Data.Error_History.Error_History_Occurrences_RC,
		  Arglist, Argcount);
	    Mon_Data.Error_History.History(Index).Message
	      := Xt.CreateWidget ("Message", Xm.LabelWidgetClass, 
		Mon_Data.Error_History.Error_History_Message_RC,
		  Arglist, Argcount);
	 end loop;

	 --
	 -- Free the Label X string.
	 --
	 Xm.StringFree (Xmstring);

      end BUILD_ERROR_HISTORY_ENTRIES;

      --
      -- Install ActiveHelp
      --
      Motif_Utilities.Install_Active_Help (
	Parent            => Mon_Data.Error_History.
			       Error_History_Scrolled_Window,
	Help_Text_Widget  => Mon_Data.Description,
	Help_Text_Message => K_Error_History_Help_String);


   end if; -- (Mon_Data.Error_History.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Mon_Data.Title, K_Panel_Title);
   Xt.ManageChild (Mon_Data.Error_History.Shell);
   Mon_Data.Parameter_Active_Hierarchy := Mon_Data.Error_History.Shell;

   --
   -- Begin updating of Error History updating
   --
   Update_Error_History (Mon_Data.Error_History);

end Create_Monitors_Panel_Errors;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/06/94   D. Forrest
--      - Initial version
--
-- --

