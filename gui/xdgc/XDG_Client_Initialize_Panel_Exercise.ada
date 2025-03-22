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
-- UNIT NAME:          Initialize_Panel_Exercise
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12 1994
--
-- PURPOSE:
--   This procedure initializes the Exercise Panel widgets with the
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
procedure Initialize_Panel_Exercise (
   Exercise : in     XDG_Client_Types.XDG_EXERCISE_PARAMETERS_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Client.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Automatic_Application_ID option menu widget
   --
   if (Exercise.Automatic_Application_ID /= Xt.XNULL) then
      if (DG_Client_GUI.Interface.Exercise_Parameters.Set_Application_ID
	= XDG_Client.K_Enabled) then
	 XDG_Client.Automatic_Application_ID_Flag := XDG_Client.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Exercise.Automatic_Application_ID), K_Enabled_String);
      else
	 XDG_Client.Automatic_Application_ID_Flag := XDG_Client.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Exercise.Automatic_Application_ID), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Application_ID text widget
   --
   if (Exercise.Application_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Client_GUI.Interface.Exercise_Parameters.Application_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Exercise.Application_ID, Temp_String);
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Exercise;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

