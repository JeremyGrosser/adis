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
-- UNIT NAME:          Create_Set_Parms_Panel_Exercise
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
procedure Create_Set_Parms_Panel_Exercise(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title        : constant STRING :=
     "XDG Server Exercise Parameters Input Screen";
   K_Arglist_Max        : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max         : constant INTEGER := 128; -- Max characters per string

   K_Hash_Parameters_Columns : constant INTEGER := 2;
   K_Exercise_ID_Digits      : constant INTEGER := 4;
   K_Site_ID_Digits          : constant INTEGER := 4;

   --
   -- Create the constant help strings
   --
   K_Automatic_Exercise_ID_Help_String : constant STRING :=
     "Enable this to have the Server automatically set the exercise ID.";
   K_Exercise_ID_Help_String : constant STRING :=
     "Please enter the exercise ID.";
   K_Automatic_Site_ID_Help_String : constant STRING :=
     "Enable this to have the Server automatically set the site ID.";
   K_Site_ID_Help_String : constant STRING :=
     "Please enter the site ID.";
   K_Automatic_Timestamp_Help_String : constant STRING :=
     "Please select the Automatic Timestamp status.";
   K_IITSEC_Bit_23_Support_Help_String : constant STRING :=
     "Please select the I/ITSEC Bit 23 Support status.";
   K_Experimental_PDUs_Help_String : constant STRING :=
     "Please select the Experimental PDU Support status.";

   --
   -- Miscellaneous declarations
   --
   Arglist           : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount          : Xt.INT := 0;                    -- number of arguments
   Temp_String       : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString     : Xm.XMSTRING;                    -- Temporary X string
   Temp_Label        : Xt.WIDGET := Xt.XNULL;          -- Temporary Widget
   Temp_Separator    : Xt.WIDGET := Xt.XNULL;          -- Temp. separator
   Do_Initialization : BOOLEAN;

   --
   -- Local widget declarations
   --
   Main_Rowcolumn                  : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   Automatic_Exercise_ID_Label     : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Exercise_ID_Label               : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Automatic_Site_ID_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Site_ID_Label                   : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Automatic_Timestamp_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   IITSEC_Bit_23_Support_Label     : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Experimental_PDUs_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Name

   --
   -- Option Menu Declarations
   --
   Automatic_Exercise_ID_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Automatic_Exercise_ID_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Automatic_Exercise_ID_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Automatic_Exercise_ID_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Automatic_Site_ID_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Automatic_Site_ID_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Automatic_Site_ID_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Automatic_Site_ID_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Automatic_Timestamp_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Automatic_Timestamp_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Automatic_Timestamp_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Automatic_Timestamp_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   IITSEC_Bit_23_Support_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   IITSEC_Bit_23_Support_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   IITSEC_Bit_23_Support_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   IITSEC_Bit_23_Support_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Experimental_PDUs_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Experimental_PDUs_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Experimental_PDUs_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Experimental_PDUs_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
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

   if (Set_Data.Exercise.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Set_Data.Exercise.Shell);
      Xt.ManageChild (Set_Data.Exercise.Shell);

   else -- (Set_Data.Exercise.Shell = Xt.XNULL)

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
	INTEGER(K_Hash_Parameters_Columns));
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
      Set_Data.Exercise.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Automatic_Exercise_ID_Label     := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Automatic Exercise ID");
      Exercise_ID_Label               := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Exercise ID");

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      Automatic_Site_ID_Label         := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Automatic Site ID");
      Site_ID_Label                   := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Site ID");

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      Automatic_Timestamp_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Automatic Timestamp");
      IITSEC_Bit_23_Support_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "I/ITSEC Bit 23 Support");
      Experimental_PDUs_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Experimental PDU Support");


      --------------------------------------------------------------------
      --
      -- Create the user input widgets
      --
      --------------------------------------------------------------------

      -- ----------------------------
      -- Exercise ID
      -- ----------------------------
      --
      -- Create the Automatic Exercise ID Enabled/Disabled option menu
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
	item_widget => Automatic_Exercise_ID_Enabled_Pushbutton,
	menu_item   => Automatic_Exercise_ID_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Automatic_Exercise_ID_Disabled_Pushbutton,
	          Automatic_Exercise_ID_Menu(
		    XDG_Server.ENABLED_DISABLED_ENUM'pos(
		      XDG_Server.DISABLED)));

      --
      -- Create the Automatic Exercise ID option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Automatic_Exercise_ID_Menu,
	return_widget    => Automatic_Exercise_ID_Menu_Cascade);
      Xt.ManageChild (Automatic_Exercise_ID_Menu_Cascade);
      Set_Data.Exercise.Automatic_Exercise_ID
	:= Automatic_Exercise_ID_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.Automatic_Exercise_ID_Flag'address);
      Xt.SetValues (Automatic_Exercise_ID_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).
	  Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (Automatic_Exercise_ID_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).
	  Item_Widget.all, Arglist, Argcount);

      --
      -- Create the Exercise_ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Exercise.Exercise_ID := Xt.CreateManagedWidget (
	"Exercise_ID", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Exercise.Exercise_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Exercise_ID_Digits);

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);


      -- ----------------------------
      -- Site ID
      -- ----------------------------
      --
      -- Create the Automatic Site ID Enabled/Disabled option menu
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
	item_widget => Automatic_Site_ID_Enabled_Pushbutton,
	menu_item   => Automatic_Site_ID_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Automatic_Site_ID_Disabled_Pushbutton,
	          Automatic_Site_ID_Menu(
		    XDG_Server.ENABLED_DISABLED_ENUM'pos(
		      XDG_Server.DISABLED)));

      --
      -- Create the Automatic Site ID option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Automatic_Site_ID_Menu,
	return_widget    => Automatic_Site_ID_Menu_Cascade);
      Xt.ManageChild (Automatic_Site_ID_Menu_Cascade);
      Set_Data.Exercise.Automatic_Site_ID
	:= Automatic_Site_ID_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.Automatic_Site_ID_Flag'address);
      Xt.SetValues (Automatic_Site_ID_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).
	  Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (Automatic_Site_ID_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).
	  Item_Widget.all, Arglist, Argcount);

      --
      -- Create the Site_ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Exercise.Site_ID := Xt.CreateManagedWidget (
	"Site_ID", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Exercise.Site_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Site_ID_Digits);

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      -- ----------------------------
      -- Automatic Timestamp
      -- ----------------------------
      MOTIF_UTILITIES.build_menu_item (XDG_Server.K_Enabled_String,
        Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
          Motif_Utilities.Set_Boolean_Value_CB'address,
            XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),              NULL, Automatic_Timestamp_Enabled_Pushbutton,
                Automatic_Timestamp_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
                  XDG_Server.ENABLED)));

      MOTIF_UTILITIES.build_menu_item (XDG_Server.K_Disabled_String,
        Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
          Motif_Utilities.Set_Boolean_Value_CB'address,
            XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
              XDG_Server.K_Disabled)), NULL,
                Automatic_Timestamp_Disabled_Pushbutton,
                  Automatic_Timestamp_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(                    XDG_Server.DISABLED)));

      MOTIF_UTILITIES.build_menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
        ASCII.NUL, TRUE, Automatic_Timestamp_Menu,
          Automatic_Timestamp_Menu_Cascade);
      Xt.ManageChild (Automatic_Timestamp_Menu_Cascade);
      Set_Data.Exercise.Automatic_Timestamp
        := Automatic_Timestamp_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Automatic_Timestamp_Flag'address);
      Xt.SetValues (Automatic_Timestamp_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Automatic_Timestamp_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);


      -- ----------------------------
      -- I/ITSEC Bit 23 Support
      -- ----------------------------
      --
      -- Create the I/ITSEC Bit 23 Support Enabled/Disabled option menu
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
	item_widget => IITSEC_Bit_23_Support_Enabled_Pushbutton,
	menu_item   => IITSEC_Bit_23_Support_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		IITSEC_Bit_23_Support_Disabled_Pushbutton,
	          IITSEC_Bit_23_Support_Menu(
		    XDG_Server.ENABLED_DISABLED_ENUM'pos(
		      XDG_Server.DISABLED)));

      --
      -- Create the Automatic Site ID option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => IITSEC_Bit_23_Support_Menu,
	return_widget    => IITSEC_Bit_23_Support_Menu_Cascade);
      Xt.ManageChild (IITSEC_Bit_23_Support_Menu_Cascade);
      Set_Data.Exercise.IITSEC_Bit_23_Support
	:= IITSEC_Bit_23_Support_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.IITSEC_Bit_23_Support_Flag'address);
      Xt.SetValues (IITSEC_Bit_23_Support_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).
	  Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (IITSEC_Bit_23_Support_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).
	  Item_Widget.all, Arglist, Argcount);

      -- ----------------------------
      -- Experimental PDU Support
      -- ----------------------------
      --
      -- Create the Experimental PDU Support Enabled/Disabled option menu
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
	item_widget => Experimental_PDUs_Enabled_Pushbutton,
	menu_item   => Experimental_PDUs_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Experimental_PDUs_Disabled_Pushbutton,
	          Experimental_PDUs_Menu(
		    XDG_Server.ENABLED_DISABLED_ENUM'pos(
		      XDG_Server.DISABLED)));

      --
      -- Create the Automatic Site ID option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Experimental_PDUs_Menu,
	return_widget    => Experimental_PDUs_Menu_Cascade);
      Xt.ManageChild (Experimental_PDUs_Menu_Cascade);
      Set_Data.Exercise.Experimental_PDUs
	:= Experimental_PDUs_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.Experimental_PDUs_Flag'address);
      Xt.SetValues (Experimental_PDUs_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).
	  Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (Experimental_PDUs_Menu(
	XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).
	  Item_Widget.all, Arglist, Argcount);




      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (Automatic_Exercise_ID_Label,
	Set_Data.Description, K_Automatic_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Exercise_ID_Label,
	Set_Data.Description, K_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Automatic_Site_ID_Label,
	Set_Data.Description, K_Automatic_Site_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Site_ID_Label,
	Set_Data.Description, K_Site_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Automatic_Timestamp_Label,
	Set_Data.Description, K_Automatic_Timestamp_Help_String);
      Motif_Utilities.Install_Active_Help (IITSEC_Bit_23_Support_Label,
	Set_Data.Description, K_IITSEC_Bit_23_Support_Help_String);
      Motif_Utilities.Install_Active_Help (Experimental_PDUs_Label,
	Set_Data.Description, K_Experimental_PDUs_Help_String);

      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Automatic_Exercise_ID, Set_Data.Description,
	  K_Automatic_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Exercise_ID, Set_Data.Description,
	  K_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Automatic_Site_ID, Set_Data.Description,
	  K_Automatic_Site_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Site_ID, Set_Data.Description,
	  K_Site_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Automatic_Timestamp, Set_Data.Description,
	  K_Automatic_Timestamp_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.IITSEC_Bit_23_Support, Set_Data.Description,
	  K_IITSEC_Bit_23_Support_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Experimental_PDUs, Set_Data.Description,
	  K_Experimental_PDUs_Help_String);

   end if; -- (Set_Data.Exercise.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.Exercise.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.Exercise.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Panel_Exercise (Set_Data.Exercise);
   end if;

end Create_Set_Parms_Panel_Exercise;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/09/94   D. Forrest
--      - Initial version
--
-- --

