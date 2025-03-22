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
with OS_GUI;
with OS_Simulation_Types;
with Text_IO;
with Utilities;
with XOS_Types;
with Xlib;
with Xm;
with Xt;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Sim_Panel_Sim
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 8, 1994
--
-- PURPOSE:
--   This procedure initializes the Simulation Panel widgets with the
--   values from the OS Shared Memory interface.
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
procedure Initialize_Sim_Panel_Sim (
   Sim_Data : in     XOS_Types.XOS_SIM_SIM_PARM_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Contact_Threshold widget
   --
   if (Sim_Data.Contact_Threshold /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.Simulation_Parameters.Contact_Threshold),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Contact_Threshold, Temp_String);
   end if;

   --
   -- Initialize Cycle_Time widget
   --
   if (Sim_Data.Cycle_Time /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.Simulation_Parameters.Cycle_Time),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Cycle_Time, Temp_String);
   end if;

   --
   -- Initialize DB_Origin_Latitude widget
   --
   if (Sim_Data.DB_Origin_Latitude /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.Simulation_Parameters.Database_Origin.Latitude),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.DB_Origin_Latitude, Temp_String);
   end if;

   --
   -- Initialize DB_Origin_Longitude widget
   --
   if (Sim_Data.DB_Origin_Longitude /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.Simulation_Parameters.Database_Origin.Longitude),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.DB_Origin_Longitude, Temp_String);
   end if;

   --
   -- Initialize DB_Origin_Altitude widget
   --
   if (Sim_Data.DB_Origin_Altitude /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.Simulation_Parameters.Database_Origin.Altitude),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.DB_Origin_Altitude, Temp_String);
   end if;


   --
   -- Initialize Exercise_ID widget
   --
   if (Sim_Data.Exercise_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Exercise_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Exercise_ID, Temp_String);
   end if;

   --
   -- Initialize Hash_Table_Increment widget
   --
   if (Sim_Data.Hash_Table_Increment /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Hash_Table_Increment),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Hash_Table_Increment, Temp_String);
   end if;

   --
   -- Initialize Hash_Table_Size widget
   --
   if (Sim_Data.Hash_Table_Size /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Hash_Table_Size),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Hash_Table_Size, Temp_String);
   end if;

   --
   -- Initialize ModSAF_Database_Filename widget
   --
   if (Sim_Data.ModSAF_Database_Filename /= Xt.XNULL) then
      Xm.TextFieldSetString (Sim_Data.ModSAF_Database_Filename, 
	OS_GUI.Interface.Simulation_Parameters.ModSAF_Database_Filename);
   end if;

   --
   -- Initialize Memory_Limit_for_ModSAF_File widget
   --
   if (Sim_Data.Memory_Limit_for_ModSAF_File /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Memory_Limit_for_ModSAF_File),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Memory_Limit_for_ModSAF_File, 
	Temp_String);
   end if;

   --
   -- Initialize Number_of_Loops_Until_Update widget
   --
   if (Sim_Data.Number_of_Loops_Until_Update /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Number_of_Loops_Until_Update),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Number_of_Loops_Until_Update,
	Temp_String);
   end if;

   --
   -- Initialize Parent_Entity_ID_Sim_Address_Site_ID widget
   --
   if (Sim_Data.Parent_Entity_ID_Sim_Address_Site_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Parent_Entity_ID.
	    Sim_Address.Site_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Parent_Entity_ID_Sim_Address_Site_ID,
	Temp_String);
   end if;

   --
   -- Initialize Parent_Entity_ID_Sim_Address_Application_ID widget
   --
   if (Sim_Data.Parent_Entity_ID_Sim_Address_Application_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Parent_Entity_ID.
	    Sim_Address.Application_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.
	Parent_Entity_ID_Sim_Address_Application_ID, Temp_String);
   end if;

   --
   -- Initialize Parent_Entity_ID_Entity_ID widget
   --
   if (Sim_Data.Parent_Entity_ID_Entity_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Parent_Entity_ID.Entity_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Sim_Data.Parent_Entity_ID_Entity_ID, Temp_String);
   end if;

   --
   -- Initialize Protocol_Version output-only widget
   --
   if (Sim_Data.Protocol_Version /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  OS_GUI.Interface.Simulation_Parameters.Protocol_Version),
	Return_String => Temp_String);
      Motif_Utilities.Set_LabelString (Sim_Data.Protocol_Version,
	Temp_String);
   end if;

   --
   -- Initialize Simulation_State option menu widget
   --
   if (Sim_Data.Simulation_State /= Xt.XNULL) then
      XOS.Simulation_State_Value 
	:= OS_Simulation_Types.SIMULATION_STATE_TYPE'pos(
	  OS_GUI.Interface.Simulation_Parameters.Simulation_State);
      Motif_Utilities.Set_LabelString (
        Xm.OptionButtonGadget(Sim_Data.Simulation_State), 
	  OS_Simulation_Types.SIMULATION_STATE_TYPE'image(
	    OS_GUI.Interface.Simulation_Parameters.Simulation_State));
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Sim_Panel_Sim;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/08/94   D. Forrest
--      - Initial version
--
-- --

