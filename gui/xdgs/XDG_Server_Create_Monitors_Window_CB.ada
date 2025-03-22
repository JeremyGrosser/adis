--                          U N C L A S S I F I E D
--
--  *=====================================================================*
--  |                                                                     |
--  |                       Manned Flight Simulator                       |
--  |              Naval Air Warfar Center Aircraft Division              |
--  |                      Patuxent River, Maryland                       |
--  |                                                                     |
--  *=====================================================================*
--

with Motif_Utilities;
with Text_IO;
with Unchecked_Conversion;
with Xlib;
with Xm;
with Xmdef;
with XDG_Server_Types;
with Xt;
with Xtdef;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Create_Monitors_Window_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 6, 1994
--
-- PURPOSE:
--   This procedure creates the XDG Server Monitors window.
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
procedure Create_Monitors_Window_CB (
   Parent      : in     Xt.WIDGET;
   XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is
   
   --
   -- Constant Declarations
   --
   K_Welcome_Message: constant STRING  :=
     "Welcome to the XDG Server Monitors Display";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string
   K_Title          : constant STRING  := "XDG Server Monitors";

   --
   -- Window Manager related declarations
   --
   Trans_Table      : Xt.TRANSLATIONS;  -- X translation table
   WM_Delete_Window : Xlib.ATOM;        -- X window manager atom

   --
   -- Miscellaneous declarations
   --
   Arglist          : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount         : Xt.INT := 0;                    -- number of arguments
   Temp_String      : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString    : Xm.XMSTRING;                    -- Temporary X string

   --
   -- Main Window widgets
   --
   Main_Form        : Xt.WIDGET;   -- Main window form
   Work_Form        : Xt.WIDGET;   -- Work area form widget
   Main_Separator_1 : Xt.WIDGET;   -- Work/Description Area separator
   Description_Form : Xt.WIDGET;   -- Description area form widget
   Main_Separator_2 : Xt.WIDGET;   -- Description/Control Area separator
   Control_Form     : Xt.WIDGET;   -- Control area form widget
   Help_Icon_Label  : Xt.WIDGET;   -- Icon label for help text field


   --
   -- Control Area Widgets
   --
   Cancel_Button    : Xt.WIDGET;   -- Cancel button widget

   --
   -- Work Area Widgets
   --
   Parameter_Selection_Scrolled_Window : Xt.WIDGET;
      Parameter_Selection_Rowcolumn    : Xt.WIDGET;
         Entities_Button               : Xt.WIDGET;
         Gateway_Button                : Xt.WIDGET;
         Errors_Button                 : Xt.WIDGET;
   Parameter_Separator                 : Xt.WIDGET;
   Parameter_Settings_Scrolled_Window  : Xt.WIDGET;

   --
   -- Renamed functions
   --
   function "=" (left, right: Xt.WIDGET)
     return BOOLEAN renames Xt."=";

   function "=" (left, right: XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR)
     return BOOLEAN renames XDG_Server_Types."=";

   function XDG_DATA_REC_PTR_to_Integer is new 
     Unchecked_Conversion (Source => XDG_Server_Types.XDG_DATA_REC_PTR,
                           Target => INTEGER);
   function XDG_MONITORS_DATA_REC_PTR_to_Integer is new 
     Unchecked_Conversion (Source => XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR,
                           Target => INTEGER);

begin

   --
   -- Redisplay window if it already exists.
   --
   if ((XDG_Data.Monitors_Data /= NULL) and then 
     (XDG_Data.Monitors_Data.Shell /= Xt.XNULL)) then

      Xt.ManageChild (XDG_Data.Monitors_Data.Shell);
      Xt.Popup (XDG_Data.Monitors_Data.Shell, Xt.GrabNone);
      Xlib.MapRaised (
	Xt.GetDisplay (XDG_Data.Monitors_Data.Shell), 
	Xt.GetWindow  (XDG_Data.Monitors_Data.Shell));
      
   --
   -- Create and display the window.
   --
   else

      --
      -- Allocate Monitors_Data
      --
      XDG_Data.Monitors_Data := new XDG_Server_Types.XDG_MONITORS_DATA_REC'(
	Shell                        => Xt.XNULL,
	Title                        => Xt.XNULL,
	Description                  => Xt.XNULL,

	Parameter_Scrolled_Window    => Xt.XNULL,
	Parameter_Active_Hierarchy   => Xt.XNULL,

	Entities                     => (
	   Shell                         => Xt.XNULL,
	   Entities_List                 => Xt.XNULL),
	Gateway                      => (
	   Shell                         => Xt.XNULL,
	   Number_Of_Clients             => Xt.XNULL,
	   Number_Of_Local_Entities      => Xt.XNULL),
	Error_History                => NULL);
      XDG_Data.Monitors_Data.Error_History := new
	XDG_Server_Types.XDG_MON_ERROR_HISTORY_DATA_REC'(
	   Shell                         => Xt.XNULL,
	   Error_History_Scrolled_Window => Xt.XNULL,
	   Error_History_Form            => Xt.XNULL,
	   Error_History_Time_RC         => Xt.XNULL,
	   Error_History_Occurrences_RC  => Xt.XNULL,
	   Error_History_Message_RC      => Xt.XNULL,
	   History                       => ( OTHERS => (
	      Time                           => Xt.XNULL,
	      Occurrences                    => Xt.XNULL,
	      Message                        => Xt.XNULL)));

      --
      -- Create the shell
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Ntitle, K_Title);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nwidth,
	XDG_Server.K_Monitors_Window_Width);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nheight,
	XDG_Server.K_Monitors_Window_Height);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NdeleteResponse, 
	INTEGER(Xm.DO_NOTHING));
      XDG_Data.Monitors_Data.Shell := Xt.CreatePopupShell (K_Title,
	Xt.topLevelShellWidgetClass, Motif_Utilities.Get_Topshell (Parent),
	Arglist, Argcount);

      --
      -- Add our close callback as the default delete window callback
      --
      WM_Delete_Window := Xm.InternAtom (Xt.GetDisplay (
	XDG_Data.Monitors_Data.Shell), "WM_DELETE_WINDOW", False);
      Xm.AddWMProtocolCallback (XDG_Data.Monitors_Data.Shell,
	WM_Delete_Window, XDG_Server.Close_Window_CB'address,
	XDG_Data.Monitors_Data.Shell);

      --
      -- Create the basic window form
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginWidth,  INTEGER(2));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginHeight, INTEGER(2));
      Main_Form := Xt.CreateManagedWidget ("Main_Form", Xm.FormWidgetClass,
	XDG_Data.Monitors_Data.Shell, Arglist, Argcount);

      -- --------------------
      -- Create Control Area (OK, Cancel, Save, Restore, etc... functions)
      -- --------------------

      --
      -- Create the control form widget.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Control_Form := Xt.CreateManagedWidget ("Control_Form",
        Xm.FormWidgetClass, Main_Form, Arglist, Argcount);

      --
      -- Create Cancel Button (which simply closes window)
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, 
        Motif_Utilities.Widget_Separation);
      Cancel_Button := Motif_Utilities.Create_Pushbutton (Control_Form, 
	" Cancel ");
      Xt.SetValues (Cancel_Button, Arglist, Argcount);
      Xt.AddCallback (Cancel_Button, Xmdef.NactivateCallback, 
	  XDG_Server.Close_Window_CB'address, XDG_Data.Monitors_Data.Shell);

      --
      -- Create the first Main_Form separator widget.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomWidget, Control_Form);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, 
        Motif_Utilities.Widget_Separation);
      Main_Separator_1 := Xt.CreateManagedWidget ("Main_Separator_1",
        Xm.SeparatorWidgetClass, Main_Form, Arglist, Argcount);


      -- --------------------
      -- Create Description Area
      -- --------------------

      --
      -- Create the description form widget.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomWidget, Main_Separator_1);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Description_Form := Xt.CreateManagedWidget ("Description_Form",
        Xm.FormWidgetClass, Main_Form, Arglist, Argcount);

      --
      -- Create the Description help icon label
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Temp_XmString := Xm.StringCreateLtoR ("Help:",
        Xm.STRING_DEFAULT_CHARSET);
      Xt.SetArg (Arglist (Argcount), Xmdef.Nlabelstring, Temp_XmString);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset,
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset,
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_NONE));
      Help_Icon_Label := Xt.CreateManagedWidget (
        "Help_Icon_Label", Xm.LabelWidgetClass, Description_Form,
        Arglist, Argcount);
      Xm.StringFree (Temp_XmString);

      --
      -- Create the Description help text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, K_Welcome_Message);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NshadowThickness, INTEGER(1));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NcursorPositionVisible, False);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Neditable, False);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, True);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget, Help_Icon_Label);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, 
        Motif_Utilities.Widget_Separation);
      XDG_Data.Monitors_Data.Description := Xt.CreateManagedWidget (
	"Description", Xm.TextFieldWidgetClass, Description_Form,
	Arglist, Argcount);

      --
      -- Create the second Main_Form separator widget.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomWidget, Description_Form);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, 
        Motif_Utilities.Widget_Separation);
      Main_Separator_2 := Xt.CreateManagedWidget ("Main_Separator_2",
        Xm.SeparatorWidgetClass, Main_Form, Arglist, Argcount);


      -- --------------------
      -- Create Work Area
      -- --------------------

      --
      -- Create the work form widget.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomWidget, Main_Separator_2);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Work_Form := Xt.CreateManagedWidget ("Work_Form",
        Xm.FormWidgetClass, Main_Form, Arglist, Argcount);

      --
      -- Create the Parameter Selection Scrolled Window
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NscrollBarDisplayPolicy,
        INTEGER(Xm.AS_NEEDED));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NscrollingPolicy,
        INTEGER(Xm.AUTOMATIC));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nwidth, INTEGER(200));
      Parameter_Selection_Scrolled_Window := Xm.CreateScrolledWindow (
        Work_Form, "Parameter_Selection_Scrolled_Window", Arglist, Argcount);
      Xt.ManageChild (Parameter_Selection_Scrolled_Window);

      --
      -- Create the Parameter Selection Rowcolumn
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginWidth, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginHeight, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nspacing,
	Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NentryAlignment, 
        INTEGER(Xm.ALIGNMENT_CENTER));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NisAligned, True);
      Parameter_Selection_Rowcolumn := Xt.CreateManagedWidget (
	"Parameter_Selection_Rowcolumn", Xm.RowColumnWidgetClass, 
	Parameter_Selection_Scrolled_Window, Arglist, Argcount);

      --
      -- Create the Set Parameters Buttons
      --
      --Entities_Button := Motif_Utilities.Create_Pushbutton (
      --  Parameter_Selection_Rowcolumn, " Entities ");
      --Xt.AddCallback (Entities_Button, Xmdef.NactivateCallback,
      --  XDG_Server.Create_Monitors_Panel_Entities'address, 
      --  XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR_to_XtPOINTER(
      --    XDG_Data.Monitors_Data));
