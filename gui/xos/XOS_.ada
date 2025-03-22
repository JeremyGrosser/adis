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
with Unchecked_Conversion;
with XOS_Types;
with Xm;
with Xt;

package XOS is

   -------------------------------------------------------------------------
   --
   -- Miscellaneous constant declarations.
   --
   -------------------------------------------------------------------------
   K_Save_Warning_String : constant STRING
     := "Warning: Only applied changes will be saved!";
   K_Update_Error_Notices_Timeout_Interval_ms : constant INTEGER
     := 1000;   -- 1000ms = 1 Hz
   K_Update_Error_History_Timeout_Interval_ms : constant INTEGER
     := 1000;   -- 1000ms = 1 Hz

   -------------------------------------------------------------------------
   -- DG Set Parms Window Declarations
   -------------------------------------------------------------------------
   K_Set_Parms_Window_Width  : constant INTEGER := 900;
   K_Set_Parms_Window_Height : constant INTEGER := 800;

   -------------------------------------------------------------------------
   -- DG Error Notices Window Declarations
   -------------------------------------------------------------------------
   K_Error_Notices_Window_Width  : constant INTEGER := 600;
   K_Error_Notices_Window_Height : constant INTEGER := 500;
   K_Error_Notices_Rows          : constant INTEGER := 10;
   K_Error_Notices_Cols          : constant INTEGER := 70;

   -------------------------------------------------------------------------
   -- DG Error Monitors Declarations
   -------------------------------------------------------------------------
   K_Monitors_Window_Width   : constant INTEGER := 900;
   K_Monitors_Window_Height  : constant INTEGER := 800;

   -------------------------------------------------------------------------
   -- DG Error History Declarations
   -------------------------------------------------------------------------
   K_Error_History_Rows      : constant INTEGER := 8;
   K_Error_History_Cols      : constant INTEGER := 70;
   K_Error_History_Max       : constant INTEGER := 4;
   K_Error_Name_Max          : constant INTEGER := 64;


   -------------------------------------------------------------------------
   --
   -- Enabled_Disabled Option menu types and functions
   --
   -------------------------------------------------------------------------
   K_Disabled        : constant BOOLEAN := FALSE;
   K_Enabled         : constant BOOLEAN := TRUE;
   K_Disabled_String : constant STRING := "Disabled  ";
   K_Enabled_String  : constant STRING := "Enabled  ";
   type ENABLED_DISABLED_ENUM is (
     DISABLED,
     ENABLED);
   subtype ENABLED_DISABLED_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       ENABLED_DISABLED_ENUM'pos(ENABLED_DISABLED_ENUM'first)..
         ENABLED_DISABLED_ENUM'pos(ENABLED_DISABLED_ENUM'last));
   function INTEGER_To_XtPOINTER
     is new Unchecked_Conversion (INTEGER, Xt.POINTER);

