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
-- PACKAGE NAME:     XDG_Client
--
-- PROJECT:          Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:           James Daryl Forrest (J.F. Taylor, Inc)
--
-- ORIGINATION DATE: August 12, 1994
--
-- PURPOSE:
--   This package is the main XDG package. It holds all routines 
--   necessary to display, initialize, and extract data from all
--   XDG Client displays and inputs.
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
with DG_Client_GUI;
with Motif_Utilities;
with Text_IO;
with Xlib;
with Xm;
with Xmdef;
with XDG_Client_Types;
with Xt;
with Xtdef;

package body XDG_Client is

   -------------------------------------------------------------------------
   -- Global Variable declarations (visible to this package only)
   -------------------------------------------------------------------------

   --
   -- Option Menu status flags
   --

   -- DG Parameters (Option Menu Status Flags)
   -- no option menus

   -- Error Parameters (Option Menu Status Flags)
   GUI_Error_Reporting_Flag       : BOOLEAN := TRUE;
   Error_Logging_Flag             : BOOLEAN := TRUE;

   -- Hash Parameters (Option Menu Status Flags)
   -- no option menus

   -- Exercise Parameters (Option Menu Status Flags)
   Automatic_Application_ID_Flag  : BOOLEAN := TRUE;

   -- Synchronization Parameters (Option Menu Status Flags)
   Server_Synchronization_Flag : BOOLEAN := TRUE;


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
      XDG_Data    : in out XDG_Client_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_DG_Parameters
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_DG_Parameters(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Error
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Error(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Hash
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Hash(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Exercise
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Exercise(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Set_Parms_Panel_Synchronization
   --
   -------------------------------------------------------------------------
   procedure Create_Set_Parms_Panel_Synchronization(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Error_Notices_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Create_Error_Notices_Window_CB(
      Parent      : in     Xt.WIDGET;
      XDG_Data    : in out XDG_Client_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Window_CB(
      Parent      : in     Xt.WIDGET;
      XDG_Data    : in out XDG_Client_Types.XDG_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Entities
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Entities(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Client_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Gateway
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Gateway(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Client_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Errors
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Errors(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XDG_Client_Types.XDG_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_DG_Parameters
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_DG_Parameters(
      DG_Parameters : in     XDG_Client_Types.XDG_DG_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Error
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Error(
      Error : in     XDG_Client_Types.XDG_ERROR_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Hash
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Hash(
      Hash : in     XDG_Client_Types.XDG_HASH_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Exercise
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Exercise(
      Exercise : in     XDG_Client_Types.XDG_EXERCISE_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Panel_Synchronization
   --
   -------------------------------------------------------------------------
   procedure Initialize_Panel_Synchronization(
      Synchronization :
	in     XDG_Client_Types.XDG_SYNCHRONIZATION_PARAMETERS_DATA_REC)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Set_Parms_Panels
   --
   -------------------------------------------------------------------------
   procedure Initialize_Set_Parms_Panels(
      Set_Data : in     XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_Notices
   --
   -------------------------------------------------------------------------
   procedure Update_Error_Notices (
      Error_Notices_Data : in out XDG_Client_Types.
                                    XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_History
   --
   -------------------------------------------------------------------------
   procedure Update_Error_History (
      Error_History_Data : in out XDG_Client_Types.
                                    XDG_MON_ERROR_HISTORY_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Apply_CB
   --
   -------------------------------------------------------------------------
   procedure Apply_CB(
      Parent              : in     Xt.WIDGET;
      Set_Parameters_Data : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Set_Parms_CB
   --
   -------------------------------------------------------------------------
   procedure Cancel_Set_Parms_CB(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in     XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
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



end XDG_Client;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --
