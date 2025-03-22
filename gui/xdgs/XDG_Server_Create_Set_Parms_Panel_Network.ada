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
-- UNIT NAME:          Create_Set_Parms_Panel_Network
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
procedure Create_Set_Parms_Panel_Network(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title        : constant STRING :=
     "XDG Server Network Parameters Input Screen";
   K_Arglist_Max        : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max         : constant INTEGER := 128; -- Max characters per string
   K_Chars_Per_UDP_Quad : constant INTEGER := 3; -- Max digits per UDP Address
						 -- quad

   --
   -- Create the constant help strings
   --
   K_UDP_Port_Help_String : constant STRING :=
     "Please enter the UDP Port.";
   K_Destination_Address_Help_String : constant STRING :=
     "Please enter the Destination Address.";
   K_Destination_Address_Quad_1_Help_String : constant STRING :=
     "Please enter Quad #1 of the Destination Address.";
   K_Destination_Address_Quad_2_Help_String : constant STRING :=
     "Please enter Quad #2 of the Destination Address.";
   K_Destination_Address_Quad_3_Help_String : constant STRING :=
     "Please enter Quad #3 of the Destination Address.";
   K_Destination_Address_Quad_4_Help_String : constant STRING :=
     "Please enter Quad #4 of the Destination Address.";
   K_Data_Reception_Help_String : constant STRING :=
     "Please select the Data Reception status.";
   K_Data_Transmission_Help_String : constant STRING :=
     "Please select the Data Transmission status.";


   --
   -- Miscellaneous declarations
   --
   Arglist           : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount          : Xt.INT := 0;                    -- number of arguments
   Temp_String       : STRING(1..K_String_Max);        -- Temporary string
   Temp_XmString     : Xm.XMSTRING;                    -- Temporary X string
   Temp_Label        : Xt.WIDGET := Xt.XNULL;          -- Temporary Widget
   Do_Initialization : BOOLEAN;

   --
   -- Local widget declarations
   --
   Main_Rowcolumn                  : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   UDP_Port_Label                  : Xt.WIDGET := Xt.XNULL; -- Parm Name
   UDP_Port_Units_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Destination_Address_Quad_Form   : Xt.WIDGET := Xt.XNULL; -- UDP Addr Form
   Destination_Address_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Destination_Address_Units_Label : Xt.WIDGET := Xt.XNULL; -- Parm Units label
   Data_Reception_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Data_Reception_Units_Label      : Xt.WIDGET := Xt.XNULL; -- Parm Units
   Data_Transmission_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Data_Transmission_Units_Label   : Xt.WIDGET := Xt.XNULL; -- Parm Units label

   --
   -- Option Menu Declarations
   --
   Network_Data_Recv_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Network_Data_Recv_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Network_Data_Recv_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Network_Data_Recv_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Network_Data_Xmit_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Network_Data_Xmit_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Network_Data_Xmit_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Network_Data_Xmit_Disabled_Pushbutton : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

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

   if (Set_Data.Network.Shell /= Xt.XNULL) then

      Do_Initialization := False;
      Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
        Xt.XNULL, Xt.XNULL, Set_Data.Network.Shell);
      Xt.ManageChild (Set_Data.Network.Shell);

   else -- (Set_Data.Network.Shell = Xt.XNULL)

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
	Xm.RowColumnWidgetClass, Set_Data.Parameter_Scrolled_Window,
	  Arglist, Argcount);
      Set_Data.Network.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      UDP_Port_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "UDP Port");
      Destination_Address_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Destination Address");
      Data_Reception_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Data Reception");
      Data_Transmission_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Data Transmission");

      --------------------------------------------------------------------
      --
      -- Create the text fields
      --
      --------------------------------------------------------------------

      --
      -- Create the UDP_Port text field
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Nvalue, "");
      Set_Data.Network.UDP_Port := Xt.CreateManagedWidget (
	"UDP Port", Xm.TextFieldWidgetClass, Main_Rowcolumn,
	  Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions (
        Parent           => Set_Data.Network.UDP_Port,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => INTEGER'last);

      --
      -- Create the Destination_Address Quad form
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.Norientation,
	INTEGER(Xm.HORIZONTAL));
      Destination_Address_Quad_Form := Xt.CreateManagedWidget (
	"Destination_Address_Quad_Form", Xm.RowColumnWidgetClass,
	  Main_Rowcolumn, Arglist, Argcount);
      --
      -- Create the Destination_Address quad text fields
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg(Arglist (Argcount), Xmdef.Nvalue, "");
      Argcount := Argcount + 1;
      Xt.SetArg(Arglist (Argcount), Xmdef.Ncolumns, K_Chars_Per_UDP_Quad);

      Set_Data.Network.Destination_Address_Quad_1 := Xt.CreateManagedWidget(
	"Destination_Address_Quad_1", Xm.TextFieldWidgetClass,
	  Destination_Address_Quad_Form, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Set_Data.Network.Destination_Address_Quad_1,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => XDG_Server.K_IP_Address_Quad_Chars_Max,
        Minimum_Integer  => XDG_Server.K_IP_Address_Quad_Min,
        Maximum_Integer  => XDG_Server.K_IP_Address_Quad_Max);
      Temp_Label := Motif_Utilities.Create_Label(
	Destination_Address_Quad_Form, ".");

      Set_Data.Network.Destination_Address_Quad_2 := Xt.CreateManagedWidget(
	"Destination_Address_Quad_2", Xm.TextFieldWidgetClass,
	  Destination_Address_Quad_Form, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Set_Data.Network.Destination_Address_Quad_2,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => XDG_Server.K_IP_Address_Quad_Chars_Max,
        Minimum_Integer  => XDG_Server.K_IP_Address_Quad_Min,
        Maximum_Integer  => XDG_Server.K_IP_Address_Quad_Max);
      Temp_Label := Motif_Utilities.Create_Label(
	Destination_Address_Quad_Form, ".");

      Set_Data.Network.Destination_Address_Quad_3 := Xt.CreateManagedWidget(
	"Destination_Address_Quad_3", Xm.TextFieldWidgetClass,
	  Destination_Address_Quad_Form, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Set_Data.Network.Destination_Address_Quad_3,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => XDG_Server.K_IP_Address_Quad_Chars_Max,
        Minimum_Integer  => XDG_Server.K_IP_Address_Quad_Min,
        Maximum_Integer  => XDG_Server.K_IP_Address_Quad_Max);
      Temp_Label := Motif_Utilities.Create_Label(
	Destination_Address_Quad_Form, ".");

      Set_Data.Network.Destination_Address_Quad_4 := Xt.CreateManagedWidget(
	"Destination_Address_Quad_4", Xm.TextFieldWidgetClass,
	  Destination_Address_Quad_Form, Arglist, Argcount);
      Motif_Utilities.Install_Text_Restrictions_With_Integer_Range (
        Parent           => Set_Data.Network.Destination_Address_Quad_4,
        Text_Type        => Motif_Utilities.TEXT_NUMERIC_INTEGER_NONNEGATIVE,
        Characters_Count => XDG_Server.K_IP_Address_Quad_Chars_Max,
        Minimum_Integer  => XDG_Server.K_IP_Address_Quad_Min,
        Maximum_Integer  => XDG_Server.K_IP_Address_Quad_Max);

      --
      -- Create the Data Reception Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (
	label       => XDG_Server.K_Enabled_String,
	class       => Xm.PushButtonGadgetClass,
	sensitive   => TRUE,
	mnemonic    => ASCII.NUL,   -- 'P'
	accelerator => "",          -- "Alt<Key>P"
	accel_text  => "",          -- "Alt+P"
	callback    => Motif_Utilities.Set_Boolean_Value_CB'address,
	cb_data     => XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	  XDG_Server.K_Enabled)),
	subitems    => NULL,
	item_widget => Network_Data_Recv_Enabled_Pushbutton,
	menu_item   => Network_Data_Recv_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Network_Data_Recv_Disabled_Pushbutton,
	          Network_Data_Recv_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	            XDG_Server.DISABLED)));

      --
      -- Create the Network Data Reception option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Network_Data_Recv_Menu,
	return_widget    => Network_Data_Recv_Menu_Cascade);
      Xt.ManageChild (Network_Data_Recv_Menu_Cascade);
      Set_Data.Network.Data_Reception := Network_Data_Recv_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.Network_Data_Reception_Flag'address);
      Xt.SetValues (Network_Data_Recv_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	XDG_Server.ENABLED)).Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (Network_Data_Recv_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	XDG_Server.DISABLED)).Item_Widget.all, Arglist, Argcount);

      --
      -- Create the Data Transmission Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (
	label       => XDG_Server.K_Enabled_String,
	class       => Xm.PushButtonGadgetClass,
	sensitive   => TRUE,
	mnemonic    => ASCII.NUL,   -- 'P'
	accelerator => "",          -- "Alt<Key>P"
	accel_text  => "",          -- "Alt+P"
	callback    => Motif_Utilities.Set_Boolean_Value_CB'address,
	cb_data     => XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	  XDG_Server.K_Enabled)),
	subitems    => NULL,
	item_widget => Network_Data_Xmit_Enabled_Pushbutton,
	menu_item   => Network_Data_Xmit_Menu(XDG_Server.
	  ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)));

      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String, 
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, 
		Network_Data_Xmit_Disabled_Pushbutton,
	          Network_Data_Xmit_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	            XDG_Server.DISABLED)));

      --
      -- Create the Network Data Reception option menu.
      --
      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Network_Data_Xmit_Menu,
	return_widget    => Network_Data_Xmit_Menu_Cascade);
      Xt.ManageChild (Network_Data_Xmit_Menu_Cascade);
      Set_Data.Network.Data_Transmission := Network_Data_Xmit_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	XDG_Server.Network_Data_Transmission_Flag'address);
      Xt.SetValues (Network_Data_Xmit_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	XDG_Server.ENABLED)).Item_Widget.all, Arglist, Argcount);
      Xt.SetValues (Network_Data_Xmit_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	XDG_Server.DISABLED)).Item_Widget.all, Arglist, Argcount);


      --------------------------------------------------------------------
      --
      -- Create the units labels
      --
      --------------------------------------------------------------------
      UDP_Port_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Destination_Address_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Data_Reception_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");
      Data_Transmission_Units_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "");


      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => UDP_Port_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_UDP_Port_Help_String);
      Motif_Utilities.Install_Active_Help (Destination_Address_Label,
	Set_Data.Description, K_Destination_Address_Help_String);
      Motif_Utilities.Install_Active_Help (Data_Reception_Label,
	Set_Data.Description, K_Data_Reception_Help_String);
      Motif_Utilities.Install_Active_Help (Data_Transmission_Label,
	Set_Data.Description, K_Data_Transmission_Help_String);


      Motif_Utilities.Install_Active_Help (
	Set_Data.Network.UDP_Port, Set_Data.Description,
	  K_UDP_Port_Help_String);
      Motif_Utilities.Install_Active_Help (
	Destination_Address_Quad_Form, Set_Data.Description,
	  K_Destination_Address_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Network.Destination_Address_Quad_1, Set_Data.Description,
	  K_Destination_Address_Quad_1_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Network.Destination_Address_Quad_2, Set_Data.Description,
	  K_Destination_Address_Quad_2_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Network.Destination_Address_Quad_3, Set_Data.Description,
	  K_Destination_Address_Quad_3_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Network.Destination_Address_Quad_4, Set_Data.Description,
	  K_Destination_Address_Quad_4_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Network.Data_Reception, Set_Data.Description,
	  K_Data_Reception_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.Network.Data_Transmission, Set_Data.Description,
	  K_Data_Transmission_Help_String);

   end if; -- (Set_Data.Network.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.Network.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.Network.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Panel_Network (Set_Data.Network);
   end if;

end Create_Set_Parms_Panel_Network;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/03/94   D. Forrest
--      - Initial version
--
-- --

