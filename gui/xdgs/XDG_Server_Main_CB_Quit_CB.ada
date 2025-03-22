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

with DG_Server_GUI;
with DG_Status;

with Motif_Utilities;
with Utilities;
with XDG_Server;
with XDG_Server_Main_CB;
with Xlib;
with Xm;
with Xt;

separate (XDG_Server_Main_CB)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Quit_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 2, 1994
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
   Parent               : in     Xt.WIDGET;
   Shutdown_Server_Flag : in out INTEGER;
   Call_Data            :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   DG_Status_Flag : DG_Status.STATUS_TYPE;
   Quit_Action : QUIT_ACTION_ENUM
     := QUIT_ACTION_ENUM'val(Shutdown_Server_Flag);
   Quit_Message : Utilities.ASTRING := NULL;

begin

   case Quit_Action is
      when QUIT_ACTION_QUIT_GUI =>
	 Quit_Message := new STRING'(
	   "Do you really wish to quit the DG Server GUI?");
      when QUIT_ACTION_SHUTDOWN_SERVER_AND_QUIT_GUI =>
	 Quit_Message := new STRING'(
	   "Do you really wish to shutdown the DG Server" & ASCII.LF
	     & "(disconnecting all clients)" & ASCII.LF
	       & "and quit the DG Server GUI?");
      when OTHERS =>
	 Quit_Message := new STRING'(
	   "Do you really wish to quit the DG Server GUI?");
   end case;

   --
   -- Put up the quit prompt dialog.
   --
   if (Motif_Utilities.Prompt_User (Parent, Xm.DIALOG_QUESTION,
     "Quit Prompt", Quit_Message.all,
       " Yes ", 'Y', "", ASCII.NUL, " No ", 'N') = 'Y') then

      --
      -- Take other quit actions as appropriate
      --
      case Quit_Action is
	 when QUIT_ACTION_QUIT_GUI =>
	    null;
	 when QUIT_ACTION_SHUTDOWN_SERVER_AND_QUIT_GUI =>
	    DG_Server_Gui.Interface.Shutdown_Server := TRUE;
	 when OTHERS =>
	    null;
      end case;
	    
      --
      -- Unmap shared memory interface
      --
--      if XDG_Server.Self_Mapped then
--	 DG_Server_GUI.Unmap_Interface(
--	   Destroy_Interface => TRUE,
--	   Status            => DG_Status_Flag);
--      else
	 DG_Server_GUI.Unmap_Interface(
	   Destroy_Interface => FALSE,
	   Status            => DG_Status_Flag);
--      end if;

      --
      -- Exit XDG
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
--   06/02/94   D. Forrest
--      - Initial version
--
-- --

