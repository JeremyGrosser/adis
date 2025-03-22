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
-- UNIT NAME:          Create_Monitors_Panel_Entities
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
procedure Create_Monitors_Panel_Entities(
   Parent      : in     Xt.WIDGET;
   Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title       : constant STRING :=
     "XDG Server Entities Monitor";
   K_Number_Of_Columns : constant INTEGER := 1;   -- Number of columns for the
						  -- main rowcolumn widget
   K_Arglist_Max       : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max        : constant INTEGER := 128; -- Max characters per string

   --
   -- Create the constant help strings
   --
   K_Entities_Monitor_Help_String : constant STRING :=
     "The entity ID and location information " &
       "(Friendly=Blue; Opposing=Red; Neutral=Green; Other=Black).";

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
   Main_Rowcolumn                  : Xt.WIDGET := Xt.XNULL;  -- Main Rowcolumn
   Temp_Label                      : Xt.WIDGET := Xt.XNULL;  -- Label Widget
   Temp_Separator                  : Xt.WIDGET := Xt.XNULL;  -- Separator Widget

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

   if (Mon_Data.Entities.Shell /= Xt.XNULL) then

      Xm.ScrolledWindowSetAreas (Mon_Data.Parameter_Scrolled_Window,
	Xt.XNULL, Xt.XNULL, Mon_Data.Entities.Shell);
      Xt.ManageChild (Mon_Data.Entities.Shell);

   else -- (Mon_Data.Entities.Shell = Xt.XNULL)

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
      Mon_Data.Entities.Shell := Main_Rowcolumn;
      Mon_Data.Entities.Entities_List := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the entity monitor sample labels.
      --
      --------------------------------------------------------------------
      declare
--          Sample Entity line:
--          "XXXX   XXXX   XXXX     X,XXX,XXX.X   X,XXX,XXX.X   X,XXX,XXX.X"
--	    " 105___   1___   1_____6,380,063.0___6,380,478.2___6,380,082.7";
--
	 K_Entity_Title_String_1 : constant STRING :=
	    "     Entity ID                         Location               ";
	 K_Entity_Title_String_2 : constant STRING :=
	    "-------------------    ---------------------------------------";
	 K_Entity_Title_String_3 : constant STRING :=
	    "Site    App  Entity         X             Y             Z     ";
	 K_Entity_1_String : constant STRING :=
	    " 105      1      1     6,380,063.0   6,380,478.2   6,380,082.7";
	 K_Entity_2_String : constant STRING :=
	    " 221    102      1     6,380,538.3   6,380,121.4   6,380,117.5";
	 K_Entity_3_String : constant STRING :=
	    "  52     96      1     6,380,311.8   6,380,388.4   6,380,027.0";
	 K_Entity_4_String : constant STRING :=
	    " 321     15      1     6,380,209.1   6,380,342.9   6,380,115.8";

	 Xcolor_Friendly : Xlib.Pixel := MOTIF_UTILITIES.make_color (
	   Main_Rowcolumn, "blue");
	 Xcolor_Opposing : Xlib.Pixel := MOTIF_UTILITIES.make_color (
	   Main_Rowcolumn, "red");
	 Xcolor_Neutral  : Xlib.Pixel := MOTIF_UTILITIES.make_color (
	   Main_Rowcolumn, "green4");
	 Xcolor_Other    : Xlib.Pixel := MOTIF_UTILITIES.make_color (
	   Main_Rowcolumn, "black");

	 Fontlist_Courier : Xm.FONTLIST;

      begin

	 --
	 -- Create a fontlist holding Courier 17 bold and the default font.
	 --
	 Fontlist_Courier := Xm.FontListCreate (
	   Xlib.LoadQueryFont (Xt.GetDisplay (Main_Rowcolumn),
	     "-*-courier-bold-r-normal--17-*"),
	   "courier_17_bold");
         Fontlist_Courier := Xm.FontListAdd (Fontlist_Courier,
	   Xlib.LoadQueryFont (Xt.GetDisplay (Main_Rowcolumn),
	     "XtDefaultFont"),
           "default");

	 --
	 -- Create the Entities Monitor title labels.
	 --
	 Temp_Label := Motif_Utilities.Create_Label (Main_Rowcolumn,
	    K_Entity_Title_String_1);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nfontlist, Fontlist_Courier);
         Xt.SetValues (Temp_Label, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Label,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 Temp_Label := Motif_Utilities.Create_Label (Main_Rowcolumn,
	    K_Entity_Title_String_2);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nfontlist, Fontlist_Courier);
         Xt.SetValues (Temp_Label, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Label,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 Temp_Label := Motif_Utilities.Create_Label (Main_Rowcolumn,
	    K_Entity_Title_String_3);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nfontlist, Fontlist_Courier);
         Xt.SetValues (Temp_Label, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Label,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 --
	 -- Create the separator to separate the titles from the entities data.
	 --
         Argcount := 0;
	 Temp_Separator := Xt.CreateManagedWidget ("Temp_Separator",
	   Xm.SeparatorWidgetClass, Main_Rowcolumn, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Separator,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 --
	 -- Create the label for the first demo entity.
	 --
	 Temp_Label := Motif_Utilities.Create_Label (Main_Rowcolumn,
	    K_Entity_1_String);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nforeground,
	   INTEGER(Xcolor_Friendly));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nfontlist, Fontlist_Courier);
         Xt.SetValues (Temp_Label, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Label,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 --
	 -- Create the label for the second demo entity.
	 --
	 Temp_Label := Motif_Utilities.Create_Label (Main_Rowcolumn,
	    K_Entity_2_String);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nforeground,
	   INTEGER(Xcolor_Opposing));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nfontlist, Fontlist_Courier);
         Xt.SetValues (Temp_Label, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Label,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 --
	 -- Create the label for the third demo entity.
	 --
	 Temp_Label := Motif_Utilities.Create_Label (Main_Rowcolumn,
	    K_Entity_3_String);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nforeground,
	   INTEGER(Xcolor_Neutral));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nfontlist, Fontlist_Courier);
         Xt.SetValues (Temp_Label, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Label,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 --
	 -- Create the label for the fourth demo entity.
	 --
	 Temp_Label := Motif_Utilities.Create_Label (Main_Rowcolumn,
	    K_Entity_4_String);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nforeground,
	   INTEGER(Xcolor_Other));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.Nfontlist, Fontlist_Courier);
         Xt.SetValues (Temp_Label, Arglist, Argcount);
         Motif_Utilities.Install_Active_Help (Temp_Label,
	    Mon_Data.Description, K_Entities_Monitor_Help_String);

	 --
	 -- Deallocate the previously allocated font list
	 --
	 Xm.FontListFree (Fontlist_Courier);
      end;

      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Mon_Data.Entities.Entities_List,
	Help_Text_Widget   => Mon_Data.Description,
	Help_Text_Message  => K_Entities_Monitor_Help_String);

   end if; -- (Mon_Data.Entities.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Mon_Data.Title, K_Panel_Title);
   Xt.ManageChild (Mon_Data.Entities.Shell);
   Mon_Data.Parameter_Active_Hierarchy := Mon_Data.Entities.Shell;

end Create_Monitors_Panel_Entities;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/03/94   D. Forrest
--      - Initial version
--
-- --

