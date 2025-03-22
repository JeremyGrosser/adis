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
-- UNIT NAME:          Initialize_Panel_DG_Parameters
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12, 1994
--
-- PURPOSE:
--   This procedure initializes the DG_Parameters Panel widgets with the
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
procedure Initialize_Panel_DG_Parameters (
   DG_Parameters : in     XDG_Client_Types.XDG_DG_PARAMETERS_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Client.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Max_Entities widget
   --
   if (DG_Parameters.Max_Entities /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface
	  .Simulation_Data_Parameters.Maximum_Entities),
	Return_String => Temp_String);
      Xm.TextFieldSetString (DG_Parameters.Max_Entities, Temp_String);
   end if;

   --
   -- Initialize Max_Emitters widget
   --
   if (DG_Parameters.Max_Emitters /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface
	  .Simulation_Data_Parameters.Maximum_Emitters),
	Return_String => Temp_String);
      Xm.TextFieldSetString (DG_Parameters.Max_Emitters, Temp_String);
   end if;

   --
   -- Initialize Max_Lasers widget
   --
   if (DG_Parameters.Max_Lasers /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface
	  .Simulation_Data_Parameters.Maximum_Lasers),
	Return_String => Temp_String);
      Xm.TextFieldSetString (DG_Parameters.Max_Lasers, Temp_String);
   end if;

   --
   -- Initialize Max_Transmitters widget
   --
   if (DG_Parameters.Max_Transmitters /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface
	  .Simulation_Data_Parameters.Maximum_Transmitters),
	Return_String => Temp_String);
      Xm.TextFieldSetString (DG_Parameters.Max_Transmitters, Temp_String);
   end if;

   --
   -- Initialize Max_Receivers widget
   --
   if (DG_Parameters.Max_Receivers /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface
	  .Simulation_Data_Parameters.Maximum_Receivers),
	Return_String => Temp_String);
      Xm.TextFieldSetString (DG_Parameters.Max_Receivers, Temp_String);
   end if;

   --
   -- Initialize PDU_Buffer_Size widget
   --
   if (DG_Parameters.PDU_Buffer_Size /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface
	  .Simulation_Data_Parameters.PDU_Buffer_Size),
	Return_String => Temp_String);
      Xm.TextFieldSetString (DG_Parameters.PDU_Buffer_Size, Temp_String);
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_DG_Parameters;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

