--
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
with Mrm;
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
-- UNIT NAME:          Create_Set_Parms_Window_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 6, 1994
--
-- PURPOSE:
--   This procedure displays the XDG_Server window which allows the user to
--   set all of the DIS Gateway parameters.
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
procedure Create_Set_Parms_Window_CB (
   Parent      : in     Xt.WIDGET;
   XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is
   
   --
   -- Constant Declarations
   --
   K_Welcome_Message: constant STRING  :=
     "Welcome to the XDG Server Parameters Input Display.";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string
   K_Title          : constant STRING  := "XDG Server Set Parameters";

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
   Main_Form         : Xt.WIDGET;   -- Main window form
   Work_Form         : Xt.WIDGET;   -- Work area form widget
   Main_Separator_1  : Xt.WIDGET;   -- Work/Description Area separator
   Description_Form  : Xt.WIDGET;   -- Description area form widget
   Main_Separator_2  : Xt.WIDGET;   -- Description/Control Area separator
   Control_Form      : Xt.WIDGET;   -- Control area form widget
   Description_Label : Xt.WIDGET;   -- Label for description text field

   --
   -- Control Area Widgets
   --
   Apply_Button     : Xt.WIDGET;   -- Apply button widget
   Cancel_Button    : Xt.WIDGET;   -- Cancel button widget

   --
   -- Work Area Widgets
   --
   Parameter_Selection_Scrolled_Window : Xt.WIDGET;
      Parameter_Selection_Rowcolumn       : Xt.WIDGET;
         Network_Button                      : Xt.WIDGET;
         Threshold_Button                    : Xt.WIDGET;
         PDU_Filters_Button                  : Xt.WIDGET;
         Specific_Filters_Button             : Xt.WIDGET;
         DG_Parameters_Button                : Xt.WIDGET;
	 Error_Parameters_Button             : Xt.WIDGET;
	 Hash_Parameters_Button              : Xt.WIDGET;
	 Exercise_Parameters_Button          : Xt.WIDGET;
   Parameter_Separator                 : Xt.WIDGET;
   Parameter_Settings_Scrolled_Window  : Xt.WIDGET;

   --
   -- Renamed functions
   --
   function "=" (left, right: Xlib.XID)
     return BOOLEAN renames Xlib."=";
   function "=" (left, right: Xt.WIDGET)
     return BOOLEAN renames Xt."=";

   function "=" (left, right: XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR)
     return BOOLEAN renames XDG_Server_Types."=";

   function XDG_DATA_REC_PTR_to_Integer is new 
     Unchecked_Conversion (Source => XDG_Server_Types.XDG_DATA_REC_PTR,
                           Target => INTEGER);
   function XDG_SET_PARM_DATA_REC_PTR_to_Integer is new 
     Unchecked_Conversion (Source => XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR,
                           Target => INTEGER);

begin

   --
   -- Redisplay window if it already exists.
   --
   if ((XDG_Data.Set_Parameters_Data /= NULL) and then 
     (XDG_Data.Set_Parameters_Data.Shell /= Xt.XNULL)) then

      Xt.ManageChild (XDG_Data.Set_Parameters_Data.Shell);
      Xt.Popup (XDG_Data.Set_Parameters_Data.Shell, Xt.GrabNone);
      Xlib.MapRaised (
	Xt.GetDisplay (XDG_Data.Set_Parameters_Data.Shell), 
	Xt.GetWindow  (XDG_Data.Set_Parameters_Data.Shell));
      
   --
   -- Create and display the window.
   --
   else

      --
      -- Allocate Set_Parameters_Data
      --
      XDG_Data.Set_Parameters_Data := new 
	XDG_Server_Types.XDG_SET_PARM_DATA_REC'(
	  Shell                       => Xt.XNULL,
	  Title                       => Xt.XNULL,
	  Description                 => Xt.XNULL,

	  Parameter_Scrolled_Window   => Xt.XNULL,
	  Parameter_Active_Hierarchy  => Xt.XNULL,

	  Network                     => (
	    Shell                       => Xt.XNULL,
	    OTHERS                      => Xt.XNULL),
	  Threshold                   => (
	    Shell                       => Xt.XNULL,
	    OTHERS                      => Xt.XNULL),
	  PDU_Filters                 => (
	    Shell                       => Xt.XNULL,
	    OTHERS                      => Xt.XNULL),
	  Specific_Filters            => (
	    Shell                       => Xt.XNULL,
	    OTHERS                      => Xt.XNULL),
	  DG_Parameters               => (
	    Shell                       => Xt.XNULL,
	    OTHERS                      => Xt.XNULL),
          Error                       => (
	    Shell                       => Xt.XNULL,
	    OTHERS                      => Xt.XNULL),
	  Hash                        => (
	    Shell                       => Xt.XNULL,
	    PDU                         => (OTHERS => (OTHERS => Xt.XNULL)) ),
	  Exercise                    => (
	    Shell                       => Xt.XNULL,
	    OTHERS                      => Xt.XNULL) );

      --
      -- Create the shell
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Ntitle, K_Title);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nwidth,
	XDG_Server.K_Set_Parms_Window_Width);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nheight,
	XDG_Server.K_Set_Parms_Window_Height);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NdeleteResponse, 
	INTEGER(Xm.DO_NOTHING));
      XDG_Data.Set_Parameters_Data.Shell := Xt.CreatePopupShell (K_Title,
	Xt.topLevelShellWidgetClass, Motif_Utilities.Get_Topshell (Parent),
	Arglist, Argcount);

      --
      -- Add our close callback as the default delete window callback
      --
      WM_Delete_Window := Xm.InternAtom (Xt.GetDisplay (
	XDG_Data.Set_Parameters_Data.Shell), "WM_DELETE_WINDOW", False);
      Xm.AddWMProtocolCallback (XDG_Data.Set_Parameters_Data.Shell,
	WM_Delete_Window, XDG_Server.Close_Window_CB'address,
	XDG_Data.Set_Parameters_Data.Shell);

      --
      -- Create the basic window form
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginWidth,  INTEGER(2));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginHeight, INTEGER(2));
      Main_Form := Xt.CreateManagedWidget ("Main_Form", Xm.FormWidgetClass,
	XDG_Data.Set_Parameters_Data.Shell, Arglist, Argcount);

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
      -- Create Apply Button (which writes all modified values in all panels
      -- to shared memory).
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
        INTEGER(Xm.ATTACH_NONE));
      Apply_Button := Motif_Utilities.Create_Pushbutton (Control_Form, 
	" Apply ");
      Xt.SetValues (Apply_Button, Arglist, Argcount);
      Xt.AddCallback (Apply_Button, Xmdef.NactivateCallback, 
	 XDG_Server.Apply_CB'address, 
	   XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	     XDG_Data.Set_Parameters_Data));

      --
      -- Create Cancel Button (which closes window and cancels changes)
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_NONE));
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
	  XDG_Server.Cancel_Set_Parms_CB'address,
	   XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	     XDG_Data.Set_Parameters_Data));

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
      Description_Label := Xt.CreateManagedWidget (
	"Description_Label", Xm.LabelWidgetClass, Description_Form,
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
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftWidget, Description_Label);
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
      XDG_Data.Set_Parameters_Data.Description := Xt.CreateManagedWidget (
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
      Network_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Network " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Network_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_Network'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

      Threshold_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Threshold " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Threshold_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_Threshold'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

      PDU_Filters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " PDU " & ASCII.LF & " Filters ");
      Xt.AddCallback (PDU_Filters_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_PDU_Filters'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

      Specific_Filters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Specific " & ASCII.LF & " Filters ");
      Xt.AddCallback (Specific_Filters_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_Specific_Filters'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

      DG_Parameters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " DG " & ASCII.LF & " Parameters ");
      Xt.AddCallback (DG_Parameters_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_DG_Parameters'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

      Error_Parameters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Error " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Error_Parameters_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_Error'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

      Hash_Parameters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Hash " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Hash_Parameters_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_Hash'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

      Exercise_Parameters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Exercise " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Exercise_Parameters_Button, Xmdef.NactivateCallback,
	XDG_Server.Create_Set_Parms_Panel_Exercise'address, 
          XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XDG_Data.Set_Parameters_Data));

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
      XDG_Data.Set_Parameters_Data.Title := Motif_Utilities.Create_Label (
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
      Xt.SetValues (XDG_Data.Set_Parameters_Data.Title, Arglist, Argcount);


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
        XDG_Data.Set_Parameters_Data.Title);
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
      XDG_Data.Set_Parameters_Data.Parameter_Scrolled_Window :=
	Xm.CreateScrolledWindow (Work_Form, "Parameter_Scrolled_Window",
	  Arglist, Argcount);
      Xt.ManageChild (XDG_Data.Set_Parameters_Data.Parameter_Scrolled_Window);

      --
      -- Manage and display window
      --
      Xt.ManageChild (XDG_Data.Set_Parameters_Data.Shell);
      Xt.Popup (XDG_Data.Set_Parameters_Data.Shell, Xt.GrabNone);

   end if;

end Create_Set_Parms_Window_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/02/94   D. Forrest
--      - Initial version
--
-- --

