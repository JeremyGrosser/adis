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
-- UNIT NAME:          Create_Set_Parms_Panel_Specific_Filters
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
procedure Create_Set_Parms_Panel_Specific_Filters(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title       : constant STRING :=
     "XDG Server Specific Filters Input Screen";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string

   --
   -- Create the constant help strings
   --
   K_Keep_Exercise_ID_Help_String : constant STRING :=
     "Please select/enter the Exercise ID information.";
   K_Keep_Force_ID_Other_Help_String : constant STRING :=
     "Please select whether to keep the Other force IDs.";
   K_Keep_Force_ID_Friendly_Help_String : constant STRING :=
     "Please select whether to keep the Friendly force IDs.";
   K_Keep_Force_ID_Opposing_Help_String : constant STRING :=
     "Please select whether to keep the Opposing force IDs.";
   K_Keep_Force_ID_Neutral_Help_String : constant STRING :=
     "Please select whether to keep the Neutral force IDs.";


   --
   -- Miscellaneous declarations
   --
   Arglist           : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount          : Xt.INT := 0;                    -- number of arguments
   Temp_String       : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString     : Xm.XMSTRING;                    -- Temporary X string
   Temp_Widget       : Xt.WIDGET;                      -- Temporary X widget
   Do_Initialization : BOOLEAN;

   --
   -- Local widget declarations
   --
   Main_Rowcolumn                     : Xt.WIDGET := Xt.XNULL; -- Main Rowcol
   Keep_Exercise_ID_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Keep_Force_ID_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Keep_Force_ID_Other_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Keep_Force_ID_Other_Units_Label    : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Keep_Force_ID_Friendly_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Keep_Force_ID_Friendly_Units_Label : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Keep_Force_ID_Opposing_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Keep_Force_ID_Opposing_Units_Label : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Keep_Force_ID_Neutral_Label        : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Keep_Force_ID_Neutral_Units_Label  : Xt.WIDGET := Xt.XNULL; -- Parm Units

   --
   -- Option Menu Declarations
   --
   Keep_Exercise_ID_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Keep_Exercise_ID_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Keep_Exercise_ID_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Keep_Exercise_ID_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Keep_Force_ID_Other_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Keep_Force_ID_Other_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Keep_Force_ID_Other_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Keep_Force_ID_Other_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Keep_Force_ID_Friendly_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Keep_Force_ID_Friendly_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Keep_Force_ID_Friendly_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Keep_Force_ID_Friendly_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Keep_Force_ID_Opposing_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Keep_Force_ID_Opposing_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Keep_Force_ID_Opposing_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Keep_Force_ID_Opposing_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Keep_Force_ID_Neutral_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Keep_Force_ID_Neutral_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Keep_Force_ID_Neutral_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Keep_Force_ID_Neutral_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
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

begin


   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Set_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Set_Data.Parameter_Active_Hierarchy);
   end if;

   if (Set_Data.Specific_Filters.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Set_Data.Specific_Filters.Shell);
      Xt.ManageChild (Set_Data.Specific_Filters.Shell);

   else -- (Set_Data.Specific_Filters.Shell = Xt.XNULL)

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
      Xt.SetArg (Arglist (Argcount), Xmdef.NnumColumns, INTEGER(3));
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
      Set_Data.Specific_Filters.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Keep_Exercise_ID_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Exercise ID");
      Keep_Force_ID_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Force ID");
      Keep_Force_ID_Other_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Other");
      Keep_Force_ID_Friendly_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Friendly");
      Keep_Force_ID_Opposing_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Opposing");
      Keep_Force_ID_Neutral_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Neutral");

      --------------------------------------------------------------------
      --
      -- Create the column 2 widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the Keep_Exercise_ID Enabled/Disabled option menu
      --
      Motif_Utilities.Build_Menu_Item (
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
	item_widget => Keep_Exercise_ID_Enabled_Pushbutton,
	menu_item   => Keep_Exercise_ID_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Keep_Exercise_ID_Disabled_Pushbutton,
		  Keep_Exercise_ID_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));

      Motif_Utilities.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Keep_Exercise_ID_Menu,
	return_widget    => Keep_Exercise_ID_Menu_Cascade);
      Xt.ManageChild (Keep_Exercise_ID_Menu_Cascade);
      Set_Data.Specific_Filters.Keep_Exercise_ID := 
	Keep_Exercise_ID_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Keep_Exercise_ID_Flag'address);
      Xt.SetValues (Keep_Exercise_ID_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Keep_Exercise_ID_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the blank widget for the Keep_Force_ID column 2
      --
      Temp_Widget := Motif_Utilities.Create_Label (Main_Rowcolumn, "");

      --
      -- Create the Keep_Force_ID_Other Enabled/Disabled option menu
      --
      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Keep_Force_ID_Other_Enabled_Pushbutton,
		Keep_Force_ID_Other_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));

      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Keep_Force_ID_Other_Disabled_Pushbutton,
		  Keep_Force_ID_Other_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));

      Motif_Utilities.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION,
	"", ASCII.NUL, TRUE, Keep_Force_ID_Other_Menu,
	Keep_Force_ID_Other_Menu_Cascade);
      Xt.ManageChild (Keep_Force_ID_Other_Menu_Cascade);
      Set_Data.Specific_Filters.Keep_Force_ID_Other := 
	Keep_Force_ID_Other_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Keep_Force_ID_Other_Flag'address);
      Xt.SetValues (Keep_Force_ID_Other_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Keep_Force_ID_Other_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Keep_Force_ID_Friendly Enabled/Disabled option menu
      --
      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Keep_Force_ID_Friendly_Enabled_Pushbutton,
		Keep_Force_ID_Friendly_Menu(
		  XDG_Server.ENABLED_DISABLED_ENUM'pos( XDG_Server.ENABLED)));

      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Keep_Force_ID_Friendly_Disabled_Pushbutton,
		  Keep_Force_ID_Friendly_Menu(
		    XDG_Server.ENABLED_DISABLED_ENUM'pos(
		      XDG_Server.DISABLED)));

      Motif_Utilities.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION,
	"", ASCII.NUL, TRUE, Keep_Force_ID_Friendly_Menu,
	Keep_Force_ID_Friendly_Menu_Cascade);
      Xt.ManageChild (Keep_Force_ID_Friendly_Menu_Cascade);
      Set_Data.Specific_Filters.Keep_Force_ID_Friendly := 
	Keep_Force_ID_Friendly_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Keep_Force_ID_Friendly_Flag'address);
      Xt.SetValues (Keep_Force_ID_Friendly_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Keep_Force_ID_Friendly_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Keep_Force_ID_Opposing Enabled/Disabled option menu
      --
      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Keep_Force_ID_Opposing_Enabled_Pushbutton,
		Keep_Force_ID_Opposing_Menu(
		  XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Keep_Force_ID_Opposing_Disabled_Pushbutton,
		  Keep_Force_ID_Opposing_Menu(
		    XDG_Server.ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)));

      Motif_Utilities.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION,
	"", ASCII.NUL, TRUE, Keep_Force_ID_Opposing_Menu,
	Keep_Force_ID_Opposing_Menu_Cascade);
      Xt.ManageChild (Keep_Force_ID_Opposing_Menu_Cascade);
      Set_Data.Specific_Filters.Keep_Force_ID_Opposing := 
	Keep_Force_ID_Opposing_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Keep_Force_ID_Opposing_Flag'address);
      Xt.SetValues (Keep_Force_ID_Opposing_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Keep_Force_ID_Opposing_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Keep_Force_ID_Neutral Enabled/Disabled option menu
      --
      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Keep_Force_ID_Neutral_Enabled_Pushbutton,
		Keep_Force_ID_Neutral_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));

      Motif_Utilities.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, 
		Keep_Force_ID_Neutral_Disabled_Pushbutton,
		Keep_Force_ID_Neutral_Menu(
		  XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));

      Motif_Utilities.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION,
	"", ASCII.NUL, TRUE, Keep_Force_ID_Neutral_Menu,
	Keep_Force_ID_Neutral_Menu_Cascade);
      Xt.ManageChild (Keep_Force_ID_Neutral_Menu_Cascade);
      Set_Data.Specific_Filters.Keep_Force_ID_Neutral := 
	Keep_Force_ID_Neutral_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Keep_Force_ID_Neutral_Flag'address);
      Xt.SetValues (Keep_Force_ID_Neutral_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Keep_Force_ID_Neutral_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      --
      -- Create the Keep_Exercise_ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Specific_Filters.Keep_Exercise_ID_Value 
	:= Xt.CreateManagedWidget ("Keep_Exercise_ID_Menu", 
	  Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Set_Data.Specific_Filters.Keep_Exercise_ID_Value,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last);

      Keep_Force_ID_Other_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Keep_Force_ID_Friendly_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Keep_Force_ID_Opposing_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Keep_Force_ID_Neutral_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Keep_Exercise_ID_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_Keep_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Keep_Force_ID_Other_Label,
	Set_Data.Description, K_Keep_Force_ID_Other_Help_String);
      Motif_Utilities.Install_Active_Help (Keep_Force_ID_Friendly_Label,
	Set_Data.Description, K_Keep_Force_ID_Friendly_Help_String);
      Motif_Utilities.Install_Active_Help (Keep_Force_ID_Opposing_Label,
	Set_Data.Description, K_Keep_Force_ID_Opposing_Help_String);
      Motif_Utilities.Install_Active_Help (Keep_Force_ID_Neutral_Label,
	Set_Data.Description, K_Keep_Force_ID_Neutral_Help_String);


      Motif_Utilities.Install_Active_Help (
	Set_Data.Specific_Filters.Keep_Exercise_ID, Set_Data.Description,
	K_Keep_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Specific_Filters.Keep_Force_ID_Other, Set_Data.Description,
	K_Keep_Force_ID_Other_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Specific_Filters.Keep_Force_ID_Friendly, Set_Data.Description,
	K_Keep_Force_ID_Friendly_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Specific_Filters.Keep_Force_ID_Opposing, Set_Data.Description,
	K_Keep_Force_ID_Opposing_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Specific_Filters.Keep_Force_ID_Neutral, Set_Data.Description,
	K_Keep_Force_ID_Neutral_Help_String);

      Motif_Utilities.Install_Active_Help (
	Set_Data.Specific_Filters.Keep_Exercise_ID_Value,
	Set_Data.Description, K_Keep_Exercise_ID_Help_String);

   end if; -- (Set_Data.Specific_Filters.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.Specific_Filters.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.Specific_Filters.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Panel_Specific_Filters (Set_Data.Specific_Filters);
   end if;

end Create_Set_Parms_Panel_Specific_Filters;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/06/94   D. Forrest
--      - Initial version
--
-- --

