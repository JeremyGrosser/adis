--
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

with Motif_Utilities;
with Text_IO;
with Unchecked_Conversion;
with Xlib;
with Xm;
with Xmdef;
with XOS;
with OS_GUI;
with XOS_Types;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Create_Ord_Parms_Window_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 18, 1994
--
-- PURPOSE:
--   This procedure displays the XOS window which allows the user to
--   set the ordnance parameters.
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
procedure Create_Ord_Parms_Window_CB (
   Parent      : in     Xt.WIDGET;
   XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is
   
   --
   -- Constant Declarations
   --
   K_Welcome_Message: constant STRING  :=
     "Welcome to the XOS Ordnance Parameters Input Display.";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string
   K_Title          : constant STRING  := "XOS Set Ordnance Parameters";
   K_Widget_Offset  : constant INTEGER := 10;

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
   -- Work Area Widgets
   --
   Parameter_Selection_Scrolled_Window : Xt.WIDGET;
      Parameter_Selection_Rowcolumn        : Xt.WIDGET;
         Aerodynamic_Parameters_Button         : Xt.WIDGET;
         Termination_Parameters_Button         : Xt.WIDGET;
         General_Parameters_Button             : Xt.WIDGET;
	 Emitter_Parameters_Button             : Xt.WIDGET;
	 Entity_Parameters_Button              : Xt.WIDGET;
   Parameter_Separator                 : Xt.WIDGET;
   Parameter_Settings_Scrolled_Window  : Xt.WIDGET;

   --
   -- Renamed functions
   --
   function "=" (left, right: Xt.WIDGET)
     return BOOLEAN renames Xt."=";

   function "=" (left, right: XOS_Types.XOS_ORD_PARM_DATA_REC_PTR)
     return BOOLEAN renames XOS_Types."=";

   function XOS_PARM_DATA_REC_PTR_to_Integer is new 
     Unchecked_Conversion (Source => XOS_Types.XOS_PARM_DATA_REC_PTR,
                           Target => INTEGER);
   function XOS_ORD_PARM_DATA_REC_PTR_to_Integer is new 
     Unchecked_Conversion (Source => XOS_Types.XOS_ORD_PARM_DATA_REC_PTR,
                           Target => INTEGER);

begin

   --
   -- Redisplay window if it already exists.
   --
   if ((XOS_Data.Ord_Data /= NULL) and then 
     (XOS_Data.Ord_Data.Shell /= Xt.XNULL)) then

      Xt.ManageChild (XOS_Data.Ord_Data.Shell);
      Xt.Popup (XOS_Data.Ord_Data.Shell, Xt.GrabNone);
      Xlib.MapRaised (
	Xt.GetDisplay (XOS_Data.Ord_Data.Shell), 
	Xt.GetWindow (XOS_Data.Ord_Data.Shell));
      
   --
   -- Create and display the window.
   --
   else

      --
      -- Allocate Ord_Data
      --
      XOS_Data.Ord_Data := new XOS_Types.XOS_ORD_PARM_DATA_REC'(
	Shell                       => Xt.XNULL,
	Title                       => Xt.XNULL,
	Description                 => Xt.XNULL,

	Apply_Button                => Xt.XNULL,
	Previous_Button             => Xt.XNULL,
	Next_Button                 => Xt.XNULL,
	Cancel_Button               => Xt.XNULL,

	Parameter_Scrolled_Window   => Xt.XNULL,
	Parameter_Active_Hierarchy  => Xt.XNULL,

	Aero                        => (
	   Shell                       => Xt.XNULL,
	   Drag_Coefficients           => (OTHERS => Xt.XNULL),
	   OTHERS                      => Xt.XNULL),

	Term                        => (
	   Shell                       => Xt.XNULL,
	   OTHERS                      => Xt.XNULL),

	Gen                         => (
	   Shell                       => Xt.XNULL,
	   OTHERS                      => Xt.XNULL),

        Emitter                     => (
           Shell                       => Xt.XNULL,
           OTHERS                      => Xt.XNULL),

        Entity                      => (
           Shell                       => Xt.XNULL,
           OTHERS                      => Xt.XNULL));


      --
      -- Create the shell
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Ntitle, K_Title);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nwidth, INTEGER(900));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xtdef.Nheight, INTEGER(600));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NdeleteResponse, 
	INTEGER(Xm.DO_NOTHING));
      XOS_Data.Ord_Data.Shell := Xt.CreatePopupShell (K_Title,
	Xt.topLevelShellWidgetClass, Motif_Utilities.Get_Topshell (Parent),
	Arglist, Argcount);

      --
      -- Add our close callback as the default delete window callback
      --
      WM_Delete_Window := Xm.InternAtom (Xt.GetDisplay (
	XOS_Data.Ord_Data.Shell), "WM_DELETE_WINDOW", False);
      Xm.AddWMProtocolCallback (XOS_Data.Ord_Data.Shell, WM_Delete_Window,
	XOS.Close_Window_CB'address, XOS_Data.Ord_Data.Shell);

      --
      -- Create the basic window form
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginWidth,  INTEGER(2));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NmarginHeight, INTEGER(2));
      Main_Form := Xt.CreateManagedWidget ("Main_Form",
	Xm.FormWidgetClass, XOS_Data.Ord_Data.Shell, Arglist, Argcount);

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
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NfractionBase, INTEGER(100));
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
      XOS_Data.Ord_Data.Apply_Button := Motif_Utilities.Create_Pushbutton(
	Control_Form, " Apply ");
      Xt.SetValues (XOS_Data.Ord_Data.Apply_Button, Arglist, Argcount);
      Xt.AddCallback (XOS_Data.Ord_Data.Apply_Button, Xmdef.NactivateCallback,
        XOS.Ord_Apply_CB'address,
          XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
            XOS_Data.Ord_Data));

      --
      -- Create Previous Button
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset,
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
        INTEGER(Xm.ATTACH_POSITION));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightPosition, INTEGER(50));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NrightOffset, K_Widget_Offset);
      Argcount := Argcount + 1;
      if OS_GUI.Interface.Ordnance_Display.Top_Of_List then
	 Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, FALSE);
      else
	 Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, TRUE);
      end if;
      XOS_Data.Ord_Data.Previous_Button := Motif_Utilities.Create_Pushbutton(
	Control_Form, "  Previous  ");
      Xt.SetValues (XOS_Data.Ord_Data.Previous_Button, Arglist, Argcount);
      Xt.AddCallback (XOS_Data.Ord_Data.Previous_Button,
	Xmdef.NactivateCallback, XOS.Ord_Previous_CB'address,
          XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
            XOS_Data.Ord_Data));

      --
      -- Create Next Button
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
        INTEGER(Xm.ATTACH_POSITION));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftPosition, INTEGER(50));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NleftOffset, K_Widget_Offset);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
        INTEGER(Xm.ATTACH_FORM));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NbottomOffset,
        Motif_Utilities.Widget_Separation);
      Argcount := Argcount + 1;
      if OS_GUI.Interface.Ordnance_Display.End_Of_List then
	 Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, FALSE);
      else
	 Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, TRUE);
      end if;
      XOS_Data.Ord_Data.Next_Button := Motif_Utilities.Create_Pushbutton(
	Control_Form, "     Next     ");
      Xt.SetValues (XOS_Data.Ord_Data.Next_Button, Arglist, Argcount);
      Xt.AddCallback (XOS_Data.Ord_Data.Next_Button,
	Xmdef.NactivateCallback, XOS.Ord_Next_CB'address,
          XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
            XOS_Data.Ord_Data));
      --
      -- Create Cancel Button (which simply closes window)
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
        INTEGER(Xm.ATTACH_FORM));
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
      XOS_Data.Ord_Data.Cancel_Button := Motif_Utilities.Create_Pushbutton(
	Control_Form, " Cancel ");
      Xt.SetValues(XOS_Data.Ord_Data.Cancel_Button, Arglist, Argcount);
      Xt.AddCallback(XOS_Data.Ord_Data.Cancel_Button, Xmdef.NactivateCallback, 
	XOS.Cancel_Ord_Parms_Window_CB'address,
	  XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
            XOS_Data.Ord_Data));

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
      XOS_Data.Ord_Data.Description := Xt.CreateManagedWidget ("Description",
	  Xm.TextFieldWidgetClass, Description_Form, Arglist, Argcount);

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
      -- Create the Ordnance Parameters Buttons
      --
      General_Parameters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " General " & ASCII.LF & " Parameters ");
      Xt.AddCallback (General_Parameters_Button, Xmdef.NactivateCallback,
	XOS.Create_Ord_Panel_Gen'address, 
	  XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XOS_Data.Ord_Data));

      Entity_Parameters_Button := Motif_Utilities.Create_Pushbutton (
        Parameter_Selection_Rowcolumn,
          " Entity " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Entity_Parameters_Button, Xmdef.NactivateCallback,
        XOS.Create_Ord_Panel_Entity'address,
          XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
            XOS_Data.Ord_Data));

      Aerodynamic_Parameters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Aerodynamic " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Aerodynamic_Parameters_Button, Xmdef.NactivateCallback,
	XOS.Create_Ord_Panel_Aero'address, 
          XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
            XOS_Data.Ord_Data));

      Emitter_Parameters_Button := Motif_Utilities.Create_Pushbutton (
        Parameter_Selection_Rowcolumn,
	  " Emitter " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Emitter_Parameters_Button, Xmdef.NactivateCallback,
        XOS.Create_Ord_Panel_Emitter'address,
          XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
            XOS_Data.Ord_Data));

      Termination_Parameters_Button := Motif_Utilities.Create_Pushbutton (
	Parameter_Selection_Rowcolumn,
	  " Termination " & ASCII.LF & " Parameters ");
      Xt.AddCallback (Termination_Parameters_Button, Xmdef.NactivateCallback,
	XOS.Create_Ord_Panel_Term'address, 
          XOS_Types.XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER(
	    XOS_Data.Ord_Data));

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
      XOS_Data.Ord_Data.Title := Motif_Utilities.Create_Label (
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
      Xt.SetValues (XOS_Data.Ord_Data.Title, Arglist, Argcount);

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
        XOS_Data.Ord_Data.Title);
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
      XOS_Data.Ord_Data.Parameter_Scrolled_Window := Xm.CreateScrolledWindow (
        Work_Form, "Parameter_Scrolled_Window", Arglist, Argcount);
      Xt.ManageChild (XOS_Data.Ord_Data.Parameter_Scrolled_Window);

      --
      -- Manage and display window
      --
      Xt.ManageChild (XOS_Data.Ord_Data.Shell);
      Xt.Popup (XOS_Data.Ord_Data.Shell, Xt.GrabNone);

   end if;

end Create_Ord_Parms_Window_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

