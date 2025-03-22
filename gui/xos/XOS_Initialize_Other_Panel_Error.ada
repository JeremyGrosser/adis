--
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
with Numeric_Types;
with OS_Data_Types;
with OS_GUI;
with Text_IO;
with Utilities;
with XOS;
with XOS_Types;
with Xlib;
with Xm;
with Xt;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Panel_Error
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 9, 1994
--
-- PURPOSE:
--   This procedure initializes the Error Panel widgets with the
--   values from the OS Shared Memory interface.
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
procedure Initialize_Other_Panel_Error (
   Error_Data : in     XOS_Types.XOS_OTHER_ERROR_PARM_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XOS.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize GUI_Error_Reporting option menu widget
   --
   if (Error_Data.GUI_Error_Reporting /= Xt.XNULL) then
      if (OS_GUI.Interface.Error_Parameters.Display_Error
	= XOS.K_Enabled) then
	 XOS.GUI_Error_Reporting_Flag := XOS.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error_Data.GUI_Error_Reporting), K_Enabled_String);
      else
	 XOS.GUI_Error_Reporting_Flag := XOS.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error_Data.GUI_Error_Reporting), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Error_Logging option menu widget
   --
   if (Error_Data.Error_Logging /= Xt.XNULL) then
      if (OS_GUI.Interface.Error_Parameters.Log_Error
	= XOS.K_Enabled) then
	 XOS.Error_Logging_Flag := XOS.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error_Data.Error_Logging), K_Enabled_String);
      else
	 XOS.Error_Logging_Flag := XOS.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error_Data.Error_Logging), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Error_Logfile widget
   --
   if (Error_Data.Error_Logfile /= Xt.XNULL) then

      if (OS_GUI.Interface.Error_Parameters.Log_File.Length > 0) then
         Xm.TextFieldSetString (Error_Data.Error_Logfile, OS_GUI.Interface.
	   Error_Parameters.Log_File.Name(OS_GUI.Interface.Error_Parameters.
	     Log_File.Name'first..OS_GUI.Interface.Error_Parameters.
	       Log_File.Name'first + OS_GUI.Interface.Error_Parameters.
		 Log_File.Length) & ASCII.NUL);
      else
         Xm.TextFieldSetString (Error_Data.Error_Logfile, " ");
      end if;

   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Other_Panel_Error;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/09/94   D. Forrest
--      - Initial version
--
-- --

