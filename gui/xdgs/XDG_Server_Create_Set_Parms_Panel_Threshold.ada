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
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Create_Set_Parms_Panel_Threshold
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 3, 1994
--
-- PURPOSE:
--   This procedure displays the Threshold Panel 
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
procedure Create_Set_Parms_Panel_Threshold(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title       : constant STRING :=
     "XDG Server Threshold Parameters Input Screen";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string

   --
   -- Create the constant help strings
   --
   K_Distance_Help_String : constant STRING :=
     "Please enter the Distance.";
   K_Orientation_Help_String : constant STRING :=
     "Please enter the Orientation.";
   K_Entity_Update_Help_String : constant STRING :=
     "Please enter the Entity Update.";
   K_Entity_Expiration_Help_String : constant STRING :=
     "Please enter the Entity Expiration.";
   K_Emission_Update_Help_String : constant STRING :=
     "Please enter the Emission Update.";
   K_Laser_Update_Help_String : constant STRING :=
     "Please enter the Laser Update.";
   K_Transmitter_Update_Help_String : constant STRING :=
     "Please enter the Transmitter Update.";
   K_Receiver_Update_Help_String : constant STRING :=
     "Please enter the Receiver Update.";


   --
   -- Miscellaneous declarations
   --
   Arglist           : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount          : Xt.INT := 0;                    -- number of arguments
   Temp_String       : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString     : Xm.XMSTRING;                    -- Temporary X string
   Do_Initialization : BOOLEAN;

   --
   -- Local widget declarations
   --
   Main_Rowcolumn                 : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   Distance_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Distance_Units_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Orientation_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Orientation_Units_Label        : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Entity_Update_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Entity_Update_Units_Label      : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Entity_Expiration_Label        : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Entity_Expiration_Units_Label  : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Emission_Update_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Emission_Update_Units_Label    : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Laser_Update_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Laser_Update_Units_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Transmitter_Update_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Transmitter_Update_Units_Label : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Receiver_Update_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Receiver_Update_Units_Label    : Xt.WIDGET := Xt.XNULL; -- Parm Units label

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

   if (Set_Data.Threshold.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
	Xt.XNULL, Xt.XNULL, Set_Data.Threshold.Shell);
      Xt.ManageChild (Set_Data.Threshold.Shell);

   else -- (Set_Data.Threshold.Shell = Xt.XNULL)

      Do_Initialization := True;
      --
      -- Create (Sub)root widget of the parameter widget hierarchy
      -- (the main parameter panel rowcolumn widget).
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
      Set_Data.Threshold.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Distance_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Distance");
      Orientation_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Orientation");
      Entity_Update_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Update");
      Entity_Expiration_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Entity Expiration");
      Emission_Update_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Emission Update");
      Laser_Update_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Laser Update");
      Transmitter_Update_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Transmitter Update");
      Receiver_Update_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Receiver Update");

      --------------------------------------------------------------------
      --
      -- Create the text fields
      --
      --------------------------------------------------------------------

      --
      -- Create the Distance text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Distance := Xt.CreateManagedWidget (
	"Distance", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Threshold.Distance,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT_NONNEGATIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Orientation text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Orientation := Xt.CreateManagedWidget (
	"Orientation", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Float_Range (
        Parent           => Set_Data.Threshold.Orientation,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_FLOAT_NONNEGATIVE,
        Characters_Count => INTEGER'last,
        Minimum_Float    => 0.0,
        Maximum_Float    => 360.0);

      --
      -- Create the Entity_Update text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Entity_Update := Xt.CreateManagedWidget (
	"Entity Update", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Threshold.Entity_Update,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Entity_Expiration text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Entity_Expiration := Xt.CreateManagedWidget (
	"Entity Expiration", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Threshold.Entity_Expiration,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Emission_Update text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Emission_Update := Xt.CreateManagedWidget (
	"Emission Update", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Threshold.Emission_Update,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Laser_Update text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Laser_Update := Xt.CreateManagedWidget (
	"Laser Update", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Threshold.Laser_Update,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Transmitter_Update text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Transmitter_Update := Xt.CreateManagedWidget (
	"Transmitter Update", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Threshold.Transmitter_Update,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Receiver_Update text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Threshold.Receiver_Update := Xt.CreateManagedWidget (
	"Receiver Update", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Threshold.Receiver_Update,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
        Characters_Count => INTEGER'last);

      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Distance_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "m");
      Orientation_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "deg");
      Entity_Update_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "sec");
      Entity_Expiration_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "sec");
      Emission_Update_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "msec");
      Laser_Update_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "msec");
      Transmitter_Update_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "msec");
      Receiver_Update_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "msec");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Distance_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_Distance_Help_String);
      Motif_Utilities.Install_Active_Help (Orientation_Label,
	Set_Data.Description, K_Orientation_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Update_Label,
	Set_Data.Description, K_Entity_Update_Help_String);
      Motif_Utilities.Install_Active_Help (Entity_Expiration_Label,
	Set_Data.Description, K_Entity_Expiration_Help_String);
      Motif_Utilities.Install_Active_Help (Emission_Update_Label,
	Set_Data.Description, K_Emission_Update_Help_String);
      Motif_Utilities.Install_Active_Help (Laser_Update_Label,
	Set_Data.Description, K_Laser_Update_Help_String);
      Motif_Utilities.Install_Active_Help (Transmitter_Update_Label,
	Set_Data.Description, K_Transmitter_Update_Help_String);
      Motif_Utilities.Install_Active_Help (Receiver_Update_Label,
	Set_Data.Description, K_Receiver_Update_Help_String);


      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Distance, Set_Data.Description,
	K_Distance_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Orientation, Set_Data.Description,
	K_Orientation_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Entity_Update, Set_Data.Description,
	K_Entity_Update_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Entity_Expiration, Set_Data.Description,
	K_Entity_Expiration_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Emission_Update, Set_Data.Description,
	K_Emission_Update_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Laser_Update, Set_Data.Description,
	K_Laser_Update_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Transmitter_Update, Set_Data.Description,
	K_Transmitter_Update_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Threshold.Receiver_Update, Set_Data.Description,
	K_Receiver_Update_Help_String);

   end if; -- (Set_Data.Threshold.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.Threshold.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.Threshold.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      XDG_Server.Initialize_Panel_Threshold(Set_Data.Threshold);
   end if;

end Create_Set_Parms_Panel_Threshold;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/03/94   D. Forrest
--      - Initial version
--
-- --

