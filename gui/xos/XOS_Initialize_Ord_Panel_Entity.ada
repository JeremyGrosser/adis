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
-- UNIT NAME:          Initialize_Ord_Panel_Entity
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 30, 1994
--
-- PURPOSE:
--   This procedure initializes the Ord Entity Panel widgets
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
procedure Initialize_Ord_Panel_Entity (
   Entity_Data : in     XOS_Types.XOS_ORD_ENTITY_PARM_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Entity_Kind option menu widget
   --
   if (Entity_Data.Entity_Kind /= Xt.XNULL) then
      XOS.Alternate_Entity_Kind_Value := DIS_Types.AN_ENTITY_KIND'pos(
	OS_GUI.Interface.General_Parameters.Alternate_Entity_Type.
	  Entity_Kind);
      Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	Entity_Data.Entity_Kind), DIS_Types.AN_ENTITY_KIND'image(
	  OS_GUI.Interface.General_Parameters.Alternate_Entity_Type.
	    Entity_Kind));
   end if;

   --
   -- Initialize Domain widget
   --
   if (Entity_Data.Domain /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Alternate_Entity_Type.Domain),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Entity_Data.Domain, Temp_String);
   end if;

   --
   -- Initialize Country widget
   --
   if (Entity_Data.Country /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DIS_Types.A_COUNTRY_ID'pos(
	  OS_GUI.Interface.General_Parameters.Alternate_Entity_Type.Country)),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Entity_Data.Country, Temp_String);
      Motif_Utilities.Set_LabelString (Entity_Data.Country_String,
	DIS_Types.A_COUNTRY_ID'image(OS_GUI.Interface.
	  General_Parameters.Alternate_Entity_Type.Country));
   end if;

   --
   -- Initialize Category widget
   --
   if (Entity_Data.Category /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Alternate_Entity_Type.Category),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Entity_Data.Category, Temp_String);
   end if;

   --
   -- Initialize Subcategory widget
   --
   if (Entity_Data.Subcategory /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Alternate_Entity_Type.Subcategory),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Entity_Data.Subcategory, Temp_String);
   end if;

   --
   -- Initialize Specific widget
   --
   if (Entity_Data.Specific /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Alternate_Entity_Type.Specific),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Entity_Data.Specific, Temp_String);
   end if;

   --
   -- Initialize Extra widget
   --
   if (Entity_Data.Extra /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Alternate_Entity_Type.Extra),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Entity_Data.Extra, Temp_String);
   end if;

   --
   -- Initialize Capabilities widget
   --
   if (Entity_Data.Capabilities /= Xt.XNULL) then

      INITIALIZE_ENTITY_CAPABILITIES_BLOCK:
      declare
	 K_String_Offset       : constant INTEGER := 1; -- STRING'first
	 K_Null_Length         : constant INTEGER
	   := Utilities.K_String_Null'length;
	 Capabilities_String : STRING(
	   DIS_Types.AN_ENTITY_CAPABILITIES_RECORD'first
	     + K_String_Offset..(DIS_Types.AN_ENTITY_CAPABILITIES_RECORD'last 
	       + K_String_Offset + K_Null_Length)) := (OTHERS => ASCII.NUL);
      begin

	 for Counter in DIS_Types.AN_ENTITY_CAPABILITIES_RECORD'range loop

	    if INTEGER(OS_GUI.Interface.General_Parameters.
	      Capabilities(Counter)) = 0 then
	       Capabilities_String(Counter + K_String_Offset) := '0';
	    else
	       Capabilities_String(Counter + K_String_Offset) := '1';
	    end if;

	 end loop;

	 Capabilities_String(Capabilities_String'last..
	   Capabilities_String'last) := Utilities.K_String_Null;

         Xm.TextFieldSetString (Entity_Data.Capabilities, Capabilities_String);

      end INITIALIZE_ENTITY_CAPABILITIES_BLOCK;


   end if;

   --
   -- Initialize Paint widget
   --
   if (Entity_Data.Paint /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_PAINT_SCHEME'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Paint),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Paint, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Mobility widget
   --
   if (Entity_Data.Mobility /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_MOBILITY_KILL'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Mobility),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Mobility, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Fire_Power widget
   --
   if (Entity_Data.Fire_Power /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_FIRE_POWER_KILL'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Fire_Power),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Fire_Power, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Damage widget
   --
   if (Entity_Data.Damage /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_DAMAGE_LEVEL'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Damage),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Damage, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Smoke widget
   --
   if (Entity_Data.Smoke /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_SMOKE_EFFECT'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Smoke),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Smoke, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Trailing widget
   --
   if (Entity_Data.Trailing /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_TRAILING_EFFECT'pos(OS_GUI.Interface.
	    General_Parameters.Entity_Appearance.General.Trailing),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Trailing, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Hatch widget
   --
   if (Entity_Data.Hatch /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_HATCH_STATE'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Hatch),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Hatch, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Lights widget
   --
   if (Entity_Data.Lights /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_LIGHT_STATUS'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Lights),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Lights, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Flaming widget
   --
   if (Entity_Data.Flaming /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => DIS_Types.A_FLAME_STATUS'pos(OS_GUI.Interface.
	  General_Parameters.Entity_Appearance.General.Flaming),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.Flaming, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize EA_Specific widget
   --
   if (Entity_Data.EA_Specific /= Xt.XNULL) then
      Utilities.Hexadecimal_To_String(
	Hexadecimal_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Entity_Appearance.Specific),
	Return_String     => Temp_String);
      for counter in 4..Temp_String'last loop
	 if (Temp_String(counter) = '#') then
	    Temp_String(counter) := ASCII.NUL;
	 end if;
      end loop;
      Xm.TextFieldSetString (Entity_Data.EA_Specific, 
	Temp_String(4..Temp_String'last));
   end if;

   --
   -- Initialize Entity_Marking widget
   --
   if (Entity_Data.Entity_Marking /= Xt.XNULL) then

      INITIALIZE_ENTITY_MARKING_BLOCK:
      declare
	 Entity_Marking_String : STRING (DIS_Types.A_MARKING_SET'range);
      begin

	 for Counter in DIS_Types.A_MARKING_SET'range loop
	    Entity_Marking_String(Counter) := CHARACTER'val(INTEGER(
	      OS_GUI.Interface.General_Parameters.Entity_Marking.Text(
		Counter)));
	 end loop;

         Xm.TextFieldSetString (Entity_Data.Entity_Marking,
	   Entity_Marking_String);
      end INITIALIZE_ENTITY_MARKING_BLOCK;
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Ord_Panel_Entity;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/30/94   D. Forrest
--      - Initial version
--
-- --

