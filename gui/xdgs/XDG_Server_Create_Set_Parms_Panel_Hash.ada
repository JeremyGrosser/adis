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
-- UNIT NAME:          Create_Set_Parms_Panel_Hash
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
procedure Create_Set_Parms_Panel_Hash(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title        : constant STRING :=
     "XDG Server Hash Parameters Input Screen";
   K_Arglist_Max        : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max         : constant INTEGER := 128; -- Max characters per string

   --
   -- The panel will have 2 columns: 1 for the label, the other for the
   -- corresponding user-input widget.
   -- A third column could be used to display a units label, if it were
   -- appropriate.
   --
   K_Hash_Parameters_Columns : constant INTEGER := 2;

   --
   -- The number of digits for the appropriate text fields.
   --
   K_Hash_Parameters_Rehash_Increment_Digits       : constant INTEGER := 3;
   K_Hash_Parameters_Site_Multiplier_Digits        : constant INTEGER := 3;
   K_Hash_Parameters_Application_Multiplier_Digits : constant INTEGER := 3;
   K_Hash_Parameters_Entity_Multiplier_Digits      : constant INTEGER := 3;

   --
   -- Create the constant help strings
   --
   K_Entity_Index_Increment_Help_String : constant STRING :=
     "Please enter the Entity PDU Rehash Increment.";
   K_Entity_Site_Multiplier_Help_String : constant STRING :=
     "Please enter the Entity PDU Site Multiplier.";
   K_Entity_Application_Multiplier_Help_String : constant STRING :=
     "Please enter the Entity PDU Application Multiplier.";
   K_Entity_Entity_Multiplier_Help_String : constant STRING :=
     "Please enter the Entity PDU Entity Multiplier.";

   K_Emitter_Index_Increment_Help_String : constant STRING :=
     "Please enter the Emitter PDU Rehash Increment.";
   K_Emitter_Site_Multiplier_Help_String : constant STRING :=
     "Please enter the Emitter PDU Site Multiplier.";
   K_Emitter_Application_Multiplier_Help_String : constant STRING :=
     "Please enter the Emitter PDU Application Multiplier.";
   K_Emitter_Entity_Multiplier_Help_String : constant STRING :=
     "Please enter the Emitter PDU Entity Multiplier.";

   K_Laser_Index_Increment_Help_String : constant STRING :=
     "Please enter the Laser PDU Rehash Increment.";
   K_Laser_Site_Multiplier_Help_String : constant STRING :=
     "Please enter the Laser PDU Site Multiplier.";
   K_Laser_Application_Multiplier_Help_String : constant STRING :=
     "Please enter the Laser PDU Application Multiplier.";
   K_Laser_Entity_Multiplier_Help_String : constant STRING :=
     "Please enter the Laser PDU Entity Multiplier.";

   K_Receiver_Index_Increment_Help_String : constant STRING :=
     "Please enter the Receiver PDU Rehash Increment.";
   K_Receiver_Site_Multiplier_Help_String : constant STRING :=
     "Please enter the Receiver PDU Site Multiplier.";
   K_Receiver_Application_Multiplier_Help_String : constant STRING :=
     "Please enter the Receiver PDU Application Multiplier.";
   K_Receiver_Entity_Multiplier_Help_String : constant STRING :=
     "Please enter the Receiver PDU Entity Multiplier.";

   K_Transmitter_Index_Increment_Help_String : constant STRING :=
     "Please enter the Transmitter PDU Rehash Increment.";
   K_Transmitter_Site_Multiplier_Help_String : constant STRING :=
     "Please enter the Transmitter PDU Site Multiplier.";
   K_Transmitter_Application_Multiplier_Help_String : constant STRING :=
     "Please enter the Transmitter PDU Application Multiplier.";
   K_Transmitter_Entity_Multiplier_Help_String : constant STRING :=
     "Please enter the Transmitter PDU Entity Multiplier.";


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

   Entity_Index_Increment_Label             : Xt.WIDGET := Xt.XNULL;
   Entity_Site_Multiplier_Label             : Xt.WIDGET := Xt.XNULL;
   Entity_Application_Multiplier_Label      : Xt.WIDGET := Xt.XNULL;
   Entity_Entity_Multiplier_Label           : Xt.WIDGET := Xt.XNULL;

   Emitter_Index_Increment_Label            : Xt.WIDGET := Xt.XNULL;
   Emitter_Site_Multiplier_Label            : Xt.WIDGET := Xt.XNULL;
   Emitter_Application_Multiplier_Label     : Xt.WIDGET := Xt.XNULL;
   Emitter_Entity_Multiplier_Label          : Xt.WIDGET := Xt.XNULL;

   Laser_Index_Increment_Label              : Xt.WIDGET := Xt.XNULL;
   Laser_Site_Multiplier_Label              : Xt.WIDGET := Xt.XNULL;
   Laser_Application_Multiplier_Label       : Xt.WIDGET := Xt.XNULL;
   Laser_Entity_Multiplier_Label            : Xt.WIDGET := Xt.XNULL;

   Receiver_Index_Increment_Label           : Xt.WIDGET := Xt.XNULL;
   Receiver_Site_Multiplier_Label           : Xt.WIDGET := Xt.XNULL;
   Receiver_Application_Multiplier_Label    : Xt.WIDGET := Xt.XNULL;
   Receiver_Entity_Multiplier_Label         : Xt.WIDGET := Xt.XNULL;

   Transmitter_Index_Increment_Label        : Xt.WIDGET := Xt.XNULL;
   Transmitter_Site_Multiplier_Label        : Xt.WIDGET := Xt.XNULL;
   Transmitter_Application_Multiplier_Label : Xt.WIDGET := Xt.XNULL;
   Transmitter_Entity_Multiplier_Label      : Xt.WIDGET := Xt.XNULL;

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

   if (Set_Data.Hash.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Set_Data.Hash.Shell);
      Xt.ManageChild (Set_Data.Hash.Shell);

   else -- (Set_Data.Hash.Shell = Xt.XNULL)

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
      Set_Data.Hash.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Entity_Index_Increment_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Rehash Increment");
      Entity_Site_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Site Multiplier");
      Entity_Application_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Application Multiplier");
      Entity_Entity_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Entity Multiplier");

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      Emitter_Index_Increment_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Emitter Rehash Increment");
      Emitter_Site_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Emitter Site Multiplier");
      Emitter_Application_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Emitter Application Multiplier");
      Emitter_Entity_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Emitter Entity Multiplier");

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      Laser_Index_Increment_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Laser Rehash Increment");
      Laser_Site_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Laser Site Multiplier");
      Laser_Application_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Laser Application Multiplier");
      Laser_Entity_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Laser Entity Multiplier");

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      Receiver_Index_Increment_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Receiver Rehash Increment");
      Receiver_Site_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Receiver Site Multiplier");
      Receiver_Application_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Receiver Application Multiplier");
      Receiver_Entity_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Receiver Entity Multiplier");

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      Transmitter_Index_Increment_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Transmitter Rehash Increment");
      Transmitter_Site_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Transmitter Site Multiplier");
      Transmitter_Application_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Transmitter Application Multiplier");
      Transmitter_Entity_Multiplier_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Transmitter Entity Multiplier");

      --------------------------------------------------------------------
      --
      -- Create the text fields
      --
      --------------------------------------------------------------------

      -- ------------------------
      -- Entity PDU
      -- ------------------------

      --
      -- Create the Entity PDU Rehash_Increment text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Rehash_Increment 
	:= Xt.CreateManagedWidget ("Entity_Rehash_Increment",
	  Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => 
	  Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Rehash_Increment,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Rehash_Increment_Digits);

      --
      -- Create the Entity PDU Site_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Site_Multiplier 
	:= Xt.CreateManagedWidget ("Entity_Site_Multiplier",
	  Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => 
	  Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Site_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Site_Multiplier_Digits);

      --
      -- Create the Entity PDU Application_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Application_Multiplier 
	:= Xt.CreateManagedWidget ("Entity_Application_Multiplier",
	  Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => 
	  Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Application_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Application_Multiplier_Digits);

      --
      -- Create the Entity PDU Entity_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Entity_Multiplier 
	:= Xt.CreateManagedWidget ("Entity_Entity_Multiplier",
	  Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => 
	  Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Entity_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Entity_Multiplier_Digits);

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);


      -- ------------------------
      -- Emitter PDU
      -- ------------------------

      --
      -- Create the Emitter PDU Rehash_Increment text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Rehash_Increment
        := Xt.CreateManagedWidget ("Emitter_Rehash_Increment",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Rehash_Increment,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Rehash_Increment_Digits);

      --
      -- Create the Emitter PDU Site_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Site_Multiplier
        := Xt.CreateManagedWidget ("Emitter_Site_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Site_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Site_Multiplier_Digits);

      --
      -- Create the Emitter PDU Application_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Application_Multiplier
        := Xt.CreateManagedWidget ("Emitter_Application_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Application_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Application_Multiplier_Digits);

      --
      -- Create the Emitter PDU Entity_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Entity_Multiplier
        := Xt.CreateManagedWidget ("Emitter_Entity_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Entity_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Entity_Multiplier_Digits);

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      -- ------------------------
      -- Laser PDU
      -- ------------------------

      --
      -- Create the Laser PDU Rehash_Increment text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.LASER).Rehash_Increment
        := Xt.CreateManagedWidget ("Laser_Rehash_Increment",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.LASER).Rehash_Increment,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Rehash_Increment_Digits);

      --
      -- Create the Laser PDU Site_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.LASER).Site_Multiplier
        := Xt.CreateManagedWidget ("Laser_Site_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.LASER).Site_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Site_Multiplier_Digits);

      --
      -- Create the Laser PDU Application_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.LASER).Application_Multiplier
        := Xt.CreateManagedWidget ("Laser_Application_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.LASER).Application_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Application_Multiplier_Digits);

      --
      -- Create the Laser PDU Entity_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.LASER).Entity_Multiplier
        := Xt.CreateManagedWidget ("Laser_Entity_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.LASER).Entity_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Entity_Multiplier_Digits);

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      -- ------------------------
      -- Transmitter PDU
      -- ------------------------

      --
      -- Create the Transmitter PDU Rehash_Increment text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Rehash_Increment
        := Xt.CreateManagedWidget ("Transmitter_Rehash_Increment",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Rehash_Increment,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Rehash_Increment_Digits);

      --
      -- Create the Transmitter PDU Site_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Site_Multiplier
        := Xt.CreateManagedWidget ("Transmitter_Site_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Site_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Site_Multiplier_Digits);

      --
      -- Create the Transmitter PDU Application_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Application_Multiplier
        := Xt.CreateManagedWidget ("Transmitter_Application_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).
          Application_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Application_Multiplier_Digits);

      --
      -- Create the Transmitter PDU Entity_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Entity_Multiplier
        := Xt.CreateManagedWidget ("Transmitter_Entity_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Entity_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Entity_Multiplier_Digits);

      Argcount := 0;
      Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);

      -- ------------------------
      -- Receiver PDU
      -- ------------------------

      --
      -- Create the Receiver PDU Rehash_Increment text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Rehash_Increment
        := Xt.CreateManagedWidget ("Receiver_Rehash_Increment",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Rehash_Increment,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Rehash_Increment_Digits);

      --
      -- Create the Receiver PDU Site_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Site_Multiplier
        := Xt.CreateManagedWidget ("Receiver_Site_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Site_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Site_Multiplier_Digits);

      --
      -- Create the Receiver PDU Application_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Application_Multiplier
        := Xt.CreateManagedWidget ("Receiver_Application_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Application_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Application_Multiplier_Digits);

      --
      -- Create the Receiver PDU Entity_Multiplier text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Entity_Multiplier
        := Xt.CreateManagedWidget ("Receiver_Entity_Multiplier",
          Xm.TextFieldWidgetClass, Main_Rowcolumn, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           =>
          Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Entity_Multiplier,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => K_Hash_Parameters_Entity_Multiplier_Digits);


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      --
      -- Install ActiveHelp for labels
      --
      Motif_Utilities.Install_Active_Help (
	Parent             => Entity_Index_Increment_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_Entity_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Site_Multiplier_Label,
	Set_Data.Description, K_Entity_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Application_Multiplier_Label,
	Set_Data.Description, K_Entity_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Entity_Multiplier_Label,
	Set_Data.Description, K_Entity_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (Emitter_Index_Increment_Label,
        Set_Data.Description, K_Emitter_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (Emitter_Site_Multiplier_Label,
        Set_Data.Description, K_Emitter_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Emitter_Application_Multiplier_Label,
        Set_Data.Description, K_Emitter_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Emitter_Entity_Multiplier_Label,
        Set_Data.Description, K_Emitter_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (Laser_Index_Increment_Label,
        Set_Data.Description, K_Laser_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (Laser_Site_Multiplier_Label,
        Set_Data.Description, K_Laser_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Laser_Application_Multiplier_Label,
        Set_Data.Description, K_Laser_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Laser_Entity_Multiplier_Label,
        Set_Data.Description, K_Laser_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (Transmitter_Index_Increment_Label,
        Set_Data.Description, K_Transmitter_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (Transmitter_Site_Multiplier_Label,
        Set_Data.Description, K_Transmitter_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Transmitter_Application_Multiplier_Label, Set_Data.Description,
          K_Transmitter_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Transmitter_Entity_Multiplier_Label,
        Set_Data.Description, K_Transmitter_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (Receiver_Index_Increment_Label,
        Set_Data.Description, K_Receiver_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (Receiver_Site_Multiplier_Label,
        Set_Data.Description, K_Receiver_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Receiver_Application_Multiplier_Label, Set_Data.Description,
          K_Receiver_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (Receiver_Entity_Multiplier_Label,
        Set_Data.Description, K_Receiver_Entity_Multiplier_Help_String);



      --
      -- Install ActiveHelp for user-input widgets
      --
      Motif_Utilities.Install_Active_Help (
	Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Rehash_Increment,
	  Set_Data.Description, K_Entity_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Site_Multiplier,
	  Set_Data.Description, K_Entity_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Application_Multiplier,
	  Set_Data.Description, K_Entity_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Hash.PDU(XDG_Server_Types.ENTITY).Entity_Multiplier,
	  Set_Data.Description, K_Entity_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Rehash_Increment,
          Set_Data.Description, K_Emitter_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Site_Multiplier,
          Set_Data.Description, K_Emitter_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Application_Multiplier,
          Set_Data.Description, K_Emitter_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.EMITTER).Entity_Multiplier,
          Set_Data.Description, K_Emitter_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.LASER).Rehash_Increment,
          Set_Data.Description, K_Laser_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.LASER).Site_Multiplier,
          Set_Data.Description, K_Laser_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.LASER).Application_Multiplier,
          Set_Data.Description, K_Laser_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.LASER).Entity_Multiplier,
          Set_Data.Description, K_Laser_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Rehash_Increment,
          Set_Data.Description, K_Transmitter_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Site_Multiplier,
          Set_Data.Description, K_Transmitter_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Application_Multiplier,
          Set_Data.Description,
            K_Transmitter_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.TRANSMITTER).Entity_Multiplier,
          Set_Data.Description, K_Transmitter_Entity_Multiplier_Help_String);

      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Rehash_Increment,
          Set_Data.Description, K_Receiver_Index_Increment_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Site_Multiplier,
          Set_Data.Description, K_Receiver_Site_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Application_Multiplier,
          Set_Data.Description, K_Receiver_Application_Multiplier_Help_String);
      Motif_Utilities.Install_Active_Help (
        Set_Data.Hash.PDU(XDG_Server_Types.RECEIVER).Entity_Multiplier,
          Set_Data.Description, K_Receiver_Entity_Multiplier_Help_String);

   end if; -- (Set_Data.Hash.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.Hash.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.Hash.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Panel_Hash (Set_Data.Hash);
   end if;

end Create_Set_Parms_Panel_Hash;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/09/94   D. Forrest
--      - Initial version
--
-- --

