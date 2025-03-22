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
with OS_GUI;
with OS_Simulation_Types;
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
-- UNIT NAME:          Create_Sim_Panel_Sim
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 18, 1994
--
-- PURPOSE:
--   This procedure displays the Simulation Parameters Panel under the
--   passed widget hierarchy.
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
procedure Create_Sim_Panel_Sim(
   Parent      : in     Xt.WIDGET;
   Sim_Data    : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title     : constant STRING :=
     "XOS Simulation Parameters Input Screen";
   K_Arglist_Max     : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max      : constant INTEGER := 128; -- Max characters per string
   Do_Initialization : BOOLEAN;

   --
   -- Create the constant help strings
   --
   K_Simulation_State_Help_String : constant STRING :=
     "Operation state of the simulation.";
   K_Contact_Threshold_Help_String : constant STRING :=
     "Radius of buffer about a point to be equivalent to making contact.";
   K_Cycle_Time_Help_String : constant STRING :=
     "Length of one timeslice of processing.";
   K_DB_Origin_Latitude_Help_String : constant STRING :=
     "Origin of database (Latitude).";
   K_DB_Origin_Longitude_Help_String : constant STRING :=
     "Origin of database (Longitude).";
   K_DB_Origin_Altitude_Help_String : constant STRING :=
     "Origin of database (Altitude).";
   K_DB_Origin_X_WC_Help_String : constant STRING :=
     "The database origin X value in world coordinates.";
   K_DB_Origin_Y_WC_Help_String : constant STRING :=
     "The database origin Y value in world coordinates.";
   K_DB_Origin_Z_WC_Help_String : constant STRING :=
     "The database origin Z value in world coordinates.";
   K_Exercise_ID_Help_String : constant STRING :=
     "Identifier for the simulation exercise.";
   K_Hash_Table_Increment_Help_String : constant STRING :=
     "Increment for traversing the hash table in the event of a collision.";
   K_Hash_Table_Size_Help_String : constant STRING :=
     "Maximum number of entities in the hash table " 
       & "(should be a prime number, ie, 13 or 1033).";
   K_ModSAF_Database_Filename_Help_String : constant STRING :=
     "Name of the file in ModSAF containing the database to be accessed "
       & "for terrain data.";
   K_Memory_Limit_For_ModSAF_File_Help_String : constant STRING :=
     "Maximum amount of memory required to store the terrain database.";
   K_Number_Of_Loops_Until_Update_Help_String : constant STRING :=
     "Number of timeslices before a complete search"
       & "of all entities is performed relative to each munition.";
   K_Parent_Entity_ID_Sim_Address_Site_ID_Help_String : constant STRING :=
     "Site ID of entity whose munitions are maintained by the OS.";
   K_Parent_Entity_ID_Sim_Address_Application_ID_Help_String :
     constant STRING :=
       "App ID of entity whose munitions are maintained by the OS.";
   K_Parent_Entity_ID_Entity_ID_Help_String : constant STRING :=
     "Entity ID of entity whose munitions are maintained by the OS.";
   K_Protocol_Version_Help_String : constant STRING :=
     "Version of the DIS Standard Protocol implemented.";


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
   Main_Rowcolumn                           : Xt.WIDGET := Xt.XNULL;
   Simulation_State_Label                   : Xt.WIDGET := Xt.XNULL;
   Simulation_State_Units_Label             : Xt.WIDGET := Xt.XNULL;
   Contact_Threshold_Label                  : Xt.WIDGET := Xt.XNULL;
   Contact_Threshold_Units_Label            : Xt.WIDGET := Xt.XNULL;
   Cycle_Time_Label                         : Xt.WIDGET := Xt.XNULL;
   Cycle_Time_Units_Label                   : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Latitude_Label                 : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Latitude_Units_Label           : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Longitude_Label                : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Longitude_Units_Label          : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Altitude_Label                 : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Altitude_Units_Label           : Xt.WIDGET := Xt.XNULL;
   DB_Origin_X_WC_Label              : Xt.WIDGET := Xt.XNULL;
   DB_Origin_X_WC_Units_Label        : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Y_WC_Label             : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Y_WC_Units_Label       : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Z_WC_Label              : Xt.WIDGET := Xt.XNULL;
   DB_Origin_Z_WC_Units_Label        : Xt.WIDGET := Xt.XNULL;
   Exercise_ID_Label                        : Xt.WIDGET := Xt.XNULL;
   Exercise_ID_Units_Label                  : Xt.WIDGET := Xt.XNULL;
   Hash_Table_Increment_Label               : Xt.WIDGET := Xt.XNULL;
   Hash_Table_Increment_Units_Label         : Xt.WIDGET := Xt.XNULL;
   Hash_Table_Size_Label                    : Xt.WIDGET := Xt.XNULL;
   Hash_Table_Size_Units_Label              : Xt.WIDGET := Xt.XNULL;
   ModSAF_Database_Filename_Label           : Xt.WIDGET := Xt.XNULL;
   ModSAF_Database_Filename_Units_Label     : Xt.WIDGET := Xt.XNULL;
   Memory_Limit_For_ModSAF_File_Label       : Xt.WIDGET := Xt.XNULL;
   Memory_Limit_For_ModSAF_File_Units_Label : Xt.WIDGET := Xt.XNULL;
   Number_Of_Loops_Until_Update_Label       : Xt.WIDGET := Xt.XNULL;
   Number_Of_Loops_Until_Update_Units_Label : Xt.WIDGET := Xt.XNULL;
   Parent_Entity_ID_Sim_Address_Site_ID_Label        : Xt.WIDGET := Xt.XNULL;
   Parent_Entity_ID_Sim_Address_Site_ID_Units_Label  : Xt.WIDGET := Xt.XNULL;
   Parent_Entity_ID_Sim_Address_Application_ID_Label : Xt.WIDGET := Xt.XNULL;
   Parent_Entity_ID_Sim_Address_Application_ID_Units_Label : Xt.WIDGET
     := Xt.XNULL;
   Parent_Entity_ID_Entity_ID_Label         : Xt.WIDGET := Xt.XNULL;
   Parent_Entity_ID_Entity_ID_Units_Label   : Xt.WIDGET := Xt.XNULL;
   Protocol_Version_Label                   : Xt.WIDGET := Xt.XNULL;
   Protocol_Version_Units_Label             : Xt.WIDGET := Xt.XNULL;

   
   --
   -- Option Menu Declarations
   --
   Simulation_State_Menu         :
     XOS_Types.XOS_SIMULATION_STATE_OPTION_MENU_TYPE;
   Simulation_State_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Simulation_State_Pushbuttons  :
     XOS_Types.XOS_SIMULATION_STATE_PUSHBUTTON_ARRAY
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

   function XOS_SIM_PARM_DATA_REC_PTR_to_XtPointer is new
     Unchecked_Conversion (Source => XOS_Types.XOS_SIM_PARM_DATA_REC_PTR,
			   Target => Xt.POINTER);
begin


   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Sim_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Sim_Data.Parameter_Active_Hierarchy);
   end if;

   if (Sim_Data.Sim.Shell /= Xt.XNULL) then
      
      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Sim_Data.Parameter_Scrolled_Window,
	Xt.XNULL, Xt.XNULL, Sim_Data.Sim.Shell);
      Xt.ManageChild (Sim_Data.Sim.Shell);

   else -- (Sim_Data.Sim.Shell = Xt.XNULL)

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
        Xm.RowColumnWidgetClass, Sim_Data.Parameter_Scrolled_Window,
        Arglist, Argcount);
      Sim_Data.Sim.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Simulation_State_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Simulation State");
      Contact_Threshold_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Contact Threshold");
      Cycle_Time_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Cycle Time");
      DB_Origin_Latitude_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "DB Origin: Latitude");
      DB_Origin_Longitude_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "DB Origin: Longitude");
      DB_Origin_Altitude_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "DB Origin: Altitude");
      DB_Origin_X_WC_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "  X (World Coordinates)");
      DB_Origin_Y_WC_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "  Y (World Coordinates)");
      DB_Origin_Z_WC_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "  Z (World Coordinates)");
      Exercise_ID_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Exercise ID");
      Hash_Table_Increment_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Hash Table Increment");
      Hash_Table_Size_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Hash Table Size");
      ModSAF_Database_Filename_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "ModSAF Database Filename");
      Memory_Limit_For_ModSAF_File_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Memory Limit for ModSAF File");
      Number_Of_Loops_Until_Update_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Number of Loops until Update");
      Parent_Entity_ID_Sim_Address_Site_ID_Label
	:= Motif_Utilities.Create_Label (Main_Rowcolumn, "Parent Site ID");
      Parent_Entity_ID_Sim_Address_Application_ID_Label
	:= Motif_Utilities.Create_Label (Main_Rowcolumn, 
	  "Parent Application ID");
      Parent_Entity_ID_Entity_ID_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Parent Entity ID");
      Protocol_Version_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "Protocol Version");

      --------------------------------------------------------------------
      --
      -- Create the data entry widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the Simulation State option menu
      --
      BUILD_SIMULATION_STATE_OPTION_MENU_ITEMS_LOOP:
      for Simulation_State_Index in 
	OS_Simulation_Types.SIMULATION_STATE_TYPE'first..
          OS_Simulation_Types.SIMULATION_STATE_TYPE'last loop

	     MOTIF_UTILITIES.Build_Menu_Item (
	       label       =>
	         OS_Simulation_Types.SIMULATION_STATE_TYPE'image(
		   Simulation_State_Index) & "  ",
	       class       => Xm.PushButtonGadgetClass,
	       sensitive   => TRUE,
	       mnemonic    => ASCII.NUL,   -- 'P'
	       accelerator => "",          -- "Alt<Key>P"
	       accel_text  => "",          -- "Alt+P"
	       callback    => Motif_Utilities.Set_Integer_Value_CB'address,
	       cb_data     => INTEGER_To_XtPOINTER (
                 OS_Simulation_Types.SIMULATION_STATE_TYPE'pos(
		   Simulation_State_Index)),
	       subitems    => NULL,
	       Item_Widget => Simulation_State_Pushbuttons(
		 Simulation_State_Index),
	       menu_item   => Simulation_State_Menu(OS_Simulation_Types.
	         SIMULATION_STATE_TYPE'pos(Simulation_State_Index)));
       
      end loop BUILD_SIMULATION_STATE_OPTION_MENU_ITEMS_LOOP;


      --
      -- Create the Simulation State option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
        parent           => Main_Rowcolumn,
        menu_type        => Xm.MENU_OPTION,
        menu_title       => "",
        menu_mnemonic    => ASCII.NUL,
        menu_sensitivity => TRUE,
        items            => Simulation_State_Menu,
        return_widget    => Simulation_State_Menu_Cascade);
      Xt.ManageChild (Simulation_State_Menu_Cascade);
      Sim_Data.Sim.Simulation_State := Simulation_State_Menu_Cascade;

      --
      -- Set up userData resource of each option menu pushbutton to
      -- hold the address of the Simulation_State value variable to be set.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XOS.Simulation_State_Value'address);

      SETUP_SIMULATION_STATE_OPTION_MENU_ITEMS_LOOP:
      for Simulation_State_Index in 
	OS_Simulation_Types.SIMULATION_STATE_TYPE'first..
          OS_Simulation_Types.SIMULATION_STATE_TYPE'last loop

             Xt.SetValues (Simulation_State_Menu(OS_Simulation_Types.
	       SIMULATION_STATE_TYPE'pos(Simulation_State_Index))
                 .Item_Widget.all, Arglist, Argcount);

      end loop SETUP_SIMULATION_STATE_OPTION_MENU_ITEMS_LOOP;

      --
      -- Create the Contact Threshold text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Contact_Threshold := Xt.CreateManagedWidget (
        "Contact_Threshold", Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist,
        Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.Contact_Threshold,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Cycle Time label
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Cycle_Time := Xt.CreateManagedWidget (
        "Cycle_Time", Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist,
        Argcount);
      Motif_Utilities.Install_Text_Restrictions(
        Parent           => Sim_Data.Sim.Cycle_Time,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Database Origin Latitude text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.DB_Origin_Latitude := Xt.CreateManagedWidget (
        "DB_Origin_Latitude", Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist,
        Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.DB_Origin_Latitude,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Database Origin Longitude text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.DB_Origin_Longitude := Xt.CreateManagedWidget (
        "DB_Origin_Longitude", Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist,
        Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.DB_Origin_Longitude,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Database Origin Altitude text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.DB_Origin_Altitude := Xt.CreateManagedWidget (
        "DB_Origin_Altitude", Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist,
        Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.DB_Origin_Altitude,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Database Origin Latitude (World Coordinates) label widget
      --
      Sim_Data.Sim.DB_Origin_X_WC := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");

      --
      -- Create the Database Origin Longitude (World Coordinates) label widget
      --
      Sim_Data.Sim.DB_Origin_Y_WC := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");

      --
      -- Create the Database Origin Altitude (World Coordinates) label widget
      --
      Sim_Data.Sim.DB_Origin_Z_WC := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");

      --
      -- Create the Exercise ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Exercise_ID := Xt.CreateManagedWidget ("Exercise_ID",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.Exercise_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Hash Table Increment text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Hash_Table_Increment := Xt.CreateManagedWidget (
        "Hash_Table_Increment", Xm.TextFieldWidgetClass, Main_Rowcolumn,
          Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.Hash_Table_Increment,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER,
        Characters_Count => INTEGER'last);

      --
      -- Create the Hash Table Size text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Hash_Table_Size := Xt.CreateManagedWidget ("Hash_Table_Size",
        Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.Hash_Table_Size,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER,
        Characters_Count => INTEGER'last);
   
      --
      -- Create the ModSAF Database Filename text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.ModSAF_Database_Filename := Xt.CreateManagedWidget (
	"ModSAF_Database_Filename", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.ModSAF_Database_Filename,
        Text_Type        => Motif_Utilities.TEXT_ANY,
        Characters_Count => OS_GUI.Interface.Simulation_Parameters.
	  ModSAF_Database_Filename'length);
	--Characters_Count => 80);

      --
      -- Create the Memory Limit for ModSAF File text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Memory_Limit_For_ModSAF_File := Xt.CreateManagedWidget (
	"Memory_Limit_For_ModSAF_File", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.Memory_Limit_For_ModSAF_File,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Number of Loops until Update text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Number_Of_Loops_Until_Update := Xt.CreateManagedWidget (
	"Number_Of_Loops_Until_Update", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range (
        Parent           => Sim_Data.Sim.Number_Of_Loops_Until_Update,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER,
        Characters_Count => INTEGER'last,
	Minimum_Integer  => 1,
	Maximum_Integer  => INTEGER'last);

      --
      -- Create the Parent Entity ID Sim Address Site_ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Parent_Entity_ID_Sim_Address_Site_ID
	:= Xt.CreateManagedWidget ("Parent_Entity_ID_Sim_Address_Site_ID",
	  Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.Parent_Entity_ID_Sim_Address_Site_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Parent Entity ID Sim Address Application_ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Parent_Entity_ID_Sim_Address_Application_ID
	:= Xt.CreateManagedWidget (
	  "Parent_Entity_ID_Sim_Address_Application_ID", 
	    Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
	  Sim_Data.Sim.Parent_Entity_ID_Sim_Address_Application_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Parent Entity ID Entity_ID text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Sim_Data.Sim.Parent_Entity_ID_Entity_ID := Xt.CreateManagedWidget (
	"Parent_Entity_ID_Entity_ID", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Sim_Data.Sim.Parent_Entity_ID_Entity_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Protocol Version label widget
      --
      Sim_Data.Sim.Protocol_Version := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "2.0.3");


      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Simulation_State_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");
      Contact_Threshold_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "m");
      Cycle_Time_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "sec");
      DB_Origin_Latitude_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "deg");
      DB_Origin_Longitude_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "deg");
      DB_Origin_Altitude_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "m");
      DB_Origin_X_WC_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "m");
      DB_Origin_Y_WC_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "m");
      DB_Origin_Z_WC_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "m");
      Exercise_ID_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");
      Hash_Table_Increment_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");
      Hash_Table_Size_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");
      ModSAF_Database_Filename_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");
      Memory_Limit_For_ModSAF_File_Units_Label
	:= Motif_Utilities.Create_Label (Main_Rowcolumn, "");
      Number_Of_Loops_Until_Update_Units_Label
	:= Motif_Utilities.Create_Label (Main_Rowcolumn, "");
      Parent_Entity_ID_Sim_Address_Site_ID_Units_Label
	:= Motif_Utilities.Create_Label (Main_Rowcolumn, "");
      Parent_Entity_ID_Sim_Address_Application_ID_Units_Label
	:= Motif_Utilities.Create_Label (Main_Rowcolumn, "");
      Parent_Entity_ID_Entity_ID_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");
      Protocol_Version_Units_Label := Motif_Utilities.Create_Label (
        Main_Rowcolumn, "");


      --------------------------------------------------------------------
      --
      -- Add the Database Origin to World Coordinates conversion callbacks
      -- to the Database Origin text field widgets.
      --
      --------------------------------------------------------------------
      Xt.AddCallback(Sim_Data.Sim.DB_Origin_Latitude,
	Xmdef.NactivateCallback, XOS.Sim_World_Coord_CB'address, 
	  XOS_SIM_PARM_DATA_REC_PTR_to_XtPointer(Sim_Data));
      Xt.AddCallback(Sim_Data.Sim.DB_Origin_Latitude,
	Xmdef.NlosingFocusCallback, XOS.Sim_World_Coord_CB'address,
	  XOS_SIM_PARM_DATA_REC_PTR_to_XtPointer(Sim_Data));

      Xt.AddCallback(Sim_Data.Sim.DB_Origin_Longitude,
	Xmdef.NactivateCallback, XOS.Sim_World_Coord_CB'address, 
	  XOS_SIM_PARM_DATA_REC_PTR_to_XtPointer(Sim_Data));
      Xt.AddCallback(Sim_Data.Sim.DB_Origin_Longitude,
	Xmdef.NlosingFocusCallback, XOS.Sim_World_Coord_CB'address,
	  XOS_SIM_PARM_DATA_REC_PTR_to_XtPointer(Sim_Data));

      Xt.AddCallback(Sim_Data.Sim.DB_Origin_Altitude,
	Xmdef.NactivateCallback, XOS.Sim_World_Coord_CB'address, 
	  XOS_SIM_PARM_DATA_REC_PTR_to_XtPointer(Sim_Data));
      Xt.AddCallback(Sim_Data.Sim.DB_Origin_Altitude,
	Xmdef.NlosingFocusCallback, XOS.Sim_World_Coord_CB'address,
	  XOS_SIM_PARM_DATA_REC_PTR_to_XtPointer(Sim_Data));


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Simulation_State_Label,
        Help_Text_Widget   => Sim_Data.Description,
	Help_Text_Message  => K_Simulation_State_Help_String);
      Motif_Utilities.Install_Active_Help (Contact_Threshold_Label,
        Sim_Data.Description, K_Contact_Threshold_Help_String);
      Motif_Utilities.Install_Active_Help (Cycle_Time_Label,
        Sim_Data.Description, K_Cycle_Time_Help_String);
      Motif_Utilities.Install_Active_Help (DB_Origin_Latitude_Label,
        Sim_Data.Description, K_DB_Origin_Latitude_Help_String);
      Motif_Utilities.Install_Active_Help (DB_Origin_Longitude_Label,
        Sim_Data.Description, K_DB_Origin_Longitude_Help_String);
      Motif_Utilities.Install_Active_Help (DB_Origin_Altitude_Label,
        Sim_Data.Description, K_DB_Origin_Altitude_Help_String);
      Motif_Utilities.Install_Active_Help (DB_Origin_X_WC_Label,
        Sim_Data.Description, K_DB_Origin_X_WC_Help_String);
      Motif_Utilities.Install_Active_Help (DB_Origin_Y_WC_Label,
        Sim_Data.Description, K_DB_Origin_Y_WC_Help_String);
      Motif_Utilities.Install_Active_Help (DB_Origin_Z_WC_Label,
        Sim_Data.Description, K_DB_Origin_Z_WC_Help_String);
      Motif_Utilities.Install_Active_Help (Exercise_ID_Label,
        Sim_Data.Description, K_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Hash_Table_Increment_Label,
        Sim_Data.Description, K_Hash_Table_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (Hash_Table_Size_Label,
        Sim_Data.Description, K_Hash_Table_Size_Help_String);
      Motif_Utilities.Install_Active_Help (ModSAF_Database_Filename_Label,
        Sim_Data.Description, K_ModSAF_Database_Filename_Help_String);
      Motif_Utilities.Install_Active_Help (Memory_Limit_For_ModSAF_File_Label,
        Sim_Data.Description, K_Memory_Limit_For_ModSAF_File_Help_String);
      Motif_Utilities.Install_Active_Help (Number_Of_Loops_Until_Update_Label,
        Sim_Data.Description, K_Number_Of_Loops_Until_Update_Help_String);
      Motif_Utilities.Install_Active_Help (
	Parent_Entity_ID_Sim_Address_Site_ID_Label,
          Sim_Data.Description,
	    K_Parent_Entity_ID_Sim_Address_Site_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Parent_Entity_ID_Sim_Address_Application_ID_Label,
          Sim_Data.Description,
	    K_Parent_Entity_ID_Sim_Address_Application_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Parent_Entity_ID_Entity_ID_Label,
        Sim_Data.Description, K_Parent_Entity_ID_Entity_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Protocol_Version_Label,
        Sim_Data.Description, K_Protocol_Version_Help_String);

      Motif_Utilities.Install_Active_Help (
	Parent             => Sim_Data.Sim.Simulation_State,
        Help_Text_Widget   => Sim_Data.Description,
	Help_Text_Message  => K_Simulation_State_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.Contact_Threshold,
        Sim_Data.Description, K_Contact_Threshold_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.Cycle_Time,
        Sim_Data.Description, K_Cycle_Time_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.DB_Origin_Latitude,
        Sim_Data.Description, K_DB_Origin_Latitude_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.DB_Origin_Longitude,
        Sim_Data.Description, K_DB_Origin_Longitude_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.DB_Origin_Altitude,
        Sim_Data.Description, K_DB_Origin_Altitude_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.DB_Origin_X_WC,
        Sim_Data.Description, K_DB_Origin_X_WC_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.DB_Origin_Y_WC,
        Sim_Data.Description, K_DB_Origin_Y_WC_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.DB_Origin_Z_WC,
        Sim_Data.Description, K_DB_Origin_Z_WC_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.Exercise_ID,
        Sim_Data.Description, K_Exercise_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.Hash_Table_Increment,
        Sim_Data.Description, K_Hash_Table_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.Hash_Table_Size,
        Sim_Data.Description, K_Hash_Table_Size_Help_String);
      Motif_Utilities.Install_Active_Help (
	Sim_Data.Sim.ModSAF_Database_Filename, Sim_Data.Description,
	  K_ModSAF_Database_Filename_Help_String);
      Motif_Utilities.Install_Active_Help (
	Sim_Data.Sim.Memory_Limit_For_ModSAF_File,
          Sim_Data.Description, K_Memory_Limit_For_ModSAF_File_Help_String);
      Motif_Utilities.Install_Active_Help (
	Sim_Data.Sim.Number_Of_Loops_Until_Update,
          Sim_Data.Description, K_Number_Of_Loops_Until_Update_Help_String);
      Motif_Utilities.Install_Active_Help (
	Sim_Data.Sim.Parent_Entity_ID_Sim_Address_Site_ID,
          Sim_Data.Description,
	    K_Parent_Entity_ID_Sim_Address_Site_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Sim_Data.Sim.Parent_Entity_ID_Sim_Address_Application_ID,
          Sim_Data.Description,
	    K_Parent_Entity_ID_Sim_Address_Application_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Sim_Data.Sim.Parent_Entity_ID_Entity_ID,
          Sim_Data.Description,
	    K_Parent_Entity_ID_Entity_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Sim_Data.Sim.Protocol_Version,
        Sim_Data.Description, K_Protocol_Version_Help_String);

   end if; -- (Sim_Data.Sim.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Sim_Data.Title, K_Panel_Title);
   Xt.ManageChild (Sim_Data.Sim.Shell);
   Sim_Data.Parameter_Active_Hierarchy := Sim_Data.Sim.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Sim_Panel_Sim (Sim_Data.Sim);
   end if;

end Create_Sim_Panel_Sim;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

