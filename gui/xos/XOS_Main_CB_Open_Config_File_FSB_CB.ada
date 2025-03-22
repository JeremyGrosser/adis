--                            U N C L A S S I F I E D
--
--    *===================================================================*
--   /|                                                                   |\
--  /||                      Manned Flight Simulator                      ||\
-- <|||             Naval Air Warfar Center Aircraft Division             |||>
--  \||                     Patuxent River, Maryland                      ||/
--   \|                                                                   |/
--    *===================================================================*
--

with Motif_Utilities;
--with OS_GUI_Interface_Types;
with OS_GUI;
with OS_Status;
with Text_IO;
with Unchecked_Conversion;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with XOS;
with XOS_Main_CB;
with XOS_Types;
with Xt;

separate (XOS_Main_CB)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Open_Config_File_FSB_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 14, 1994
--
-- PURPOSE:
--   This procedure handled the FSB callbacks for opening an XOS
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
procedure Open_Config_File_FSB_CB(
   Parent      : in     Xt.WIDGET;
   XOS_Data    : in out XOS_Types.XOS_PARM_DATA_REC_PTR;
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
--	 if Temp_String_Length
--	   > OS_GUI_Interface_Types.K_Max_Configuration_Filename_Length then
--
--	    raise String_Too_Long;
--
--         else
--
--	    OS_GUI.Interface.Configuration_File.Name
--	      := (OTHERS => ASCII.NUL);
--	    OS_GUI.Interface.Configuration_File.Name(
--	      OS_GUI.Interface.Configuration_File.Name'first..
--		OS_GUI.Interface.Configuration_File.Name'first
--		  + Temp_String_Length)
--		    := Temp_String.all;
--	    OS_GUI.Interface.Configuration_File.Length
--	      := Temp_String_Length;
--	    OS_GUI.Interface.Configuration_File_Command
--	      := OS_GUI_Interface_Types.LOAD;
--
--	 end if;

	 --
	 -- Install Reinitialize_Panels_Timeout
	 --
	 XOS_Main_CB.Reinitialize_Panels_Timeout (XOS_Data);

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

end Open_Config_File_FSB_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/13/94   D. Forrest
--      - Initial version
--
-- --

