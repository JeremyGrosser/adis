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
-- UNIT NAME:          Initialize_Ord_Panel_Emitter
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 31, 1994
--
-- PURPOSE:
--   This procedure initializes the Ord Emitter Panel widgets
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
procedure Initialize_Ord_Panel_Emitter (
   Emitter_Data : in     XOS_Types.XOS_ORD_EMITTER_PARM_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Emitter_Name widget
   --
   if (Emitter_Data.Emitter_Name /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DIS_Types.AN_EMITTER_SYSTEM'pos(
          OS_GUI.Interface.General_Parameters.Emitter_Parameters.
	    Emitter_System.Emitter_Name)),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Emitter_Name, Temp_String);
   end if;

   --
   -- Initialize Emitter_Function widget
   --
   if (Emitter_Data.Emitter_Function /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(DIS_Types.AN_EMISSION_FUNCTION'pos(
          OS_GUI.Interface.General_Parameters.Emitter_Parameters.
	    Emitter_System.Emitter_Function)),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Emitter_Function, Temp_String);
   end if;

   --
   -- Initialize Emitter_ID widget
   --
   if (Emitter_Data.Emitter_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Emitter_System.Emitter_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Emitter_ID, Temp_String);
   end if;

   --
   -- Initialize Location_X widget
   --
   if (Emitter_Data.Location_X /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Location.X),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Location_X, Temp_String);
   end if;

   --
   -- Initialize Location_Y widget
   --
   if (Emitter_Data.Location_Y /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Location.Y),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Location_Y, Temp_String);
   end if;

   --
   -- Initialize Location_Z widget
   --
   if (Emitter_Data.Location_Z /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Location.Z),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Location_Z, Temp_String);
   end if;

   --
   -- Initialize Frequency widget
   --
   if (Emitter_Data.Frequency /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.Frequency),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Frequency, Temp_String);
   end if;

   --
   -- Initialize Frequency_Range widget
   --
   if (Emitter_Data.Frequency_Range /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.Frequency_Range),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Frequency_Range, Temp_String);
   end if;

   --
   -- Initialize ERP widget
   --
   if (Emitter_Data.ERP /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.ERP),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.ERP, Temp_String);
   end if;

   --
   -- Initialize PRF widget
   --
   if (Emitter_Data.PRF /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.PRF),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.PRF, Temp_String);
   end if;

   --
   -- Initialize Pulse_Width widget
   --
   if (Emitter_Data.Pulse_Width /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.Pulse_Width),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Pulse_Width, Temp_String);
   end if;

   --
   -- Initialize Beam_Azimuth_Center widget
   --
   if (Emitter_Data.Beam_Azimuth_Center /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.Beam_Azimuth_Center),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Beam_Azimuth_Center, Temp_String);
   end if;

   --
   -- Initialize Beam_Elevation_Center widget
   --
   if (Emitter_Data.Beam_Elevation_Center /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.Beam_Elevation_Center),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Beam_Elevation_Center, Temp_String);
   end if;

   --
   -- Initialize Beam_Sweep_Sync widget
   --
   if (Emitter_Data.Beam_Sweep_Sync /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Fundamental_Parameter_Data.Beam_Sweep_Sync),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Beam_Sweep_Sync, Temp_String);
   end if;


   --
   -- Initialize Beam_Parameter_Index widget
   --
   if (Emitter_Data.Beam_Parameter_Index /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Beam_Data.Beam_Parameter_Index),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Beam_Parameter_Index, Temp_String);
   end if;

   --
   -- Initialize Beam_Function widget
   --
   if (Emitter_Data.Beam_Function /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Beam_Data.Beam_Function),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Beam_Function, Temp_String);
   end if;

   --
   -- Initialize High_Density_Track_Jam widget
   --
   if (Emitter_Data.High_Density_Track_Jam /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Beam_Data.High_Density_Track_Jam),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.High_Density_Track_Jam, Temp_String);
   end if;

   --
   -- Initialize Jamming_Mode_Sequence widget
   --
   if (Emitter_Data.Jamming_Mode_Sequence /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(OS_GUI.Interface.General_Parameters.
	  Emitter_Parameters.Beam_Data.Jamming_Mode_Sequence),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Emitter_Data.Jamming_Mode_Sequence, Temp_String);
   end if;


exception
   
   when OTHERS =>
      null;

end Initialize_Ord_Panel_Emitter;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/31/94   D. Forrest
--      - Initial version
--
-- --

