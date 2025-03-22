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
with OS_Data_Types;
with OS_GUI;
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
-- UNIT NAME:          Create_Ord_Panel_Gen
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 26, 1994
--
-- PURPOSE:
--   This procedure displays the Ordnance General Parameters Panel 
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
procedure Create_Ord_Panel_Gen(
   Parent      : in     Xt.WIDGET;
   Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title     : constant STRING :=
     "XOS General Parameters Input Screen";
   K_Arglist_Max     : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max      : constant INTEGER := 128; -- Max characters per string
   Do_Initialization : BOOLEAN;

   --
   -- Create the constant help strings
   --
   K_Dead_Reckoning_Algorithm_Help_String : constant STRING :=
     "Please enter the Dead Reckonging Algorithm.";
   K_Entity_Type_Help_String : constant STRING :=
     "Please enter the Entity Information below.";
   K_Entity_Kind_Help_String : constant STRING :=
     "Please select the Entity Kind.";
   K_Domain_Help_String : constant STRING :=
     "Please enter the Entity Domain.";
   K_Country_Help_String : constant STRING :=
     "Please select the Entity Country.";
   K_Category_Help_String : constant STRING :=
     "Please enter the Entity Category.";
   K_Subcategory_Help_String : constant STRING :=
     "Please enter the Entity Subcategory.";
   K_Specific_Help_String : constant STRING :=
     "Please enter the Entity Specific.";
   K_Fly_Out_Model_ID_Help_String : constant STRING :=
     "Please select the Fly-Out Model ID.";


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
   Main_Rowcolumn             : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   Dead_Reckoning_Algorithm_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Dead_Reckoning_Algorithm_Units_Label : Xt.WIDGET := Xt.XNULL;
     -- Parm Units label
   Entity_Type_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Entity_Type_Units_Label      : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Entity_Kind_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Entity_Kind_Units_Label      : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Domain_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Domain_Units_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Country_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Category_Label               : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Category_Units_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Subcategory_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Subcategory_Units_Label      : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Specific_Label               : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Specific_Units_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Fly_Out_Model_ID_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Fly_Out_Model_ID_Units_Label : Xt.WIDGET := Xt.XNULL; -- Parm Units label

   --
   -- Option Menu Declarations
   --
   Dead_Reckoning_Algorithm_Menu         :
     XOS_Types.XOS_DEAD_RECKONING_OPTION_MENU_TYPE;
   Dead_Reckoning_Algorithm_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Dead_Reckoning_Algorithm_Pushbuttons  :
     XOS_Types.XOS_DEAD_RECKONING_PUSHBUTTON_ARRAY
       := (OTHERS => new Xt.WIDGET'(Xt.XNULL));

   Entity_Kind_Menu         : XOS_Types.XOS_ENTITY_KIND_OPTION_MENU_TYPE;
   Entity_Kind_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Entity_Kind_Pushbuttons  : XOS_Types.XOS_ENTITY_KIND_PUSHBUTTON_ARRAY
     := (OTHERS => new Xt.WIDGET'(Xt.XNULL));

   Fly_Out_Model_ID_Menu         :
     XOS_Types.XOS_FLY_OUT_MODEL_ID_OPTION_MENU_TYPE;
   Fly_Out_Model_ID_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Fly_Out_Model_ID_Pushbuttons  :
     XOS_Types.XOS_FLY_OUT_MODEL_ID_PUSHBUTTON_ARRAY
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

   if (Ord_Data.Gen.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Ord_Data.Parameter_Scrolled_window,
        Xt.XNULL, Xt.XNULL, Ord_Data.Gen.Shell);
      Xt.ManageChild (Ord_Data.Gen.Shell);


   else -- (Ord_Data.Gen.Shell = Xt.XNULL)

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
	Xm.RowColumnWidgetClass, Ord_Data.Parameter_Scrolled_Window,
	Arglist, Argcount);
      Ord_Data.Gen.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Dead_Reckoning_Algorithm_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Dead Reckoning Algorithm");
      Entity_Type_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Information");
      Entity_Kind_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Entity Kind");
      Domain_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Domain");
      Country_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Country");
      Category_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Category");
      Subcategory_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Subcategory");
      Specific_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "   Specific");
      Fly_Out_Model_ID_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Fly-Out Model ID");

      --------------------------------------------------------------------
      --
      -- Create the user input widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the Dead_Reckoning_Algorithm Option Menu Items
      --
      BUILD_DEAD_RECKONING_ALGORITHM_OPTION_MENU_ITEMS_LOOP:
      for Dead_Reckoning_Algorithm_Index in
        DIS_Types.A_DEAD_RECKONING_ALGORITHM'first..
          DIS_Types.A_DEAD_RECKONING_ALGORITHM'last loop

	     MOTIF_UTILITIES.Build_Menu_Item (
	       label       => DIS_Types.A_DEAD_RECKONING_ALGORITHM'image(
                 Dead_Reckoning_Algorithm_Index) & "  ",
	       class       => Xm.PushButtonGadgetClass,
	       sensitive   => TRUE,
	       mnemonic    => ASCII.NUL,   -- 'P'
	       accelerator => "",          -- "Alt<Key>P"
	       accel_text  => "",          -- "Alt+P"
	       callback    => Motif_Utilities.Set_Integer_Value_CB'address,
	       cb_data     => INTEGER_To_XtPOINTER (
		 DIS_Types.A_DEAD_RECKONING_ALGORITHM'pos(
                   Dead_Reckoning_Algorithm_Index)),
	       subitems    => NULL,
	       Item_Widget => Dead_Reckoning_Algorithm_Pushbuttons(
                 Dead_Reckoning_Algorithm_Index),
	       menu_item   => Dead_Reckoning_Algorithm_Menu(
                 DIS_Types.A_DEAD_RECKONING_ALGORITHM'pos(
                   Dead_Reckoning_Algorithm_Index)));

      end loop BUILD_DEAD_RECKONING_ALGORITHM_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Dead_Reckoning_Algorithm option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Dead_Reckoning_Algorithm_Menu,
        return_widget    => Dead_Reckoning_Algorithm_Menu_Cascade);
      Xt.ManageChild (Dead_Reckoning_Algorithm_Menu_Cascade);
      Ord_Data.Gen.Dead_Reckoning_Algorithm
        := Dead_Reckoning_Algorithm_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Dead_Reckoning_Algorithm value 
      -- variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Dead_Reckoning_Algorithm_Value'address);

      SETUP_DEAD_RECKONING_ALGORITHM_OPTION_MENU_ITEMS_LOOP:
      for Dead_Reckoning_Algorithm_Index in
        DIS_Types.A_DEAD_RECKONING_ALGORITHM'first..
          DIS_Types.A_DEAD_RECKONING_ALGORITHM'last loop

             Xt.SetValues (Dead_Reckoning_Algorithm_Menu(
               DIS_Types.A_DEAD_RECKONING_ALGORITHM'pos(
                 Dead_Reckoning_Algorithm_Index)).Item_Widget.all,
                   Arglist, Argcount);

      end loop SETUP_DEAD_RECKONING_ALGORITHM_OPTION_MENU_ITEMS_LOOP;


      --
      -- Create the Entity_Type null label
      --
      Ord_Data.Gen.Entity_Type := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      --
      -- Create the Entity_Kind Option Menu Items
      --
      BUILD_ENTITY_KIND_OPTION_MENU_ITEMS_LOOP:
      for Entity_Kind_Index in
        DIS_Types.AN_ENTITY_KIND'first..DIS_Types.AN_ENTITY_KIND'last loop

           MOTIF_UTILITIES.Build_Menu_Item (
             label       =>
	       DIS_Types.AN_ENTITY_KIND'image(Entity_Kind_Index) & "  ",
             class       => Xm.PushButtonGadgetClass,
             sensitive   => TRUE,
             mnemonic    => ASCII.NUL,   -- 'P'
             accelerator => "",          -- "Alt<Key>P"
             accel_text  => "",          -- "Alt+P"
             callback    => Motif_Utilities.Set_Integer_Value_CB'address,
             cb_data     => INTEGER_To_XtPOINTER (
               DIS_Types.AN_ENTITY_KIND'pos(Entity_Kind_Index)),
             subitems    => NULL,
             Item_Widget => Entity_Kind_Pushbuttons(Entity_Kind_Index),
             menu_item   => Entity_Kind_Menu(DIS_Types.AN_ENTITY_KIND'pos(
               Entity_Kind_Index)));

      end loop BUILD_ENTITY_KIND_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Entity_Kind option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Entity_Kind_Menu,
        return_widget    => Entity_Kind_Menu_Cascade);
      Xt.ManageChild (Entity_Kind_Menu_Cascade);
      Ord_Data.Gen.Entity_Kind := Entity_Kind_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Entity_Kind value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Entity_Kind_Value'address);

      SETUP_ENTITY_KIND_OPTION_MENU_ITEMS_LOOP:
      for Entity_Kind_Index in
        DIS_Types.AN_ENTITY_KIND'first..DIS_Types.AN_ENTITY_KIND'last loop

             Xt.SetValues (Entity_Kind_Menu(DIS_Types.AN_ENTITY_KIND'pos(
               Entity_Kind_Index)).Item_Widget.all, Arglist, Argcount);

      end loop SETUP_ENTITY_KIND_OPTION_MENU_ITEMS_LOOP;


      --
      -- Create the Domain text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Gen.Domain := Xt.CreateManagedWidget ("Domain",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Gen.Domain,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => 0,
--	  OS_GUI.Interface.General_Parameters.Entity_Type.Domain'first,
--        The base type if ...Domain is Numeric_Types.UNSIGNED_8_BIT
        Maximum_Integer  => 255);
