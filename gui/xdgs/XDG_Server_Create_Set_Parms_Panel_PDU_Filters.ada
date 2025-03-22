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
-- UNIT NAME:          Create_Set_Parms_Panel_PDU_Filters
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
procedure Create_Set_Parms_Panel_PDU_Filters(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Constant Declarations
   --
   K_Panel_Title       : constant STRING :=
     "XDG Server PDU Filters Input Screen";
   K_COLUMN_COUNT   : constant INTEGER := 2;   -- Columns in Main RowColumn
   K_Arglist_Max    : constant INTEGER := 25;  -- Max aruments per arglist
   K_String_Max     : constant INTEGER := 128; -- Max characters per string
   K_PDU_Filter_Name_Max : constant INTEGER := 32; -- Max chars per PDU name
   -- 12345678901234567890123456789012
   K_PDU_Filter_Help_Max : constant INTEGER := 64; -- Max chars per PDU Help
   -- 1234567890123456789012345678901234567890123456789012345678901234


   --
   -- Create the constant help strings
   --
   K_Entity_State_Help_String : constant STRING :=
     "Please select the Entity State PDU filter status.";
   K_Fire_Help_String : constant STRING :=
     "Please select the Fire PDU filter status.";
   K_Detonation_Help_String : constant STRING :=
     "Please select the Detonation PDU filter status.";
   K_Collision_Help_String : constant STRING :=
     "Please select the Collision PDU filter status.";
   K_Service_Request_Help_String : constant STRING :=
     "Please select the Service_Request PDU filter status.";
   K_Resupply_Offer_Help_String : constant STRING :=
     "Please select the Resupply Offer PDU filter status.";
   K_Resupply_Received_Help_String : constant STRING :=
     "Please select the Resupply Received PDU filter status.";
   K_Resupply_Cancelled_Help_String : constant STRING :=
     "Please select the Resupply Cancelled PDU filter status.";
   K_Repair_Complete_Help_String : constant STRING :=
     "Please select the Repair Complete PDU filter status.";
   K_Repair_Response_Help_String : constant STRING :=
     "Please select the Repair Response PDU filter status.";
   K_Create_Entity_Help_String : constant STRING :=
     "Please select the Create Entity PDU filter status.";
   K_Remove_Entity_Help_String : constant STRING :=
     "Please select the Remove Entity PDU filter status.";
   K_Start_Resume_Help_String : constant STRING :=
     "Please select the Start/Resume PDU filter status.";
   K_Stop_Freeze_Help_String : constant STRING :=
     "Please select the Stop/Freeze PDU filter status.";
   K_Acknowledge_Help_String : constant STRING :=
     "Please select the Acknowledge PDU filter status.";
   K_Action_Request_Help_String : constant STRING :=
     "Please select the Action Request PDU filter status.";
   K_Action_Response_Help_String : constant STRING :=
     "Please select the Action Response PDU filter status.";
   K_Data_Query_Help_String : constant STRING :=
     "Please select the Data Query PDU filter status.";
   K_Set_Data_Help_String : constant STRING :=
     "Please select the Set Data PDU filter status.";
   K_Data_Help_String : constant STRING :=
     "Please select the Data PDU filter status.";
   K_Event_Report_Help_String : constant STRING :=
     "Please select the Event Report PDU filter status.";
   K_Message_Help_String : constant STRING :=
     "Please select the Message PDU filter status.";
   K_Emission_Help_String : constant STRING :=
     "Please select the Emission PDU filter status.";
   K_Laser_Help_String : constant STRING :=
     "Please select the Laser PDU filter status.";
   K_Transmitter_Help_String : constant STRING :=
     "Please select the Transmitter PDU filter status.";
   K_Receiver_Help_String : constant STRING :=
     "Please select the Receiver PDU filter status.";

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
   Main_Rowcolumn                : Xt.WIDGET := Xt.XNULL; -- Main Rowcolumn
   Entity_State_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Fire_Label                    : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Detonation_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Collision_Label               : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Service_Request_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Resupply_Offer_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Resupply_Received_Label       : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Resupply_Cancelled_Label      : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Repair_Complete_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Repair_Response_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Create_Entity_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Remove_Entity_Label           : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Start_Resume_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Stop_Freeze_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Acknowledge_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Action_Request_Label          : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Action_Response_Label         : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Data_Query_Label              : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Set_Data_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Data_Label                    : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Event_Report_Label            : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Message_Label                 : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Emission_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Laser_Label                   : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Transmitter_Label             : Xt.WIDGET := Xt.XNULL; -- Parm Name
   Receiver_Label                : Xt.WIDGET := Xt.XNULL; -- Parm Name

   --
   -- Option Menu Declarations
   --
   Entity_State_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Entity_State_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Entity_State_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Entity_State_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Fire_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Fire_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Fire_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Fire_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Detonation_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Detonation_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Detonation_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Detonation_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Collision_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Collision_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Collision_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Collision_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Service_Request_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Service_Request_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Service_Request_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Service_Request_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Resupply_Offer_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Resupply_Offer_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Resupply_Offer_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Resupply_Offer_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Resupply_Received_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Resupply_Received_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Resupply_Received_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Resupply_Received_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Resupply_Cancelled_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Resupply_Cancelled_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Resupply_Cancelled_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Resupply_Cancelled_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Repair_Complete_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Repair_Complete_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Repair_Complete_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Repair_Complete_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Repair_Response_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Repair_Response_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Repair_Response_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Repair_Response_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Create_Entity_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Create_Entity_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Create_Entity_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Create_Entity_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Remove_Entity_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Remove_Entity_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Remove_Entity_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Remove_Entity_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Start_Resume_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Start_Resume_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Start_Resume_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Start_Resume_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Stop_Freeze_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Stop_Freeze_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Stop_Freeze_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Stop_Freeze_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Acknowledge_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Acknowledge_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Acknowledge_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Acknowledge_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Action_Request_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Action_Request_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Action_Request_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Action_Request_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Action_Response_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Action_Response_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Action_Response_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Action_Response_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Data_Query_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Data_Query_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Data_Query_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Data_Query_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Set_Data_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Set_Data_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Set_Data_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Set_Data_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Data_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Data_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Data_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Data_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Event_Report_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Event_Report_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Event_Report_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Event_Report_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Message_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Message_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Message_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Message_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Emission_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Emission_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Emission_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Emission_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Laser_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Laser_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Laser_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Laser_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Transmitter_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Transmitter_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Transmitter_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Transmitter_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);

   Receiver_Menu : XDG_Server.ENABLED_DISABLED_OPTION_MENU_TYPE;
   Receiver_Menu_Cascade : Xt.WIDGET := Xt.XNULL;
   Receiver_Enabled_Pushbutton  : Motif_Utilities.AWIDGET :=
     new Xt.WIDGET'(Xt.XNULL);
   Receiver_Disabled_Pushbutton  : Motif_Utilities.AWIDGET :=
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

