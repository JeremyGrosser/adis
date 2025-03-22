--                          U N C L A S S I F I E D
--
--  *======================================================================*
--  |                                                                      |
--  |                       Manned Flight Simulator                        |
--  |              Naval Air Warfar Center Aircraft Division               |
--  |                      Patuxent River, Maryland                        |
--  |                                                                      |
--  *======================================================================*
--
----------------------------------------------------------------------------
--
--                        Manned Flight Simulator
--                        Bldg 2035
--                        Patuxent River, MD 20670
--
-- PACKAGE NAME:     XDG_Server
--
-- PROJECT:          Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:           James Daryl Forrest (J.F. Taylor, Inc)
--
-- ORIGINATION DATE: June 2, 1994
--
-- PURPOSE:
--   - This package
--
-- EFFECTS:
--   -The expected usage is:
--
-- EXCEPTIONS:
--   None.
--
-- PORTABILITY ISSUES:
--   This package uses Xm, Xmdef, Xt, and Xtdef.
--
-- ANTICIPATED CHANGES:
--   None.
--
----------------------------------------------------------------------------

with DG_GUI_Interface_Types;
with DG_Server_GUI;
with Motif_Utilities;
with Text_IO;
with Xlib;
with Xm;
with Xmdef;
with XDG_Server_Types;
with Xt;
with Xtdef;

