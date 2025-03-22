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

with Motif_Utilities;
with OS_Data_Types;
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
-- UNIT NAME:          Create_Ord_Panel_Aero
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 26, 1994
--
-- PURPOSE:
--   This procedure displays the Ordnance Aerodynamic Parameters Panel 
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
procedure Create_Ord_Panel_Aero(
   Parent      : in     Xt.WIDGET;
   Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title     : constant STRING :=
     "XOS Aerodynamic Parameters Input Screen";
   K_Arglist_Max     : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max      : constant INTEGER := 128; -- Max characters per string
   Do_Initialization : BOOLEAN;

   --
   -- Create the constant help strings
   --
   K_Burn_Rate_Help_String : constant STRING :=
     "Please enter the Burn Rate.";
   K_Burn_Time_Help_String : constant STRING :=
     "Please enter the Burn Time.";
   K_Azimuth_Detection_Angle_Help_String : constant STRING :=
     "Please enter the Azimuth Detection Angle.";
   K_Elevation_Detection_Angle_Help_String : constant STRING :=
     "Please enter the Elevation Detection Angle.";
   K_Drag_Coefficients_Help_String : constant STRING :=
     "Please enter the Drag coefficient.";
   K_Frontal_Area_Help_String : constant STRING :=
     "Please enter the Frontal Area.";
   K_G_Gain_Help_String : constant STRING :=
     "Please enter the G Gain.";
   K_Guidance_Help_String : constant STRING :=
     "Please select the Guidance.";
   K_Illumination_Flag_Help_String : constant STRING :=
     "Please select the Illumination Flag.";
   K_Initial_Mass_Help_String : constant STRING :=
     "Please enter the Initial Mass.";
   K_Max_Gs_Help_String : constant STRING :=
     "Please enter the Max Gs.";
   K_Max_Speed_Help_String : constant STRING :=
     "Please enter the Max Speed.";
   K_Thrust_Help_String : constant STRING :=
     "Please enter the Thrust.";
   K_Laser_Code_Help_String : constant STRING :=
     "Please enter the Laser codLaser code.";

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
   Main_Rowcolumn                 : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   Burn_Rate_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Burn_Rate_Units_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Burn_Time_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Burn_Time_Units_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Azimuth_Detection_Angle_Label  : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Azimuth_Detection_Angle_Units_Label   : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Elevation_Detection_Angle_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Elevation_Detection_Angle_Units_Label : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Drag_Coefficient_Label         : array (
     OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range) of Xt.WIDGET
       := (OTHERS => Xt.XNULL); -- Parm Name
   Drag_Coefficient_Units_Label   : array (
     OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range) of Xt.WIDGET
       := (OTHERS => Xt.XNULL); -- Parm Units label
   Frontal_Area_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Frontal_Area_Units_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   G_Gain_Label                   : Xt.WIDGET := Xt.XNULL; -- Parm Name
   G_Gain_Units_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Guidance_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Guidance_Units_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Illumination_Flag_Label        : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Illumination_Flag_Units_Label  : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Initial_Mass_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Initial_Mass_Units_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Max_Gs_Label                   : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Max_Gs_Units_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Max_Speed_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Max_Speed_Units_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Thrust_Label                   : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Thrust_Units_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Laser_Code_Label               : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Laser_Code_Units_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Units label

   --
   -- Option Menu Declarations
   --
   Guidance_Menu         : XOS_Types.XOS_GUIDANCE_OPTION_MENU_TYPE;
   Guidance_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Guidance_Pushbuttons  : XOS_Types.XOS_GUIDANCE_PUSHBUTTON_ARRAY
     := (OTHERS => new Xt.WIDGET'(Xt.XNULL));

   Illumination_Menu         : XOS_Types.XOS_ILLUMINATION_OPTION_MENU_TYPE;
   Illumination_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Illumination_Pushbuttons  : XOS_Types.XOS_ILLUMINATION_PUSHBUTTON_ARRAY
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

   if (Ord_Data.Aero.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Ord_Data.Parameter_Scrolled_Window,
	  Xt.XNULL, Xt.XNULL, Ord_Data.Aero.Shell);
      Xt.ManageChild (Ord_Data.Aero.Shell);

   else -- (Ord_Data.Aero.Shell = Xt.XNULL)

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
      Ord_Data.Aero.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Burn_Rate_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Burn Rate");
      Burn_Time_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Burn Time");
      Azimuth_Detection_Angle_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Azimuth Detection Angle");
      Elevation_Detection_Angle_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Elevation Detection Angle");
      for Counter in OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range loop
	 Drag_Coefficient_Label(Counter) := Motif_Utilities.Create_Label (
	   Main_Rowcolumn, "Drag Coefficient" & INTEGER'image (Counter));
      end loop;
      Frontal_Area_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Frontal Area");
      G_Gain_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "G Gain");
      Guidance_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Guidance");
      Illumination_Flag_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Illumination Flag");
      Initial_Mass_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Initial Mass");
      Max_Gs_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Max Gs");

      Max_Speed_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Max Speed");
      --
      -- This parameter is not needed by the original ADIS Fly-out models,
      -- and so is made insensitive...
      --
      Xt.SetSensitive (Max_Speed_Label, FALSE);

      Thrust_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Thrust");
      Laser_Code_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Laser Code");


      --------------------------------------------------------------------
      --
      -- Create the text fields
      --
      --------------------------------------------------------------------
      --
	 -- Create the Burn_Rate text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Burn_Rate := Xt.CreateManagedWidget ("Burn Rate",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Burn_Rate,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Burn_Time text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Burn_Time := Xt.CreateManagedWidget ("Burn Time",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Burn_Time,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Azimuth_Detection_Angle text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Azimuth_Detection_Angle := Xt.CreateManagedWidget (
	"Azimuth Detection Angle", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Azimuth_Detection_Angle,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Elevation_Detection_Angle text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Elevation_Detection_Angle := Xt.CreateManagedWidget (
	"Elevation Detection Angle", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Elevation_Detection_Angle,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Drag text fields
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      for Counter in OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range loop
	 Ord_Data.Aero.Drag_Coefficients(Counter) := Xt.CreateManagedWidget (
	    "Drag", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	      Arglist, Argcount);
	 Motif_Utilities.Install_Text_Restrictions(
	   Parent           => Ord_Data.Aero.Drag_Coefficients(Counter),
	   Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	   Characters_Count => INTEGER'last);
      end loop;

      --
      -- Create the Frontal_Area text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Frontal_Area := Xt.CreateManagedWidget ("Frontal Area",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Frontal_Area,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the G_Gain text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.G_Gain := Xt.CreateManagedWidget ("G Gain",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.G_Gain,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Guidance Option Menu Items
      --
      BUILD_GUIDANCE_OPTION_MENU_ITEMS_LOOP:
      for Guidance_Index in
	OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'first..
	  OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'last loop

             MOTIF_UTILITIES.Build_Menu_Item (
               label       =>
                 OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'image(
                   Guidance_Index) & "  ",
               class       => Xm.PushButtonGadgetClass,
               sensitive   => TRUE,
               mnemonic    => ASCII.NUL,   -- 'P'
               accelerator => "",          -- "Alt<Key>P"
               accel_text  => "",          -- "Alt+P"
               callback    => Motif_Utilities.Set_Integer_Value_CB'address,
               cb_data     => INTEGER_To_XtPOINTER (
                 OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'pos(
                   Guidance_Index)),
               subitems    => NULL,
               Item_Widget => Guidance_Pushbuttons(Guidance_Index),
               menu_item   => Guidance_Menu(OS_Data_Types.
                 GUIDANCE_MODEL_IDENTIFIER'pos(Guidance_Index)));

      end loop BUILD_GUIDANCE_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Guidance option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Guidance_Menu,
        return_widget    => Guidance_Menu_Cascade);
      Xt.ManageChild (Guidance_Menu_Cascade);
      Ord_Data.Aero.Guidance := Guidance_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Guidance value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Guidance_Value'address);

      SETUP_GUIDANCE_OPTION_MENU_ITEMS_LOOP:
      for Guidance_Index in
        OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'first..
          OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'last loop

             Xt.SetValues (Guidance_Menu(
               OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'pos(
                 Guidance_Index)).Item_Widget.all, Arglist, Argcount);

      end loop SETUP_GUIDANCE_OPTION_MENU_ITEMS_LOOP;



      --
      -- Create the Illumination Flag Option Menu Items
      --
      BUILD_ILLUMINATION_OPTION_MENU_ITEMS_LOOP:
      for Illumination_Index in
	OS_Data_Types.ILLUMINATION_IDENTIFIER'first..
	  OS_Data_Types.ILLUMINATION_IDENTIFIER'last loop

             MOTIF_UTILITIES.Build_Menu_Item (
               label       =>
                 OS_Data_Types.ILLUMINATION_IDENTIFIER'image(
                   Illumination_Index) & "  ",
               class       => Xm.PushButtonGadgetClass,
               sensitive   => TRUE,
               mnemonic    => ASCII.NUL,   -- 'P'
               accelerator => "",          -- "Alt<Key>P"
               accel_text  => "",          -- "Alt+P"
               callback    => Motif_Utilities.Set_Integer_Value_CB'address,
               cb_data     => INTEGER_To_XtPOINTER (
                 OS_Data_Types.ILLUMINATION_IDENTIFIER'pos(
                   Illumination_Index)),
               subitems    => NULL,
               Item_Widget => Illumination_Pushbuttons(Illumination_Index),
               menu_item   => Illumination_Menu(OS_Data_Types.
                 ILLUMINATION_IDENTIFIER'pos(Illumination_Index)));

      end loop BUILD_ILLUMINATION_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Illumination option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Illumination_Menu,
        return_widget    => Illumination_Menu_Cascade);
      Xt.ManageChild (Illumination_Menu_Cascade);
      Ord_Data.Aero.Illumination_Flag := Illumination_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Illumination value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Illumination_Flag_Value'address);

      SETUP_ILLUMINATION_OPTION_MENU_ITEMS_LOOP:
      for Illumination_Index in
        OS_Data_Types.ILLUMINATION_IDENTIFIER'first..
          OS_Data_Types.ILLUMINATION_IDENTIFIER'last loop

             Xt.SetValues (Illumination_Menu(
               OS_Data_Types.ILLUMINATION_IDENTIFIER'pos(
                 Illumination_Index)).Item_Widget.all, Arglist, Argcount);

      end loop SETUP_ILLUMINATION_OPTION_MENU_ITEMS_LOOP;


      --
      -- Create the Initial_Mass text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Initial_Mass := Xt.CreateManagedWidget ("Initial Mass",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Initial_Mass,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Max_Gs text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Max_Gs := Xt.CreateManagedWidget ("Max Gs",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Max_Gs,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Max_Speed text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Max_Speed := Xt.CreateManagedWidget ("Max Speed",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Max_Speed,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);
      --
      -- This parameter is not needed by the original ADIS Fly-out models,
      -- and so is made insensitive...
      --
      Xt.SetSensitive (Ord_Data.Aero.Max_Speed, FALSE);

      --
      -- Create the Thrust text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Thrust := Xt.CreateManagedWidget ("Thrust",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Thrust,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
	Characters_Count => INTEGER'last);

      --
      -- Create the Laser Code text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Ord_Data.Aero.Laser_Code := Xt.CreateManagedWidget ("Laser Code",
	Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Ord_Data.Aero.Laser_Code,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
	Characters_Count => INTEGER'last);

      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Burn_Rate_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "kg/sec");
      Burn_Time_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "sec");
      Azimuth_Detection_Angle_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "deg");
      Elevation_Detection_Angle_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "deg");

      for Counter in OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range loop
	  Drag_Coefficient_Units_Label(Counter)
	    := Motif_Utilities.Create_Label (Main_Rowcolumn, "");
      end loop;

      Frontal_Area_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m2");
      G_Gain_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Guidance_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Illumination_Flag_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Initial_Mass_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "kg");
      Max_Gs_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Max_Speed_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m/sec");
      Thrust_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "N");
      Laser_Code_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");


      --------------------------------------------------------------------
      --
      -- Install the ActiveHelp.
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Burn_Rate_Label,
	Help_Text_Widget   => Ord_Data.Description,
	Help_Text_Message  => K_Burn_Rate_Help_String);
      Motif_Utilities.Install_Active_Help (Burn_Time_Label,
	Ord_Data.Description, K_Burn_Time_Help_String);
      Motif_Utilities.Install_Active_Help (Azimuth_Detection_Angle_Label,
	Ord_Data.Description, K_Azimuth_Detection_Angle_Help_String);
      Motif_Utilities.Install_Active_Help (Elevation_Detection_Angle_Label,
	Ord_Data.Description, K_Elevation_Detection_Angle_Help_String);

      for Counter in OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range loop
	 Motif_Utilities.Install_Active_Help (Drag_Coefficient_Label(Counter),
	   Ord_Data.Description, K_Drag_Coefficients_Help_String);
      end loop;

      Motif_Utilities.Install_Active_Help (Frontal_Area_Label,
	Ord_Data.Description, K_Frontal_Area_Help_String);
      Motif_Utilities.Install_Active_Help (G_Gain_Label,
	Ord_Data.Description, K_G_Gain_Help_String);
      Motif_Utilities.Install_Active_Help (Guidance_Label,
	Ord_Data.Description, K_Guidance_Help_String);
      Motif_Utilities.Install_Active_Help (Illumination_Flag_Label,
	Ord_Data.Description, K_Illumination_Flag_Help_String);
      Motif_Utilities.Install_Active_Help (Initial_Mass_Label,
	Ord_Data.Description, K_Initial_Mass_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Gs_Label,
	Ord_Data.Description, K_Max_Gs_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Speed_Label,
	Ord_Data.Description, K_Max_Speed_Help_String);
      Motif_Utilities.Install_Active_Help (Thrust_Label,
	Ord_Data.Description, K_Thrust_Help_String);
      Motif_Utilities.Install_Active_Help (Laser_Code_Label,
	Ord_Data.Description, K_Laser_Code_Help_String);

      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Burn_Rate,
	Ord_Data.Description, K_Burn_Rate_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Burn_Time,
	Ord_Data.Description, K_Burn_Time_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Aero.Azimuth_Detection_Angle,
	Ord_Data.Description, K_Azimuth_Detection_Angle_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Aero.Elevation_Detection_Angle,
	Ord_Data.Description, K_Elevation_Detection_Angle_Help_String);

      for Counter in OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range loop
	 Motif_Utilities.Install_Active_Help (
	   Ord_Data.Aero.Drag_Coefficients(Counter),
	     Ord_Data.Description, K_Drag_Coefficients_Help_String);
      end loop;

      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Frontal_Area,
	Ord_Data.Description, K_Frontal_Area_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.G_Gain,
	Ord_Data.Description, K_G_Gain_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Guidance,
	Ord_Data.Description, K_Guidance_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Illumination_Flag,
	Ord_Data.Description, K_Illumination_Flag_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Initial_Mass,
	Ord_Data.Description, K_Initial_Mass_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Max_Gs,
	Ord_Data.Description, K_Max_Gs_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Max_Speed,
	Ord_Data.Description, K_Max_Speed_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Thrust,
        Ord_Data.Description, K_Thrust_Help_String);
      Motif_Utilities.Install_Active_Help (Ord_Data.Aero.Laser_Code,
        Ord_Data.Description, K_Laser_Code_Help_String);

   end if; -- (Ord_Data.Aero.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Ord_Data.Title, K_Panel_Title);
   Xt.ManageChild (Ord_Data.Aero.Shell);
   Ord_Data.Parameter_Active_Hierarchy := Ord_Data.Aero.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Ord_Panel_Aero (Ord_Data.Aero);
   end if;

end Create_Ord_Panel_Aero;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/26/94   D. Forrest
--      - Initial version
--
-- --

