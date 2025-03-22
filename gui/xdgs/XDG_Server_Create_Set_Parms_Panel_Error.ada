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
-- UNIT NAME:          Create_Set_Parms_Panel_Error
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 9, 1994
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
procedure Create_Set_Parms_Panel_Error(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title        : constant STRING :=
     "XDG Server Error Parameters Input Screen";
   K_Arglist_Max        : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max         : constant INTEGER := 128; -- Max characters per string
   K_Error_Parameters_Columns : constant INTEGER := 2; -- Columns of info 

   --
   -- Create the constant help strings
   --
   K_GUI_Error_Reporting_Help_String : constant STRING :=
     "Please select whether or not to enable GUI error reporting.";
   K_Error_Logging_Help_String : constant STRING :=
     "Please select whether or not to enable error logging.";
   K_Error_Logfile_Help_String : constant STRING :=
     "Please enter error logfile filename.";


   --
   -- Miscellaneous declarations
   --
   Arglist           : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount          : Xt.INT := 0;                    -- number of arguments
   Temp_String       : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString     : Xm.XMSTRING;                    -- Temporary X string
   Temp_Label        : Xt.WIDGET := Xt.XNULL;          -- Temporary Widget
   Do_Initialization : BOOLEAN;

   --
   -- Local widget declarations
   --
   Main_Rowcolumn                  : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   GUI_Error_Reporting_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Error_Logging_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Error_Logfile_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name

   --
   -- Option Menu Declarations
   --
   GUI_Error_Reporting_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   GUI_Error_Reporting_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   GUI_Error_Reporting_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   GUI_Error_Reporting_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Error_Logging_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Error_Logging_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Error_Logging_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Error_Logging_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

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
   function ADDRESS_To_INTEGER
     is new Unchecked_Conversion (System.ADDRESS, INTEGER);

begin


   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Set_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Set_Data.Parameter_Active_Hierarchy);
   end if;

   if (Set_Data.Error.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Set_Data.Error.Shell);
      Xt.ManageChild (Set_Data.Error.Shell);

   else -- (Set_Data.Error.Shell = Xt.XNULL)

      Do_Initialization := True;
      --
      -- Create (Sub)root widget of the simulation parameter widget hierarchy
      -- (the main simulation parameter panel rowcolumn widget).
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Npacking, INTEGER(Xm.PACK_COLUMN));
      Argcount := Argcount + 1;
      -- creates COLUMNS of widgets; number of rows varies
      Xt.SetArg (Arglist (Argcount), Xmdef.Norientation, INTEGER(Xm.VERTICAL));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NnumColumns, 
	INTEGER(K_Error_Parameters_Columns));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NentryAlignment,
	INTEGER(Xm.ALIGNMENT_BEGINNING));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NisAligned, True);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nspacing, INTEGER(0));
      Main_Rowcolumn := Xt.CreateWidget ("Main_Rowcolumn",
	Xm.RowColumnWidgetClass, Set_Data.Parameter_Scrolled_Window,
	  Arglist, Argcount);
      Set_Data.Error.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      GUI_Error_Reporting_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "GUI Error Reporting");
      Error_Logging_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Error Logging");
      Error_Logfile_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Error Logfile");

      --------------------------------------------------------------------
      --
      -- Create the user input widgets
      --
      --------------------------------------------------------------------

      -- ---
      -- Create the GUI_Error_Reporting Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (
	label       => XDG_Server.K_Enabled_String,
	class       => Xm.PushButtonGadgetClass,
	sensitive   => TRUE,
	mnemonic    => ASCII.NUL,   -- 'P'
	accelerator => "",          -- "Alt<Key>P"
	accel_text  => "",          -- "Alt+P"
	callback    => Motif_Utilities.Set_Boolean_Value_CB'address,
	cb_data     => XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	  XDG_Server.K_Enabled)),
	subitems    => NULL,
	item_widget => GUI_Error_Reporting_Enabled_Pushbutton,
	menu_item   => GUI_Error_Reporting_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		GUI_Error_Reporting_Disabled_Pushbutton,
	          GUI_Error_Reporting_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	            XDG_Server.DISABLED)));

      --
      -- Create the Error GUI_Error_Reporting option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => GUI_Error_Reporting_Menu,
	return_widget    => GUI_Error_Reporting_Menu_Cascade);
      Xt.ManageChild (GUI_Error_Reporting_Menu_Cascade);
      Set_Data.Error.GUI_Error_Reporting := GUI_Error_Reporting_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.GUI_Error_Reporting_Flag'address);
      Xt.SetValues (GUI_Error_Reporting_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).
	  Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (GUI_Error_Reporting_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).
	  Item_Widget.all, Arglist, Argcount);


      -- ---
      -- Create the Error_Logging Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (
	label       => XDG_Server.K_Enabled_String,
	class       => Xm.PushButtonGadgetClass,
	sensitive   => TRUE,
	mnemonic    => ASCII.NUL,   -- 'P'
	accelerator => "",          -- "Alt<Key>P"
	accel_text  => "",          -- "Alt+P"
	callback    => Motif_Utilities.Set_Boolean_Value_CB'address,
	cb_data     => XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	  XDG_Server.K_Enabled)),
	subitems    => NULL,
	item_widget => Error_Logging_Enabled_Pushbutton,
	menu_item   => Error_Logging_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Error_Logging_Disabled_Pushbutton,
	          Error_Logging_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	            XDG_Server.DISABLED)));

      --
      -- Create the Error Error_Logging option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Error_Logging_Menu,
	return_widget    => Error_Logging_Menu_Cascade);
      Xt.ManageChild (Error_Logging_Menu_Cascade);
      Set_Data.Error.Error_Logging := Error_Logging_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.Error_Logging_Flag'address);
      Xt.SetValues (Error_Logging_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).
	  Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (Error_Logging_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).
	  Item_Widget.all, Arglist, Argcount);


      --
      -- Create the Error_Logfile text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Error.Error_Logfile := Xt.CreateManagedWidget (
	"Error_Logfile", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Error.Error_Logfile,
        Text_Type        => Motif_Utilities.TEXT_ANY,
        Characters_Count => 80);

      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => GUI_Error_Reporting_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_GUI_Error_Reporting_Help_String);
      Motif_Utilities.Install_Active_Help (Error_Logging_Label,
	Set_Data.Description, K_Error_Logging_Help_String);
      Motif_Utilities.Install_Active_Help (Error_Logfile_Label,
	Set_Data.Description, K_Error_Logfile_Help_String);


      Motif_Utilities.Install_Active_Help (
	Set_Data.Error.GUI_Error_Reporting, Set_Data.Description,
	  K_GUI_Error_Reporting_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Error.Error_Logging, Set_Data.Description,
	  K_Error_Logging_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Error.Error_Logfile, Set_Data.Description,
	  K_Error_Logfile_Help_String);

   end if; -- (Set_Data.Error.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.Error.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.Error.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Panel_Error (Set_Data.Error);
   end if;

end Create_Set_Parms_Panel_Error;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/09/94   D. Forrest
--      - Initial version
--
-- --

