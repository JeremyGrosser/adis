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
with DIS_Types;
with Motif_Utilities;
with Numeric_Types;
with Text_IO;
with Unchecked_Conversion;
with Unchecked_Deallocation;
with Utilities;
with XDG_Client_Types;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XDG_Client)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Apply_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12, 1994
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
   Set_Parameters_Data : in out XDG_Client_Types.XDG_SET_PARM_DATA_REC_PTR;
   Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Declare panel name constant strings
   --
   K_DG_Parameters_Panel_Name       : constant STRING := "DG Parameters";
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

   Temp_Interface  : DG_Client_GUI.INTERFACE_TYPE;

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
   Temp_Interface := DG_Client_Gui.Interface.all;

   -- --- -------------------------------------------------------------
   -- Extract data from DG Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.DG_Parameters.Shell /= Xt.XNULL) then

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
        := XDG_Client.GUI_Error_Reporting_Flag;

      --
      -- Extract the value from the Error Parameters
      -- Error_Logging option menu.
      --
      Temp_Interface.Error_Parameters.Error_Log_Enabled
        := XDG_Client.Error_Logging_Flag;

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

      else

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
	   XDG_Client_Types.ENTITY).Rehash_Increment,
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
	   XDG_Client_Types.ENTITY).Site_Multiplier,
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
	   XDG_Client_Types.ENTITY).Application_Multiplier,
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
	   XDG_Client_Types.ENTITY).Entity_Multiplier,
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
	   XDG_Client_Types.EMITTER).Rehash_Increment,
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
	   XDG_Client_Types.EMITTER).Site_Multiplier,
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
	   XDG_Client_Types.EMITTER).Application_Multiplier,
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
	   XDG_Client_Types.EMITTER).Entity_Multiplier,
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
	   XDG_Client_Types.LASER).Rehash_Increment,
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
	   XDG_Client_Types.LASER).Site_Multiplier,
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
	   XDG_Client_Types.LASER).Application_Multiplier,
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
	   XDG_Client_Types.LASER).Entity_Multiplier,
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
	   XDG_Client_Types.TRANSMITTER).Rehash_Increment,
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
	   XDG_Client_Types.TRANSMITTER).Site_Multiplier,
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
	   XDG_Client_Types.TRANSMITTER).Application_Multiplier,
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
	   XDG_Client_Types.TRANSMITTER).Entity_Multiplier,
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
	   XDG_Client_Types.RECEIVER).Rehash_Increment,
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
	   XDG_Client_Types.RECEIVER).Site_Multiplier,
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
	   XDG_Client_Types.RECEIVER).Application_Multiplier,
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
	   XDG_Client_Types.RECEIVER).Entity_Multiplier,
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
      -- Automatic_Application_ID option menu.
      --
      Temp_Interface.Exercise_Parameters.Set_Application_ID
        := XDG_Client.Automatic_Application_ID_Flag;

      --
      -- Extract the value from the Exercise Parameters panel
      -- Application_ID field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	 Text_Widget  => Set_Parameters_Data.Exercise.Application_ID,
	 Return_Value => Temp_Integer,
	 Success      => Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Exercise_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Application ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Exercise_Parameters.Application_ID
	:= Numeric_Types.UNSIGNED_16_BIT(Temp_Integer);

      Temp_Interface.Exercise_Parameter_Change := True;

   else

      Temp_Interface.Exercise_Parameter_Change := False;

   end if;

   -- --- -------------------------------------------------------------
   -- Extract data from Synchronization Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Set_Parameters_Data.Synchronization.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Synchronization Parameters panel
      -- Automatic_Application_ID option menu.
      --
      Temp_Interface.Synchronize_With_Server
        := XDG_Client.Server_Synchronization_Flag;

   end if;

   --
   -- Assign our newly read values to the real Temp_Interface.
   --
   DG_Client_Gui.Interface.all := Temp_Interface;

   --
   -- Connect to DG Server
   --
   DG_Client_Gui.Interface.Connect_With_Server := TRUE;

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
        Title         => "XDG Client Apply Problem",
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
        Title         => "XDG Client Apply Problem",
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
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

