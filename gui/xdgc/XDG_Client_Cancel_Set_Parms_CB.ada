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

separate (XDG_Client)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Cancel_Set_Parms_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 19, 1994
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
procedure Cancel_Set_Parms_CB (
    Parent      : in     Xt.WIDGET;
    Set_Data    : in     XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
    Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is
begin

    --
    -- Close the window
    --
    Xt.UnmanageChild (Set_Data.Shell);
    Xt.Popdown (Set_Data.Shell);

    --
    -- Cancel all un-applied data entries by re-initializing
    --
    XDG_Client.Initialize_Set_Parms_Panels (Set_Data);

end Cancel_Set_Parms_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/19/94   D. Forrest
--      - Initial version
--
-- --

