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
-- UNIT NAME:          Quit_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 18, 1994
--
-- PURPOSE:
--   This procedure prompts the user to quit the XOS, and quits the XOS (by
--   unmanaging the parent XOS window) is the user responds affirmatively.
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
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

