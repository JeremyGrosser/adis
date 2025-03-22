
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
with Numeric_Types;
with Text_IO;
with Utilities;
with XDG_Server_Types;
with Xlib;
with Xm;
with Xt;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Panel_Network
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 1, 1994
--
-- PURPOSE:
--   This procedure initializes the Network Panel widgets with the
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
procedure Initialize_Panel_Network (
   Network : in     XDG_Server_Types.XDG_NETWORK_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Arglist           : Xt.ARGLIST (1..10);
   Argcount          : Xt.INT := 0;
   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Server.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   -- DG_Server_GUI.Interface (of type DG_Server_GUI.INTERFACE_TYPE)

   --
   -- Initialize UDP_Port widget
   --
   if (Network.UDP_Port /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Network_Parameters.UDP_Port),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Network.UDP_Port, Temp_String);
   end if;

   --
   -- Initialize Destination_Address_Quad_1 widget
   --
   if (Network.Destination_Address_Quad_1 /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Network_Parameters.Broadcast_IP_Address(
	    1)),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Network.Destination_Address_Quad_1, Temp_String);
   end if;

   --
   -- Initialize Destination_Address_Quad_2 widget
   --
   if (Network.Destination_Address_Quad_2 /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Network_Parameters.Broadcast_IP_Address(
	    2)),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Network.Destination_Address_Quad_2, Temp_String);
   end if;

   --
   -- Initialize Destination_Address_Quad_3 widget
   --
   if (Network.Destination_Address_Quad_3 /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Network_Parameters.Broadcast_IP_Address(
	    3)),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Network.Destination_Address_Quad_3, Temp_String);
   end if;

   --
   -- Initialize Destination_Address_Quad_4 widget
   --
   if (Network.Destination_Address_Quad_4 /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Network_Parameters.Broadcast_IP_Address(
	    4)),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Network.Destination_Address_Quad_4, Temp_String);
   end if;

   --
   -- Initialize Data_Reception option menu widget
   --
   if (Network.Data_Reception /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Network_Parameters.Data_Reception_Enabled
	= XDG_Server.K_Enabled) then
	 XDG_Server.Network_Data_Reception_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Network.Data_Reception), K_Enabled_String);
      else
	 XDG_Server.Network_Data_Reception_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Network.Data_Reception), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Data_Transmission option menu widget
   --
   if (Network.Data_Transmission /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Network_Parameters.
	Data_Transmission_Enabled = XDG_Server.K_Enabled) then
	 XDG_Server.Network_Data_Transmission_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Network.Data_Transmission), K_Enabled_String);
      else
	 XDG_Server.Network_Data_Transmission_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Network.Data_Transmission), K_Disabled_String);
      end if;
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Network;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/01/94   D. Forrest
--      - Initial version
--
-- --

