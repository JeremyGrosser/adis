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

with DIS_Types;
with Motif_Utilities;
with System;
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
-- UNIT NAME:          Create_Ord_Panel_Entity
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 9, 1994
--
-- PURPOSE:
--   This procedure displays the Entity Parameters Panel 
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
procedure Create_Ord_Panel_Entity(
   Parent      : in     Xt.WIDGET;
   Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title        : constant STRING :=
     "XOS Entity Parameters Input Screen";
   K_Arglist_Max        : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max         : constant INTEGER := 128; -- Max characters per string
   K_Entity_Parameters_Columns : constant INTEGER := 3; -- Columns of info 
   K_Indent             : constant STRING := "     ";

   --
   -- Create the constant help strings
   --
   K_Entity_Kind_Help_String : constant STRING :=
     "Please enter the entity kind.";
   K_Domain_Help_String : constant STRING :=
     "Please enter the entity domain.";
   K_Country_Help_String : constant STRING :=
     "Please enter the entity country (DIS number).";
   K_Category_Help_String : constant STRING :=
     "Please enter the entity category.";
   K_Subcategory_Help_String : constant STRING :=
     "Please enter the entity subcategory.";
   K_Specific_Help_String : constant STRING :=
     "Please enter the entity specific.";
   K_Extra_Help_String : constant STRING :=
     "Please enter the entity extra.";

   K_Capabilities_Help_String : constant STRING :=
     "Please enter the entity capabilities.";

   K_Paint_Help_String : constant STRING :=
     "Please enter the entity appearance paint code.";
   K_Mobility_Help_String : constant STRING :=
     "Please enter the entity appearance mobility code.";
   K_Fire_Power_Help_String : constant STRING :=
     "Please enter the entity appearance fire power code.";
   K_Damage_Help_String : constant STRING :=
     "Please enter the entity appearance damage code.";
   K_Smoke_Help_String : constant STRING :=
     "Please enter the entity appearance smoke code.";
   K_Trailing_Help_String : constant STRING :=
     "Please enter the entity appearance trailing code.";
   K_Hatch_Help_String : constant STRING :=
     "Please enter the entity appearance hatch code.";
   K_Lights_Help_String : constant STRING :=
     "Please enter the entity appearance lights code.";
   K_Flaming_Help_String : constant STRING :=
     "Please enter the entity appearance flaming code.";
   K_EA_Specific_Help_String : constant STRING :=
     "Please enter the entity appearance specific code.";

   K_Entity_Marking_Help_String : constant STRING :=
     "Please enter the entity marking code.";


   --
   -- Miscellaneous declarations
   --
   Arglist           : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount          : Xt.INT := 0;                    -- number of arguments
   Temp_String       : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString     : Xm.XMSTRING;                    -- Temporary X string
   Temp_Label        : Xt.WIDGET := Xt.XNULL;          -- Temporary Widget
   Do_Initialization : BOOLEAN;
   Number_Of_Columns : INTEGER := 12;  -- Number of columns in text widget.

   --
   -- Local widget declarations
   --
   Main_Rowcolumn              : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   Alternate_Entity_Type_Label : Xt.WIDGET := Xt.XNULL;
   Entity_Kind_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Domain_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Country_Label               : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Category_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Subcategory_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Specific_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Extra_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name

   Capabilities_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Name

   Entity_Appearance_Label     : Xt.WIDGET := Xt.XNULL;
   General_Label               : Xt.WIDGET := Xt.XNULL;
   Paint_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Mobility_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Fire_Power_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Damage_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Smoke_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Trailing_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Hatch_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Lights_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Flaming_Label               : Xt.WIDGET := Xt.XNULL; -- Parm Name
   EA_Specific_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Name

   Entity_Marking_Label        : Xt.WIDGET := Xt.XNULL; -- Parm Name

   --
   -- Option Menu Declarations
   --
   Entity_Kind_Menu : XOS_Types.XOS_ENTITY_KIND_OPTION_MENU_TYPE;
   Entity_Kind_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Entity_Kind_Pushbuttons : XOS_Types.XOS_ENTITY_KIND_PUSHBUTTON_ARRAY
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
   function ADDRESS_To_INTEGER
     is new Unchecked_Conversion (System.ADDRESS, INTEGER);

begin


   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Ord_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Ord_Data.Parameter_Active_Hierarchy);
   end if;

   if (Ord_Data.Entity.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Ord_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Ord_Data.Entity.Shell);
      Xt.ManageChild (Ord_Data.Entity.Shell);

   else -- (Ord_Data.Entity.Shell = Xt.XNULL)

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
	INTEGER(K_Entity_Parameters_Columns));
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
      Ord_Data.Entity.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Alternate_Entity_Type_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Alternate Entity Type");
      Entity_Kind_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Entity Kind");
      Domain_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Domain");
      Country_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Country");
      Category_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Category");
      Subcategory_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Subcategory");
      Specific_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Specific");
      Extra_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Extra");
      Capabilities_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Capabilities");
      Entity_Appearance_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Appearance");
      General_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "General");
      Paint_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Paint");
      Mobility_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Mobility");
      Fire_Power_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Fire Power");
      Damage_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Damage");
      Smoke_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Smoke");
      Trailing_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Trailing");
      Hatch_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Hatch");
      Lights_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Lights");
      Flaming_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & K_Indent & "Flaming");
      EA_Specific_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Specific");
      Entity_Marking_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Marking");

      --------------------------------------------------------------------
      --
      -- Create the user input widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the Entity_Type null label
      --
      Alternate_Entity_Type_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");

      --
      -- Create the Entity_Kind Option Menu Items
      --
      BUILD_ENTITY_KIND_OPTION_MENU_ITEMS_LOOP:
      for Entity_Kind_Index in
        DIS_Types.AN_ENTITY_KIND'first..DIS_Types.AN_ENTITY_KIND'last loop

           MOTIF_UTILITIES.Build_Menu_Item (
             label       => DIS_Types.AN_ENTITY_KIND'image(Entity_Kind_Index)
	       & "  ",
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
      Ord_Data.Entity.Entity_Kind := Entity_Kind_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Entity_Kind value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Alternate_Entity_Kind_Value'address);

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
      Ord_Data.Entity.Domain := Xt.CreateManagedWidget (
	"Domain", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Entity.Domain,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => 0,
--        OS_GUI.Interface.General_Parameters.Entity_Type.Domain'first,
--        The base type if ...Domain is Numeric_Types.UNSIGNED_8_BIT
        Maximum_Integer  => 255);
--        OS_GUI.Interface.General_Parameters.Entity_Type.Domain'last);


      --
      -- Create the Country text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Country := Xt.CreateManagedWidget (
	"Country", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Entity.Country,
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
      Ord_Data.Entity.Category := Xt.CreateManagedWidget ("Category",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Entity.Category,
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
      Ord_Data.Entity.Subcategory := Xt.CreateManagedWidget ("Subcategory",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Entity.Subcategory,
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
      Ord_Data.Entity.Specific := Xt.CreateManagedWidget ("Specific",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Entity.Specific,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => 0,
        Maximum_Integer  => 255);

      --
      -- Create the Extra text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Extra := Xt.CreateManagedWidget ("Extra",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Ord_Data.Entity.Extra,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => 0,
        Maximum_Integer  => 255);

      --
      -- Create the Capabilities text field
      --
      Number_Of_Columns := DIS_Types.AN_ENTITY_CAPABILITIES_RECORD'last
	- DIS_Types.AN_ENTITY_CAPABILITIES_RECORD'first + 1;
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Ncolumns, Number_Of_Columns);
      Ord_Data.Entity.Capabilities := Xt.CreateManagedWidget ("Capabilities",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Capabilities,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_BINARY,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Entity_Appearance null label
      --
      Entity_Appearance_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");

      --
      -- Create the General null label
      --
      General_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");

      --
      -- Create the Paint text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Paint := Xt.CreateManagedWidget ("Paint",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Paint,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Mobility text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Mobility := Xt.CreateManagedWidget ("Mobility",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Mobility,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Fire_Power text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Fire_Power := Xt.CreateManagedWidget ("Fire_Power",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Fire_Power,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Damage text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Damage := Xt.CreateManagedWidget ("Damage",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Damage,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Smoke text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Smoke := Xt.CreateManagedWidget ("Smoke",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Smoke,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Trailing text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Trailing := Xt.CreateManagedWidget ("Trailing",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Trailing,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Hatch text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Hatch := Xt.CreateManagedWidget ("Hatch",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Hatch,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Lights text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Lights := Xt.CreateManagedWidget ("Lights",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Lights,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Flaming text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.Flaming := Xt.CreateManagedWidget ("Flaming",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Flaming,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the EA_Specific text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Entity.EA_Specific := Xt.CreateManagedWidget ("EA_Specific",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Number_Of_Columns := 8;
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.EA_Specific,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_HEXADECIMAL,
        Characters_Count => Number_Of_Columns);

      --
      -- Create the Entity_Marking text field
      --
      Number_Of_Columns := DIS_Types.A_MARKING_SET'last
	- DIS_Types.A_MARKING_SET'first + 1;
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Ncolumns, Number_Of_Columns);
      Ord_Data.Entity.Entity_Marking := Xt.CreateManagedWidget (
        "Entity_Marking", Xm.TextFieldWidgetClass, Main_Rowcolumn,
          Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Ord_Data.Entity.Entity_Marking,
        Text_Type        => Motif_Utilities.TEXT_ANY,
        Characters_Count => Number_Of_Columns);

      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Alternate_Entity_Type_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Entity_Kind_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Domain_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      --
      -- Create the country name label, and assign the XOS_Text_Country_CB
      -- callback to the country textfield widget.
      --
      Ord_Data.Entity.Country_String := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Xt.AddCallback (Ord_Data.Entity.Country, Xmdef.NactivateCallback,
	XOS.Text_Country_CB'address, Ord_Data.Entity.Country_String);
      Xt.AddCallback (Ord_Data.Entity.Country, Xmdef.NlosingFocusCallback,
	XOS.Text_Country_CB'address, Ord_Data.Entity.Country_String);

      Category_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Subcategory_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Specific_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Extra_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Capabilities_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Entity_Appearance_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      General_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Paint_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Mobility_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Fire_Power_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Damage_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Smoke_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Trailing_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Hatch_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Lights_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Flaming_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      EA_Specific_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Entity_Marking_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Entity_Kind_Label,
	Help_Text_Widget   => Ord_Data.Description,
	Help_Text_Message  => K_Entity_Kind_Help_String);
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
      Motif_Utilities.Install_Active_Help (Extra_Label,
	Ord_Data.Description, K_Extra_Help_String);
      Motif_Utilities.Install_Active_Help (Capabilities_Label,
	Ord_Data.Description, K_Capabilities_Help_String);
      Motif_Utilities.Install_Active_Help (Paint_Label,
	Ord_Data.Description, K_Paint_Help_String);
      Motif_Utilities.Install_Active_Help (Mobility_Label,
	Ord_Data.Description, K_Mobility_Help_String);
      Motif_Utilities.Install_Active_Help (Fire_Power_Label,
	Ord_Data.Description, K_Fire_Power_Help_String);
      Motif_Utilities.Install_Active_Help (Damage_Label,
	Ord_Data.Description, K_Damage_Help_String);
      Motif_Utilities.Install_Active_Help (Smoke_Label,
	Ord_Data.Description, K_Smoke_Help_String);
      Motif_Utilities.Install_Active_Help (Trailing_Label,
	Ord_Data.Description, K_Trailing_Help_String);
      Motif_Utilities.Install_Active_Help (Hatch_Label,
	Ord_Data.Description, K_Hatch_Help_String);
      Motif_Utilities.Install_Active_Help (Lights_Label,
	Ord_Data.Description, K_Lights_Help_String);
      Motif_Utilities.Install_Active_Help (Flaming_Label,
	Ord_Data.Description, K_Flaming_Help_String);
      Motif_Utilities.Install_Active_Help (EA_Specific_Label,
	Ord_Data.Description, K_EA_Specific_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Marking_Label,
	Ord_Data.Description, K_Entity_Marking_Help_String);

      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Entity_Kind,
          Ord_Data.Description, K_Entity_Kind_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Domain,
          Ord_Data.Description, K_Domain_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Country,
	Ord_Data.Description, K_Country_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Category,
	Ord_Data.Description, K_Category_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Subcategory,
	Ord_Data.Description, K_Subcategory_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Specific,
	Ord_Data.Description, K_Specific_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Extra,
	Ord_Data.Description, K_Extra_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Capabilities,
	Ord_Data.Description, K_Capabilities_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Paint,
	Ord_Data.Description, K_Paint_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Mobility,
	Ord_Data.Description, K_Mobility_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Fire_Power,
	Ord_Data.Description, K_Fire_Power_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Damage,
	Ord_Data.Description, K_Damage_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Smoke,
	Ord_Data.Description, K_Smoke_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Trailing,
	Ord_Data.Description, K_Trailing_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Hatch,
	Ord_Data.Description, K_Hatch_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Lights,
	Ord_Data.Description, K_Lights_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Flaming,
	Ord_Data.Description, K_Flaming_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.EA_Specific,
	Ord_Data.Description, K_EA_Specific_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Entity.Entity_Marking,
	Ord_Data.Description, K_Entity_Marking_Help_String);

   end if; -- (Ord_Data.Entity.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Ord_Data.Title, K_Panel_Title);
   Xt.ManageChild (Ord_Data.Entity.Shell);
   Ord_Data.Parameter_Active_Hierarchy := Ord_Data.Entity.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Ord_Panel_Entity (Ord_Data.Entity);
   end if;

end Create_Ord_Panel_Entity;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/09/94   D. Forrest
--      - Initial version
--
-- --

