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
with DG_Server_GUI;
with Motif_Utilities;
with Text_IO;
with Utilities;
with XDG_Server_Types;
with Xlib;
with Xm;
with Xt;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Panel_Threshold
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 1, 1994
--
-- PURPOSE:
--   This procedure initializes the Threshold Panel widgets with the
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
procedure Initialize_Panel_Threshold (
   Threshold : in     XDG_Server_Types.XDG_THRESHOLD_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Server.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Distance widget
   --
   if (Threshold.Distance /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value   => FLOAT(
	  DG_Server_GUI.Interface.Threshold_Parameters.Distance),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Distance, Temp_String);
   end if;

   --
   -- Initialize Orientation widget
   --
   if (Threshold.Orientation /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value   => FLOAT(
	  DG_Server_GUI.Interface.Threshold_Parameters.Orientation),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Orientation, Temp_String);

   end if;

   --
   -- Initialize Entity_Update widget
   --
   if (Threshold.Entity_Update /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Threshold_Parameters.Entity_Update),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Entity_Update, Temp_String);
   end if;

   --
   -- Initialize Entity_Expiration widget
   --
   if (Threshold.Entity_Expiration /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Threshold_Parameters.Entity_Expiration),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Entity_Expiration, Temp_String);
   end if;

   --
   -- Initialize Emission_Update widget
   --
   if (Threshold.Emission_Update /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Threshold_Parameters.Emission_Update),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Emission_Update, Temp_String);
   end if;

   --
   -- Initialize Laser_Update widget
   --
   if (Threshold.Laser_Update /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Threshold_Parameters.Laser_Update),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Laser_Update, Temp_String);
   end if;

   --
   -- Initialize Transmitter_Update widget
   --
   if (Threshold.Transmitter_Update /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Threshold_Parameters.Transmitter_Update),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Transmitter_Update, Temp_String);
   end if;

   --
   -- Initialize Receiver_Update widget
   --
   if (Threshold.Receiver_Update /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Threshold_Parameters.Receiver_Update),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Threshold.Receiver_Update, Temp_String);
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Threshold;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/01/94   D. Forrest
--      - Initial version
--
-- --

