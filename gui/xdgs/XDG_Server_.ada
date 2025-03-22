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

with Calendar;
with Motif_Utilities;
with System;
with Unchecked_Conversion;
with XDG_Server_Types;
with Xm;
with Xt;

package XDG_Server is

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


   -------------------------------------------------------------------------
   -- IP Address Constants
   -------------------------------------------------------------------------
   K_IP_Address_Quad_Chars_Max : constant INTEGER := 3;
   K_IP_Address_Quad_Min       : constant INTEGER := 0;
   K_IP_Address_Quad_Max       : constant INTEGER := 255;

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
   -- Global variable declarations
   -------------------------------------------------------------------------
--   -- This variable is True if the XDG maps it's own ShMem interface
--   -- This will only happen during debugging, after which time this
--   -- variable and all related code will be removed....
--   Self_Mapped : BOOLEAN := False;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XDG_Server Set Setnance Parameters window.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Network
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters Network Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Network(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Threshold
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters Threshold Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Threshold(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_PDU_Filters
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters PDU Filters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_PDU_Filters(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Specific_Filters
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters Specific Filters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Specific_Filters(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_DG_Parameters
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters DG Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_DG_Parameters(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Error
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters Error Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Error(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Hash
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters Hash Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Hash(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Exercise
   --
   -- PURPOSE:
   --   This procedure displays the Set Parameters Exercise Parameters Panel
   --   under the passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Exercise(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Error_Notices_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XDG Error Notices window.
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
      XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Window_CB
   --
   -- PURPOSE:
   --   This procedure displays the XDG Monitors window.
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
      XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Entities
   --
   -- PURPOSE:
   --   This procedure displays the Monitor Entities Panel under the
   --   passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Entities(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Gateway
   --
   -- PURPOSE:
   --   This procedure displays the Monitor Gateway Panel under the
   --   passed widget hierarchy.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Gateway(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
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
      Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Network
   --
   -- PURPOSE:
   --   This procedure initializes the Network Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Network(
      Network : in     XDG_Server_Types.XDG_NETWORK_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Threshold
   --
   -- PURPOSE:
   --   This procedure initializes the Threshold Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Threshold(
      Threshold : in     XDG_Server_Types.XDG_THRESHOLD_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_DG_Parameters
   --
   -- PURPOSE:
   --   This procedure initializes the DG_Parameters Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_DG_Parameters(
      DG_Parameters : in     XDG_Server_Types.XDG_DG_PARAMETERS_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_PDU_Filters
   --
   -- PURPOSE:
   --   This procedure initializes the PDU_Filters Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_PDU_Filters(
      PDU_Filters : in     XDG_Server_Types.XDG_PDU_FILTERS_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Specific_Filters
   --
   -- PURPOSE:
   --   This procedure initializes the Specific_Filters Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Specific_Filters(
      Specific_Filters : in     XDG_Server_Types.XDG_SPECIFIC_FILTERS_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Error
   --
   -- PURPOSE:
   --   This procedure initializes the Error Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Error(
      Error : in     XDG_Server_Types.XDG_ERROR_PARAMETERS_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Hash
   --
   -- PURPOSE:
   --   This procedure initializes the Hash Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Hash(
      Hash : in     XDG_Server_Types.XDG_HASH_PARAMETERS_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Exercise
   --
   -- PURPOSE:
   --   This procedure initializes the Exercise Panel widgets with the
   --   values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Exercise(
      Exercise : in     XDG_Server_Types.XDG_EXERCISE_PARAMETERS_DATA_REC);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Set_Parms_Panels
   --
   -- PURPOSE:
   --   This procedure initializes all XDG Server Set Parameters panels
   --   using values from the DG Shared Memory interface.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Initialize_Set_Parms_Panels(
      Set_Data : in     XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR);

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
     Error_Notices_Data : in out XDG_Server_Types.
				   XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR);

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
     Error_History_Data : in out XDG_Server_Types.
				   XDG_MON_ERROR_HISTORY_DATA_REC_PTR);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Apply_CB
   --
   -- PURPOSE:
   --   This procedure writes all changed values in all Set Parameters
   --   panels to shared memory.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Apply_CB(
      Parent              : in     Xt.WIDGET;
      Set_Parameters_Data : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Set_Parms_CB
   --
   -- PURPOSE:
   --   This procedure closes the Set Parms window and cancels all pending 
   --   XDG Server parameter changes.                              
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Cancel_Set_Parms_CB(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in     XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Close_Window_CB
   --
   -- PURPOSE:
   --   This procedure closes the window pointed to by the parameter Shell
   --   by unmanaging (not destroying) it.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Close_Window_CB (
      Parent      : in     Xt.WIDGET;
      Shell       : in out Xt.Widget;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

end XDG_Server;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/02/94   D. Forrest
--      - Initial version
--
-- --

