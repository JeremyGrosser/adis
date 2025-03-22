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
-- UNIT NAME:          Initialize_Panel_Hash
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12 1994
--
-- PURPOSE:
--   This procedure initializes the Hash Panel widgets with the
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
procedure Initialize_Panel_Hash (
   Hash : in     XDG_Client_Types.XDG_HASH_PARAMETERS_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   -- DG_Client_GUI.Interface (of type DG_Client_GUI.INTERFACE_TYPE)

   -- ---------------------------
   -- Initialize Hash Parameters panel Entity PDU Widgets
   -- ---------------------------
   --
   -- Initialize Entity PDU Rehash_Increment widget
   --
   if (Hash.PDU(XDG_Client_Types.ENTITY).Rehash_Increment /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Entity_Hash_Table.Index_Increment),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.ENTITY).
	Rehash_Increment, Temp_String);
   end if;

   --
   -- Initialize Entity PDU Site_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.ENTITY).Site_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Entity_Hash_Table.Site_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.ENTITY).
	Site_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Entity PDU Application_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.ENTITY).Application_Multiplier
     /= Xt.XNULL) then

      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Entity_Hash_Table.Application_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.ENTITY).
	Application_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Entity PDU Entity_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.ENTITY).Entity_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Entity_Hash_Table.Entity_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.ENTITY).
	Entity_Multiplier, Temp_String);
   end if;

   -- ---------------------------
   -- Initialize Hash Parameters panel Emitter PDU Widgets
   -- ---------------------------
   --
   -- Initialize Emitter PDU Rehash_Increment widget
   --
   if (Hash.PDU(XDG_Client_Types.EMITTER).Rehash_Increment /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Emission_Hash_Table.Index_Increment),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.EMITTER).
	Rehash_Increment, Temp_String);
   end if;

   --
   -- Initialize Emitter PDU Site_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.EMITTER).Site_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Emission_Hash_Table.Site_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.EMITTER).
	Site_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Emitter PDU Application_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.EMITTER).Application_Multiplier
     /= Xt.XNULL) then

      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Emission_Hash_Table.Application_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.EMITTER).
	Application_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Emitter PDU Entity_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.EMITTER).Entity_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Emission_Hash_Table.Entity_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.EMITTER).
	Entity_Multiplier, Temp_String);
   end if;


   -- ---------------------------
   -- Initialize Hash Parameters panel Laser PDU Widgets
   -- ---------------------------
   --
   -- Initialize Laser PDU Rehash_Increment widget
   --
   if (Hash.PDU(XDG_Client_Types.LASER).Rehash_Increment /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Laser_Hash_Table.Index_Increment),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.LASER).
	Rehash_Increment, Temp_String);
   end if;

   --
   -- Initialize Laser PDU Site_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.LASER).Site_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Laser_Hash_Table.Site_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.LASER).
	Site_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Laser PDU Application_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.LASER).Application_Multiplier
     /= Xt.XNULL) then

      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Laser_Hash_Table.Application_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.LASER).
	Application_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Laser PDU Entity_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.LASER).Entity_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Laser_Hash_Table.Entity_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.LASER).
	Entity_Multiplier, Temp_String);
   end if;


   -- ---------------------------
   -- Initialize Hash Parameters panel Transmitter PDU Widgets
   -- ---------------------------
   --
   -- Initialize Transmitter PDU Rehash_Increment widget
   --
   if (Hash.PDU(XDG_Client_Types.TRANSMITTER).Rehash_Increment /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Transmitter_Hash_Table.Index_Increment),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.TRANSMITTER).
	Rehash_Increment, Temp_String);
   end if;

   --
   -- Initialize Transmitter PDU Site_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.TRANSMITTER).Site_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Transmitter_Hash_Table.Site_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.TRANSMITTER).
	Site_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Transmitter PDU Application_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.TRANSMITTER).Application_Multiplier
     /= Xt.XNULL) then

      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Transmitter_Hash_Table.Application_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.TRANSMITTER).
	Application_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Transmitter PDU Entity_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.TRANSMITTER).Entity_Multiplier
     /= Xt.XNULL) then

      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Transmitter_Hash_Table.Entity_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.TRANSMITTER).
	Entity_Multiplier, Temp_String);
   end if;


   -- ---------------------------
   -- Initialize Hash Parameters panel Receiver PDU Widgets
   -- ---------------------------
   --
   -- Initialize Receiver PDU Rehash_Increment widget
   --
   if (Hash.PDU(XDG_Client_Types.RECEIVER).Rehash_Increment /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Receiver_Hash_Table.Index_Increment),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.RECEIVER).
	Rehash_Increment, Temp_String);
   end if;

   --
   -- Initialize Receiver PDU Site_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.RECEIVER).Site_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Receiver_Hash_Table.Site_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.RECEIVER).
	Site_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Receiver PDU Application_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.RECEIVER).Application_Multiplier
     /= Xt.XNULL) then

      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Receiver_Hash_Table.Application_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.RECEIVER).
	Application_Multiplier, Temp_String);
   end if;

   --
   -- Initialize Receiver PDU Entity_Multiplier widget
   --
   if (Hash.PDU(XDG_Client_Types.RECEIVER).Entity_Multiplier /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DG_Client_GUI.Interface.Hash_Parameters.
	  Receiver_Hash_Table.Entity_Multiplier),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Hash.PDU(XDG_Client_Types.RECEIVER).
	Entity_Multiplier, Temp_String);
   end if;


exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Hash;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

