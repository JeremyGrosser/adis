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

with Motif_Utilities;
with OS_GUI;
with OS_Status;
with Xlib;
with Xm;
with XOS;
with XOS_Main_CB;
with Xt;

separate (XOS_Main_CB)

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
--   This procedure prompts the user to quit the application. If the
--   user chooses to quit, the application is terminated.
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
   Client_Data : in out Xt.POINTER;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   OS_Status_Flag : OS_Status.STATUS_TYPE;

begin

    --
    -- Put up the quit prompt dialog.
    --
    if (Motif_Utilities.Prompt_User (Parent, Xm.DIALOG_QUESTION,
      "Quit Prompt", "Do you really wish to quit this program?",
      " Yes ", 'Y', "", ASCII.NUL, " No ", 'N') = 'Y') then
	    

       --
       -- Unmap shared memory interface
       --
--       if XOS.Self_Mapped then
--          OS_GUI.Unmap_Interface(
--            Destroy_Interface => TRUE,
--            Status            => OS_Status_Flag);
--       else
          OS_GUI.Unmap_Interface(
            Destroy_Interface => FALSE,
            Status            => OS_Status_Flag);
--       end if;

       --
       -- Exit XOS
       --
       Xlib.c_exit (0);

    end if;

exception

   when OTHERS =>
      Motif_Utilities.Display_Message (
        Parent  => Motif_Utilities.Get_Topshell (Parent),
        Title   => "Unknown Error",
        Message => "An unknown error has occured; please try again...");

end Quit_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

