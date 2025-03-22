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
with DIS_Types;
with Motif_Utilities;
with Numeric_Types;
with Text_IO;
with Unchecked_Conversion;
with Unchecked_Deallocation;
with Utilities;
with XDG_Server_Types;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Apply_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   July 22, 1994
--
-- PURPOSE:
--   This procedure writes all changed values in all Set Parameters
--   panels to shared memory.
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
procedure Apply_CB (
   Parent              : in     Xt.WIDGET;
   Set_Parameters_Data : in out XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Declare panel name constant strings
   --
   K_Network_Parameters_Panel_Name  : constant STRING := "Network Parameters";
   K_Threshold_Parameters_Panel_Name: constant STRING := "Threshold Parameters";
   K_DG_Parameters_Panel_Name       : constant STRING := "DG Parameters";
   K_PDU_Filters_Panel_Name         : constant STRING := "PDU Filters";
   K_Specific_Filters_Panel_Name    : constant STRING := "Specific Filters";
   K_Error_Parameters_Panel_Name    : constant STRING := "Error Parameters";
   K_Hash_Parameters_Panel_Name     : constant STRING := "Hash Parameters";
   K_Exercise_Parameters_Panel_Name : constant STRING := "Exercise Parameters";

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

   Temp_Interface  : DG_Server_GUI.INTERFACE_TYPE;

   --
   -- Local exceptions
   --
   Bad_Value : EXCEPTION;

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

   -- --- -------------------------------------------------------------
   -- Initialize our local Temp_Interface to the values in shared memory.
   -- --- -------------------------------------------------------------
   Temp_Interface := DG_Server_GUI.Interface.all;

   -- --- -------------------------------------------------------------
   -- Extract data from Network Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.Network.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Network panel UDP_Port field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Network.UDP_Port,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      --
      -- If Get_Integer_From_Text_Widget fails, raise the Bad_Value exception.
      --
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Network_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("UDP Port");
	 raise Bad_Value;
      end if;
      --
      -- Assign our newly extracted value to the appropriate interface
      -- record field.
      --
      Temp_Interface.Network_Parameters.UDP_Port
	:= Numeric_Types.UNSIGNED_16_BIT(Temp_Integer);

      --
      -- Extract the value from the Network panel Destination_Address_Quad_1
      -- field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Network.Destination_Address_Quad_1,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Network_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Destination Address (1)");
	 raise Bad_Value;
      end if;
      Temp_Interface.Network_Parameters.Broadcast_IP_Address(1)
	:= Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);

      --
      -- Extract the value from the Network panel Destination_Address_Quad_2
      -- field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Network.Destination_Address_Quad_2,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Network_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Destination Address (2)");
	 raise Bad_Value;
      end if;
      Temp_Interface.Network_Parameters.Broadcast_IP_Address(2)
	:= Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);

      --
      -- Extract the value from the Network panel Destination_Address_Quad_3
      -- field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Network.Destination_Address_Quad_3,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Network_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Destination Address (3)");
	 raise Bad_Value;
      end if;
      Temp_Interface.Network_Parameters.Broadcast_IP_Address(3)
	:= Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);

      --
      -- Extract the value from the Network panel Destination_Address_Quad_4
      -- field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Network.Destination_Address_Quad_4,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Network_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Destination Address (4)");
	 raise Bad_Value;
      end if;
      Temp_Interface.Network_Parameters.Broadcast_IP_Address(4)
	:= Numeric_Types.UNSIGNED_8_BIT(Temp_Integer);

      --
      -- Extract the value from the Network panel Data Reception option menu.
      --
      Temp_Interface.Network_Parameters.Data_Reception_Enabled
	:= XDG_Server.Network_Data_Reception_Flag;

      --
      -- Extract the value from the Network panel Data Transmission option menu.
      --
      Temp_Interface.Network_Parameters.Data_Transmission_Enabled
	:= XDG_Server.Network_Data_Transmission_Flag;

      Temp_Interface.Network_Parameter_Change := True;

   else

      Temp_Interface.Network_Parameter_Change := False;

   end if;


   -- --- -------------------------------------------------------------
   -- Extract data from Threshold Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.Threshold.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Threshold panel Distance field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Distance,
	 Return_Value => Temp_Float,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Distance");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Distance
	:= Numeric_Types.FLOAT_32_BIT(Temp_Float);

      --
      -- Extract the value from the Threshold panel Orientation field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Orientation,
	 Return_Value => Temp_Float,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Orientation");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Orientation
	:= Numeric_Types.FLOAT_32_BIT(Temp_Float);

      --
      -- Extract the value from the Threshold panel Entity_Update field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Entity_Update,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity Update");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Entity_Update
	:= INTEGER(Temp_Integer);

      --
      -- Extract the value from the Threshold panel Entity_Expiration field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Entity_Expiration,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity Expiration");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Entity_Expiration
	:= INTEGER(Temp_Integer);

      --
      -- Extract the value from the Threshold panel Emission_Update field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Emission_Update,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Emission Update");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Emission_Update
	:= INTEGER(Temp_Integer);

      --
      -- Extract the value from the Threshold panel Laser_Update field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Laser_Update,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Laser Update");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Laser_Update
	:= INTEGER(Temp_Integer);

      --
      -- Extract the value from the Threshold panel Transmitter_Update field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Transmitter_Update,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Transmitter Update");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Transmitter_Update
	:= INTEGER(Temp_Integer);

      --
      -- Extract the value from the Threshold panel Receiver_Update field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Threshold.Receiver_Update,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Threshold_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Receiver Update");
	 raise Bad_Value;
      end if;
      Temp_Interface.Threshold_Parameters.Receiver_Update
	:= INTEGER(Temp_Integer);

      Temp_Interface.Threshold_Parameter_Change := True;

   else

      Temp_Interface.Threshold_Parameter_Change := False;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from PDU Filters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.PDU_Filters.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the PDU Filter option menus.
      --
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ENTITY_STATE) := XDG_Server.Entity_State_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.FIRE) := XDG_Server.Fire_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.DETONATION) := XDG_Server.Detonation_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.COLLISION) := XDG_Server.Collision_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.SERVICE_REQUEST) := XDG_Server.Service_Request_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RESUPPLY_OFFER) := XDG_Server.Resupply_Offer_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RESUPPLY_RECEIVED)
	  := XDG_Server.Resupply_Received_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RESUPPLY_CANCEL)
	  := XDG_Server.Resupply_Cancelled_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.REPAIR_COMPLETE) := XDG_Server.Repair_Complete_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.REPAIR_RESPONSE) := XDG_Server.Repair_Response_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.CREATE_ENTITY) := XDG_Server.Create_Entity_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.REMOVE_ENTITY) := XDG_Server.Remove_Entity_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.START_OR_RESUME) := XDG_Server.Start_Resume_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.STOP_OR_FREEZE) := XDG_Server.Stop_Freeze_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ACKNOWLEDGE) := XDG_Server.Acknowledge_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ACTION_REQUEST) := XDG_Server.Action_Request_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ACTION_RESPONSE) := XDG_Server.Action_Response_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.DATA_QUERY) := XDG_Server.Data_Query_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.SET_DATA) := XDG_Server.Set_Data_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.DATA) := XDG_Server.Data_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.EVENT_REPORT) := XDG_Server.Event_Report_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.MESSAGE) := XDG_Server.Message_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.EMISSION) := XDG_Server.Emission_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.LASER) := XDG_Server.Laser_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.TRANSMITTER) := XDG_Server.Transmitter_Flag;
      Temp_Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RECEIVER) := XDG_Server.Receiver_Flag;

      Temp_Interface.Filter_Parameter_Change := True;

   else

      Temp_Interface.Filter_Parameter_Change := False;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from Specific Filters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.Specific_Filters.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Specific Filter option menus.
      --
      Temp_Interface.Filter_Parameters.Keep_Exercise_ID
	:= XDG_Server.Keep_Exercise_ID_Flag;
      Temp_Interface.Filter_Parameters.Keep_Other_Force
	:= XDG_Server.Keep_Force_ID_Other_Flag;
      Temp_Interface.Filter_Parameters.Keep_Friendly_Force
	:= XDG_Server.Keep_Force_ID_Friendly_Flag;
      Temp_Interface.Filter_Parameters.Keep_Opposing_Force
	:= XDG_Server.Keep_Force_ID_Opposing_Flag;
      Temp_Interface.Filter_Parameters.Keep_Neutral_Force
	:= XDG_Server.Keep_Force_ID_Neutral_Flag;

      --
      -- Extract the value from the Specific Filters panel Exercise ID field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  =>
	   Set_Parameters_Data.Specific_Filters.Keep_Exercise_ID_Value,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Specific_Filters_Panel_Name);
	 Problem_Item  := new STRING'("Exercise ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Filter_Parameters.Exercise_ID
	:= DIS_Types.AN_EXERCISE_IDENTIFIER(Temp_Integer);

      Temp_Interface.Filter_Parameter_Change := True;

   else

      Temp_Interface.Filter_Parameter_Change := False;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from DG Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.DG_Parameters.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the DG Parameters panel Timeslice field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.DG_Parameters.Timeslice,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_DG_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Timeslice");
	 raise Bad_Value;
      end if;
      Temp_Interface.Timeslice := Temp_Integer;

      --
      -- Extract the value from the DG Parameters panel Max_Entities field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  =>
	   Set_Parameters_Data.DG_Parameters.Max_Entities,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_DG_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Maximum Number of Entities");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Data_Parameters.Maximum_Entities
	:= Temp_Integer;

      --
      -- Extract the value from the DG Parameters panel Max_Emitters field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  =>
	   Set_Parameters_Data.DG_Parameters.Max_Emitters,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_DG_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Maximum Number of Emitters");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Data_Parameters.Maximum_Emitters
	:= Temp_Integer;

      --
      -- Extract the value from the DG Parameters panel Max_Lasers field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  =>
	   Set_Parameters_Data.DG_Parameters.Max_Lasers,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_DG_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Maximum Number of Lasers");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Data_Parameters.Maximum_Lasers
	:= Temp_Integer;

      --
      -- Extract the value from the DG Parameters panel Max_Transmitters field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  =>
	   Set_Parameters_Data.DG_Parameters.Max_Transmitters,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_DG_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Maximum Number of Transmitters");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Data_Parameters.Maximum_Transmitters
	:= Temp_Integer;

      --
      -- Extract the value from the DG Parameters panel Max_Receivers field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  =>
	   Set_Parameters_Data.DG_Parameters.Max_Receivers,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_DG_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Maximum Number of Receivers");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Data_Parameters.Maximum_Receivers
	:= Temp_Integer;

      --
      -- Extract the value from the DG Parameters panel PDU_Buffer_Size field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  =>
	   Set_Parameters_Data.DG_Parameters.PDU_Buffer_Size,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_DG_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("PDU Buffer Size");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Data_Parameters.PDU_Buffer_Size
	:= Temp_Integer;

      Temp_Interface.Simulation_Data_Parameter_Change := True;

   else

      Temp_Interface.Simulation_Data_Parameter_Change := False;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from Error Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.Error.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Error Parameters
      -- GUI_Error_Reporting option menu.
      --
      Temp_Interface.Error_Parameters.Error_Monitor_Enabled
        := XDG_Server.GUI_Error_Reporting_Flag;

      --
      -- Extract the value from the Error Parameters
      -- Error_Logging option menu.
      --
      Temp_Interface.Error_Parameters.Error_Log_Enabled
        := XDG_Server.Error_Logging_Flag;

      --
      -- Extract the value from the Error Parameters panel
      -- Error_Logfile field.
      --
      Temp_Text := Xm.TextfieldGetString (Set_Parameters_Data.Error.
	Error_Logfile);

      if (Utilities.Length_Of_String(Temp_Text.all) = 0) then

	 Temp_Interface.Error_Parameters.Error_Log_File.Name
	   := (OTHERS => ASCII.NUL);
	 Temp_Interface.Error_Parameters.Error_Log_File.Length := 0;

      elsif (Temp_Text'length < 80) then

	 Utilities.Strip_Spaces(Temp_Text.all);
	 Temp_Interface.Error_Parameters.Error_Log_File.Name(
	   Temp_Interface.Error_Parameters.Error_Log_File.Name'first..
	     Temp_Interface.Error_Parameters.Error_Log_File.Name'first
	       + Temp_Text'length - 1) := Temp_Text.all;
	 Temp_Interface.Error_Parameters.Error_Log_File.Length :=
	   Utilities.Length_Of_String (Temp_Text.all);

      else -- Temp_Text'length >= 80

	 Utilities.Strip_Spaces(Temp_Text.all);
	 Temp_Interface.Error_Parameters.Error_Log_File.Name :=
	   Temp_Text(Temp_Text'first..Temp_Text'first
	     + Temp_Interface.Error_Parameters.Error_Log_File.Name'length - 1);
         Temp_Interface.Error_Parameters.Error_Log_File.Length :=
	   Temp_Interface.Error_Parameters.Error_Log_File.Name'length;

      end if;

      --
      -- Don't free this (as you normally would), because Verdix Ada
      -- corrupts memory when you do...
      --
      --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Temp_Text));

      Temp_Interface.Error_Parameter_Change := True;

   else

      Temp_Interface.Error_Parameter_Change := False;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from Hash Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.Hash.Shell /= Xt.XNULL) then

      -- --------------------------------------------
      -- Extract data from the Hash Parameters panel Entity PDU fields.
      -- --------------------------------------------
      --
      -- Extract the value from the Hash Parameters panel
      -- Entity PDU Rehash_Increment field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.ENTITY).Rehash_Increment,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity PDU Rehash Increment");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Entity_Hash_Table.
	Index_Increment := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Entity PDU Site_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.ENTITY).Site_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity PDU Site Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Entity_Hash_Table.
	Site_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Entity PDU Application_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.ENTITY).Application_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity PDU Application_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Entity_Hash_Table.
	Application_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Entity PDU Entity_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.ENTITY).Entity_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Entity PDU Entity_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Entity_Hash_Table.
	Entity_Multiplier := Temp_Integer;

      -- --------------------------------------------
      -- Extract data from the Hash Parameters panel Emitter PDU fields.
      -- --------------------------------------------
      --
      -- Extract the value from the Hash Parameters panel
      -- Emitter PDU Rehash_Increment field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.EMITTER).Rehash_Increment,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Emitter PDU Rehash Increment");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Emission_Hash_Table.
	Index_Increment := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Emitter PDU Site_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.EMITTER).Site_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Emitter PDU Site Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Emission_Hash_Table.
	Site_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Emitter PDU Application_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.EMITTER).Application_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Emitter PDU Application_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Emission_Hash_Table.
	Application_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Emitter PDU Entity_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.EMITTER).Entity_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Emitter PDU Entity_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Emission_Hash_Table.
	Entity_Multiplier := Temp_Integer;


      -- --------------------------------------------
      -- Extract data from the Hash Parameters panel Laser PDU fields.
      -- --------------------------------------------
      --
      -- Extract the value from the Hash Parameters panel
      -- Laser PDU Rehash_Increment field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.LASER).Rehash_Increment,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Laser PDU Rehash Increment");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Laser_Hash_Table.
	Index_Increment := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Laser PDU Site_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.LASER).Site_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Laser PDU Site Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Laser_Hash_Table.
	Site_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Laser PDU Application_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.LASER).Application_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Laser PDU Application_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Laser_Hash_Table.
	Application_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Laser PDU Entity_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.LASER).Entity_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Laser PDU Entity_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Laser_Hash_Table.
	Entity_Multiplier := Temp_Integer;

      -- --------------------------------------------
      -- Extract data from the Hash Parameters panel Transmitter PDU fields.
      -- --------------------------------------------
      --
      -- Extract the value from the Hash Parameters panel
      -- Transmitter PDU Rehash_Increment field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.TRANSMITTER).Rehash_Increment,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Transmitter PDU Rehash Increment");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Transmitter_Hash_Table.
	Index_Increment := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Transmitter PDU Site_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.TRANSMITTER).Site_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Transmitter PDU Site Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Transmitter_Hash_Table.
	Site_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Transmitter PDU Application_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.TRANSMITTER).Application_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Transmitter PDU Application_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Transmitter_Hash_Table.
	Application_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Transmitter PDU Entity_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.TRANSMITTER).Entity_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Transmitter PDU Entity_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Transmitter_Hash_Table.
	Entity_Multiplier := Temp_Integer;


      -- --------------------------------------------
      -- Extract data from the Hash Parameters panel Receiver PDU fields.
      -- --------------------------------------------
      --
      -- Extract the value from the Hash Parameters panel
      -- Receiver PDU Rehash_Increment field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.RECEIVER).Rehash_Increment,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Receiver PDU Rehash Increment");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Receiver_Hash_Table.
	Index_Increment := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Receiver PDU Site_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.RECEIVER).Site_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Receiver PDU Site Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Receiver_Hash_Table.
	Site_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Receiver PDU Application_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.RECEIVER).Application_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Receiver PDU Application_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Receiver_Hash_Table.
	Application_Multiplier := Temp_Integer;

      --
      -- Extract the value from the Hash Parameters panel
      -- Receiver PDU Entity_Multiplier field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Hash.PDU(
	   XDG_Server_Types.RECEIVER).Entity_Multiplier,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Hash_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Receiver PDU Entity_Multiplier");
	 raise Bad_Value;
      end if;
      Temp_Interface.Hash_Parameters.Receiver_Hash_Table.
	Entity_Multiplier := Temp_Integer;

      Temp_Interface.Hash_Parameter_Change := True;

   else

      Temp_Interface.Hash_Parameter_Change := False;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from Exercise Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.Exercise.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Exercise Parameters panel
      -- Automatic_Exercise_ID option menu.
      --
      Temp_Interface.Exercise_Parameters.Set_Exercise_ID
        := XDG_Server.Automatic_Exercise_ID_Flag;

      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Exercise.Exercise_ID,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Exercise_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Exercise ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Exercise_Parameters.Exercise_ID
	:= DIS_Types.AN_EXERCISE_IDENTIFIER(Temp_Integer);

      --
      -- Extract the value from the Exercise Parameters panel
      -- Automatic_Site_ID option menu.
      --
      Temp_Interface.Exercise_Parameters.Set_Site_ID
        := XDG_Server.Automatic_Site_ID_Flag;

      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Exercise.Site_ID,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Exercise_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Site ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Exercise_Parameters.Site_ID
	:= Numeric_Types.UNSIGNED_16_BIT(Temp_Integer);

      --
      -- Extract the value from the Exercise Parameters 
      -- Automatic Timestamp option menu.
      --
      Temp_Interface.Exercise_Parameters.Automatic_Timestamp
        := XDG_Server.Automatic_Timestamp_Flag;

      --
      -- Extract the value from the Exercise Parameters 
      -- I/ITSEC Bit 23 Support option menu.
      --
      --Temp_Interface.Exercise_Parameters.IITSEC_Bit_23_Support
      --  := XDG_Server.IITSEC_Bit_23_Support_Flag;

      --
      -- Extract the value from the Exercise Parameters panel
      -- Experimental_PDUs option menu.
      --
      Temp_Interface.Exercise_Parameters.Experimental_PDU_Support
        := XDG_Server.Experimental_PDUs_Flag;


      Temp_Interface.Exercise_Parameter_Change := True;

   else

      Temp_Interface.Exercise_Parameter_Change := False;

   end if;

   --
   -- Assign our newly read values to the real Temp_Interface.
   --
   DG_Server_GUI.Interface.all := Temp_Interface;

   --
   -- Tell DG Server to Start Server
   --
   DG_Server_GUI.Interface.Start_Server := True;

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
        Title         => "XDG Server Apply Problem",
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
        Title         => "XDG Server Apply Problem",
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

end Apply_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   07/22/94   D. Forrest
--      - Initial version
--
-- --

