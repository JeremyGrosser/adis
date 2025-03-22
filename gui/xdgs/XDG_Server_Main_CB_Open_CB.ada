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

with XDG_Server;
with XDG_Server_Main_CB;
with XDG_Server_Types;
with Motif_Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;

separate (XDG_Server_Main_CB)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Open_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 13, 1994
--
-- PURPOSE:
--   This procedure allows the user to load a pre-existing
--   configuration file.
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
procedure Open_CB (
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   K_Arglist_Max  : constant INTEGER := 20;
   K_Dialog_Title : constant STRING  := "Please select a config file to open:";

   Arglist        : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount       : Xt.INT := 0;                    -- number of arguments
   Temp_XmString  : Xm.XMSTRING;

   File_Selection_Box : Xt.WIDGET;

   DG_Status_Flag : DG_Status.STATUS_TYPE;


begin

    --
    -- Put up the quit prompt dialog; only create dialog if user OKs it.
    --
    if (Motif_Utilities.Prompt_User (Parent, Xm.DIALOG_QUESTION, "Open Prompt",
      "Do you really wish to open a pre-existing configuration file?"
	& ASCII.LF & "(All data currently entered into the XDG Server GUI "
	  & "will be overwritten...)",
            " Yes ", 'Y', "", ASCII.NUL, " No ", 'N') = 'Y') then
	    
       --
       -- Set up the FSB Open dialog resources
       --

       -- Dialog title
       Argcount := 0;
       Temp_XmString := Xm.StringCreateSimple (K_Dialog_Title);
       Argcount := Argcount + 1;
       Xt.SetArg (Arglist(Argcount), Xmdef.NdialogTitle, Temp_XmString);
       --
       -- Don't free this string; Ada crashes when you do.
       --
       --Xm.StringFree (Temp_XmString);

       -- Dialog file mask
       Argcount := Argcount + 1;
       Temp_XmString := Xm.StringCreateSimple(
	 XDG_Server_Types.K_Config_File_Base_Directory 
	   & XDG_Server_Types.K_Config_File_Mask);
       Xt.SetArg (Arglist(Argcount), Xmdef.Npattern, Temp_XmString);
       --
       -- Don't free this string; Ada crashes when you do.
       --
       --Xm.StringFree (Temp_XmString);

       --
       -- Create FSB Open dialog
       --
       File_Selection_Box := Xm.CreateFileSelectionDialog(
	 Parent   => Motif_Utilities.Get_Topshell(Parent),
	 Name     => "XDG" & ASCII.NUL,
	 Arglist  => Arglist,
	 Argcount => Argcount);
       --
       -- Unmanage the (unused) help buton
       --
       Xt.UnmanageChild (Xm.FileSelectionBoxGetChild(File_Selection_Box,
	 Xm.DIALOG_HELP_BUTTON));
       --
       -- Make the manual filename entry field insensitive
       --
       Xt.SetSensitive (Xm.FileSelectionBoxGetChild(File_Selection_Box,
	 Xm.DIALOG_TEXT), False);

       --
       -- Add the dialog destroy callback to the dialog cancel button
       --
       Xt.AddCallback (File_Selection_Box, Xmdef.NcancelCallback, 
	 Motif_Utilities.Destroy_Widget_CB'address, File_Selection_Box);

       --
       -- Add the dialog handler callback to the dialog ok button
       --
       Xt.AddCallback (File_Selection_Box, Xmdef.NokCallback,
	 XDG_Server_Main_CB.Open_Config_File_FSB_CB'address,
	   XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	     Set_Data));

       --
       -- Manage FSB Open dialog
       --
       Xt.ManageChild (File_Selection_Box);

    end if;

end Open_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/13/94   D. Forrest
--      - Initial version
--
-- --

