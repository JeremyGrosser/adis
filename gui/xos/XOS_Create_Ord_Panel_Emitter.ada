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
with Numeric_Types;
with OS_Data_Types;
with OS_GUI;
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
-- UNIT NAME:          Create_Ord_Panel_Emitter
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 29, 1994
--
-- PURPOSE:
--   This procedure displays the Emitter Parameters Panel 
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
procedure Create_Ord_Panel_Emitter(
   Parent      : in     Xt.WIDGET;
   Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title        : constant STRING :=
     "XOS Emitter Parameters Input Screen";
   K_Arglist_Max        : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max         : constant INTEGER := 128; -- Max characters per string
   K_Emitter_Parameters_Columns : constant INTEGER := 3; -- Columns of info 
   K_Indent             : constant STRING := "     ";

   --
   -- Create the constant help strings
   --
   K_Emitter_Name_Help_String : constant STRING :=
     "Name of emitter (undefined enumeration)";
   K_Emitter_Function_Help_String : constant STRING :=
     "Function for a particular emitter (undefined enumeration)";
   K_Emitter_ID_Help_String : constant STRING :=
     "Location of the emitter on the entity offset from the center";
   K_Location_X_Help_String : constant STRING :=
     "Positive toward the nose of the entity";
   K_Location_Y_Help_String : constant STRING :=
     "Positive toward the right of the entity";
   K_Location_Z_Help_String : constant STRING :=
     "Positive toward the bottom of the entity";
   K_Frequency_Help_String : constant STRING :=
     "Center of the frequency emission (Hz)";
   K_Frequency_Range_Help_String : constant STRING :=
     "Bandwidth of the frequencies corresponding to the Frequency";
   K_ERP_Help_String : constant STRING :=
     "Effective Radiated Power (dbm)";
   K_PRF_Help_String : constant STRING :=
     "Pulse Repetition Frequency (Hz)";
   K_Pulse_Width_Help_String : constant STRING :=
     "Average pulse width (microseconds)";
   K_Beam_Azimuth_Center_Help_String : constant STRING :=
     "Beam Azimuth Center";
   K_Beam_Elevation_Center_Help_String : constant STRING :=
     "Beam Elevation Center";
   K_Beam_Sweep_Sync_Help_String : constant STRING :=
     "Percentage of time a scan is through its pattern from its origin";
   K_Beam_Parameter_Index_Help_String : constant STRING :=
     "Beam parameter index number";
   K_Beam_Function_Help_String : constant STRING :=
     "Function of a particular beam (undefined enumeration)";
   K_High_Density_Track_Jam_Help_String : constant STRING :=
     "Indicates whether all entities in the scan pattern can be assumed"
       & " as tracked or jammed as per beam function";
   K_Jamming_Mode_Sequence_Help_String : constant STRING :=
     "Jamming Mode Sequence";


   --
   -- Miscellaneous declarations
   --
   Arglist           : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount          : Xt.INT := 0;                    -- number of arguments
   Text_Arglist      : Xt.ARGLIST (1..K_Arglist_Max);  -- Text argument list
   Text_Argcount     : Xt.INT := 0;                    -- Text arguments count
   Temp_String       : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString     : Xm.XMSTRING;                    -- Temporary X string
   Temp_Label        : Xt.WIDGET := Xt.XNULL;          -- Temporary Widget
   Do_Initialization : BOOLEAN;

   --
   -- Local widget declarations
   --
   Main_Rowcolumn                         : Xt.WIDGET := Xt.XNULL;
   Emitter_System_Label                   : Xt.WIDGET := Xt.XNULL;
   Emitter_Name_Label                     : Xt.WIDGET := Xt.XNULL;
   Emitter_Function_Label                 : Xt.WIDGET := Xt.XNULL;
   Emitter_ID_Label                       : Xt.WIDGET := Xt.XNULL;
      
   Location_Label                         : Xt.WIDGET := Xt.XNULL;
   Location_X_Label                       : Xt.WIDGET := Xt.XNULL;
   Location_Y_Label                       : Xt.WIDGET := Xt.XNULL;
   Location_Z_Label                       : Xt.WIDGET := Xt.XNULL;

   Fundamental_Parameter_Data_Label       : Xt.WIDGET := Xt.XNULL;
   Frequency_Label                        : Xt.WIDGET := Xt.XNULL;
   Frequency_Range_Label                  : Xt.WIDGET := Xt.XNULL;
   ERP_Label                              : Xt.WIDGET := Xt.XNULL;
   PRF_Label                              : Xt.WIDGET := Xt.XNULL;
   Pulse_Width_Label                      : Xt.WIDGET := Xt.XNULL;
   Beam_Azimuth_Center_Label              : Xt.WIDGET := Xt.XNULL;
   Beam_Elevation_Center_Label            : Xt.WIDGET := Xt.XNULL;
   Beam_Sweep_Sync_Label                  : Xt.WIDGET := Xt.XNULL;

   Beam_Data_Label                        : Xt.WIDGET := Xt.XNULL;
   Beam_Parameter_Index_Label             : Xt.WIDGET := Xt.XNULL;
   Beam_Function_Label                    : Xt.WIDGET := Xt.XNULL;
   High_Density_Track_Jam_Label           : Xt.WIDGET := Xt.XNULL;
   Jamming_Mode_Sequence_Label            : Xt.WIDGET := Xt.XNULL;

   Emitter_System_Units_Label             : Xt.WIDGET := Xt.XNULL;
   Emitter_Name_Units_Label               : Xt.WIDGET := Xt.XNULL;
   Emitter_Function_Units_Label           : Xt.WIDGET := Xt.XNULL;
   Emitter_ID_Units_Label                 : Xt.WIDGET := Xt.XNULL;

   Location_Units_Label                   : Xt.WIDGET := Xt.XNULL;
   Location_X_Units_Label                 : Xt.WIDGET := Xt.XNULL;
   Location_Y_Units_Label                 : Xt.WIDGET := Xt.XNULL;
   Location_Z_Units_Label                 : Xt.WIDGET := Xt.XNULL;

   Fundamental_Parameter_Data_Units_Label : Xt.WIDGET := Xt.XNULL;
   Frequency_Units_Label                  : Xt.WIDGET := Xt.XNULL;
   Frequency_Range_Units_Label            : Xt.WIDGET := Xt.XNULL;
   ERP_Units_Label                        : Xt.WIDGET := Xt.XNULL;
   PRF_Units_Label                        : Xt.WIDGET := Xt.XNULL;
   Pulse_Width_Units_Label                : Xt.WIDGET := Xt.XNULL;
   Beam_Azimuth_Center_Units_Label        : Xt.WIDGET := Xt.XNULL;
   Beam_Elevation_Center_Units_Label      : Xt.WIDGET := Xt.XNULL;
   Beam_Sweep_Sync_Units_Label            : Xt.WIDGET := Xt.XNULL;

   Beam_Data_Units_Label                  : Xt.WIDGET := Xt.XNULL;
   Beam_Parameter_Index_Units_Label       : Xt.WIDGET := Xt.XNULL;
   Beam_Function_Units_Label              : Xt.WIDGET := Xt.XNULL;
   High_Density_Track_Jam_Units_Label     : Xt.WIDGET := Xt.XNULL;
   Jamming_Mode_Sequence_Units_Label      : Xt.WIDGET := Xt.XNULL;

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

   if (Ord_Data.Emitter.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Ord_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Ord_Data.Emitter.Shell);
      Xt.ManageChild (Ord_Data.Emitter.Shell);

   else -- (Ord_Data.Emitter.Shell = Xt.XNULL)

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
	INTEGER(K_Emitter_Parameters_Columns));
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
      Ord_Data.Emitter.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Emitter_System_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Emitter System");
      Emitter_Name_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Emitter Name");
      Emitter_Function_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Emitter Function");
      Emitter_ID_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Emitter ID");

      Location_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Location");
      Location_X_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "X");
      Location_Y_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Y");
      Location_Z_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Z");

      Fundamental_Parameter_Data_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Fundamental Parameter Data");
      Frequency_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Frequency");
      Frequency_Range_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Frequency Range");
      ERP_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "ERP");
      PRF_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "PRF");
      Pulse_Width_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Pulse Width");
      Beam_Azimuth_Center_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Beam Azimuth Center");
      Beam_Elevation_Center_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Beam Elevation Center");
      Beam_Sweep_Sync_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Beam Sweep Sync");

      Beam_Data_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Beam Data");
      Beam_Parameter_Index_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Beam Parameter Index");
      Beam_Function_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Beam Function");
      High_Density_Track_Jam_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "High Density Track Jam");
      Jamming_Mode_Sequence_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, K_Indent & "Jamming Mode Sequence");


      --------------------------------------------------------------------
      --
      -- Create the user input widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the Emitter_System placeholder
      --
      Emitter_System_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      --
      -- Create the default argument list for all text widgets...
      --
      Text_Argcount := 0;
      Text_Argcount := Text_Argcount + 1;
      Xt.SetArg (Text_Arglist (Text_Argcount), Xmdef.Nvalue, "");

      --
      -- Create the Emitter_Name text field
      --
      Ord_Data.Emitter.Emitter_Name := Xt.CreateManagedWidget(
	"Emitter_Name", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range(
        Parent           => Ord_Data.Emitter.Emitter_Name,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => DIS_Types.AN_EMITTER_SYSTEM'pos(
	  DIS_Types.AN_EMITTER_SYSTEM'first),
        Maximum_Integer  => DIS_Types.AN_EMITTER_SYSTEM'pos(
	  DIS_Types.AN_EMITTER_SYSTEM'last));

      --
      -- Create the Emitter_Function text field
      --
      Ord_Data.Emitter.Emitter_Function := Xt.CreateManagedWidget(
	"Emitter_Function", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range(
        Parent           => Ord_Data.Emitter.Emitter_Function,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => DIS_Types.AN_EMISSION_FUNCTION'pos(
	  DIS_Types.AN_EMISSION_FUNCTION'first),
        Maximum_Integer  => DIS_Types.AN_EMISSION_FUNCTION'pos(
	  DIS_Types.AN_EMISSION_FUNCTION'last));

      --
      -- Create the Emitter_ID text field
      --
      Ord_Data.Emitter.Emitter_ID := Xt.CreateManagedWidget (
	"Emitter_ID", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range (
        Parent           => Ord_Data.Emitter.Emitter_ID,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Integer  => Numeric_Types.UNSIGNED_8_BIT'pos(
	  Numeric_Types.UNSIGNED_8_BIT'first),
        Maximum_Integer  => Numeric_Types.UNSIGNED_8_BIT'pos(
	  Numeric_Types.UNSIGNED_8_BIT'last));

      --
      -- Create the Location placeholder
      --
      Location_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      --
      -- Create the Location_X text field
      --
      Ord_Data.Emitter.Location_X := Xt.CreateManagedWidget (
	"Location_X", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Location_X,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Location_Y text field
      --
      Ord_Data.Emitter.Location_Y := Xt.CreateManagedWidget (
	"Location_Y", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Location_Y,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Location_Z text field
      --
      Ord_Data.Emitter.Location_Z := Xt.CreateManagedWidget (
	"Location_Z", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Location_Z,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Fundamental_Parameter_Data placeholder
      --
      Fundamental_Parameter_Data_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      --
      -- Create the Frequency text field
      --
      Ord_Data.Emitter.Frequency := Xt.CreateManagedWidget (
	"Frequency", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Frequency,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Frequency_Range text field
      --
      Ord_Data.Emitter.Frequency_Range := Xt.CreateManagedWidget (
	"Frequency_Range", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Frequency_Range,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the ERP text field
      --
      Ord_Data.Emitter.ERP := Xt.CreateManagedWidget (
	"ERP", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.ERP,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the PRF text field
      --
      Ord_Data.Emitter.PRF := Xt.CreateManagedWidget (
	"PRF", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.PRF,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Pulse_Width text field
      --
      Ord_Data.Emitter.Pulse_Width := Xt.CreateManagedWidget (
	"Pulse_Width", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Pulse_Width,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Beam_Azimuth_Center text field
      --
      Ord_Data.Emitter.Beam_Azimuth_Center := Xt.CreateManagedWidget (
	"Beam_Azimuth_Center", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Beam_Azimuth_Center,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Beam_Elevation_Center text field
      --
      Ord_Data.Emitter.Beam_Elevation_Center := Xt.CreateManagedWidget (
	"Beam_Elevation_Center", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Beam_Elevation_Center,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Beam_Sweep_Sync text field
      --
      Ord_Data.Emitter.Beam_Sweep_Sync := Xt.CreateManagedWidget (
	"Beam_Sweep_Sync", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Ord_Data.Emitter.Beam_Sweep_Sync,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT,
        Characters_Count => INTEGER'last);

      --
      -- Create the Beam_Data placeholder
      --
      Beam_Data_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      --
      -- Create the Beam_Parameter_Index text field
      --
      Ord_Data.Emitter.Beam_Parameter_Index := Xt.CreateManagedWidget(
	"Beam_Parameter_Index", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range(
        Parent           => Ord_Data.Emitter.Beam_Parameter_Index,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
	Minimum_Integer  => Numeric_Types.UNSIGNED_16_BIT'pos(
	  Numeric_Types.UNSIGNED_16_BIT'first),
	Maximum_Integer  => Numeric_Types.UNSIGNED_16_BIT'pos(
	  Numeric_Types.UNSIGNED_16_BIT'last));

      --
      -- Create the Beam_Function text field
      --
      Ord_Data.Emitter.Beam_Function := Xt.CreateManagedWidget (
	"Beam_Function", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range(
        Parent           => Ord_Data.Emitter.Beam_Function,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
	Minimum_Integer  => Numeric_Types.UNSIGNED_8_BIT'pos(
	  Numeric_Types.UNSIGNED_8_BIT'first),
	Maximum_Integer  => Numeric_Types.UNSIGNED_8_BIT'pos(
	  Numeric_Types.UNSIGNED_8_BIT'last));

      --
      -- Create the High_Density_Track_Jam text field
      --
      Ord_Data.Emitter.High_Density_Track_Jam := Xt.CreateManagedWidget (
	"High_Density_Track_Jam", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range(
        Parent           => Ord_Data.Emitter.High_Density_Track_Jam,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
	Minimum_Integer  => Numeric_Types.UNSIGNED_8_BIT'pos(
	  Numeric_Types.UNSIGNED_8_BIT'first),
	Maximum_Integer  => Numeric_Types.UNSIGNED_8_BIT'pos(
	  Numeric_Types.UNSIGNED_8_BIT'last));

      --
      -- Create the Jamming_Mode_Sequence text field
      --
      Ord_Data.Emitter.Jamming_Mode_Sequence := Xt.CreateManagedWidget (
	"Jamming_Mode_Sequence", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Text_Arglist, Text_Argcount);
      Motif_Utilities.Install_Text_Restrictions_with_Integer_Range(
        Parent           => Ord_Data.Emitter.Jamming_Mode_Sequence,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last,
	Minimum_Integer  => Numeric_Types.UNSIGNED_32_BIT'pos(
	  Numeric_Types.UNSIGNED_32_BIT'first),
	Maximum_Integer  => Numeric_Types.UNSIGNED_32_BIT'pos(
	  Numeric_Types.UNSIGNED_32_BIT'last));

      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Emitter_System_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Emitter_Name_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Emitter_Function_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Emitter_ID_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      Location_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Location_X_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");
      Location_Y_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");
      Location_Z_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");

      Fundamental_Parameter_Data_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Frequency_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Hz");
      Frequency_Range_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      ERP_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "dbm");
      PRF_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Hz");
      Pulse_Width_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "ms");
      Beam_Azimuth_Center_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Beam_Elevation_Center_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Beam_Sweep_Sync_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");

      Beam_Data_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Beam_Parameter_Index_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Beam_Function_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      High_Density_Track_Jam_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Jamming_Mode_Sequence_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Emitter_Name_Label,
	Help_Text_Widget   => Ord_Data.Description,
	Help_Text_Message  => K_Emitter_Name_Help_String);
      Motif_Utilities.Install_Active_Help (Emitter_Function_Label,
	Ord_Data.Description, K_Emitter_Function_Help_String);
      Motif_Utilities.Install_Active_Help (Emitter_ID_Label,
	Ord_Data.Description, K_Emitter_ID_Help_String);
      Motif_Utilities.Install_Active_Help (Location_X_Label,
	Ord_Data.Description, K_Location_X_Help_String);
      Motif_Utilities.Install_Active_Help (Location_Y_Label,
	Ord_Data.Description, K_Location_Y_Help_String);
      Motif_Utilities.Install_Active_Help (Location_Z_Label,
	Ord_Data.Description, K_Location_Z_Help_String);
      Motif_Utilities.Install_Active_Help (Frequency_Label,
	Ord_Data.Description, K_Frequency_Help_String);
      Motif_Utilities.Install_Active_Help (Frequency_Range_Label,
	Ord_Data.Description, K_Frequency_Range_Help_String);
      Motif_Utilities.Install_Active_Help (ERP_Label,
	Ord_Data.Description, K_ERP_Help_String);
      Motif_Utilities.Install_Active_Help (PRF_Label,
	Ord_Data.Description, K_PRF_Help_String);
      Motif_Utilities.Install_Active_Help (Pulse_Width_Label,
	Ord_Data.Description, K_Pulse_Width_Help_String);
      Motif_Utilities.Install_Active_Help (Beam_Azimuth_Center_Label,
	Ord_Data.Description, K_Beam_Azimuth_Center_Help_String);
      Motif_Utilities.Install_Active_Help (Beam_Elevation_Center_Label,
	Ord_Data.Description, K_Beam_Elevation_Center_Help_String);
      Motif_Utilities.Install_Active_Help (Beam_Sweep_Sync_Label,
	Ord_Data.Description, K_Beam_Sweep_Sync_Help_String);
      Motif_Utilities.Install_Active_Help (Beam_Parameter_Index_Label,
	Ord_Data.Description, K_Beam_Parameter_Index_Help_String);
      Motif_Utilities.Install_Active_Help (Beam_Function_Label,
	Ord_Data.Description, K_Beam_Function_Help_String);
      Motif_Utilities.Install_Active_Help (High_Density_Track_Jam_Label,
	Ord_Data.Description, K_High_Density_Track_Jam_Help_String);
      Motif_Utilities.Install_Active_Help (Jamming_Mode_Sequence_Label,
	Ord_Data.Description, K_Jamming_Mode_Sequence_Help_String);


      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Emitter_Name, Ord_Data.Description,
	  K_Emitter_Name_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Emitter_Function, Ord_Data.Description,
	  K_Emitter_Function_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Emitter_ID, Ord_Data.Description,
	  K_Emitter_ID_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Location_X, Ord_Data.Description,
	  K_Location_X_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Location_Y, Ord_Data.Description,
	  K_Location_Y_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Location_Z, Ord_Data.Description,
	  K_Location_Z_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Frequency, Ord_Data.Description,
	  K_Frequency_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Frequency_Range, Ord_Data.Description,
	  K_Frequency_Range_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.ERP, Ord_Data.Description,
	  K_ERP_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.PRF, Ord_Data.Description,
	  K_PRF_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Pulse_Width, Ord_Data.Description,
	  K_Pulse_Width_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Beam_Azimuth_Center, Ord_Data.Description,
	  K_Beam_Azimuth_Center_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Beam_Elevation_Center, Ord_Data.Description,
	  K_Beam_Elevation_Center_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Beam_Sweep_Sync, Ord_Data.Description,
	  K_Beam_Sweep_Sync_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Beam_Parameter_Index, Ord_Data.Description,
	  K_Beam_Parameter_Index_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Beam_Function, Ord_Data.Description,
	  K_Beam_Function_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.High_Density_Track_Jam, Ord_Data.Description,
	  K_High_Density_Track_Jam_Help_String);
      Motif_Utilities.Install_Active_Help (
	Ord_Data.Emitter.Jamming_Mode_Sequence, Ord_Data.Description,
	  K_Jamming_Mode_Sequence_Help_String);

   end if; -- (Ord_Data.Emitter.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Ord_Data.Title, K_Panel_Title);
   Xt.ManageChild (Ord_Data.Emitter.Shell);
   Ord_Data.Parameter_Active_Hierarchy := Ord_Data.Emitter.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Ord_Panel_Emitter (Ord_Data.Emitter);
   end if;

end Create_Ord_Panel_Emitter;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/29/94   D. Forrest
--      - Initial version
--
-- --