--
--      Gateway_Button := Motif_Utilities.Create_Pushbutton (
--	Parameter_Selection_Rowcolumn, " Gateway " & ASCII.LF & " Monitor ");
--      Xt.AddCallback (Gateway_Button, Xmdef.NactivateCallback,
--	XDG_Server.Create_Monitors_Panel_Gateway'address, 
--        XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR_to_XtPOINTER(
--	  XDG_Data.Monitors_Data));

      Errors_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn, " Error " & ASCII.LF & " History ");
      Xt.AddCallback (Errors_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Monitors_Panel_Errors'address, 
        XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR_to_XtPOINTER(
	  XDG_Data.Monitors_Data));

      --
      -- Create the Parameter separator widget.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Norientation,
        INTEGER(Xm.VERTICAL));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget, 
	Parameter_Selection_Scrolled_Window);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, 
        Motif_Utilities.Widget_Separation);
      Parameter_Separator := Xt.CreateManagedWidget ("Parameter_Separator",
        Xm.SeparatorWidgetClass, Work_Form, Arglist, Argcount);

      --
      -- Create the Parameter Settings Scrolled Window Title widget
      --
      XDG_Data.Monitors_Data.Title := Motif_Utilities.Create_Label (
	Work_Form, K_Welcome_Message);
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget,
        Parameter_Separator);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_NONE));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, 
        Motif_Utilities.Widget_Separation);
      Xt.SetValues (XDG_Data.Monitors_Data.Title, Arglist, Argcount);

      --
      -- Create the Parameter Settings Scrolled Window
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NscrollBarDisplayPolicy,
        INTEGER(Xm.AS_NEEDED));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NscrollingPolicy,
        INTEGER(Xm.AUTOMATIC));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopWidget,
        XDG_Data.Monitors_Data.Title);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_WIDGET));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget,
        Parameter_Separator);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, 
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, 
        Motif_Utilities.Widget_Separation);
      XDG_Data.Monitors_Data.Parameter_Scrolled_Window :=
	Xm.CreateScrolledWindow (Work_Form, "Parameter_Scrolled_Window",
	  Arglist, Argcount);
      Xt.ManageChild (XDG_Data.Monitors_Data.Parameter_Scrolled_Window);

      --
      -- Manage and display window
      --
      Xt.ManageChild (XDG_Data.Monitors_Data.Shell);
      Xt.Popup (XDG_Data.Monitors_Data.Shell, Xt.GrabNone);

   end if;

end Create_Monitors_Window_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/02/94   D. Forrest
--      - Initial version
--
-- --

