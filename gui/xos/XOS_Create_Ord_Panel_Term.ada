--                          U N C L A S S I F I E D
--
--  *=====================================================================*
--  |                                                                     |
--  |                       Manned Flight Simulator                       |
--  |              Naval Air Warfare Center Aircraft Division             |
--  |                      Patuxent River, Maryland                       |
--  |                                                                     |
--  *=====================================================================*
--

with DIS_Types;
with Motif_Utilities;
with Text_IO;
with Unchecked_Conversion;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Create_Ord_Panel_Term
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 26, 1994
--
-- PURPOSE:
--   This procedure displays the Ordnance Termination Parameters Panel 
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
procedure Create_Ord_Panel_Term(
   Parent      : in     Xt.WIDGET;
   Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title     : constant STRING :=
     "XOS Termination Parameters Input Screen";
   K_Arglist_Max     : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max      : constant INTEGER := 128; -- Max characters per string
   Do_Initialization : BOOLEAN;

   --
   -- Create the constant help strings
   --
   K_Fuze_Help_String : constant STRING :=
     "Please select the Fuse.";
   K_Fuze_Detonation_Proximity_Help_String : constant STRING :=
     "Please enter the Fuse Detonation Proximity.";
   K_Fuze_Height_Relative_To_Sea_Level_To_Detonate_Help_String : constant 
     STRING := 
       "Please enter the Fuse Height Relative To Sea Level To Detonate.";
   K_Fuze_Time_To_Detonation_Help_String : constant STRING :=
     "Please enter the Fuse Time To Detonation.";
   K_Warhead_Help_String : constant STRING :=
     "Please select the Warhead.";
   K_Warhead_Range_To_Damage_Help_String : constant STRING :=
     "Please enter the Warhead Range To Damage.";
   K_Warhead_Hard_Kill_Help_String : constant STRING :=
     "Please enter the Warhead Hard Kill.";
   K_Max_Range_Help_String : constant STRING :=
     "Please enter the Max Range.";


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
   Main_Rowcolumn                        : Xt.WIDGET := Xt.XNULL;
   Fuze_Label                            : Xt.WIDGET := Xt.XNULL;
   Fuze_Units_Label                      : Xt.WIDGET := Xt.XNULL;
   Fuze_Detonation_Proximity_Label       : Xt.WIDGET := Xt.XNULL;
   Fuze_Detonation_Proximity_Units_Label : Xt.WIDGET := Xt.XNULL;
   Fuze_Height_Relative_To_Sea_Level_To_Detonate_Label : Xt.WIDGET
     := Xt.XNULL;
   Fuze_Height_Relative_To_Sea_Level_To_Detonate_Units_Label : Xt.WIDGET
     := Xt.XNULL;
   Fuze_Time_To_Detonation_Label         : Xt.WIDGET := Xt.XNULL;
   Fuze_Time_To_Detonation_Units_Label   : Xt.WIDGET := Xt.XNULL;
   Warhead_Label                         : Xt.WIDGET := Xt.XNULL;
   Warhead_Units_Label                   : Xt.WIDGET := Xt.XNULL;
   Warhead_Range_To_Damage_Label         : Xt.WIDGET := Xt.XNULL;
   Warhead_Range_To_Damage_Units_Label   : Xt.WIDGET := Xt.XNULL; 
   Warhead_Hard_Kill_Label               : Xt.WIDGET := Xt.XNULL;
   Warhead_Hard_Kill_Units_Label         : Xt.WIDGET := Xt.XNULL;
   Max_Range_Label                       : Xt.WIDGET := Xt.XNULL;
   Max_Range_Units_Label                 : Xt.WIDGET := Xt.XNULL;

   --
   -- Option Menu Declarations
   --
   Fuze_Menu         : XOS_Types.XOS_FUZE_OPTION_MENU_TYPE;
   Fuze_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Fuze_Pushbuttons  : XOS_Types.XOS_FUZE_PUSHBUTTON_ARRAY
     := (OTHERS => new Xt.WIDGET'(Xt.XNULL));
   
   Warhead_Menu         : XOS_Types.XOS_WARHEAD_OPTION_MENU_TYPE;
   Warhead_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Warhead_Pushbuttons  : XOS_Types.XOS_WARHEAD_PUSHBUTTON_ARRAY
     := (OTHERS => new Xt.WIDGET'(Xt.XNULL));
   
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
   function INTEGER_To_XtPOINTER
     is new Unchecked_Conversion (INTEGER, Xt.POINTER);

begin


   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Ord_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Ord_Data.Parameter_Active_Hierarchy);
   end if;

   if (Ord_Data.Term.Shell /= Xt.XNULL) then
      
      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Ord_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Ord_Data.Term.Shell);
      Xt.ManageChild (Ord_Data.Term.Shell);

   else  -- (Ord_Data.Term.Shell = Xt.XNULL)

      Do_Initialization := True;
      --
      -- Create (Sub)root widget of the simulation parameter widget hierarchy
      -- (the main simulation parameter panel rowcolumn widget).
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Npacking, INTEGER(Xm.PACK_COLUMN));

      -- creates COLUMNS of widgets; number of rows varies
      Argcount := Argcount + 1;
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
	Xm.RowColumnWidgetClass, Ord_Data.Parameter_Scrolled_Window,
	Arglist, Argcount);
      Ord_Data.Term.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Fuze_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Fuse");
      Fuze_Detonation_Proximity_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "  Detonation Proximity");
      Fuze_Height_Relative_To_Sea_Level_To_Detonate_Label :=
	Motif_Utilities.Create_Label ( Main_Rowcolumn,
	  "  Height Relative To Sea Level To Detonate");
      Fuze_Time_To_Detonation_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "  Time To Detonation");
      Warhead_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Warhead");
      Warhead_Range_To_Damage_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "  Range To Damage");
      Warhead_Hard_Kill_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "  Hard Kill");
      Max_Range_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Max Range");

      --------------------------------------------------------------------
      --
      -- Create the user input widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the Fuze Option Menu Items
      --
      BUILD_FUZE_OPTION_MENU_ITEMS_LOOP:
      for Fuze_Index in
        DIS_Types.A_FUZE_TYPE'first..DIS_Types.A_FUZE_TYPE'last loop

	   MOTIF_UTILITIES.Build_Menu_Item (
	     label       => DIS_Types.A_FUZE_TYPE'image(Fuze_Index) & "  ",
	     class       => Xm.PushButtonGadgetClass,
	     sensitive   => TRUE,
	     mnemonic    => ASCII.NUL,   -- 'P'
	     accelerator => "",          -- "Alt<Key>P"
	     accel_text  => "",          -- "Alt+P"
	     callback    => Motif_Utilities.Set_Integer_Value_CB'address,
	     cb_data     => INTEGER_To_XtPOINTER (
	       DIS_Types.A_FUZE_TYPE'pos(Fuze_Index)),
	     subitems    => NULL,
	     Item_Widget => Fuze_Pushbuttons(Fuze_Index),
	     menu_item   => Fuze_Menu(DIS_Types.A_FUZE_TYPE'pos(Fuze_Index)));

      end loop BUILD_FUZE_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Fuze option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Fuze_Menu,
        return_widget    => Fuze_Menu_Cascade);
      Xt.ManageChild (Fuze_Menu_Cascade);
      Ord_Data.Term.Fuze := Fuze_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Fuze value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Fuze_Value'address);

      SETUP_FUZE_OPTION_MENU_ITEMS_LOOP:
      for Fuze_Index in
        DIS_Types.A_FUZE_TYPE'first..DIS_Types.A_FUZE_TYPE'last loop

             Xt.SetValues (Fuze_Menu(DIS_Types.A_FUZE_TYPE'pos(
               Fuze_Index)).Item_Widget.all, Arglist, Argcount);

      end loop SETUP_FUZE_OPTION_MENU_ITEMS_LOOP;


      --
      -- Create the Fuze_Detonation_Proximity text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Term.Fuze_Detonation_Proximity := Xt.CreateManagedWidget (
	"Fuze_Detonation_Proximity", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Term.Fuze_Detonation_Proximity,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Fuze_Height_Relative_To_Sea_Level_To_Detonate text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Term.Fuze_Height_Relative_To_Sea_Level_To_Detonate :=
	Xt.CreateManagedWidget (
	  "Fuze_Height_Relative_To_Sea_Level_To_Detonate",
	  Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Ord_Data.Term.Fuze_Height_Relative_To_Sea_Level_To_Detonate,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Fuze_Time_To_Detonation text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Term.Fuze_Time_To_Detonation := Xt.CreateManagedWidget (
	"Fuze_Time_To_Detonation", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Term.Fuze_Time_To_Detonation,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);


      --
      -- Create the Warhead Option Menu Items
      --
      BUILD_WARHEAD_OPTION_MENU_ITEMS_LOOP:
      for Warhead_Index in
        DIS_Types.A_WARHEAD_TYPE'first..DIS_Types.A_WARHEAD_TYPE'last loop

	   MOTIF_UTILITIES.Build_Menu_Item (
	     label       => DIS_Types.A_WARHEAD_TYPE'image(Warhead_Index)
	       & "  ",
	     class       => Xm.PushButtonGadgetClass,
	     sensitive   => TRUE,
	     mnemonic    => ASCII.NUL,   -- 'P'
	     accelerator => "",          -- "Alt<Key>P"
	     accel_text  => "",          -- "Alt+P"
	     callback    => Motif_Utilities.Set_Integer_Value_CB'address,
	     cb_data     => INTEGER_To_XtPOINTER (
	       DIS_Types.A_WARHEAD_TYPE'pos(Warhead_Index)),
	     subitems    => NULL,
	     Item_Widget => Warhead_Pushbuttons(Warhead_Index),
	     menu_item   =>
               Warhead_Menu(DIS_Types.A_WARHEAD_TYPE'pos(Warhead_Index)));

      end loop BUILD_WARHEAD_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Warhead option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Warhead_Menu,
        return_widget    => Warhead_Menu_Cascade);
      Xt.ManageChild (Warhead_Menu_Cascade);
      Ord_Data.Term.Warhead := Warhead_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Warhead value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Warhead_Value'address);

      SETUP_WARHEAD_OPTION_MENU_ITEMS_LOOP:
      for Warhead_Index in
        DIS_Types.A_WARHEAD_TYPE'first..DIS_Types.A_WARHEAD_TYPE'last loop

	   Xt.SetValues (Warhead_Menu(DIS_Types.A_WARHEAD_TYPE'pos(
             Warhead_Index)).Item_Widget.all, Arglist, Argcount);

      end loop SETUP_WARHEAD_OPTION_MENU_ITEMS_LOOP;


      --
      -- Create the Warhead_Range_To_Damage text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Term.Warhead_Range_To_Damage := Xt.CreateManagedWidget (
	"Warhead_Range_To_Damage", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Term.Warhead_Range_To_Damage,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Warhead_Hard_Kill text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Term.Warhead_Hard_Kill := Xt.CreateManagedWidget (
	"Warhead_Hard_Kill", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Term.Warhead_Hard_Kill,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Max_Range text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Term.Max_Range := Xt.CreateManagedWidget ("Max_Range",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Term.Max_Range,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Fuze_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Fuze_Detonation_Proximity_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");
      Fuze_Height_Relative_To_Sea_Level_To_Detonate_Units_Label := 
	Motif_Utilities.Create_Label ( Main_Rowcolumn, "m");
      Fuze_Time_To_Detonation_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "sec");
      Warhead_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Warhead_Range_To_Damage_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");
      Warhead_Hard_Kill_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");
      Max_Range_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Fuze_Label,
	Help_Text_Widget   => Ord_Data.Description,
	Help_Text_Message  => K_Fuze_Help_String);
      Motif_Utilities.Install_Active_Help (Fuze_Detonation_Proximity_Label,
	Ord_Data.Description, K_Fuze_Detonation_Proximity_Help_String);
      Motif_Utilities.Install_Active_Help (
	Fuze_Height_Relative_To_Sea_Level_To_Detonate_Label,
	Ord_Data.Description,
	K_Fuze_Height_Relative_To_Sea_Level_To_Detonate_Help_String);
      Motif_Utilities.Install_Active_Help (Fuze_Time_To_Detonation_Label,
	Ord_Data.Description, K_Fuze_Time_To_Detonation_Help_String);
      Motif_Utilities.Install_Active_Help (Warhead_Label,
	Ord_Data.Description, K_Warhead_Help_String);
      Motif_Utilities.Install_Active_Help (Warhead_Range_To_Damage_Label,
	Ord_Data.Description, K_Warhead_Range_To_Damage_Help_String);
      Motif_Utilities.Install_Active_Help (Warhead_Hard_Kill_Label,
	Ord_Data.Description, K_Warhead_Hard_Kill_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Range_Label,
	Ord_Data.Description, K_Max_Range_Help_String);

      Motif_Utilities.Install_Active_Help (Ord_Data.Term.Fuze,
	Ord_Data.Description, K_Fuze_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Term.Fuze_Detonation_Proximity, Ord_Data.Description,
	K_Fuze_Detonation_Proximity_Help_String);
      Motif_Utilities.Install_Active_Help (
      Ord_Data.Term.Fuze_Height_Relative_To_Sea_Level_To_Detonate,
	Ord_Data.Description,
	K_Fuze_Height_Relative_To_Sea_Level_To_Detonate_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Term.Fuze_Time_To_Detonation,
	Ord_Data.Description, K_Fuze_Time_To_Detonation_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Term.Warhead,
	Ord_Data.Description, K_Warhead_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Term.Warhead_Range_To_Damage,
	Ord_Data.Description, K_Warhead_Range_To_Damage_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Term.Warhead_Hard_Kill,
	Ord_Data.Description, K_Warhead_Hard_Kill_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Term.Max_Range,
	Ord_Data.Description, K_Max_Range_Help_String);

   end if;  -- (Ord_Data.Term.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Ord_Data.Title, K_Panel_Title);
   Xt.ManageChild (Ord_Data.Term.Shell);
   Ord_Data.Parameter_Active_Hierarchy := Ord_Data.Term.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Ord_Panel_Term (Ord_Data.Term);
   end if;

end Create_Ord_Panel_Term;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/26/94   D. Forrest
--      - Initial version
--
-- --

