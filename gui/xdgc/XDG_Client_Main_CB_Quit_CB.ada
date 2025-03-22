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

with DG_Client_GUI;
with DG_Status;

with XDG_Client;
with XDG_Client_Main_CB;
with Motif_Utilities;
with Xlib;
with Xm;
with Xt;

separate (XDG_Client_Main_CB)

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

   DG_Status_Flag : DG_Status.STATUS_TYPE;
   K_Prompt_Title : constant STRING := "Quit Prompt (" 
     & DG_Client_GUI.Interface.Client_Name.Name(DG_Client_GUI.Interface.
       Client_Name.Name'first..DG_Client_GUI.Interface.Client_Name.
	 Name'first + DG_Client_GUI.Interface.Client_Name.Length - 1) & ")"
	   & ASCII.NUL;

begin

    --
    -- Put up the quit prompt dialog.
    --
    if (Motif_Utilities.Prompt_User (Parent, Xm.DIALOG_QUESTION,
      K_Prompt_Title, "Do you really wish to quit the DG Client GUI?" 
	& ASCII.LF 
	  & "(Doing so will disconnect this client from the DG Server!)",
	    " Yes ", 'Y', "", ASCII.NUL, " No ", 'N') = 'Y') then
	    
      --
      -- Disconnect from DG Server.
      --
      DG_Client_GUI.Interface.Connected_To_Server := False;
      DG_Client_GUI.Interface.Shutdown_Client     := True;

--      if XDG_Client.Self_Mapped then
--	 DG_Client_GUI.Unmap_Interface(
--	   Destroy_Interface => TRUE,
--	   Status            => DG_Status_Flag);
--      else
	 DG_Client_GUI.Unmap_Interface(
	   Destroy_Interface => FALSE,
	   Status            => DG_Status_Flag);
--      end if;

      --
      -- Exit the DG Server application.
      --
      Xlib.c_exit (0);

    end if;

end Quit_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

