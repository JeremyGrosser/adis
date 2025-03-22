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

with DG_GUI_Interface_Types;
with DG_Client_GUI;
with DG_Status;
with Motif_Utilities;
with Unchecked_Conversion;
with Utilities;

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
-- UNIT NAME:          Save_Config_File_FSB_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 13, 1994
--
-- PURPOSE:
--   This procedure handled the FSB callbacks for saving an XDG
--   Client configuration file.
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
procedure Save_Config_File_FSB_CB(
   Parent      : in     Xt.WIDGET;
   Set_Data    : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data   : in out Xm.FILESELECTIONBOXCALLBACKSTRUCT_PTR) is

   K_Arglist_Max  : constant INTEGER := 10;

   Arglist        : Xt.ARGLIST (1..K_Arglist_Max);  -- X argument list
   Argcount       : Xt.INT := 0;                    -- number of arguments

   Temp_String        : Xm.String_Ptr;
   Temp_String_Length : INTEGER := 0;
   Success            : BOOLEAN;

   String_Get_Failed : EXCEPTION;
   String_Empty      : EXCEPTION;
   String_Too_Long   : EXCEPTION;

begin

   case Call_Data.Reason is

      when Xm.CR_APPLY =>

	 --
	 -- Apply the string...
	 --
	 if (DG_Client_GUI.Interface.Configuration_File.Length > 0) then

	    Xm.TextSetString (Xm.FileSelectionBoxGetChild (Parent,
	      Xm.DIALOG_TEXT), DG_Client_GUI.Interface.Configuration_File.Name(
		DG_Client_GUI.Interface.Configuration_File.Name'first..
		  DG_Client_GUI.Interface.Configuration_File.Name'first
		    + DG_Client_GUI.Interface.Configuration_File.Length - 1));
	 else
	    Xm.TextSetString (Xm.FileSelectionBoxGetChild (Parent,
	      Xm.DIALOG_TEXT), XDG_Client_Types.K_Default_Config_Filename);
	 end if;

      when Xm.CR_OK =>

	 --
	 -- Extract the string from the callback data structure
	 --
	 Xm.StringGetLtoR (Call_Data.Value, Xm.STRING_DEFAULT_CHARSET,
	   Temp_String, Success);
         if not Success then
	    raise String_Get_Failed;
	 end if;

	 --
	 -- Make sure the string is not empty
	 --
	 Temp_String_Length := Utilities.Length_Of_String (Temp_String.all);
	 if Temp_String_Length = 0 then
	    raise String_Empty;
	 end if;

	 --
	 -- Update the X display
	 --
	 Xm.UpdateDisplay (Parent);

	 --
	 -- Put the filename into shared memory and set the changed flag
	 --
	 if Temp_String_Length
	   > DG_GUI_Interface_Types.K_Max_Configuration_Filename_Length then

	    raise String_Too_Long;

         else

	    DG_Client_GUI.Interface.Configuration_File.Name
	      := (OTHERS => ASCII.NUL);
	    DG_Client_GUI.Interface.Configuration_File.Name(
	      DG_Client_GUI.Interface.Configuration_File.Name'first..
		DG_Client_GUI.Interface.Configuration_File.Name'first
		  + Temp_String_Length)
		    := Temp_String.all;
	    DG_Client_GUI.Interface.Configuration_File.Length
	      := Temp_String_Length;
	    DG_Client_GUI.Interface.Configuration_File_Command
	      := DG_GUI_Interface_Types.SAVE;

	 end if;

	 --
	 -- Free the Temp_String
	 --
	 Xlib.FreeAdaString (Temp_String);

	 --
	 -- Destroy the dialog
	 --
	 Xt.DestroyWidget (Xt.Parent (Parent));
   
      when Xm.CR_CANCEL =>
	 Xt.DestroyWidget (Xt.Parent (Parent));

      when OTHERS =>
	 null;

   end case;

exception

   when String_Get_Failed =>
       Motif_Utilities.Display_Message (
	 Parent  => Motif_Utilities.Get_Topshell (Parent),
	 Title   => "Error: Config File",
	 Message => 
	   "There has been a problem reading the filename from the dialog."
	     & ASCII.LF & "Please reselect a config file and try again...");

   when String_Empty =>
       Motif_Utilities.Display_Message (
	 Parent  => Motif_Utilities.Get_Topshell (Parent),
	 Title   => "Error: Config File",
	 Message => 
	   "The selected filename is empty."
	     & ASCII.LF & "Please select a valid file and try again...");

   when String_Too_Long =>
       Motif_Utilities.Display_Message (
	 Parent  => Motif_Utilities.Get_Topshell (Parent),
	 Title   => "Error: Config File",
	 Message => 
	   "The selected filename is too long (too many characters)."
	     & ASCII.LF & "Please select a file with a shorter name...");

   when OTHERS =>
       Motif_Utilities.Display_Message (
	 Parent  => Motif_Utilities.Get_Topshell (Parent),
	 Title   => "Error: Config File",
	 Message => 
	   "There has been a problem opening the selected config file."
	     & ASCII.LF & "Please check the file and try again...");

end Save_Config_File_FSB_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/13/94   D. Forrest
--      - Initial version
--
-- --

