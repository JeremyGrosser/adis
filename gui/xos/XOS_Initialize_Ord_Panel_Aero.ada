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
-- UNIT NAME:          Initialize_Ord_Panel_Aero
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 8, 1994
--
-- PURPOSE:
--   This procedure initializes the Ordnance Aerodynamic Panel widgets
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
procedure Initialize_Ord_Panel_Aero (
   Aero_Data : in     XOS_Types.XOS_ORD_AERO_PARM_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Burn_Rate widget
   --
   if (Aero_Data.Burn_Rate /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.Burn_Rate),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Burn_Rate, Temp_String);
   end if;

   --
   -- Initialize Burn_Time widget
   --
   if (Aero_Data.Burn_Time /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.Burn_Time),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Burn_Time, Temp_String);
   end if;

   --
   -- Initialize Azimuth_Detection_Angle widget
   --
   if (Aero_Data.Azimuth_Detection_Angle /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	    Azimuth_Detection_Angle),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Azimuth_Detection_Angle, Temp_String);
   end if;

   --
   -- Initialize Elevation_Detection_Angle widget
   --
   if (Aero_Data.Elevation_Detection_Angle /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	    Elevation_Detection_Angle),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Elevation_Detection_Angle, Temp_String);
   end if;

   --
   -- Initialize Drag_Coefficients widget arrays
   --
   for Counter in OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range loop
      if (Aero_Data.Drag_Coefficients(Counter) /= Xt.XNULL) then
	 Utilities.Float_To_String (
	   Float_Value => FLOAT(
	     OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	       Drag_Coefficients(Counter)),
	   Return_String => Temp_String);
	 Xm.TextFieldSetString (Aero_Data.Drag_Coefficients(Counter), 
	   Temp_String);
      end if;
   end loop;

   --
   -- Initialize Frontal_Area widget
   --
   if (Aero_Data.Frontal_Area /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	    Frontal_Area),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Frontal_Area, Temp_String);
   end if;

   --
   -- Initialize G_Gain widget
   --
   if (Aero_Data.G_Gain /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.G_Gain),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.G_Gain, Temp_String);
   end if;

   --
   -- Initialize Guidance option menu widget
   --
   if (Aero_Data.Guidance /= Xt.XNULL) then
      XOS.Guidance_Value := OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'pos(
	OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.Guidance);
      Motif_Utilities.Set_LabelString (
        Xm.OptionButtonGadget(Aero_Data.Guidance), 
	  OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'image(
	    OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	      Guidance));
   end if;

   --
   -- Initialize Illumination_Flag option menu widget
   --
   if (Aero_Data.Illumination_Flag /= Xt.XNULL) then
      XOS.Illumination_Flag_Value
	:= OS_Data_Types.ILLUMINATION_IDENTIFIER'pos(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	    Illumination_Flag);
      Motif_Utilities.Set_LabelString (
        Xm.OptionButtonGadget(Aero_Data.Illumination_Flag), 
	  OS_Data_Types.ILLUMINATION_IDENTIFIER'image(
	    OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	      Illumination_Flag));
   end if;

   --
   -- Initialize Initial_Mass widget
   --
   if (Aero_Data.Initial_Mass /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.
	    Initial_Mass),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Initial_Mass, Temp_String);
   end if;

   --
   -- Initialize Max_Gs widget
   --
   if (Aero_Data.Max_Gs /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.Max_Gs),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Max_Gs, Temp_String);
   end if;

   --
   -- Initialize Max_Speed widget
   --
   if (Aero_Data.Max_Speed /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.Max_Speed),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Max_Speed, Temp_String);
   end if;

   --
   -- Initialize Thrust widget
   --
   if (Aero_Data.Thrust /= Xt.XNULL) then
      Utilities.Float_To_String (
	Float_Value => FLOAT(
	  OS_GUI.Interface.General_Parameters.Aerodynamic_Parameters.Thrust),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Thrust, Temp_String);
   end if;

   --
   -- Initialize Laser_Code widget
   --
   if (Aero_Data.Laser_Code /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER( OS_GUI.Interface.General_Parameters.
	  Aerodynamic_Parameters.Laser_Code),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Aero_Data.Laser_Code, Temp_String);
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Ord_Panel_Aero;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/08/94   D. Forrest
--      - Initial version
--
-- --

