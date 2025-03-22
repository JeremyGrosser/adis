--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--
----------------------------------------------------------------------------
--
--                        Manned Flight Simulator
--                        Bldg 2035
--                        Patuxent River, MD 20670
--
-- PACKAGE NAME:     XOS
--
-- PROJECT:          Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:           James Daryl Forrest (J.F. Taylor, Inc)
--
-- ORIGINATION DATE: May 18, 1994
--
-- PURPOSE:
--   -This package
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

with DIS_Types;
with Motif_Utilities;
with OS_Data_Types;
with OS_Simulation_Types;
with Text_IO;
with Xlib;
with Xm;
with Xmdef;
with XOS_Types;
with Xt;
with Xtdef;

package body XOS is

   -------------------------------------------------------------------------
   -- Global Variable declarations (visible to this package only)
   -------------------------------------------------------------------------
   -- Error Parameters (Option Menu Status Flags)
   GUI_Error_Reporting_Flag : BOOLEAN := TRUE;
   Error_Logging_Flag       : BOOLEAN := TRUE;

   -- Simulation Parameters (Option Menu Status Flags)
   Simulation_State_Value : INTEGER := 
     OS_Simulation_Types.SIMULATION_STATE_TYPE'pos(
       OS_Simulation_Types.SIMULATION_STATE_TYPE'first);

   -- Aerodynamic Guidance Parameters (Option Menu Status Flags)
   Guidance_Value : INTEGER := 
     OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'pos(
       OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'first);

   -- Aerodynamic Illumination Parameters (Option Menu Status Flags)
   Illumination_Flag_Value : INTEGER := 
     OS_Data_Types.ILLUMINATION_IDENTIFIER'pos(
       OS_Data_Types.ILLUMINATION_IDENTIFIER'first);

   -- Termination Fuze Parameters (Option Menu Status Flags)
   Fuze_Value : INTEGER := 
     DIS_Types.A_FUZE_TYPE'pos(DIS_Types.A_FUZE_TYPE'first);

   -- Termination Warhead Parameters (Option Menu Status Flags)
   Warhead_Value : INTEGER := 
     DIS_Types.A_WARHEAD_TYPE'pos(DIS_Types.A_WARHEAD_TYPE'first);

   -- General Dead Reckoning Parameters (Option Menu Status Flags)
   Dead_Reckoning_Algorithm_Value : INTEGER := 
     DIS_Types.A_DEAD_RECKONING_ALGORITHM'pos(
       DIS_Types.A_DEAD_RECKONING_ALGORITHM'first);

   -- General Entity Type Parameters (Option Menu Status Flags)
   Entity_Kind_Value : INTEGER := 
     DIS_Types.AN_ENTITY_KIND'pos(DIS_Types.AN_ENTITY_KIND'first);

   -- General Fly-Out Model ID Parameters (Option Menu Status Flags)
   Fly_Out_Model_ID_Value : INTEGER := 
     OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'pos(
       OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'first);

   -- Ordnance Entity Parameters (Option Menu Status Flags)
   Alternate_Entity_Kind_Value : INTEGER :=
     DIS_Types.AN_ENTITY_KIND'pos(DIS_Types.AN_ENTITY_KIND'first);

   --
   -- This variable holds the number of characters in the Error Notices
   -- text widget. It is used internally.
   --
   Error_Notices_Text_Position : Xm.TEXTPOSITION;


   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Parms_Window_CB
   --
   ---------------------------------------------------------------------------
   procedure Create_Ord_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Aero
   --
   ---------------------------------------------------------------------------
   procedure Create_Ord_Panel_Aero(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Term
   --
   ---------------------------------------------------------------------------
   procedure Create_Ord_Panel_Term(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Entity
   --
   ---------------------------------------------------------------------------
   procedure Create_Ord_Panel_Entity(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Emitter
   --
   ---------------------------------------------------------------------------
   procedure Create_Ord_Panel_Emitter(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Ord_Panel_Gen
   --
   ---------------------------------------------------------------------------
   procedure Create_Ord_Panel_Gen(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Sim_Parms_Window_CB
   --
   ---------------------------------------------------------------------------
   procedure Create_Sim_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Sim_Panel_Sim
   --
   -------------------------------------------------------------------------
   procedure Create_Sim_Panel_Sim(
      Parent      : in     Xt.WIDGET;
      Sim_Data    : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Other_Parms_Window_CB
   --
   ---------------------------------------------------------------------------
   procedure Create_Other_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Other_Panel_Error
   --
   ---------------------------------------------------------------------------
   procedure Create_Other_Panel_Error(
      Parent      : in     Xt.WIDGET;
      Other_Data  : in out XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Error_Notices_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Create_Error_Notices_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Window_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Create_Monitors_Panel_Errors
   --
   -------------------------------------------------------------------------
   procedure Create_Monitors_Panel_Errors(
      Parent      : in     Xt.WIDGET;
      Mon_Data    : in out XOS_Types.XOS_MONITORS_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Sim_Panel_Sim
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Sim_Panel_Sim(
      Sim_Data : in     XOS_Types.XOS_SIM_SIM_PARM_DATA_REC)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Aero
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Aero(
      Aero_Data : in     XOS_Types.XOS_ORD_AERO_PARM_DATA_REC)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Gen
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Gen(
      Gen_Data : in     XOS_Types.XOS_ORD_GEN_PARM_DATA_REC)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Term
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Term(
      Term_Data : in     XOS_Types.XOS_ORD_TERM_PARM_DATA_REC)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Entity
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Entity(
      Entity_Data : in     XOS_Types.XOS_ORD_ENTITY_PARM_DATA_REC)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Panel_Emitter
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Ord_Panel_Emitter(
      Emitter_Data : in     XOS_Types.XOS_ORD_EMITTER_PARM_DATA_REC)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Other_Panel_Error
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Other_Panel_Error(
      Error_Data : in     XOS_Types.XOS_OTHER_ERROR_PARM_DATA_REC)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Ord_Parms_Panels
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Ord_Parms_Panels(
      Ord_Data    : in     XOS_Types.XOS_ORD_PARM_DATA_REC_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Sim_Parms_Panels
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Sim_Parms_Panels(
      Sim_Data    : in     XOS_Types.XOS_SIM_PARM_DATA_REC_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Initialize_Other_Parms_Panels
   --
   ---------------------------------------------------------------------------
   procedure Initialize_Other_Parms_Panels(
      Other_Data  : in     XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_Notices
   --
   -------------------------------------------------------------------------
   procedure Update_Error_Notices (
      Error_Notices_Data : in out XOS_Types.
                                    XOS_ERROR_NOTICES_MONITOR_DATA_REC_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Error_History
   --
   -------------------------------------------------------------------------
   procedure Update_Error_History (
      Error_History_Data : in out XOS_Types.
                                    XOS_MON_ERROR_HISTORY_DATA_REC_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Sim_Apply_CB
   --
   ---------------------------------------------------------------------------
   procedure Sim_Apply_CB(
      Parent              : in     Xt.WIDGET;
      Sim_Parameters_Data : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Apply_CB
   --
   ---------------------------------------------------------------------------
   procedure Ord_Apply_CB(
      Parent              : in     Xt.WIDGET;
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Previous_CB
   --
   ---------------------------------------------------------------------------
   procedure Ord_Previous_CB(
      Parent              : in     Xt.WIDGET;
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Next_CB
   --
   ---------------------------------------------------------------------------
   procedure Ord_Next_CB(
      Parent              : in     Xt.WIDGET;
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Ord_Update_Previous_Next_Buttons
   --
   ---------------------------------------------------------------------------
   procedure Ord_Update_Previous_Next_Buttons(
      Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Other_Apply_CB
   --
   ---------------------------------------------------------------------------
   procedure Other_Apply_CB(
      Parent                : in     Xt.WIDGET;
      Other_Parameters_Data : in out XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR;
      Call_Data             :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Text_Country_CB
   --
   ---------------------------------------------------------------------------
   procedure Text_Country_CB (
       Parent        : in     Xt.WIDGET;
       Country_Label : in out Xt.WIDGET;
       Call_Data     :    out Xm.ANYCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Sim_World_Coord_CB
   --
   ---------------------------------------------------------------------------
   procedure Sim_World_Coord_CB (
       Parent      : in     Xt.WIDGET;
       Sim_Data    : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
       Call_Data   :    out Xm.ANYCALLBACKSTRUCT_PTR)
     is separate;

   ---------------------------------------------------------------------------
   --
   -- UNIT NAME:          Close_Window_CB
   --
   ---------------------------------------------------------------------------
   procedure Close_Window_CB(
      Parent      : in     Xt.WIDGET;
      Shell       : in out Xt.WIDGET;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Ord_Parms_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Cancel_Ord_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      Ord_Data    : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Sim_Parms_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Cancel_Sim_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      Sim_Data    : in     XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Cancel_Other_Parms_Window_CB
   --
   -------------------------------------------------------------------------
   procedure Cancel_Other_Parms_Window_CB(
      Parent      : in     Xt.WIDGET;
      Other_Data  : in     XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;


end XOS;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --
