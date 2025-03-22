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
-- UNIT NAME:          Initialize_Ord_Panel_Gen
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 8, 1994
--
-- PURPOSE:
--   This procedure initializes the Ordnance General Panel widgets
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
procedure Initialize_Ord_Panel_Gen (
   Gen_Data : in     XOS_Types.XOS_ORD_GEN_PARM_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Dead_Reckoning_Algorithm option menu widget
   --
   if (Gen_Data.Dead_Reckoning_Algorithm /= Xt.XNULL) then
      XOS.Dead_Reckoning_Algorithm_Value
	:= DIS_Types.A_DEAD_RECKONING_ALGORITHM'pos(
	  OS_GUI.Interface.General_Parameters.Dead_Reckoning_Algorithm);
      Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	Gen_Data.Dead_Reckoning_Algorithm), 
	  DIS_Types.A_DEAD_RECKONING_ALGORITHM'image(
	    OS_GUI.Interface.General_Parameters.Dead_Reckoning_Algorithm));
   end if;

   --
   -- Initialize Entity_Kind option menu widget
   --
   if (Gen_Data.Entity_Kind /= Xt.XNULL) then
      XOS.Entity_Kind_Value := DIS_Types.AN_ENTITY_KIND'pos(
	OS_GUI.Interface.General_Parameters.Entity_Type.Entity_Kind);
      Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	Gen_Data.Entity_Kind), DIS_Types.AN_ENTITY_KIND'image(
	  OS_GUI.Interface.General_Parameters.Entity_Type.Entity_Kind));
   end if;

   --
   -- Initialize Domain widget
   --
   if (Gen_Data.Domain /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.General_Parameters.Entity_Type.Domain),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Gen_Data.Domain, Temp_String);
   end if;

   --
   -- Initialize Country option menu widget
   --
   if (Gen_Data.Country /= Xt.XNULL) then
      Utilities.Integer_To_String (
        Integer_Value => INTEGER(DIS_Types.A_COUNTRY_ID'pos(
          OS_GUI.Interface.General_Parameters.Entity_Type.Country)),
        Return_String => Temp_String);
      Xm.TextFieldSetString (Gen_Data.Country, Temp_String);
      Motif_Utilities.Set_LabelString (Gen_Data.Country_String,
        DIS_Types.A_COUNTRY_ID'image(OS_GUI.Interface.
          General_Parameters.Entity_Type.Country));
   end if;

   --
   -- Initialize Category widget
   --
   if (Gen_Data.Category /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.General_Parameters.Entity_Type.Category),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Gen_Data.Category, Temp_String);
   end if;

   --
   -- Initialize Subcategory widget
   --
   if (Gen_Data.Subcategory /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.General_Parameters.Entity_Type.Subcategory),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Gen_Data.Subcategory, Temp_String);
   end if;

   --
   -- Initialize Specific widget
   --
   if (Gen_Data.Specific /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.General_Parameters.Entity_Type.Specific),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Gen_Data.Specific, Temp_String);
   end if;

   --
   -- Initialize Fly_Out_Model_ID option menu widget
   --
   if (Gen_Data.Fly_Out_Model_ID /= Xt.XNULL) then
      XOS.Fly_Out_Model_ID_Value := 
	OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'pos(
	  OS_GUI.Interface.General_Parameters.Fly_Out_Model_ID);
      Motif_Utilities.Set_LabelString (
	Xm.OptionButtonGadget(Gen_Data.Fly_Out_Model_ID), 
	  OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'image(
	    OS_GUI.Interface.General_Parameters.Fly_Out_Model_ID));
   end if;


exception
   
   when OTHERS =>
      null;

end Initialize_Ord_Panel_Gen;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/08/94   D. Forrest
--      - Initial version
--
-- --

