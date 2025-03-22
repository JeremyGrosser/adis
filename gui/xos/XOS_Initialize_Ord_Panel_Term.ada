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
with XOS_Types;
with Xlib;
with Xm;
with Xt;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Ord_Panel_Term
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 8, 1994
--
-- PURPOSE:
--   This procedure initializes the Ordnance Termination Panel widgets
--   with the values from the OS Shared Memory interface.
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
procedure Initialize_Ord_Panel_Term (
   Term_Data : in     XOS_Types.XOS_ORD_TERM_PARM_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Fuze option menu widget
   --
   if (Term_Data.Fuze /= Xt.XNULL) then
      XOS.Fuze_Value := DIS_Types.A_FUZE_TYPE'pos(
	OS_GUI.Interface.General_Parameters.Termination_Parameters.Fuze);
      Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(Term_Data.Fuze), 
	DIS_Types.A_FUZE_TYPE'image(
	  OS_GUI.Interface.General_Parameters.Termination_Parameters.Fuze));
   end if;

   --
   -- Initialize Fuze_Detonation_Proximity widget
   --
   if (Term_Data.Fuze_Detonation_Proximity /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Termination_Parameters.
	    Detonation_Proximity_Distance),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Term_Data.Fuze_Detonation_Proximity, Temp_String);
   end if;

   --
   -- Initialize Fuze_Height_Relative_To_Sea_Level_To_Detonate widget
   --
   if (Term_Data.Fuze_Height_Relative_To_Sea_Level_To_Detonate 
     /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Termination_Parameters.
	    Height_Relative_to_Sea_Level_to_Detonate),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Term_Data.
	Fuze_Height_Relative_To_Sea_Level_To_Detonate, Temp_String);
   end if;

   --
   -- Initialize Fuze_Time_To_Detonation widget
   --
   if (Term_Data.Fuze_Time_To_Detonation /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Termination_Parameters.
	    Time_to_Detonation),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Term_Data.Fuze_Time_To_Detonation, Temp_String);
   end if;

   --
   -- Initialize Warhead option menu widget
   --
   if (Term_Data.Warhead /= Xt.XNULL) then
      XOS.Warhead_Value := DIS_Types.A_WARHEAD_TYPE'pos(
	OS_GUI.Interface.General_Parameters.Termination_Parameters.Warhead);
      Motif_Utilities.Set_LabelString (
	Xm.OptionButtonGadget(Term_Data.Warhead), 
	  DIS_Types.A_WARHEAD_TYPE'image(OS_GUI.Interface.
	    General_Parameters.Termination_Parameters.Warhead));
   end if;

   --
   -- Initialize Warhead_Range_To_Damage widget
   --
   if (Term_Data.Warhead_Range_To_Damage /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Termination_Parameters.
	    Range_to_Damage),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Term_Data.Warhead_Range_To_Damage, Temp_String);
   end if;

   --
   -- Initialize Warhead_Hard_Kill widget
   --
   if (Term_Data.Warhead_Hard_Kill /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Termination_Parameters.
	    Hard_Kill),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Term_Data.Warhead_Hard_Kill, Temp_String);
   end if;

   --
   -- Initialize Max_Range widget
   --
   if (Term_Data.Max_Range /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Termination_Parameters.Max_Range),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Term_Data.Max_Range, Temp_String);
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Ord_Panel_Term;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/08/94   D. Forrest
--      - Initial version
--
-- --

