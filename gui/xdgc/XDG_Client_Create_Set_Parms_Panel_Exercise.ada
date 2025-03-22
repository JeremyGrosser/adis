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

separate (XDG_Client)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Create_Set_Parms_Panel_Exercise
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12, 1994
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
   Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title        : constant STRING :=
     "XDG Client Exercise Parameters Input Screen";
   K_Arglist_Max        : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max         : constant INTEGER := 128; -- Max characters per string

   K_Hash_Parameters_Columns : constant INTEGER := 2;
   K_Application_ID_Digits   : constant INTEGER := 4;

   --
   -- Create the constant help strings
   --
   K_Automatic_Application_ID_Help_String : constant STRING :=
     "Enable this to have the Client automatically set the application ID.";
   K_Application_ID_Help_String : constant STRING :=
     "Please enter the application ID.";

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
   Automatic_Application_ID_Label  : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Application_ID_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name

   --
   -- Option Menu Declarations
   --
   Automatic_Application_ID_Menu : XDG_Client.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Automatic_Application_ID_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Automatic_Application_ID_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Automatic_Application_ID_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
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
      Automatic_Application_ID_Label  := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Automatic Application ID");
      Application_ID_Label            := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Application ID");

      --------------------------------------------------------------------
      --
      -- Create the text fields
      --
      --------------------------------------------------------------------

      -- ----------------------------
      -- Application ID
      -- ----------------------------
      --
      -- Create the Automatic Application ID Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (
	label       => XDG_Client.K_Enabled_String,
	class       => Xm.PushButtonGadgetClass,
	sensitive   => TRUE,
	mnemonic    => ASCII.NUL,   -- 'P'
	accelerator => "",          -- "Alt<Key>P"
	accel_text  => "",          -- "Alt+P"
	callback    => Motif_Utilities.Set_Boolean_Value_CB'address,
	cb_data     => XDG_Client.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	  XDG_Client.K_Enabled)),
	subitems    => NULL,
	item_widget => Automatic_Application_ID_Enabled_Pushbutton,
	menu_item   => Automatic_Application_ID_Menu(XDG_Client.
	  ENABLED_DISABLED_ENUM'pos(XDG_Client.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Client.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Client.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Client.K_Disabled)), NULL,
		Automatic_Application_ID_Disabled_Pushbutton,
	          Automatic_Application_ID_Menu(
		    XDG_Client.ENABLED_DISABLED_ENUM'pos(
		      XDG_Client.DISABLED)));

      --
      -- Create the Automatic Application ID option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Automatic_Application_ID_Menu,
	return_widget    => Automatic_Application_ID_Menu_Cascade);
      Xt.ManageChild (Automatic_Application_ID_Menu_Cascade);
      Set_Data.Exercise.Automatic_Application_ID
	:= Automatic_Application_ID_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Client.Automatic_Application_ID_Flag'address);
      Xt.SetValues (Automatic_Application_ID_Menu(
	XDG_Client.ENABLED_DISABLED_ENUM'pos(XDG_Client.ENABLED)).
	  Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (Automatic_Application_ID_Menu(
	XDG_Client.ENABLED_DISABLED_ENUM'pos(XDG_Client.DISABLED)).
	  Item_Widget.all, Arglist, Argcount);

      --
      -- Create the Application_ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Exercise.Application_ID := Xt.CreateManagedWidget (
	"Application_ID", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Exercise.Application_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Application_ID_Digits);

      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Automatic_Application_ID_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_Automatic_Application_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Application_ID_Label,
	Set_Data.Description, K_Application_ID_Help_String);


      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Automatic_Application_ID, Set_Data.Description,
	  K_Automatic_Application_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Exercise.Application_ID, Set_Data.Description,
	  K_Application_ID_Help_String);

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
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

