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
-- ORIGINATION DATE: May 18, 1994
--
-- PURPOSE:
--   This package holds the package spec for the Main_CB package.
--
-- EFFECTS:
--   None.
--
-- EXCEPTIONS:
--   None.
--
-- PORTABILITY ISSUES:
--   This package uses Xm and Xt.
--
-- ANTICIPATED CHANGES:
--   None.
--
----------------------------------------------------------------------------

with Xm;
with XOS_Types;
with Xt;

package XOS_Main_CB is

   --
   -- Global variable declarations
   --
   App_Context : Xt.APPCONTEXT;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Open_CB
   --
   -- PURPOSE:
   --   This procedure allows the user to open an existing configuration
   --   file.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Open_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Open_Config_File_FSB_CB
   --
   -- PURPOSE:
   --   This procedure handles the Open FSB callbacks for opening
   --   and XOS configuration file.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Open_Config_File_FSB_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   : in out Xm.FILESELECTIONBOXCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Reinitialize_Panels_Timeout
   --
   -- PURPOSE:
   --   This procedure waits for the OS to load the new configuration
   --   file (this happens when the config file changes flag in the interface
   --   becomes False), and then calls XOS.Initialize_Set_Parms_Panels
   --   to reinitialize all Set Parameters panels.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Reinitialize_Panels_Timeout(
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Save_CB
   --
   -- PURPOSE:
   --   This procedure allows the user to save the existing data in
   --   a configuration file.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Save_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Save_Config_File_FSB_CB
   --
   -- PURPOSE:
   --   This procedure handles the Save FSB callbacks for opening
   --   and XOS configuration file.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Save_Config_File_FSB_CB(
      Parent      : in     Xt.WIDGET;
      XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
      Call_Data   : in out Xm.FILESELECTIONBOXCALLBACKSTRUCT_PTR);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Quit_CB
   --
   -- PURPOSE:
   --   This procedure prompts the user to quit the application. If the
   --   user chooses to quit, the application is terminated.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   -------------------------------------------------------------------------
   procedure Quit_CB(
      Parent      : in     Xt.WIDGET;
      Client_Data : in out Xt.POINTER;
      Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR);

end XOS_Main_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

