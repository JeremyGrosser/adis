--
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
-- UNIT NAME:          Create_Set_Parms_Panel_DG_Parameters
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 3, 1994
--
-- PURPOSE:
--   This procedure displays the DG_Parameters Panel 
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
procedure Create_Set_Parms_Panel_DG_Parameters(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title       : constant STRING :=
     "XDG Server DG Parameters Input Screen";
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string

   --
   -- Create the constant help strings
   --
   K_Timeslice_Help_String : constant STRING :=
     "Please enter the Timeslice.";
   K_Max_Entities_Help_String : constant STRING :=
     "Please enter the Maximum number of Entities.";
   K_Max_Emitters_Help_String : constant STRING :=
     "Please enter the Maximum number of Emitters.";
   K_Max_Lasers_Help_String : constant STRING :=
     "Please enter the Maximum number of Lasers.";
   K_Max_Transmitters_Help_String : constant STRING :=
     "Please enter the Maximum number of Transmitters.";
   K_Max_Receivers_Help_String : constant STRING :=
     "Please enter the Maximum number of Receivers.";
   K_PDU_Buffer_Size_Help_String : constant STRING :=
     "Please enter the PDU Buffer Size.";

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
   Main_Rowcolumn                  : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   Timeslice_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Timeslice_Units_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Max_Entities_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Max_Entities_Units_Label        : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Max_Emitters_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Max_Emitters_Units_Label        : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Max_Lasers_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Max_Lasers_Units_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Max_Transmitters_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Max_Transmitters_Units_Label    : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Max_Receivers_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Max_Receivers_Units_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   PDU_Buffer_Size_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Name
   PDU_Buffer_Size_Units_Label     : Xt.WIDGET := Xt.XNULL; -- Parm Units label

   --
   -- Renamed functions
   --
   function "=" (left, right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";
   function ASTRING_To_XtPOINTER
     is new Unchecked_Conversion (Utilities.ASTRING, Xt.POINTER);
   function XtWIDGET_To_INTEGER
     is new Unchecked_Conversion (Xt.WIDGET, INTEGER);
   function ASTRING_To_INTEGER
     is new Unchecked_Conversion (Utilities.ASTRING, INTEGER);

   --
   -- Instantiated Packages
   --
   package Float_IO
     is new Text_IO.Float_IO(FLOAT);

begin
   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Set_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Set_Data.Parameter_Active_Hierarchy);
   end if;

   if (Set_Data.DG_Parameters.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
	Xt.XNULL, Xt.XNULL, Set_Data.DG_Parameters.Shell);
      Xt.ManageChild (Set_Data.DG_Parameters.Shell);

   else -- (Set_Data.DG_Parameters.Shell = Xt.XNULL)

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
      Set_Data.DG_Parameters.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Timeslice_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Timeslice");
      Max_Entities_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Maximum Entities");
      Max_Emitters_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Maximum Emitters");
      Max_Lasers_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Maximum Lasers");
      Max_Transmitters_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Maximum Transmitters");
      Max_Receivers_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Maximum Receivers");
      PDU_Buffer_Size_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "PDU Buffer Size");

      --------------------------------------------------------------------
      --
      -- Create the text fields
      --
      --------------------------------------------------------------------

      --
      -- Create the Timeslice text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.DG_Parameters.Timeslice := Xt.CreateManagedWidget (
	"Timeslice", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Set_Data.DG_Parameters.Timeslice,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
	Characters_Count => INTEGER'last);

      --
      -- Create the Max_Entities text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.DG_Parameters.Max_Entities := Xt.CreateManagedWidget (
	"Max_Entities", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Set_Data.DG_Parameters.Max_Entities,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
	Characters_Count => INTEGER'last);

      --
      -- Create the Max_Emitters text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.DG_Parameters.Max_Emitters := Xt.CreateManagedWidget (
	"Max_Emitters", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Set_Data.DG_Parameters.Max_Emitters,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
	Characters_Count => INTEGER'last);

      --
      -- Create the Max_Lasers text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.DG_Parameters.Max_Lasers := Xt.CreateManagedWidget (
	"Max_Lasers", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Set_Data.DG_Parameters.Max_Lasers,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
	Characters_Count => INTEGER'last);

      --
      -- Create the Max_Transmitters text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.DG_Parameters.Max_Transmitters := Xt.CreateManagedWidget (
	"Max_Transmitters", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Set_Data.DG_Parameters.Max_Transmitters,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
	Characters_Count => INTEGER'last);

      --
      -- Create the Max_Receivers text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.DG_Parameters.Max_Receivers := Xt.CreateManagedWidget (
	"Max_Receivers", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Set_Data.DG_Parameters.Max_Receivers,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
	Characters_Count => INTEGER'last);

      --
      -- Create the PDU_Buffer_Size text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.DG_Parameters.PDU_Buffer_Size := Xt.CreateManagedWidget (
	"PDU_Buffer_Size", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
	Parent           => Set_Data.DG_Parameters.PDU_Buffer_Size,
	Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_POSITIVE,
	Characters_Count => INTEGER'last);

      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      Timeslice_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "ms");
      Max_Entities_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Max_Emitters_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Max_Lasers_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Max_Transmitters_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Max_Receivers_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      PDU_Buffer_Size_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "bytes");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Timeslice_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_Timeslice_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Entities_Label,
	Set_Data.Description, K_Max_Entities_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Emitters_Label,
	Set_Data.Description, K_Max_Emitters_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Lasers_Label,
	Set_Data.Description, K_Max_Lasers_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Transmitters_Label,
	Set_Data.Description, K_Max_Transmitters_Help_String);
      Motif_Utilities.Install_Active_Help (Max_Receivers_Label,
	Set_Data.Description, K_Max_Receivers_Help_String);
      Motif_Utilities.Install_Active_Help (PDU_Buffer_Size_Label,
	Set_Data.Description, K_PDU_Buffer_Size_Help_String);


      Motif_Utilities.Install_Active_Help (
	Set_Data.DG_Parameters.Timeslice, Set_Data.Description,
	K_Timeslice_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.DG_Parameters.Max_Entities, Set_Data.Description,
	K_Max_Entities_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.DG_Parameters.Max_Emitters, Set_Data.Description,
	K_Max_Emitters_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.DG_Parameters.Max_Lasers, Set_Data.Description,
	K_Max_Lasers_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.DG_Parameters.Max_Transmitters, Set_Data.Description,
	K_Max_Transmitters_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.DG_Parameters.Max_Receivers, Set_Data.Description,
	K_Max_Receivers_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.DG_Parameters.PDU_Buffer_Size, Set_Data.Description,
	K_PDU_Buffer_Size_Help_String);

   end if; -- (Set_Data.DG_Parameters.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.DG_Parameters.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.DG_Parameters.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Panel_DG_Parameters (Set_Data.DG_Parameters);
   end if;

end Create_Set_Parms_Panel_DG_Parameters;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/03/94   D. Forrest
--      - Initial version
--
-- --