package body XDG_Server is

   -------------------------------------------------------------------------
   -- Global Variable declarations (visible to this package only)
   -------------------------------------------------------------------------

   --
   -- Option menu status flags
   --
   -- Network Parameters (Option Menu Status Flags)
   Network_Data_Reception_Flag    : BOOLEAN := TRUE;
   Network_Data_Transmission_Flag : BOOLEAN := TRUE;

   -- Threshold Parameters (Option Menu Status Flags)
   -- no option menus

   -- PDU Filters (Option Menu Status Flags)
   Entity_State_Flag              : BOOLEAN := TRUE;
   Fire_Flag                      : BOOLEAN := TRUE;
   Detonation_Flag                : BOOLEAN := TRUE;
   Collision_Flag                 : BOOLEAN := TRUE;
   Service_Request_Flag           : BOOLEAN := TRUE;
   Resupply_Offer_Flag            : BOOLEAN := TRUE;
   Resupply_Received_Flag         : BOOLEAN := TRUE;
   Resupply_Cancelled_Flag        : BOOLEAN := TRUE;
   Repair_Complete_Flag           : BOOLEAN := TRUE;
   Repair_Response_Flag           : BOOLEAN := TRUE;
   Create_Entity_Flag             : BOOLEAN := TRUE;
   Remove_Entity_Flag             : BOOLEAN := TRUE;
   Start_Resume_Flag              : BOOLEAN := TRUE;
   Stop_Freeze_Flag               : BOOLEAN := TRUE;
   Acknowledge_Flag               : BOOLEAN := TRUE;
   Action_Request_Flag            : BOOLEAN := TRUE;
   Action_Response_Flag           : BOOLEAN := TRUE;
   Data_Query_Flag                : BOOLEAN := TRUE;
   Set_Data_Flag                  : BOOLEAN := TRUE;
   Data_Flag                      : BOOLEAN := TRUE;
   Event_Report_Flag              : BOOLEAN := TRUE;
   Message_Flag                   : BOOLEAN := TRUE;
   Emission_Flag                  : BOOLEAN := TRUE;
   Laser_Flag                     : BOOLEAN := TRUE;
   Transmitter_Flag               : BOOLEAN := TRUE;
   Receiver_Flag                  : BOOLEAN := TRUE;

   -- Specific Filters (Option Menu Status Flags)
   Keep_Exercise_ID_Flag          : BOOLEAN := TRUE;
   Keep_Force_ID_Other_Flag       : BOOLEAN := TRUE;
   Keep_Force_ID_Friendly_Flag    : BOOLEAN := TRUE;
   Keep_Force_ID_Opposing_Flag    : BOOLEAN := TRUE;
   Keep_Force_ID_Neutral_Flag     : BOOLEAN := TRUE;

   -- DG Parameters (Option Menu Status Flags)
   -- no option menus

   -- Error Parameters (Option Menu Status Flags)
   GUI_Error_Reporting_Flag       : BOOLEAN := TRUE;
   Error_Logging_Flag             : BOOLEAN := TRUE;

   -- Hash Parameters (Option Menu Status Flags)
   -- no option menus

   -- Exercise Parameters (Option Menu Status Flags)
   Automatic_Application_ID_Flag  : BOOLEAN := TRUE;
   Automatic_Exercise_ID_Flag     : BOOLEAN := TRUE;
   Automatic_Site_ID_Flag         : BOOLEAN := TRUE;
   Automatic_Timestamp_Flag       : BOOLEAN := TRUE;
   IITSEC_Bit_23_Support_Flag     : BOOLEAN := TRUE;
   Experimental_PDUs_Flag         : BOOLEAN := TRUE;

   -- Simulation Data Parameters (Option Menu Status Flags)
   -- no option menus

   --
   -- This variable holds the number of characters in the Error Notices
   -- text widget. It is used internally.
   --
   Error_Notices_Text_Position : Xm.TEXTPOSITION;


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Network
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Network(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Threshold
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Threshold(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_PDU_Filters
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_PDU_Filters(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Specific_Filters
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Specific_Filters(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_DG_Parameters
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_DG_Parameters(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Error
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Error(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Hash
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Hash(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Exercise
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Exercise(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Error_Notices_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Create_Error_Notices_Window_CB(
      Parent      : in     Xt.WIDGET;
      XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Window_CB(
      Parent      : in     Xt.WIDGET;
      XDG_Data    : in out XDG_Server_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Entities
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Entities(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Gateway
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Gateway(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Errors
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Errors(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Server_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Network
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Network(
      Network : in     XDG_Server_Types.XDG_NETWORK_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Threshold
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Threshold(
      Threshold : in     XDG_Server_Types.XDG_THRESHOLD_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_DG_Parameters
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_DG_Parameters(
      DG_Parameters : in     XDG_Server_Types.XDG_DG_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_PDU_Filters
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_PDU_Filters(
      PDU_Filters : in     XDG_Server_Types.XDG_PDU_FILTERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Specific_Filters
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Specific_Filters(
      Specific_Filters : in     XDG_Server_Types.XDG_SPECIFIC_FILTERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Error
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Error(
      Error : in     XDG_Server_Types.XDG_ERROR_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Hash
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Hash(
      Hash : in     XDG_Server_Types.XDG_HASH_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Exercise
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Exercise(
      Exercise : in     XDG_Server_Types.XDG_EXERCISE_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Set_Parms_Panels
   --
   -------------------------------------------------------------------------
   procedure Initialize_Set_Parms_Panels(
      Set_Data : in     XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_Notices
   --
   -------------------------------------------------------------------------
   procedure Update_Error_Notices (
      Error_Notices_Data : in out XDG_Server_Types.
				    XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_History
   --
   -------------------------------------------------------------------------
   procedure Update_Error_History (
      Error_History_Data : in out XDG_Server_Types.
				    XDG_MON_ERROR_HISTORY_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Apply_CB
   --
   -------------------------------------------------------------------------
   procedure Apply_CB(
      Parent              : in     Xt.WIDGET;
      Set_Parameters_Data : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Set_Parms_CB
   --
   -------------------------------------------------------------------------
   procedure Cancel_Set_Parms_CB(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in     XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Close_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Close_Window_CB (
      Parent      : in     Xt.WIDGET;
      Shell       : in out Xt.Widget;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;


end XDG_Server;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/02/94   D. Forrest
--      - Initial version
--
-- --
