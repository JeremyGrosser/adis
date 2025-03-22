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
with XDG_Client_Types;
with Xt;
with Xtdef;

separate (XDG_Client)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Create_Error_Notices_Window_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 15, 1994
--
-- PURPOSE:
--   This procedure displays the Error Notices window, which updates in
--   real-time, displaying Errors (with the time of their occurrence) as
--   they occur.
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
procedure Create_Error_Notices_Window_CB (
   Parent      : in     Xt.WIDGET;
   XDG_Data    : in out XDG_Client_Types.XDG_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is
   
   --
   -- Constant Declarations
   --
   K_Welcome_Message: constant STRING  :=
     "Welcome to the XDG Client Error Notices Monitor";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string
   K_Title          : constant STRING  := "XDG Client Error Notices Monitor";
   K_Widget_Offset  : constant INTEGER := 10;
   K_Error_Notices_Text_Rows    : constant INTEGER := 10;
   K_Error_Notices_Text_Columns : constant INTEGER := 80;

   --
   -- Create the constant help strings
   --
   K_Error_Notices_Help_String : constant STRING :=
     "This is a list of DG Client errors as they occur.";

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

   --
   -- Control Area Widgets
   --
   Close_Window_Button : Xt.WIDGET;   -- Cancel button widget
   Help_Label          : Xt.WIDGET;   -- Help Label

   --
   -- Work Area Widgets
   --
   -- none

   --
   -- Renamed functions
   --
   function "=" (left, right: Xt.WIDGET)
     return BOOLEAN renames Xt."=";

   function "=" (left, right: XDG_Client_Types.
     XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR)
       return BOOLEAN renames XDG_Client_Types."=";

   --
   -- Instantiated functions
   --
   function XDG_DATA_REC_PTR_to_Integer
     is new Unchecked_Conversion (
       Source => XDG_Client_Types.XDG_DATA_REC_PTR,
       Target => INTEGER);

   function XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR_to_INTEGER
     is new Unchecked_Conversion (
       Source => XDG_Client_Types.XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR,
       Target => INTEGER);

begin

   --
   -- Redisplay window if it already exists.
   --
   if ((XDG_Data.Error_Notices_Data /= NULL) and then 
     (XDG_Data.Error_Notices_Data.Shell /= Xt.XNULL)) then

      Xt.ManageChild (XDG_Data.Error_Notices_Data.Shell);
      Xt.Popup (XDG_Data.Error_Notices_Data.Shell, Xt.GrabNone);
      Xlib.MapRaised (
	Xt.GetDisplay (XDG_Data.Error_Notices_Data.Shell), 
	Xt.GetWindow  (XDG_Data.Error_Notices_Data.Shell));
      
   --
   -- Create and display the window.
   --
   else

      --
      -- Allocate Error_Notices_Data
      --
      XDG_Data.Error_Notices_Data
	:= new XDG_Client_Types.XDG_ERROR_NOTICES_MONITOR_DATA_REC'(
	  Shell                       => Xt.XNULL,
	  Title                       => Xt.XNULL,
	  Description                 => Xt.XNULL,

	  Error_Notices_Text          => Xt.XNULL,
	  
	  Error_Notices_Count         => 0);

      --
      -- Create the shell
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Ntitle, K_Title);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nwidth,
	XDG_Client.K_Error_Notices_Window_Width);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nheight,
	XDG_Client.K_Error_Notices_Window_Height);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NdeleteResponse, 
	INTEGER(Xm.DO_NOTHING));
      XDG_Data.Error_Notices_Data.Shell := Xt.CreatePopupShell (K_Title,
	Xt.topLevelShellWidgetClass, Motif_Utilities.Get_Topshell (Parent),
	Arglist, Argcount);

      --
      -- Add our close callback as the default delete window callback
      --
      WM_Delete_Window := Xm.InternAtom (Xt.GetDisplay (
	XDG_Data.Error_Notices_Data.Shell), "WM_DELETE_WINDOW", False);
      Xm.AddWMProtocolCallback (XDG_Data.Error_Notices_Data.Shell,
	WM_Delete_Window, XDG_Client.Close_Window_CB'address,
	XDG_Data.Error_Notices_Data.Shell);

      --
      -- Create the basic window form
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginWidth,  INTEGER(2));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginHeight, INTEGER(2));
      Main_Form := Xt.CreateManagedWidget ("Main_Form", Xm.FormWidgetClass,
	XDG_Data.Error_Notices_Data.Shell, Arglist, Argcount);

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
      Close_Window_Button := Motif_Utilities.Create_Pushbutton (Control_Form, 
	" Close Window ");
      Xt.SetValues (Close_Window_Button, Arglist, Argcount);
      Xt.AddCallback (Close_Window_Button, Xmdef.NactivateCallback, 
	XDG_Client.Close_Window_CB'address, 
	  XDG_Data.Error_Notices_Data.Shell);

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
      -- Create the Description help label
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
      Help_Label := Xt.CreateManagedWidget (
        "Help_Label", Xm.LabelWidgetClass, Description_Form,
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
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget, Help_Label);
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
      XDG_Data.Error_Notices_Data.Description := Xt.CreateManagedWidget (
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


      -- --------------------------
      -- Create the work area widgets
      -- --------------------------

      --
      -- Initialize Error Notices character and line counts.
      --
      XDG_Client.Error_Notices_Text_Position          := Xm.TEXTPOSITION(0);
      XDG_Data.Error_Notices_Data.Error_Notices_Count := 0;

      --
      -- Create the Error Notices text widget.
      --
      Argcount := 0;
      XDG_Data.Error_Notices_Data.Error_Notices_Text  :=
	Xm.CreateScrolledText (Work_Form, "Error_Notices_Text",
	  Arglist, Argcount);

      --
      -- Set up the ScrolledText parent resources.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment, 
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopOffset, K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment, 
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment, 
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset, K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment, 
	INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, K_Widget_Offset);

      Xt.SetValues (Xt.Parent(XDG_Data.Error_Notices_Data.Error_Notices_Text),
	Arglist, Argcount);

      --
      -- Set up the ScrolledText resources.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nrows, K_Error_Notices_Text_Rows);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Ncolumns,
	K_Error_Notices_Text_Columns);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Neditable, FALSE);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NeditMode, 
	INTEGER(Xm.MULTI_LINE_EDIT));
      Argcount := Argcount + 1;
--      Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, FALSE);
--      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NwordWrap, FALSE);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NscrollHorizontal, TRUE);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NblinkRate, INTEGER(0));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NautoShowCursorPosition, TRUE);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NcursorPositionVisible, FALSE);

      Xt.SetValues (XDG_Data.Error_Notices_Data.Error_Notices_Text,
	Arglist, Argcount);

      --
      -- Install ActiveHelp
      --
      Motif_Utilities.Install_Active_Help (
	Parent             => XDG_Data.Error_Notices_Data.Error_Notices_Text,
	Help_Text_Widget   => XDG_Data.Error_Notices_Data.Description,
	Help_Text_Message  => K_Error_Notices_Help_String);

      --
      -- Install the TimeProc to update the Error Notices window
      --
      Update_Error_Notices (XDG_Data.Error_Notices_Data);


      --
      -- Manage and display window
      --
      Xt.ManageChild (XDG_Data.Error_Notices_Data.Error_Notices_Text);
      Xt.ManageChild (XDG_Data.Error_Notices_Data.Shell);
      Xt.Popup (XDG_Data.Error_Notices_Data.Shell, Xt.GrabNone);

   end if;

end Create_Error_Notices_Window_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/15/94   D. Forrest
--      - Initial version
--
-- --