begin


   --
   -- Unmanage the previously displayed (active) parameter widget hierarchy.
   --
   if (Set_Data.Parameter_Active_Hierarchy /= Xt.XNULL) then
       Xt.UnmanageChild (Set_Data.Parameter_Active_Hierarchy);
   end if;

   if (Set_Data.PDU_Filters.Shell /= Xt.XNULL) then

       Do_Initialization := False;
       Xm.ScrolledWindowSetAreas (Set_Data.Parameter_Scrolled_Window,
         Xt.XNULL, Xt.XNULL, Set_Data.PDU_Filters.Shell);
       Xt.ManageChild (Set_Data.PDU_Filters.Shell);

   else -- (Set_Data.PDU_Filters.Shell = Xt.XNULL)

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
      Xt.SetArg (Arglist (Argcount), Xmdef.NnumColumns, K_COLUMN_COUNT);
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
      Set_Data.PDU_Filters.Shell := Main_Rowcolumn;

      --------------------------------------------------------------------
      --
      -- Create the name labels
      --
      --------------------------------------------------------------------
      Entity_State_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Entity State");
      Fire_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Fire");
      Detonation_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Detonation");
      Collision_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Collision");
      Service_Request_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Service Request");
      Resupply_Offer_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Resupply Offer");
      Resupply_Received_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Resupply Received");
      Resupply_Cancelled_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Resupply Cancelled");
      Repair_Complete_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Repair Complete");
      Repair_Response_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Repair Response");
      Create_Entity_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Create Entity");
      Remove_Entity_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Remove Entity");
      Start_Resume_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Start/Resume");
      Stop_Freeze_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Stop/Freeze");
      Acknowledge_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Acknowledge");
      Action_Request_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Action Request");
      Action_Response_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Action Response");
      Data_Query_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Data Query");
      Set_Data_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Set Data");
      Data_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Data");
      Event_Report_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Event Report");
      Message_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Message");
      Emission_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Emission");
      Laser_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Laser");
      Transmitter_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Transmitter");
      Receiver_Label := Motif_Utilities.Create_Label (
	Main_Rowcolumn, "Keep Receiver");

      --------------------------------------------------------------------
      --
      -- Create the user input widgets
      --
      --------------------------------------------------------------------

      --
      -- Create the Entity_State Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (
--	label       => XDG_Server.K_Enabled_String,
	label       => "Enabled...",
	class       => Xm.PushButtonGadgetClass,
	sensitive   => TRUE,
	mnemonic    => ASCII.NUL,   -- 'P'
	accelerator => "",          -- "Alt<Key>P"
	accel_text  => "",          -- "Alt+P"
	callback    => Motif_Utilities.Set_Boolean_Value_CB'address,
	cb_data     => XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	  XDG_Server.K_Enabled)),
	subitems    => NULL,
	item_widget => Entity_State_Enabled_Pushbutton,
	menu_item   => Entity_State_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
	  XDG_Server.ENABLED)));

