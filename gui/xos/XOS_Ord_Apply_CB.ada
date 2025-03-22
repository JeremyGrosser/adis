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

with DIS_Types;
with Motif_Utilities;
with Numeric_Types;
with OS_GUI;
with Text_IO;
with Unchecked_Conversion;
with Unchecked_Deallocation;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with XOS_Types;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Ord_Apply_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 8, 1994
--
-- PURPOSE:
--   This procedure writes all changed values in all Set Ordnance
--   Parameters panels to shared memory.
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
procedure Ord_Apply_CB (
   Parent              : in     Xt.WIDGET;
   Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
   Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Declare panel name constant strings
   --
   K_General_Parameters_Panel_Name  : constant STRING
     := "General Parameters";
   K_Entity_Parameters_Panel_Name   : constant STRING
     := "Entity Parameters";
   K_Aerodynamic_Parameters_Panel_Name  : constant STRING
     := "Aerodynamic Parameters";
   K_Emitter_Parameters_Panel_Name  : constant STRING
     := "Emitter Parameters";
   K_Termination_Parameters_Panel_Name  : constant STRING
     := "Termination Parameters";

   --
   -- Local variable declarations
   --
   Success         : BOOLEAN;

   Problem_Message : Utilities.ASTRING := NULL;
   Problem_Panel   : Utilities.ASTRING := NULL;
   Problem_Item    : Utilities.ASTRING := NULL;

   Temp_Integer    : INTEGER;
   Temp_Float      : FLOAT;
   Temp_Char       : CHARACTER;
   Temp_Text       : Xm.STRING_PTR := NULL;

   --
   -- Local exceptions
   --
   Bad_Value : EXCEPTION;

   --
   -- Local OS GUI Interface record
   --
   Temp_Interface : OS_GUI.OS_GUI_INTERFACE_RECORD;

   --
   -- Local instantiations
   --
   procedure Free
     is new Unchecked_Deallocation (STRING, Utilities.ASTRING);
   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";
   function XmSTRING_PTR_To_XtPOINTER
     is new Unchecked_Conversion (Xm.STRING_PTR, Xt.POINTER);

begin

   --
   -- Initialize Temp_Interface with values from shared memory;
   --
   Temp_Interface := OS_GUI.Interface.all;

   -- --- -------------------------------------------------------------
   -- Extract data from Ordnance Aerodynamic Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Ord_Parameters_Data.Aero.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Burn_Rate field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	 Text_Widget  => Ord_Parameters_Data.Aero.Burn_Rate,
	 Return_Value => Temp_Float,
	 Success      => Success);
      --
      -- If Get_Float_From_Text_Widget fails, raise the Bad_Value exception.
      --
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Burn Rate");
	 raise Bad_Value;
      end if;
      --
      -- Assign our newly extracted value to the appropriate interface
      -- record field.
      --
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Burn_Rate
	:= OS_Data_Types.KILOGRAMS_PER_SECOND(Temp_Float);

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      --  field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Burn_Time, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Burn Time");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Burn_Time
	:= OS_Data_Types.SECONDS(Temp_Float);

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Azimuth_Detection_Angle field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Azimuth_Detection_Angle, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Azimuth Detection Angle");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.
	Azimuth_Detection_Angle := OS_Data_Types.DEGREES_CIRC(Temp_Float);

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Elevation_Detection_Angle field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Elevation_Detection_Angle, Temp_Float,
	  Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Elevation Detection Angle");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.
	Aerodynamic_Parameters.Elevation_Detection_Angle
	  := OS_Data_Types.DEGREES_CIRC(Temp_Float);

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Drag_Coefficient_n fields.
      --
      for Counter in OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range loop

	 Motif_Utilities.Get_Float_From_Text_Widget (
	   Ord_Parameters_Data.Aero.Drag_Coefficients(Counter),
	     Temp_Float, Success);
	 if (Success = False) then
	    Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	    Problem_Item  := new STRING'("Drag Coefficient"
	      & INTEGER'image(Counter));
	    raise Bad_Value;
	 end if;
	 Temp_Interface.General_Parameters.Aerodynamic_Parameters.
	   Drag_Coefficients(Counter)
	     := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      end loop;

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Frontal_Area field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Frontal_Area, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Frontal Area");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Frontal_Area
	:= Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- G_Gain field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.G_Gain, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("G Gain");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.G_Gain
	:= Numeric_Types.FLOAT_32_BIT(Temp_Float);
      -- -----

      --
      -- Extract the value from the Ordnance Aerodynamic Parameters panel
      -- Guidance option menu.
      --
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Guidance
	:= OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'val(
	  XOS.Guidance_Value);

      --
      -- Extract the value from the Ordnance Aerodynamic Parameters panel
      -- Illumination_Flag option menu.
      --
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.
	Illumination_Flag := OS_Data_Types.ILLUMINATION_IDENTIFIER'val(
	  XOS.Illumination_Flag_Value);

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Initial_Mass field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Initial_Mass, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Initial Mass");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Initial_Mass
	:= OS_Data_Types.KILOGRAMS(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Max_Gs field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Max_Gs, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Max Gs");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Max_Gs
	:= Numeric_Types.FLOAT_32_BIT(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Max_Speed field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Max_Speed, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Max Speed");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Max_Speed
	:= OS_Data_Types.METERS_PER_SECOND(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Thrust field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Aero.Thrust, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Thrust");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Thrust
	:= OS_Data_Types.NEWTONS(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Ordnance Aerodynamic panel
      -- Laser_Code field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Ord_Parameters_Data.Aero.Laser_Code, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Aerodynamic_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Laser Code");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Aerodynamic_Parameters.Laser_Code
	:= Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      --
      -- Tell the OS that the Ordnance Aerodynamic Parameters have changed.
      --
      --Temp_Interface.General_Parameters.Aerodynamic_Parameter_Change
      --  := True;

   else
      --
      -- Tell the OS that the Ordnance Aerodynamic Parameters have not changed.
      --
      --Temp_Interface.General_Parameters.Aerodynamic_Parameter_Change
      --  := False;
      null;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from Ordnance Termination Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Ord_Parameters_Data.Term.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Ordnance Termination Parameters panel
      -- Fuze option menu.
      --
      Temp_Interface.General_Parameters.Termination_Parameters.Fuze
	 := DIS_Types.A_FUZE_TYPE'val(XOS.Fuze_Value);

      -- -----
      -- Extract the value from the Ordnance Termination panel
      -- Fuze Detonation_Proximity field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Term.Fuze_Detonation_Proximity, Temp_Float,
	  Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Termination_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Fuze Detonation Proximity");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Termination_Parameters.
	Detonation_Proximity_Distance := OS_Data_Types.METERS_DP(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Ordnance Termination panel
      -- Fuze Height_Relative_To_Sea_Level_To_Detonate field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Term.Fuze_Height_Relative_To_Sea_Level_To_Detonate,
	  Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Termination_Parameters_Panel_Name);
	 Problem_Item  := new STRING'(
	   "Fuze Height Relative to Sea Level to Detonate");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Termination_Parameters.
	Height_Relative_to_Sea_Level_to_Detonate 
	  := OS_Data_Types.METERS_DP(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Ordnance Termination panel
      -- Fuze Time_To_Detonation field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Term.Fuze_Time_To_Detonation, Temp_Float,
	  Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Termination_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Fuze Time to Detonation");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Termination_Parameters.
	Time_to_Detonation := OS_Data_Types.SECONDS(Temp_Float);
      -- -----

      --
      -- Extract the value from the Ordnance Termination Parameters panel
      -- Warhead option menu.
      --
      Temp_Interface.General_Parameters.Termination_Parameters.Warhead
	 := DIS_Types.A_WARHEAD_TYPE'val(XOS.Warhead_Value);

      -- -----
      -- Extract the value from the Ordnance Termination panel
      -- Warhead Range_To_Damage field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Term.Warhead_Range_To_Damage, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Termination_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Warhead Range to Damage");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Termination_Parameters.
	Range_to_Damage := OS_Data_Types.METERS_DP(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Ordnance Termination panel
      -- Warhead Hard_Kill field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Ord_Parameters_Data.Term.Warhead_Hard_Kill, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Termination_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Warhead Hard Kill");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Termination_Parameters.
	Hard_Kill := OS_Data_Types.METERS_DP(Temp_Float);
      -- -----

      -- -----
      --
      -- Tell the OS that the Ordnance Termination Parameters have changed.
      --
      --Temp_Interface.General_Parameters.Termination_Parameter_Change
      --  := True;

   else
      --
      -- Tell the OS that the Ordnance Termination Parameters have not changed.
      --
      --Temp_Interface.General_Parameters.Termination_Parameter_Change
      --  := False;
      null;

   end if;


   -- --- -------------------------------------------------------------
   -- Extract data from Ordnance General Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Ord_Parameters_Data.Gen.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Ordnance General Parameters panel
      -- Dead_Reckoning_Algorithm option menu.
      --
      Temp_Interface.General_Parameters.Dead_Reckoning_Algorithm
	:= DIS_Types.A_DEAD_RECKONING_ALGORITHM'val(
	  XOS.Dead_Reckoning_Algorithm_Value);

      --
      -- Extract the value from the Ordnance General Parameters panel
      -- Entity_Type Entity_Kind option menu.
      --
      Temp_Interface.General_Parameters.Entity_Type.Entity_Kind
	:= DIS_Types.AN_ENTITY_KIND'val(XOS.Entity_Kind_Value);

      -- -----
      -- Extract the value from the Ordnance General panel
      -- Entity_Type_Domain field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Ord_Parameters_Data.Gen.Domain, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_General_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity Type Domain");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Type.Domain
	:= NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      --
      -- Extract the value from the Ordnance General Parameters panel
      -- Entity_Type Country widget`
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Gen.Country, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_General_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Type Country");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Type.Country
        := DIS_Types.A_COUNTRY_ID'val(Temp_Integer);

      -- -----
      -- Extract the value from the Ordnance General panel
      -- Entity_Type Category field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Ord_Parameters_Data.Gen.Category, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_General_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity Type Category");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Type.Category
	:= NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ordnance General panel
      -- Entity_Type Subcategory field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Ord_Parameters_Data.Gen.Subcategory, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_General_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity Type Subcategory");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Type.Subcategory
	:= NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ordnance General panel
      -- Entity_Type Specific field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Ord_Parameters_Data.Gen.Specific, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_General_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity Type Specific");
	 raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Type.Specific
	:= NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      --
      -- Extract the value from the Ordnance General Parameters panel
      -- Fly_Out_Model_ID option menu.
      --
      Temp_Interface.General_Parameters.Fly_Out_Model_ID
	:= OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'val(
	  XOS.Fly_Out_Model_ID_Value);

      -- -----
      --
      -- Tell the OS that the Ordnance General Parameters have changed.
      --
      --Temp_Interface.General_Parameters.General_Parameter_Change
      --  := True;

   else
      --
      -- Tell the OS that the Ordnance General Parameters have not changed.
      --
      --Temp_Interface.General_Parameters.General_Parameter_Change
      --  := False;
      null;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from Ordnance Emitter Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Ord_Parameters_Data.Emitter.Shell /= Xt.XNULL) then

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Emitter_Name field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Emitter_Name, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Emitter Name");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
        Emitter_System.Emitter_Name
          := DIS_Types.AN_EMITTER_SYSTEM'val(Temp_Integer);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Emitter_Function field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Emitter_Function, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Emitter Function");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
        Emitter_System.Emitter_Function
          := DIS_Types.AN_EMISSION_FUNCTION'val(Temp_Integer);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Emitter_ID field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Emitter_ID, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Emitter ID");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
        Emitter_System.Emitter_ID
          := Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Location_X field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Location_X, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Location X");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.Location.X
        := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Location_Y field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Location_Y, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Location Y");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.Location.Y
        := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Location_Z field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Location_Z, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Location Z");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.Location.Z
        := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Frequency field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Frequency, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Frequency");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.Frequency
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Frequency_Range field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Frequency_Range, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Frequency Range");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.Frequency_Range
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- ERP field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.ERP, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("ERP");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.ERP
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- PRF field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.PRF, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("PRF");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.PRF
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Pulse_Width field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Pulse_Width, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Pulse Width");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.Pulse_Width
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Beam_Azimuth_Center field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Beam_Azimuth_Center, Temp_Float,
	  Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Beam Azimuth Center");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.Beam_Azimuth_Center
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Beam_Elevation_Center field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Beam_Elevation_Center, Temp_Float,
	  Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Beam Elevation Center");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.Beam_Elevation_Center
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Beam_Sweep_Sync field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Beam_Sweep_Sync, Temp_Float, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Beam Sweep Sync");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.
	Fundamental_Parameter_Data.Beam_Sweep_Sync
          := Numeric_Types.FLOAT_32_BIT(Temp_Float);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Beam_Parameter_Index field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Beam_Parameter_Index, Temp_Integer,
	  Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Beam Parameter Index");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.Beam_Data.
	Beam_Parameter_Index
          := Numeric_Types.UNSIGNED_16_BIT(Temp_Integer);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Beam_Function field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Beam_Function, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Beam Function");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.Beam_Data.
	Beam_Function
          := Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- High_Density_Track_Jam field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Emitter.High_Density_Track_Jam, Temp_Integer,
	  Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("High Density Track Jam");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.Beam_Data.
	High_Density_Track_Jam
          := Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);

      -- -----
      -- Extract the value from the Ord Emitter panel
      -- Jamming_Mode_Sequence field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Emitter.Jamming_Mode_Sequence, Temp_Integer,
	  Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Emitter_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Jamming Mode Sequence");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Emitter_Parameters.Beam_Data.
	Jamming_Mode_Sequence
          := Numeric_Types.UNSIGNED_32_BIT(Temp_Integer);


      --
      -- Tell the OS that the Ord Emitter Parameters have changed.
      --
      --Temp_Interface.Emitter_Parameters.Emitter_Parameter_Change
      --  := True;

   else
      --
      -- Tell the OS that the Ord Emitter Parameters have not changed.
      --
      --Temp_Interface.Emitter_Parameters.Emitter_Parameter_Change
      --  := False;
      null;

   end if;


   -- --- -------------------------------------------------------------
   -- Extract data from Ordnance Entity Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Ord_Parameters_Data.Entity.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Ord General Parameters panel
      -- Alternate_Entity_Type Entity_Kind option menu.
      --
      Temp_Interface.General_Parameters.Alternate_Entity_Type.Entity_Kind
        := DIS_Types.AN_ENTITY_KIND'val(XOS.Entity_Kind_Value);

      -- -----
      -- Extract the value from the Ord General panel
      -- Alternate_Entity_Type Domain field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Domain, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Alternate_Entity_Type.Domain
        := NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      --
      -- Extract the value from the Ord General Parameters panel
      -- Alternate_Entity_Type Country widget.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Country, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Type Country");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Alternate_Entity_Type.Country
        := DIS_Types.A_COUNTRY_ID'val(Temp_Integer);

      -- -----
      -- Extract the value from the Ord General panel
      -- Alternate_Entity_Type Category field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Category, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Type Category");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Alternate_Entity_Type.Category
        := NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Alternate_Entity_Type Subcategory field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Subcategory, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Type Subcategory");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Alternate_Entity_Type.Subcategory
        := NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Alternate_Entity_Type Specific field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Specific, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Type Specific");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Alternate_Entity_Type.Specific
        := NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Alternate_Entity_Type Extra field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Extra, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Type Extra");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Alternate_Entity_Type.Extra
        := NUMERIC_TYPES.UNSIGNED_8_BIT(Temp_Integer);
      -- -----

      --
      -- Extract the value from the General Parameters panel
      -- Alternate Entity Capabilities field.
      --
      APPLY_CAPABILITIES_BLOCK:
      declare
	 Capabilities_Array_Index : INTEGER;
      begin
	 --
	 -- Initialize the Alternate Entity Capabilities array to false
	 --
	 INITIALIZE_CAPABILITIES_ARRAY:
	 for Capabilities_Index in 
	   DIS_Types.AN_ENTITY_CAPABILITIES_RECORD'range loop

	    Temp_Interface.General_Parameters.Capabilities(Capabilities_Index)
	      := NUMERIC_TYPES.UNSIGNED_1_BIT(BOOLEAN'pos(FALSE));

	 end loop INITIALIZE_CAPABILITIES_ARRAY;

	 --
	 -- Set the Alternate Entity Capabilities array to match the value
	 -- of the bit string in the Alternate Entity Capabilities text widget.
	 --
	 Temp_Text := Xm.TextfieldGetString (Ord_Parameters_Data.Entity.
	   Capabilities);
	 Capabilities_Array_Index
	   := DIS_Types.AN_ENTITY_CAPABILITIES_RECORD'last;

	 ASSIGN_CAPABILITIES_ARRAY:
	 for Capabilities_Bit_String_Index in reverse Temp_Text'range loop
	    if Temp_Text(Capabilities_Bit_String_Index) = '0' then
	       Temp_Interface.General_Parameters.Capabilities(
		 Capabilities_Array_Index) 
		   := NUMERIC_TYPES.UNSIGNED_1_BIT(BOOLEAN'pos(FALSE));
	    else
	       Temp_Interface.General_Parameters.Capabilities(
		 Capabilities_Array_Index)
		   := NUMERIC_TYPES.UNSIGNED_1_BIT(BOOLEAN'pos(TRUE));
	    end if;
	    Capabilities_Array_Index := Capabilities_Array_Index -1;
	 end loop ASSIGN_CAPABILITIES_ARRAY;

	 --
	 -- Don't free this (as you normally would), because Verdix Ada
	 -- corrupts memory when you do...
	 --
	 --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Temp_Text));

      exception
	 when OTHERS =>
            Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
            Problem_Item  := new STRING'("Entity Capabilities");
            raise Bad_Value;
      end APPLY_CAPABILITIES_BLOCK;


      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Paint field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Paint, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Paint");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Paint
        := DIS_Types.A_PAINT_SCHEME'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Mobility field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Mobility, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Mobility");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Mobility
        := DIS_Types.A_MOBILITY_KILL'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Fire_Power field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Fire_Power, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Fire_Power");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Fire_Power
        := DIS_Types.A_FIRE_POWER_KILL'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Damage field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Damage, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Damage");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Damage
        := DIS_Types.A_DAMAGE_LEVEL'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Smoke field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Smoke, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Smoke");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Smoke
        := DIS_Types.A_SMOKE_EFFECT'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Trailing field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Trailing, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Trailing");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Trailing
        := DIS_Types.A_TRAILING_EFFECT'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Hatch field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Hatch, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Hatch");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Hatch
        := DIS_Types.A_HATCH_STATE'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Lights field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Lights, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Lights");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Lights
        := DIS_Types.A_LIGHT_STATUS'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General Flaming field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Flaming, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/General/Flaming");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.General.Flaming
        := DIS_Types.A_FLAME_STATUS'val(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Appearance General EA_Specific field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Ord_Parameters_Data.Entity.Specific, Temp_Integer, Success);
      if (Success = False) then
         Problem_Panel := new STRING'(K_Entity_Parameters_Panel_Name);
         Problem_Item  := new STRING'("Entity Appearance/Specific");
         raise Bad_Value;
      end if;
      Temp_Interface.General_Parameters.Entity_Appearance.Specific
        := Numeric_Types.UNSIGNED_16_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Ord General panel
      -- Entity_Marking field.
      --
      Temp_Interface.General_Parameters.Entity_Marking.Character_Set
	:= DIS_Types.ASCII;

      INITIALIZE_ENTITY_MARKING_BLOCK:
      declare
	 Marking_Initialization_Character : CHARACTER := ASCII.nul;
      begin
	 for Marking_Index in DIS_Types.A_MARKING_SET'range loop
	    Temp_Interface.General_Parameters.Entity_Marking.Text(
	      Marking_Index) := Numeric_Types.UNSIGNED_8_BIT(
		CHARACTER'pos(Marking_Initialization_Character));
	 end loop;
      end INITIALIZE_ENTITY_MARKING_BLOCK;

      ASSIGN_ENTITY_MARKING_BLOCK:
      declare
      begin
	 Temp_Text := Xm.TextfieldGetString (Ord_Parameters_Data.Entity.
	   Entity_Marking);
         for Marking_Index in Temp_Text'range loop
	     Temp_Interface.General_Parameters.Entity_Marking.Text(
	       Marking_Index) := Numeric_Types.UNSIGNED_8_BIT(CHARACTER'pos(
		 Temp_Text(Marking_Index)));
	 end loop;

	 --
	 -- Don't free this (as you normally would), because Verdix Ada
	 -- corrupts memory when you do...
	 --
	 --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Temp_Text));

      end ASSIGN_ENTITY_MARKING_BLOCK;


      --
      -- Tell the OS that the Ord Entity Parameters have changed.
      --
      --Temp_Interface.Entity_Parameters.Entity_Parameter_Change
      --  := True;

   else
      --
      -- Tell the OS that the Ord Entity Parameters have not changed.
      --
      --Temp_Interface.Entity_Parameters.Entity_Parameter_Change
      --  := False;
      null;

   end if;

   --
   -- Write out changed values into shared memory.
   --
   OS_GUI.Interface.all := Temp_Interface;

   OS_GUI.Interface.Ordnance_Display.Command
      := OS_GUI.APPLY;
  
   Ord_Update_Previous_Next_Buttons(Ord_Parameters_Data);


   --
   -- If Problem_Panel and/or Problem_Item strings are non-NULL
   -- then free them.
   --
   if (not Utilities."="(Problem_Panel, NULL)) then
      Free (Problem_Item);
   end if;
   if (not Utilities."="(Problem_Item, NULL)) then
      Free (Problem_Panel);
   end if;

exception
   
   --
   -- This user-defined exception occurs if the functions to get integers
   -- or floats from text widgets return a failure status. This will occur
   -- if the format is invalid (though this should not be the case with the
   -- modifyVerifyCallback installed) or if a field is completely blank.
   --
   when Bad_Value =>
      --
      -- If Problem_Panel and/or Problem_Item strings are NULL,
      -- assign them default values.
      --
      if (Utilities."="(Problem_Panel, NULL)) then
	 Problem_Panel := new STRING'("UNKNOWN PANEL");
      end if;
      if (Utilities."="(Problem_Item, NULL)) then
	 Problem_Item := new STRING'("UNKNOWN ITEM");
      end if;

      --
      -- Build the Problem_Message string, which will inform the user
      -- as to the location of the problem.
      --
      Problem_Message := new STRING'(
	"There was a problem with field `" & Problem_Item.all & "'" & ASCII.LF
	  & "in panel `" & Problem_Panel.all & "'." & ASCII.LF 
	    & "(Note: Empty fields are invalid...)" & ASCII.LF
	      & "Apply aborted" & ASCII.LF & ASCII.LF
	        & "Please enter a valid value in this field and re-Apply.");

      --
      -- Free memory as appropriate
      --
      Free (Problem_Item);
      Free (Problem_Panel);

      --
      -- Display a modal dialog telling the user that there was a
      -- problem via the string Problem_Message created above.
      --
      Temp_Char := Motif_Utilities.Prompt_User(
	Parent        => Motif_Utilities.Get_Shell(Parent),
	Dialog_Type   => Xm.DIALOG_WARNING,
        Title         => "XOS Apply Problem",
	Prompt_String => Problem_Message.all,
	Choice1       => "",
	Mnemonic1     => ASCII.NUL,
	Choice2       => " OK ",
	Mnemonic2     => 'O',
	Choice3       => "",
	Mnemonic3     => ASCII.NUL);

      --
      -- Free memory as appropriate
      --
      Free (Problem_Message);

   --
   -- This is to catch all non-user-defined exceptions
   -- (i.e., if an float with an invalid format was somehow input)
   --
   when OTHERS =>
      --
      -- Display a modal dialog telling the user that there was an
      -- unknown problem and suggest rechecking all data...
      --
      Temp_Char := Motif_Utilities.Prompt_User(
	Parent        => Motif_Utilities.Get_Shell(Parent),
	Dialog_Type   => Xm.DIALOG_WARNING,
        Title         => "XOS Apply Problem",
	Prompt_String => 
	  "An unknown problem has occurred with this Apply request."
	    & ASCII.LF & "Apply aborted" & ASCII.LF & ASCII.LF
	      & "Please check all data and try again...",
	Choice1       => "",
	Mnemonic1     => ASCII.NUL,
	Choice2       => " OK ",
	Mnemonic2     => 'O',
	Choice3       => "",
	Mnemonic3     => ASCII.NUL);

end Ord_Apply_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/08/94   D. Forrest
--      - Initial version
--
-- --

