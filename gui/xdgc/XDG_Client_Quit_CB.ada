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
-- UNIT NAME:          Quit_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12, 1994
--
-- PURPOSE:
--   This procedure prompts the user to quit the XDG Client, and quits the 
--   XDG Client (by unmanaging the parent XDG Client window) if the user 
--   responds affirmatively.
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
procedure Quit_CB (
    Parent      : in     Xt.WIDGET;
    Shell       : in out Xt.WIDGET;
    Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is
begin

    --
    -- Put up the quit prompt dialog.
    --
--    if (Motif_Utilities.Prompt_User (parent, Xm.DIALOG_QUESTION,
--      "Quit Prompt", "Do you really wish to close this window?",
--      " Yes ", 'Y', "", ASCII.NUL, " No ", 'N') = 'Y') then
	    
       Xt.UnmanageChild (Shell);
       Xt.Popdown (Shell);

--    end if;

end Quit_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

