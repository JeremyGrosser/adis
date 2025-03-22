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
-- PACKAGE NAME:     Main_CB
--
-- PROJECT:          Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:           James Daryl Forrest (J.F. Taylor, Inc)
--
-- ORIGINATION DATE: August 12, 1994
--
-- PURPOSE:
--   This package contains the callbacks associated with the main
--   program.
--
-- EFFECTS:
--   None.
--
-- EXCEPTIONS:
--   None.
--
-- PORTABILITY ISSUES:
--   This package uses Xm, and Xt.
--
-- ANTICIPATED CHANGES:
--   None.
--
----------------------------------------------------------------------------

with DG_Client_GUI;
with DG_GUI_Interface_Types;
with Text_IO;
with XDG_Client;
with XDG_Client_Types;
with Xm;
with Xt;

package body XDG_Client_Main_CB is

   --
   -- Package constants
   --
   K_Reinitialize_Panels_Timeout_Interval_ms : constant Xt.UnsignedLong := 100;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Open_CB
   --
   -------------------------------------------------------------------------
   procedure Open_CB(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Open_Config_File_FSB_CB
   --
   -------------------------------------------------------------------------
   procedure Open_Config_File_FSB_CB(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   : in out Xm.FILESELECTIONBOXCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Reinitialize_Panels_Timeout
   --
   -------------------------------------------------------------------------
   procedure Reinitialize_Panels_Timeout(
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR) is

      Interval_ID : Xt.INTERVALID;

   begin

      --
      -- We are still waiting for the DG Client to complete the
      -- configuration file load which we requested...
      --
      if DG_GUI_Interface_Types."="(
        DG_Client_GUI.Interface.Configuration_File_Command,
          DG_GUI_Interface_Types.LOAD) then

         --
         -- Reinstall ourselves...
         --
         Interval_ID := Xt.AppAddTimeOut(
           App_Context => XDG_Client_Main_CB.App_Context,
           Interval    => K_Reinitialize_Panels_Timeout_Interval_ms,
           Proc        => Reinitialize_Panels_Timeout'address,
           Client_Data => XDG_Client_Types.
             XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(Set_Data));

      --
      -- The DG Client says that the load is complete.
      -- We can initialize our Set Parameters panels.
      --
      elsif DG_GUI_Interface_Types."="(
        DG_Client_GUI.Interface.Configuration_File_Command,
          DG_GUI_Interface_Types.NONE) then

         XDG_Client.Initialize_Set_Parms_Panels (Set_Data);

      --
      -- This condition should never occur:
      -- We must be waiting on a save... (why are we here?)
      --
      else
          null; -- Do nothing...
      end if;

   end Reinitialize_Panels_Timeout;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Save_CB
   --
   -------------------------------------------------------------------------
   procedure Save_CB(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Save_Config_File_FSB_CB
   --
   -------------------------------------------------------------------------
   procedure Save_Config_File_FSB_CB(
      Parent      : in     Xt.WIDGET;
      Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
      Call_Data   : in out Xm.FILESELECTIONBOXCALLBACKSTRUCT_PTR)
     is separate;


   --------------------------------------------------------------------------
   --
   -- UNIT NAME: Quit_CB
   --
   --------------------------------------------------------------------------
   procedure Quit_CB(
      Parent      : in     Xt.WIDGET;
      Client_Data : in out Xt.POINTER;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR)
     is separate;

end XDG_Client_Main_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --
