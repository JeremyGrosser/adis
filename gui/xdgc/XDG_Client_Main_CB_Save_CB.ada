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
with XDG_Client_Types;
with Motif_Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;

separate (XDG_Client_Main_CB)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Save_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 13, 1994
--
-- PURPOSE:
--   This procedure allows the user to save the data in the current
--   XDG Client screens into a configuration file.
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
procedure Save_CB (
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   K_Arglist_Max  : constant INTEGER := 20;
   K_Dialog_Title : constant STRING := "Config File Save Dialog (" 
     & DG_Client_GUI.Interface.Client_Name.Name(DG_Client_GUI.Interface.
       Client_Name.Name'first..DG_Client_GUI.Interface.Client_Name.
	 Name'first + DG_Client_GUI.Interface.Client_Name.Length - 1) & ")"
	   & ASCII.NUL;
   K_Filename_Max : constant INTEGER := 1024;

   Arglist        : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount       : Xt.INT := 0;                    -- number of arguments
   Temp_XmString  : Xm.XMSTRING;

   File_Selection_Box : Xt.WIDGET;
   Save_Warning_Label : Xt.WIDGET;

   DG_Status_Flag : DG_Status.STATUS_TYPE;

begin

    -- Dialog title
    Argcount := 0;
    Temp_XmString := Xm.StringCreateSimple (K_Dialog_Title);
    Argcount := Argcount + 1;
    Xt.SetArg (Arglist(Argcount), Xmdef.NdialogTitle, Temp_XmString);
    Argcount := Argcount + 1;
    --
    -- The Xmdef and Xm packages are missing the Motif 1.2 constants
    -- Xmdef.NchildPlacement and Xm.PLACE_BELOW_SELECTION, so I've
    -- declared them in the Motif_Utilities package. The call to Xt.SetArg
    -- with the Xmdef and Xm constants is left below (commented out)
    -- for reference, and to be un-commented when (if?) Verdix adds
    -- the full Motif 1.2 bindings...
    --
    --Xt.SetArg (Arglist(Argcount), Xmdef.NchildPlacement, 
    --  INTEGER(Xm.PLACE_BELOW_SELECTION));
    Xt.SetArg (Arglist(Argcount), Motif_Utilities.K_XmdefNchildPlacement,
      Motif_Utilities.K_XmPLACE_BELOW_SELECTION);

    --
    -- Don't free this string; Ada crashes when you do.
    --Xm.StringFree (Temp_XmString);

    --
    -- Create FSB Save dialog
    --
    File_Selection_Box := Xm.CreateFileSelectionDialog(
      Parent   => Motif_Utilities.Get_Topshell(Parent),
      Name     => "XDG" & ASCII.NUL,
      Arglist  => Arglist,
      Argcount => Argcount);

    --
    -- Set the default save filename string
    --
    if (DG_Client_GUI.Interface.Configuration_File.Length > 0) then

       Xm.TextSetString (Xm.FileSelectionBoxGetChild (File_Selection_Box,
	 Xm.DIALOG_TEXT), DG_Client_GUI.Interface.Configuration_File.Name(
	   DG_Client_GUI.Interface.Configuration_File.Name'first..
	     DG_Client_GUI.Interface.Configuration_File.Name'first
	       + DG_Client_GUI.Interface.Configuration_File.Length - 1));
    else
       Xm.TextSetString (Xm.FileSelectionBoxGetChild (File_Selection_Box,
	 Xm.DIALOG_TEXT), XDG_Client_Types.K_Default_Config_Filename);
    end if;

    --
    -- Unmanage the (unused) help buton
    --
    Xt.UnmanageChild (Xm.FileSelectionBoxGetChild(File_Selection_Box,
      Xm.DIALOG_HELP_BUTTON));

    --
    -- Add the save warning label.
    --
    Save_Warning_Label := Motif_Utilities.Create_Label (File_Selection_Box,
      XDG_Client.K_Save_Warning_String);
    Argcount := 0;
    Argcount := Argcount + 1;
    Xt.SetArg (Arglist(Argcount), Xmdef.Nalignment,
      INTEGER(Xm.ALIGNMENT_BEGINNING));
    Xt.SetValues (Save_Warning_Label, Arglist, Argcount);

    --
    -- Add the dialog destroy callback to the dialog cancel button
    --
    Xt.AddCallback (File_Selection_Box, Xmdef.NcancelCallback,
      Motif_Utilities.Destroy_Widget_CB'address, File_Selection_Box);

    --
    -- Add the dialog handler callback to the dialog ok button
    --
    Xt.AddCallback (File_Selection_Box, Xmdef.NokCallback,
      XDG_Client_Main_CB.Save_Config_File_FSB_CB'address,
	XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	  Set_Data));

    --
    -- Add the dialog handler callback to the dialog apply button
    --
    Xt.AddCallback (File_Selection_Box, Xmdef.NapplyCallback,
      XDG_Client_Main_CB.Save_Config_File_FSB_CB'address,
	XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER(
	  Set_Data));

    --
    -- Manage FSB Save dialog
    --
    Xt.ManageChild (File_Selection_Box);

end Save_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/13/94   D. Forrest
--      - Initial version
--
-- --