--	  OS_GUI.Interface.General_Parameters.Entity_Type.Domain'last);

      --
      -- Create the Country text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Gen.Country := Xt.CreateManagedWidget (
        "Country", Xm.TextFieldWidgetClass, Main_Rowcolumn,
          Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Gen.Country,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  =>
          DIS_Types.A_COUNTRY_ID'pos(DIS_Types.A_COUNTRY_ID'first),
        Maximum_Integer  =>
          DIS_Types.A_COUNTRY_ID'pos(DIS_Types.A_COUNTRY_ID'last));


      --
      -- Create the Category text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Gen.Category := Xt.CreateManagedWidget ("Category",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Gen.Category,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => 0,
        Maximum_Integer  => 255);

      --
      -- Create the Subcategory text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Gen.Subcategory := Xt.CreateManagedWidget ("Subcategory",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Gen.Subcategory,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => 0,
        Maximum_Integer  => 255);

      --
      -- Create the Specific text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Gen.Specific := Xt.CreateManagedWidget ("Specific",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Gen.Specific,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => 0,
        Maximum_Integer  => 255);

      --
      -- Create the Fly_Out_Model_ID Option Menu Items
      --
      BUILD_FLY_OUT_MODEL_ID_OPTION_MENU_ITEMS_LOOP:
      for Fly_Out_Model_ID_Index in
        OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'first..
          OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'last loop

	     MOTIF_UTILITIES.Build_Menu_Item (
	       label       => OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'image(
                 Fly_Out_Model_ID_Index) & "  ",
	       class       => Xm.PushButtonGadgetClass,
	       sensitive   => TRUE,
	       mnemonic    => ASCII.NUL,   -- 'P'
	       accelerator => "",          -- "Alt<Key>P"
	       accel_text  => "",          -- "Alt+P"
	       callback    => Motif_Utilities.Set_Integer_Value_CB'address,
	       cb_data     => INTEGER_To_XtPOINTER (
		 OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'pos(
                   Fly_Out_Model_ID_Index)),
	       subitems    => NULL,
	       Item_Widget => Fly_Out_Model_ID_Pushbuttons(
                 Fly_Out_Model_ID_Index),
	       menu_item   => Fly_Out_Model_ID_Menu(
                 OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'pos(
                   Fly_Out_Model_ID_Index)));

      end loop BUILD_FLY_OUT_MODEL_ID_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Fly_Out_Model_ID option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Fly_Out_Model_ID_Menu,
        return_widget    => Fly_Out_Model_ID_Menu_Cascade);
      Xt.ManageChild (Fly_Out_Model_ID_Menu_Cascade);
      Ord_Data.Gen.Fly_Out_Model_ID := Fly_Out_Model_ID_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Fly_Out_Model_ID value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Fly_Out_Model_ID_Value'address);

      SETUP_FLY_OUT_MODEL_ID_OPTION_MENU_ITEMS_LOOP:
      for Fly_Out_Model_ID_Index in
        OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'first..
          OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'last loop

             Xt.SetValues (Fly_Out_Model_ID_Menu(
               OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'pos(
                 Fly_Out_Model_ID_Index)).Item_Widget.all, Arglist, Argcount);

      end loop SETUP_FLY_OUT_MODEL_ID_OPTION_MENU_ITEMS_LOOP;



      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Dead_Reckoning_Algorithm_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Entity_Type_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Entity_Kind_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Domain_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      --
      -- Create the country name label, and assign the XOS_Text_Country_CB
      -- callback to the country textfield widget.
      --
      Ord_Data.Gen.Country_String := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");
      Xt.AddCallback (Ord_Data.Gen.Country, Xmdef.NactivateCallback,
        XOS.Text_Country_CB'address, Ord_Data.Gen.Country_String);
      Xt.AddCallback (Ord_Data.Gen.Country, Xmdef.NlosingFocusCallback,
        XOS.Text_Country_CB'address, Ord_Data.Gen.Country_String);


      Category_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Subcategory_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Specific_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Fly_Out_Model_ID_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Dead_Reckoning_Algorithm_Label,
	Help_Text_Widget   => Ord_Data.Description,
	Help_Text_Message  => K_Dead_Reckoning_Algorithm_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Type_Label,
	Ord_Data.Description, K_Entity_Type_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Kind_Label,
	Ord_Data.Description, K_Entity_Kind_Help_String);
      Motif_Utilities.Install_Active_Help (Domain_Label,
	Ord_Data.Description, K_Domain_Help_String);
      Motif_Utilities.Install_Active_Help (Country_Label,
	Ord_Data.Description, K_Country_Help_String);
      Motif_Utilities.Install_Active_Help (Category_Label,
	Ord_Data.Description, K_Category_Help_String);
      Motif_Utilities.Install_Active_Help (Subcategory_Label,
	Ord_Data.Description, K_Subcategory_Help_String);
      Motif_Utilities.Install_Active_Help (Specific_Label,
	Ord_Data.Description, K_Specific_Help_String);
      Motif_Utilities.Install_Active_Help (Fly_Out_Model_ID_Label,
	Ord_Data.Description, K_Fly_Out_Model_ID_Help_String);


      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Dead_Reckoning_Algorithm, Ord_Data.Description,
	K_Dead_Reckoning_Algorithm_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Entity_Type, Ord_Data.Description,
	K_Entity_Type_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Entity_Kind, Ord_Data.Description,
	K_Entity_Kind_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Domain, Ord_Data.Description, K_Domain_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Country, Ord_Data.Description, K_Country_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Category, Ord_Data.Description, K_Category_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Subcategory, Ord_Data.Description,
	K_Subcategory_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Specific, Ord_Data.Description, K_Specific_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Gen.Fly_Out_Model_ID, Ord_Data.Description,
	K_Fly_Out_Model_ID_Help_String);

   end if; -- (Ord_Data.Gen.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Ord_Data.Title, K_Panel_Title);
   Xt.ManageChild (Ord_Data.Gen.Shell);
   Ord_Data.Parameter_Active_Hierarchy := Ord_Data.Gen.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Ord_Panel_Gen (Ord_Data.Gen);
   end if;


end Create_Ord_Panel_Gen;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/26/94   D. Forrest
--      - Initial version
--
-- --