--   --
--   -- TRUE is the XOS maps its own interface; this should be true only
--   -- when debugging...
--   --
--   Self_Mapped : BOOLEAN := False;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Parms_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XOS Set Ordnance Parameters window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Ord_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Aero
   --
   -- PURPOSE:
   --   This procedure displays the Ordnance Aerodynamics Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Ord_Panel_Aero(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Term
   --
   -- PURPOSE:
   --   This procedure displays the Ordnance Termination Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Ord_Panel_Term(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Gen
   --
   -- PURPOSE:
   --   This procedure displays the Ordnance General Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Ord_Panel_Gen(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Entity
   --
   -- PURPOSE:
   --   This procedure displays the Ord Entity Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Ord_Panel_Entity(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Emitter
   --
   -- PURPOSE:
   --   This procedure displays the Ord Emitter Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Ord_Panel_Emitter(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Sim_Parms_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XOS Set Simulation Parameters window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Sim_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Sim_Panel_Sim
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
   -------------------------------------------------------------------------
   procedure Create_Sim_Panel_Sim(
      Parent      : in     Xt.WIDGET;
      Sim_Data    : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Other_Parms_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XOS Set Other Parameters window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Other_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Other_Panel_Error
   --
   -- PURPOSE:
   --   This procedure displays the Other Error Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Other_Panel_Error(
      Parent      : in     Xt.WIDGET;
      Other_Data  : in out XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Error_Notices_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XOS Error Notices window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Error_Notices_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XOS Monitors window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Errors
   --
   -- PURPOSE:
   --   This procedure displays the Monitor Errors Panel under the
   --   passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Errors(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XOS_Types.XOS_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Sim_Panel_Sim
   --
   -- PURPOSE:
   --   This procedure initializes the Simulation Panel widgets with the
   --   values from the OS Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Sim_Panel_Sim(
      Sim_Data : in     XOS_Types.XOS_SIM_SIM_PARM_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Aero
   --
   -- PURPOSE:
   --   This procedure initializes the Ordnance Aerodynamic Panel widgets 
   --   with the values from the OS Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Aero(
      Aero_Data : in     XOS_Types.XOS_ORD_AERO_PARM_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Gen
   --
   -- PURPOSE:
   --   This procedure initializes the Ordnance General Panel widgets
   --   with the values from the OS Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Gen(
      Gen_Data : in     XOS_Types.XOS_ORD_GEN_PARM_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Term
   --
   -- PURPOSE:
   --   This procedure initializes the Ordnance Termination Panel widgets
   --   with the values from the OS Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Term(
      Term_Data : in     XOS_Types.XOS_ORD_TERM_PARM_DATA_REC);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Entity
   --
   -- PURPOSE:
   --   This procedure initializes the Ord Entity Panel widgets with the
   --   values from the OS Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Entity(
      Entity_Data : in     XOS_Types.XOS_ORD_ENTITY_PARM_DATA_REC);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Emitter
   --
   -- PURPOSE:
   --   This procedure initializes the Ord Emitter Panel widgets with the
   --   values from the OS Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Emitter(
      Emitter_Data : in     XOS_Types.XOS_ORD_EMITTER_PARM_DATA_REC);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Other_Panel_Error
   --
   -- PURPOSE:
   --   This procedure initializes the Other Error Panel widgets with the
   --   values from the OS Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Other_Panel_Error(
      Error_Data : in     XOS_Types.XOS_OTHER_ERROR_PARM_DATA_REC);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Parms_Panels
   --
   -- PURPOSE:
   --   This procedure initializes the Ord panels by calling their respective
   --   Initialize functions.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Ord_Parms_Panels(
      Ord_Data    : in     XOS_Types.XOS_ORD_PARM_DATA_REC_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Sim_Parms_Panels
   --
   -- PURPOSE:
   --   This procedure initializes the Sim panels by calling their respective
   --   Initialize functions.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Sim_Parms_Panels(
      Sim_Data    : in     XOS_Types.XOS_SIM_PARM_DATA_REC_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Other_Parms_Panels
   --
   -- PURPOSE:
   --   This procedure initializes the Other panels by calling their respective
   --   Initialize functions.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Other_Parms_Panels(
      Other_Data  : in     XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_Notices
   --
   -- PURPOSE:
   --   This procedure is a time proc which updates the Error Notices
   --   window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Update_Error_Notices (
     Error_Notices_Data : in out XOS_Types.
                                   XOS_ERROR_NOTICES_MONITOR_DATA_REC_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_History
   --
   -- PURPOSE:
   --   This procedure is a time proc which updates the Error History
   --   window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Update_Error_History (
     Error_History_Data : in out XOS_Types.
                                   XOS_MON_ERROR_HISTORY_DATA_REC_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Sim_Apply_CB
   --
   -- PURPOSE:
   --   This procedure writes all changed values in all Set Simulation
   --   Parameters panels to shared memory.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Sim_Apply_CB(
      Parent              : in     Xt.WIDGET;
      Sim_Parameters_Data : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Apply_CB
   --
   -- PURPOSE:
   --   This procedure writes all changed values in all Set Ordnance
   --   Parameters panels to shared memory.
   --   This procedure also checks to see if either of the booleans 
   --   OS_GUI.Interface.Ordnance_xxx.[Top_Of_List,End_Of_List] are true,
   --   and sensitizes/insensitizes the Prev/Next buttons as appropriate.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Ord_Apply_CB(
      Parent              : in     Xt.WIDGET;
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Previous_CB
   --
   -- PURPOSE:
   --   This procedure instructs the OS to place the data for the previous
   --   munition in the list in shared memory. After this is complete, this
   --   procedure reinitializes all panels in this window to reflect this 
   --   new data. This procedure also checks to see if either of the booleans 
   --   OS_GUI.Interface.Ordnance_xxx.[Top_Of_List,End_Of_List] are true,
   --   and sensitizes/insensitizes the Prev/Next buttons as appropriate.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Ord_Previous_CB(
      Parent              : in     Xt.WIDGET;
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Next_CB
   --
   -- PURPOSE:
   --   This procedure instructs the OS to place the data for the next
   --   munition in the list in shared memory. After this is complete, this
   --   procedure reinitializes all panels in this window to reflect this 
   --   new data. This procedure also checks to see if either of the booleans 
   --   OS_GUI.Interface.Ordnance_xxx.[Top_Of_List,End_Of_List] are true,
   --   and sensitizes/insensitizes the Prev/Next buttons as appropriate.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Ord_Next_CB(
      Parent              : in     Xt.WIDGET;
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Update_Previous_Next_Buttons
   --
   -- PURPOSE:
   --   This procedure updates the Next and Previous buttons on the Ordnance
   --   parameters window based on OS_GUI.Interface.Ordnance_xxx.Top_Of_List
   --   and OS_GUI.Interface.Ordnance_xxx.End_Of_List.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Ord_Update_Previous_Next_Buttons(
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Other_Apply_CB
   --
   -- PURPOSE:
   --   This procedure writes all changed values in all Set Other
   --   Parameters panels to shared memory.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Other_Apply_CB(
      Parent                : in     Xt.WIDGET;
      Other_Parameters_Data : in out XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR;
      Call_Data             :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Text_Country_CB
   --
   -- PURPOSE:
   --   This procedure reads the integer out of the parent textfield widget
   --   and places the equivalent country name (from DIS_Types.A_COUNTRY_ID)
   --   into the label widget whose widget ID is passed in as the client data.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Text_Country_CB(
      Parent        : in     Xt.WIDGET;
      Country_Label : in out Xt.WIDGET;
      Call_Data     :    out Xm.ANYCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Sim_World_Coord_CB
   --
   -- PURPOSE:
   --   This procedure reads the values out of the standard database
   --   origin coordinate fields (in Geodetic coordinates), converts these
   --   into world coordinates (aka, Geocentric coordinates) and places
   --   these new values into the appropriate labels on the Sim display.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Sim_World_Coord_CB(
      Parent      : in     Xt.WIDGET;
      Sim_Data    : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.ANYCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Close_Window_CB
   --
   -- PURPOSE:
   --   This procedure closes the window pointed to by the parameter Shell.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Close_Window_CB(
      Parent      : in     Xt.WIDGET;
      Shell       : in out Xt.WIDGET;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Ord_Parms_Window_CB
   --
   -- PURPOSE:
   --   This procedure closes the Ord Parms window and cancels all pending
   --   XOS parameter changes.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Cancel_Ord_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Sim_Parms_Window_CB
   --
   -- PURPOSE:
   --   This procedure closes the Sim Parms window and cancels all pending
   --   XOS parameter changes.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Cancel_Sim_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      Sim_Data    : in     XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Other_Parms_Window_CB
   --
   -- PURPOSE:
   --   This procedure closes the Other Parms window and cancels all pending
   --   XOS parameter changes.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Cancel_Other_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      Other_Data  : in     XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);


end XOS;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

