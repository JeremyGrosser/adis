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

with MOTIF_UTILITIES;
with Text_IO;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Cancel_Sim_Parms_Window_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 12, 1994
--
-- PURPOSE:
--   This procedure closes the window pointed to by the parameter Shell,
--   and then cancels all pending parameter changes.
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
procedure Cancel_Sim_Parms_Window_CB (
    Parent      : in     Xt.WIDGET;
    Sim_Data    : in     XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
    Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is
begin

    --
    -- Close the window
    --
    Xt.UnmanageChild (Sim_Data.Shell);
    Xt.Popdown (Sim_Data.Shell);

    --
    -- Cancel all un-applied data entries by re-initializing
    --
    XOS.Initialize_Sim_Parms_Panels (Sim_Data);

end Cancel_Sim_Parms_Window_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/12/94   D. Forrest
--      - Initial version
--
-- --