--      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
      MOTIF_UTILITIES.Build_Menu_Item ("Disabled...",
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Entity_State_Disabled_Pushbutton,
	        Entity_State_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));

      MOTIF_UTILITIES.Build_Menu (
	parent           => Main_Rowcolumn,
	menu_type        => Xm.MENU_OPTION,
	menu_title       => "",
	menu_mnemonic    => ASCII.NUL,
	menu_sensitivity => TRUE,
	items            => Entity_State_Menu,
	return_widget    => Entity_State_Menu_Cascade);
      Xt.ManageChild (Entity_State_Menu_Cascade);
      Set_Data.PDU_Filters.Entity_State := Entity_State_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Entity_State_Flag'address);
      Xt.SetValues (Entity_State_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Entity_State_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Fire Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Enabled)), NULL, Fire_Enabled_Pushbutton,
	        Fire_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Fire_Disabled_Pushbutton,
	        Fire_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Fire_Menu, Fire_Menu_Cascade);
      Xt.ManageChild (Fire_Menu_Cascade);
      Set_Data.PDU_Filters.Fire := Fire_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Fire_Flag'address);
      Xt.SetValues (Fire_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Fire_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Detonation Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Enabled)), NULL, Detonation_Enabled_Pushbutton,
	        Detonation_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Detonation_Disabled_Pushbutton,
		Detonation_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Detonation_Menu, Detonation_Menu_Cascade);
      Xt.ManageChild (Detonation_Menu_Cascade);
      Set_Data.PDU_Filters.Detonation := Detonation_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Detonation_Flag'address);
      Xt.SetValues (Detonation_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Detonation_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Collision Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Enabled)), NULL, Collision_Enabled_Pushbutton,
		Collision_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Collision_Disabled_Pushbutton,
		Collision_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Collision_Menu, Collision_Menu_Cascade);
      Xt.ManageChild (Collision_Menu_Cascade);
      Set_Data.PDU_Filters.Collision := Collision_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Collision_Flag'address);
      Xt.SetValues (Collision_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Collision_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Service_Request Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Enabled)), NULL, Service_Request_Enabled_Pushbutton,
		Service_Request_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Service_Request_Disabled_Pushbutton,
		  Service_Request_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Service_Request_Menu, Service_Request_Menu_Cascade);
      Xt.ManageChild (Service_Request_Menu_Cascade);
      Set_Data.PDU_Filters.Service_Request := Service_Request_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Service_Request_Flag'address);
      Xt.SetValues (Service_Request_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Service_Request_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Resupply_Offer Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Resupply_Offer_Enabled_Pushbutton,
		Resupply_Offer_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Resupply_Offer_Disabled_Pushbutton,
		Resupply_Offer_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Resupply_Offer_Menu, Resupply_Offer_Menu_Cascade);
      Xt.ManageChild (Resupply_Offer_Menu_Cascade);
      Set_Data.PDU_Filters.Resupply_Offer := Resupply_Offer_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Resupply_Offer_Flag'address);
      Xt.SetValues (Resupply_Offer_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Resupply_Offer_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Resupply_Received Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Resupply_Received_Enabled_Pushbutton,
		Resupply_Received_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Resupply_Received_Disabled_Pushbutton,
		  Resupply_Received_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Resupply_Received_Menu,
	  Resupply_Received_Menu_Cascade);
      Xt.ManageChild (Resupply_Received_Menu_Cascade);
      Set_Data.PDU_Filters.Resupply_Received := Resupply_Received_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Resupply_Received_Flag'address);
      Xt.SetValues (Resupply_Received_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Resupply_Received_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Resupply_Cancelled Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Resupply_Cancelled_Enabled_Pushbutton,
		Resupply_Cancelled_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String, 
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Resupply_Cancelled_Disabled_Pushbutton,
		  Resupply_Cancelled_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Resupply_Cancelled_Menu, 
	  Resupply_Cancelled_Menu_Cascade);
      Xt.ManageChild (Resupply_Cancelled_Menu_Cascade);
      Set_Data.PDU_Filters.Resupply_Cancelled :=
	Resupply_Cancelled_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Resupply_Cancelled_Flag'address);
      Xt.SetValues (Resupply_Cancelled_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Resupply_Cancelled_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Repair_Complete Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Repair_Complete_Enabled_Pushbutton,
		Repair_Complete_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Repair_Complete_Disabled_Pushbutton,
		  Repair_Complete_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Repair_Complete_Menu, Repair_Complete_Menu_Cascade);
      Xt.ManageChild (Repair_Complete_Menu_Cascade);
      Set_Data.PDU_Filters.Repair_Complete := Repair_Complete_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Repair_Complete_Flag'address);
      Xt.SetValues (Repair_Complete_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Repair_Complete_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Repair_Response Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Repair_Response_Enabled_Pushbutton,
		Repair_Response_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL,
		Repair_Response_Disabled_Pushbutton,
		  Repair_Response_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Repair_Response_Menu, Repair_Response_Menu_Cascade);
      Xt.ManageChild (Repair_Response_Menu_Cascade);
      Set_Data.PDU_Filters.Repair_Response := Repair_Response_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Repair_Response_Flag'address);
      Xt.SetValues (Repair_Response_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Repair_Response_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Create_Entity Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Create_Entity_Enabled_Pushbutton,
		Create_Entity_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Create_Entity_Disabled_Pushbutton,
		Create_Entity_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Create_Entity_Menu, Create_Entity_Menu_Cascade);
      Xt.ManageChild (Create_Entity_Menu_Cascade);
      Set_Data.PDU_Filters.Create_Entity := Create_Entity_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Create_Entity_Flag'address);
      Xt.SetValues (Create_Entity_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Create_Entity_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Remove_Entity Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Remove_Entity_Enabled_Pushbutton,
		Remove_Entity_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (
	XDG_Server.K_Disabled_String, Xm.PushButtonGadgetClass,
	  TRUE, ASCII.NUL, "", "", Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Remove_Entity_Disabled_Pushbutton,
		Remove_Entity_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Remove_Entity_Menu, Remove_Entity_Menu_Cascade);
      Xt.ManageChild (Remove_Entity_Menu_Cascade);
      Set_Data.PDU_Filters.Remove_Entity := Remove_Entity_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Remove_Entity_Flag'address);
      Xt.SetValues (Remove_Entity_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Remove_Entity_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Start_Resume Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Start_Resume_Enabled_Pushbutton,
		Start_Resume_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Start_Resume_Disabled_Pushbutton,
		Start_Resume_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Start_Resume_Menu, Start_Resume_Menu_Cascade);
      Xt.ManageChild (Start_Resume_Menu_Cascade);
      Set_Data.PDU_Filters.Start_Resume := Start_Resume_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Start_Resume_Flag'address);
      Xt.SetValues (Start_Resume_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Start_Resume_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Stop_Freeze Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Stop_Freeze_Enabled_Pushbutton,
		Stop_Freeze_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Stop_Freeze_Disabled_Pushbutton,
		Stop_Freeze_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Stop_Freeze_Menu, Stop_Freeze_Menu_Cascade);
      Xt.ManageChild (Stop_Freeze_Menu_Cascade);
      Set_Data.PDU_Filters.Stop_Freeze := Stop_Freeze_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Stop_Freeze_Flag'address);
      Xt.SetValues (Stop_Freeze_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Stop_Freeze_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Acknowledge Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Acknowledge_Enabled_Pushbutton,
		Acknowledge_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Acknowledge_Disabled_Pushbutton,
		Acknowledge_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Acknowledge_Menu, Acknowledge_Menu_Cascade);
      Xt.ManageChild (Acknowledge_Menu_Cascade);
      Set_Data.PDU_Filters.Acknowledge := Acknowledge_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Acknowledge_Flag'address);
      Xt.SetValues (Acknowledge_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Acknowledge_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Action_Request Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Action_Request_Enabled_Pushbutton,
		Action_Request_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Action_Request_Disabled_Pushbutton,
		Action_Request_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Action_Request_Menu, Action_Request_Menu_Cascade);
      Xt.ManageChild (Action_Request_Menu_Cascade);
      Set_Data.PDU_Filters.Action_Request := Action_Request_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Action_Request_Flag'address);
      Xt.SetValues (Action_Request_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Action_Request_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Action_Response Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Action_Response_Enabled_Pushbutton,
		Action_Response_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, 
		Action_Response_Disabled_Pushbutton,
		  Action_Response_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		    XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Action_Response_Menu, Action_Response_Menu_Cascade);
      Xt.ManageChild (Action_Response_Menu_Cascade);
      Set_Data.PDU_Filters.Action_Response := Action_Response_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Action_Response_Flag'address);
      Xt.SetValues (Action_Response_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Action_Response_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Data_Query Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Data_Query_Enabled_Pushbutton,
		Data_Query_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "", 
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Data_Query_Disabled_Pushbutton,
		Data_Query_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Data_Query_Menu, Data_Query_Menu_Cascade);
      Xt.ManageChild (Data_Query_Menu_Cascade);
      Set_Data.PDU_Filters.Data_Query := Data_Query_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Data_Query_Flag'address);
      Xt.SetValues (Data_Query_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Data_Query_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Set_Data Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Set_Data_Enabled_Pushbutton,
		Set_Data_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Set_Data_Disabled_Pushbutton,
		Set_Data_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Set_Data_Menu, Set_Data_Menu_Cascade);
      Xt.ManageChild (Set_Data_Menu_Cascade);
      Set_Data.PDU_Filters.Set_Data := Set_Data_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Set_Data_Flag'address);
      Xt.SetValues (Set_Data_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Set_Data_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);
      --
      -- Create the Data Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Data_Enabled_Pushbutton,
		Data_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Data_Disabled_Pushbutton,
		Data_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Data_Menu, Data_Menu_Cascade);
      Xt.ManageChild (Data_Menu_Cascade);
      Set_Data.PDU_Filters.Data := Data_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Data_Flag'address);
      Xt.SetValues (Data_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Data_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Event_Report Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Event_Report_Enabled_Pushbutton,
		Event_Report_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Event_Report_Disabled_Pushbutton,
		Event_Report_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Event_Report_Menu, Event_Report_Menu_Cascade);
      Xt.ManageChild (Event_Report_Menu_Cascade);
      Set_Data.PDU_Filters.Event_Report := Event_Report_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Event_Report_Flag'address);
      Xt.SetValues (Event_Report_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Event_Report_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Message Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Message_Enabled_Pushbutton,
		Message_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Message_Disabled_Pushbutton,
		Message_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Message_Menu, Message_Menu_Cascade);
      Xt.ManageChild (Message_Menu_Cascade);
      Set_Data.PDU_Filters.Message := Message_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Message_Flag'address);
      Xt.SetValues (Message_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Message_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Emission Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Emission_Enabled_Pushbutton,
		Emission_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Emission_Disabled_Pushbutton,
		Emission_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Emission_Menu, Emission_Menu_Cascade);
      Xt.ManageChild (Emission_Menu_Cascade);
      Set_Data.PDU_Filters.Emission := Emission_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Emission_Flag'address);
      Xt.SetValues (Emission_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Emission_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Laser Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Laser_Enabled_Pushbutton,
		Laser_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Laser_Disabled_Pushbutton,
		Laser_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Laser_Menu, Laser_Menu_Cascade);
      Xt.ManageChild (Laser_Menu_Cascade);
      Set_Data.PDU_Filters.Laser := Laser_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Laser_Flag'address);
      Xt.SetValues (Laser_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Laser_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Transmitter Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Transmitter_Enabled_Pushbutton,
		Transmitter_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Transmitter_Disabled_Pushbutton,
		Transmitter_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Transmitter_Menu, Transmitter_Menu_Cascade);
      Xt.ManageChild (Transmitter_Menu_Cascade);
      Set_Data.PDU_Filters.Transmitter := Transmitter_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Transmitter_Flag'address);
      Xt.SetValues (Transmitter_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Transmitter_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --
      -- Create the Receiver Enabled/Disabled option menu
      --
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Enabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(XDG_Server.K_Enabled)),
	      NULL, Receiver_Enabled_Pushbutton,
		Receiver_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.ENABLED)));
      MOTIF_UTILITIES.Build_Menu_Item (XDG_Server.K_Disabled_String,
	Xm.PushButtonGadgetClass, TRUE, ASCII.NUL, "", "",
	  Motif_Utilities.Set_Boolean_Value_CB'address,
	    XDG_Server.INTEGER_To_XtPOINTER (BOOLEAN'pos(
	      XDG_Server.K_Disabled)), NULL, Receiver_Disabled_Pushbutton,
		Receiver_Menu(XDG_Server.ENABLED_DISABLED_ENUM'pos(
		  XDG_Server.DISABLED)));
      MOTIF_UTILITIES.Build_Menu (Main_Rowcolumn, Xm.MENU_OPTION, "",
	ASCII.NUL, TRUE, Receiver_Menu, Receiver_Menu_Cascade);
      Xt.ManageChild (Receiver_Menu_Cascade);
      Set_Data.PDU_Filters.Receiver := Receiver_Menu_Cascade;

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
        XDG_Server.Receiver_Flag'address);
      Xt.SetValues (Receiver_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.ENABLED)).Item_Widget.all,
          Arglist, Argcount);
      Xt.SetValues (Receiver_Menu(XDG_Server.
        ENABLED_DISABLED_ENUM'pos(XDG_Server.DISABLED)).Item_Widget.all,
          Arglist, Argcount);

      --------------------------------------------------------------------
      --
      -- Install ActiveHelp
      --
      --------------------------------------------------------------------
      Motif_Utilities.Install_Active_Help (
	Parent             => Entity_State_Label,
	Help_Text_Widget   => Set_Data.Description,
	Help_Text_Message  => K_Entity_State_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Entity_State, Set_Data.Description,
	K_Entity_State_Help_String);

      Motif_Utilities.Install_Active_Help (Fire_Label,
	Set_Data.Description, K_Fire_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Fire , Set_Data.Description,
	K_Fire_Help_String);

      Motif_Utilities.Install_Active_Help (Detonation_Label,
	Set_Data.Description, K_Detonation_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Detonation , Set_Data.Description,
	K_Detonation_Help_String);

      Motif_Utilities.Install_Active_Help (Collision_Label,
	Set_Data.Description, K_Collision_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Collision , Set_Data.Description,
	K_Collision_Help_String);

      Motif_Utilities.Install_Active_Help (Service_Request_Label,
	Set_Data.Description, K_Service_Request_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Service_Request , Set_Data.Description,
	K_Service_Request_Help_String);

      Motif_Utilities.Install_Active_Help (Resupply_Offer_Label,
	Set_Data.Description, K_Resupply_Offer_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Resupply_Offer , Set_Data.Description,
	K_Resupply_Offer_Help_String);

      Motif_Utilities.Install_Active_Help (Resupply_Received_Label,
	Set_Data.Description, K_Resupply_Received_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Resupply_Received , Set_Data.Description,
	K_Resupply_Received_Help_String);

      Motif_Utilities.Install_Active_Help (Resupply_Cancelled_Label,
	Set_Data.Description, K_Resupply_Cancelled_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Resupply_Cancelled , Set_Data.Description,
	K_Resupply_Cancelled_Help_String);

      Motif_Utilities.Install_Active_Help (Repair_Complete_Label,
	Set_Data.Description, K_Repair_Complete_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Repair_Complete , Set_Data.Description,
	K_Repair_Complete_Help_String);

      Motif_Utilities.Install_Active_Help (Repair_Response_Label,
	Set_Data.Description, K_Repair_Response_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Repair_Response , Set_Data.Description,
	K_Repair_Response_Help_String);

      Motif_Utilities.Install_Active_Help (Create_Entity_Label,
	Set_Data.Description, K_Create_Entity_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Create_Entity , Set_Data.Description,
	K_Create_Entity_Help_String);

      Motif_Utilities.Install_Active_Help (Remove_Entity_Label,
	Set_Data.Description, K_Remove_Entity_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Remove_Entity , Set_Data.Description,
	K_Remove_Entity_Help_String);

      Motif_Utilities.Install_Active_Help (Start_Resume_Label,
	Set_Data.Description, K_Start_Resume_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Start_Resume , Set_Data.Description,
	K_Start_Resume_Help_String);

      Motif_Utilities.Install_Active_Help (Stop_Freeze_Label,
	Set_Data.Description, K_Stop_Freeze_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Stop_Freeze , Set_Data.Description,
	K_Stop_Freeze_Help_String);

      Motif_Utilities.Install_Active_Help (Acknowledge_Label,
	Set_Data.Description, K_Acknowledge_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Acknowledge , Set_Data.Description,
	K_Acknowledge_Help_String);

      Motif_Utilities.Install_Active_Help (Action_Request_Label,
	Set_Data.Description, K_Action_Request_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Action_Request , Set_Data.Description,
	K_Action_Request_Help_String);

      Motif_Utilities.Install_Active_Help (Action_Response_Label,
	Set_Data.Description, K_Action_Response_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Action_Response , Set_Data.Description,
	K_Action_Response_Help_String);

      Motif_Utilities.Install_Active_Help (Data_Query_Label,
	Set_Data.Description, K_Data_Query_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Data_Query , Set_Data.Description,
	K_Data_Query_Help_String);

      Motif_Utilities.Install_Active_Help (Set_Data_Label,
	Set_Data.Description, K_Set_Data_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Set_Data , Set_Data.Description,
	K_Set_Data_Help_String);

      Motif_Utilities.Install_Active_Help (Data_Label,
	Set_Data.Description, K_Data_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Data , Set_Data.Description,
	K_Data_Help_String);

      Motif_Utilities.Install_Active_Help (Event_Report_Label,
	Set_Data.Description, K_Event_Report_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Event_Report , Set_Data.Description,
	K_Event_Report_Help_String);

      Motif_Utilities.Install_Active_Help (Message_Label,
	Set_Data.Description, K_Message_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Message , Set_Data.Description,
	K_Message_Help_String);

      Motif_Utilities.Install_Active_Help (Emission_Label,
	Set_Data.Description, K_Emission_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Emission , Set_Data.Description,
	K_Emission_Help_String);

      Motif_Utilities.Install_Active_Help (Laser_Label,
	Set_Data.Description, K_Laser_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Laser , Set_Data.Description,
	K_Laser_Help_String);

      Motif_Utilities.Install_Active_Help (Transmitter_Label,
	Set_Data.Description, K_Transmitter_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Transmitter , Set_Data.Description,
	K_Transmitter_Help_String);

      Motif_Utilities.Install_Active_Help (Receiver_Label,
	Set_Data.Description, K_Receiver_Help_String);
      Motif_Utilities.Install_Active_Help (
	Set_Data.PDU_Filters.Receiver , Set_Data.Description,
	K_Receiver_Help_String);

   end if; -- (Set_Data.PDU_Filters.Shell /= Xt.XNULL)

   --
   -- Set Parameter_Active_Hierarchy to point to (Sub)root of the
   -- active parameter widget sun-hierarchy.
   --
   Motif_Utilities.Set_LabelString (Set_Data.Title, K_Panel_Title);
   Xt.ManageChild (Set_Data.PDU_Filters.Shell);
   Set_Data.Parameter_Active_Hierarchy := Set_Data.PDU_Filters.Shell;

   --
   -- Initialize panel to values in shared memory
   --
   if (Do_Initialization) then
      Initialize_Panel_PDU_Filters (Set_Data.PDU_Filters);
   end if;

end Create_Set_Parms_Panel_PDU_Filters;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/03/94   D. Forrest
--      - Initial version
--
-- --

