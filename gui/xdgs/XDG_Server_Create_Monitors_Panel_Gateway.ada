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
-- UNIT NAME:          Create_Monitors_Panel_Gateway
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 3, 1994
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
procedure Create_Monitors_Panel_Gateway(
   Parent      : in     Xt.WIDGET;
   Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title       : constant STRING :=
     "XDG Server Gateway Monitor";
   K_Number_Of_Columns : constant INTEGER := 2;   -- Number of columns for 
						  -- main rowcolumn widget
   K_Arglist_Max       : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max        : constant INTEGER := 128; -- Max characters per string

   --
   -- Create the constant help strings
   --
   K_Number_Of_Clients_Help_String : constant STRING :=
     "The number of clients.";
   K_Number_Of_Local_Entities_Help_String : constant STRING :=
     "The number of local entities.";


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
   Main_Rowcolumn                       : Xt.WIDGET := Xt.XNULL; -- Main Rowcol
   Number_Of_Clients_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Number_Of_Local_Entities_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name

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
   if (Mon_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Mon_Data.Parameter_Active_Hierarchy);
   end if;

   if (Mon_Data.Gateway.Shell /= Xt.XNULL) then

      Xm.ScrolledWindowSetAreas (Mon_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Mon_Data.Gateway.Shell);
      Xt.ManageChild (Mon_Data.Gateway.Shell);

   else -- (Mon_Data.Gateway.Shell = Xt.XNULL)

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
      Xt.SetArg (Arglist (Argcount), Xmdef.NnumColumns, K_Number_Of_Columns);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NentryAlignment,
	INTEGER(Xm.ALIGNMENT_BEGINNING));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NisAligned, True);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nspacing, INTEGER(0));
      Main_Rowcolumn := Xt.CreateWidget ("Main_Rowcolumn",
	Xm.RowColumnWidgetClass, Mon_Data.Parameter_Scrolled_Window,
	Arglist, Argcount);
      Mon_Data.Gateway.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Number_Of_Clients_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Number of Clients");
      Number_Of_Local_Entities_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Number of Local Entities");

      --------------------------------------------------------------------
      --
      -- Create the text fields
      --
      --------------------------------------------------------------------

      --
      -- Create the Number_Of_Clients text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "3");
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NshadowThickness, INTEGER(1));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NcursorPositionVisible, False);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Neditable, False);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, True);
      Mon_Data.Gateway.Number_Of_Clients := Xt.CreateManagedWidget (
	"Number_Of_Clients", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);

      --
      -- Create the Number_Of_Local_Entities text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "20");
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NshadowThickness, INTEGER(1));
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NcursorPositionVisible, False);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Neditable, False);
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nsensitive, True);
      Mon_Data.Gateway.Number_Of_Local_Entities := Xt.CreateManagedWidget (
	"Number_Of_Local_Entities", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	Arglist, Argcount);


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Number_Of_Clients_Label,
	Help_Text_Widget   => Mon_Data.Description,
	Help_Text_Message  => K_Number_Of_Clients_Help_String);
      Motif_Utilities.Install_Active_Help (Number_Of_Local_Entities_Label,
	Mon_Data.Description, K_Number_Of_Local_Entities_Help_String);


      Motif_Utilities.Install_Active_Help (
	Mon_Data.Gateway.Number_Of_Clients, Mon_Data.Description,
	K_Number_Of_Clients_Help_String);
      Motif_Utilities.Install_Active_Help (
	Mon_Data.Gateway.Number_Of_Local_Entities, Mon_Data.Description,
	K_Number_Of_Local_Entities_Help_String);

   end if; -- (Mon_Data.Gateway.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Mon_Data.Title, K_Panel_Title);
   Xt.ManageChild (Mon_Data.Gateway.Shell);
   Mon_Data.Parameter_Active_Hierarchy := Mon_Data.Gateway.Shell;

end Create_Monitors_Panel_Gateway;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/03/94   D. Forrest
--      - Initial version
--
-- --

