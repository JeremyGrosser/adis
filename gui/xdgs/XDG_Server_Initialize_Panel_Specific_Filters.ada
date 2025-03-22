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
-- UNIT NAME:          Initialize_Panel_Specific_Filters
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 1, 1994
--
-- PURPOSE:
--   This procedure initializes the Specific_Filters Panel widgets with the
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
procedure Initialize_Panel_Specific_Filters (
   Specific_Filters : in     XDG_Server_Types.XDG_SPECIFIC_FILTERS_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Server.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Keep_Exercise_ID option menu widget
   --
   if (Specific_Filters.Keep_Exercise_ID /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.Keep_Exercise_ID
	= XDG_Server.K_Enabled) then
	 XDG_Server.Keep_Exercise_ID_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Exercise_ID), K_Enabled_String);
      else
	 XDG_Server.Keep_Exercise_ID_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Exercise_ID), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep_Exercise_ID_Value widget
   --
   if (Specific_Filters.Keep_Exercise_ID_Value /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Filter_Parameters.Exercise_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Specific_Filters.Keep_Exercise_ID_Value,
	Temp_String);
   end if;

   --
   -- Initialize Keep_Force_ID_Other option menu widget
   --
   if (Specific_Filters.Keep_Force_ID_Other /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.Keep_Other_Force
	= XDG_Server.K_Enabled) then
	 XDG_Server.Keep_Force_ID_Other_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Other), K_Enabled_String);
      else
	 XDG_Server.Keep_Force_ID_Other_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Other), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep_Force_ID_Friendly option menu widget
   --
   if (Specific_Filters.Keep_Force_ID_Friendly /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.Keep_Friendly_Force
	= XDG_Server.K_Enabled) then
	 XDG_Server.Keep_Force_ID_Friendly_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Friendly), K_Enabled_String);
      else
	 XDG_Server.Keep_Force_ID_Friendly_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Friendly), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep_Force_ID_Opposing option menu widget
   --
   if (Specific_Filters.Keep_Force_ID_Opposing /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.Keep_Opposing_Force
	= XDG_Server.K_Enabled) then
	 XDG_Server.Keep_Force_ID_Opposing_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Opposing), K_Enabled_String);
      else
	 XDG_Server.Keep_Force_ID_Opposing_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Opposing), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep_Force_ID_Neutral option menu widget
   --
   if (Specific_Filters.Keep_Force_ID_Neutral /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.Keep_Neutral_Force
	= XDG_Server.K_Enabled) then
	 XDG_Server.Keep_Force_ID_Neutral_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Neutral), K_Enabled_String);
      else
	 XDG_Server.Keep_Force_ID_Neutral_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Specific_Filters.Keep_Force_ID_Neutral), K_Disabled_String);
      end if;
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Specific_Filters;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/01/94   D. Forrest
--      - Initial version
--
-- --

