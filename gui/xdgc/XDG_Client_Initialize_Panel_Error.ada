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

with DG_GUI_Interface_Types;
with DG_Client_GUI;
with Motif_Utilities;
with Numeric_Types;
with Text_IO;
with Utilities;
with XDG_Client_Types;
with Xlib;
with Xm;
with Xt;

separate (XDG_Client)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Panel_Error
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12 1994
--
-- PURPOSE:
--   This procedure initializes the Error Panel widgets with the
--   values from the DG Shared Memory interface.
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
procedure Initialize_Panel_Error (
   Error : in     XDG_Client_Types.XDG_ERROR_PARAMETERS_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Client.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   null;
   --
   -- Initialize GUI_Error_Reporting option menu widget
   --
   if (Error.GUI_Error_Reporting /= Xt.XNULL) then
      if (DG_Client_GUI.Interface.Error_Parameters.Error_Monitor_Enabled
	= XDG_Client.K_Enabled) then
	 XDG_Client.GUI_Error_Reporting_Flag := XDG_Client.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error.GUI_Error_Reporting), K_Enabled_String);
      else
	 XDG_Client.GUI_Error_Reporting_Flag := XDG_Client.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error.GUI_Error_Reporting), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Error_Logging option menu widget
   --
   if (Error.Error_Logging /= Xt.XNULL) then
      if (DG_Client_GUI.Interface.Error_Parameters.Error_Log_Enabled
	= XDG_Client.K_Enabled) then
	 XDG_Client.Error_Logging_Flag := XDG_Client.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error.Error_Logging), K_Enabled_String);
      else
	 XDG_Client.Error_Logging_Flag := XDG_Client.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Error.Error_Logging), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Error_Logfile widget
   --
   if (Error.Error_Logfile /= Xt.XNULL) then

      if DG_Client_GUI.Interface.Error_Parameters.Error_Log_File.Length > 0
        then

         Xm.TextFieldSetString (Error.Error_Logfile, DG_Client_GUI.Interface.
           Error_Parameters.Error_Log_File.Name(DG_Client_GUI.Interface.
             Error_Parameters.Error_Log_File.Name'first..DG_Client_GUI.
               Interface.Error_Parameters.Error_Log_File.Name'first +
                 DG_Client_GUI.Interface.Error_Parameters.
                   Error_Log_File.Length) & ASCII.NUL);
      else

         Xm.TextFieldSetString (Error.Error_Logfile, " ");
	 --Xm.TextFieldSetString (Error.Error_Logfile, 
	 --  Utilities.K_String_Null);

      end if;

   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Error;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

