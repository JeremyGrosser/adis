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
with DL_Types;
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
-- UNIT NAME:          Sim_Apply_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 7, 1994
--
-- PURPOSE:
--   This procedure writes all changed values in all Set Simulation
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
procedure Sim_Apply_CB (
   Parent              : in     Xt.WIDGET;
   Sim_Parameters_Data : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
   Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Declare panel name constant strings
   --
   K_Simulation_Parameters_Panel_Name  : constant STRING
     := "Simulation Parameters";

   --
   -- Declare minimum values for fields...
   -- The OS packages do not declare these internally, so I 
   -- declare them myself here...
   --
   K_Minimum_Cycle_Time : constant FLOAT := 0.030000;

   --
   -- Local variable declarations
   --
   Success          : BOOLEAN;

   Problem_Message  : Utilities.ASTRING := NULL;
   Problem_Panel    : Utilities.ASTRING := NULL;
   Problem_Item     : Utilities.ASTRING := NULL;

   Temp_Integer     : INTEGER;
   Temp_Float       : FLOAT;
   Temp_Short_Float : SHORT_FLOAT;
   Temp_Char        : CHARACTER;
   Temp_Text        : Xm.STRING_PTR := NULL;

   --
   -- Local exceptions
   --
   Bad_Value        : EXCEPTION;
   Value_Too_Small  : EXCEPTION;

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
   function XmSTRING_PTR_To_INTEGER
     is new Unchecked_Conversion (Xm.STRING_PTR, INTEGER);
   function XtWIDGET_To_INTEGER
     is new Unchecked_Conversion (Xt.WIDGET, INTEGER);

begin

   --
   -- Initialize Temp_Interface with values from shared memory.
   --
   Temp_Interface := OS_GUI.Interface.all;

   -- --- -------------------------------------------------------------
   -- Extract data from Simulation Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Sim_Parameters_Data.Sim.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Simulation panel Contact_Threshold field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	 Text_Widget  => Sim_Parameters_Data.Sim.Contact_Threshold,
	 Return_Value => Temp_Float,
	 Success      => Success);
      --
      -- If Get_Float_From_Text_Widget fails, raise the Bad_Value exception.
      --
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Contact Threshold");
	 raise Bad_Value;
      end if;
      --
      -- Assign our newly extracted value to the appropriate interface
      -- record field.
      --
      Temp_Interface.Simulation_Parameters.Contact_Threshold
	:= OS_Data_Types.METERS_DP(Temp_Float);

      -- -----
      -- Extract the value from the Simulation panel Cycle Time field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Sim_Parameters_Data.Sim.Cycle_Time, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Cycle Time");
	 raise Bad_Value;
      end if;
      if (Temp_Float < K_Minimum_Cycle_Time) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Cycle Time");
	 raise Value_Too_Small;
      end if;
      Temp_Interface.Simulation_Parameters.Cycle_Time
	:= OS_Data_Types.SECONDS(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel DB Origin Latitude field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Sim_Parameters_Data.Sim.DB_Origin_Latitude, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Database Origin Latitude");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Database_Origin.Latitude
	:= DL_Types.DEGREES_SEMI(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel DB Origin Longitude field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Sim_Parameters_Data.Sim.DB_Origin_Longitude, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Database Origin Longitude");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Database_Origin.Longitude
	:= DL_Types.DEGREES_CIRC(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel DB Origin Altitude field.
      --
      Motif_Utilities.Get_Float_From_Text_Widget (
	Sim_Parameters_Data.Sim.DB_Origin_Altitude, Temp_Float, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Database Origin Altitude");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Database_Origin.Altitude
	:= OS_Data_Types.METERS_DP(Temp_Float);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel Exercise_ID field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Sim_Parameters_Data.Sim.Exercise_ID, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Exercise ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Exercise_ID
	:= DIS_Types.AN_EXERCISE_IDENTIFIER(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel Hash_Table_Increment field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Sim_Parameters_Data.Sim.Hash_Table_Increment, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Hash Table Increment");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Hash_Table_Increment
	:= INTEGER(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel Hash_Table_Size field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Sim_Parameters_Data.Sim.Hash_Table_Size, Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Hash Table Size");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Hash_Table_Size
	:= INTEGER(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel 
      -- ModSAF_Database_Filename field.
      --
      MODSAF_DATABASE_FILENAME_APPLY_BLOCK:
      declare 
	 Text_Text_Length : INTEGER := 0;
      begin
	 Temp_Text := Xm.TextFieldGetString (
	   Sim_Parameters_Data.Sim.ModSAF_Database_Filename);
         Text_Text_Length := Utilities.Length_Of_String(Temp_Text.all);

	 if (Text_Text_Length = 0) then
	    Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	    Problem_Item  := new STRING'("ModSAF Database Filename");
	    raise Bad_Value;
	 end if;
	 if (Temp_Text'length < Temp_Interface.Simulation_Parameters.
	   ModSAF_Database_Filename'length) then
	     
	    Temp_Interface.Simulation_Parameters.ModSAF_Database_Filename(
	      Temp_Interface.Simulation_Parameters.ModSAF_Database_Filename'
		first..Temp_Interface.Simulation_Parameters.
		  ModSAF_Database_Filename'first+Temp_Text'length-1)
		    := Temp_Text.all;
	 else
	   Temp_Interface.Simulation_Parameters.ModSAF_Database_Filename
	     := Temp_Text(Temp_Text'first..Temp_Text'first+Temp_Interface.
	       Simulation_Parameters.ModSAF_Database_Filename'length-1);
	 end if;

         --
	 -- Don't free this (as you normally would), because Verdix Ada
	 -- corrupts memory when you do...
	 --
         --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Temp_Text));

      end MODSAF_DATABASE_FILENAME_APPLY_BLOCK;
      -- -----

      -- -----
      -- Extract the value from the Simulation panel
      -- Memory_Limit_For_ModSAF_File field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Sim_Parameters_Data.Sim.Memory_Limit_For_ModSAF_File,
	  Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Memory Limit for ModSAF File");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Memory_Limit_For_ModSAF_File
	:= INTEGER(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel 
      -- Number_of_Loops_Until_Update field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
	Sim_Parameters_Data.Sim.Number_of_Loops_Until_Update,
	  Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Number of Loops until Update");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Number_of_Loops_Until_Update
	:= INTEGER(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel Parent Entity ID
      -- Sim Address Site_ID field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Sim_Parameters_Data.Sim.Parent_Entity_ID_Sim_Address_Site_ID,
	  Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Parent Entity ID Sim Address Site ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.
	Parent_Entity_ID.Sim_Address.Site_ID
	  := NUMERIC_TYPES.UNSIGNED_16_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel Parent Entity ID
      -- Sim Address Application_ID field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Sim_Parameters_Data.Sim.Parent_Entity_ID_Sim_Address_Application_ID,
	  Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'(
	   "Parent Entity ID Sim Address Application ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.
	Parent_Entity_ID.Sim_Address.Application_ID
	  := NUMERIC_TYPES.UNSIGNED_16_BIT(Temp_Integer);
      -- -----

      -- -----
      -- Extract the value from the Simulation panel Parent Entity ID
      -- Entity_ID field.
      --
      Motif_Utilities.Get_Integer_From_Text_Widget (
        Sim_Parameters_Data.Sim.Parent_Entity_ID_Entity_ID,
	  Temp_Integer, Success);
      if (Success = False) then
	 Problem_Panel := new STRING'(K_Simulation_Parameters_Panel_Name);
	 Problem_Item  := new STRING'("Parent Entity ID Entity ID");
	 raise Bad_Value;
      end if;
      Temp_Interface.Simulation_Parameters.Parent_Entity_ID.Entity_ID
	:= NUMERIC_TYPES.UNSIGNED_16_BIT(Temp_Integer);
      -- -----

      --
      -- Extract the value from the Simulation panel Simulation State
      -- option menu.
      --
      Temp_Interface.Simulation_Parameters.Simulation_State
	:= OS_Simulation_Types.SIMULATION_STATE_TYPE'val(
	  XOS.Simulation_State_Value);

      --
      -- Tell the OS that the Simulation Parameters have changed.
      --
      --Temp_Interface.Simulation_Parameter_Change := True;

   else

      --
      -- Tell the OS that the Simulation Parameters have not changed.
      --
      --Temp_Interface.Simulation_Parameter_Change := False;
      null;

   end if;

   --
   -- Write out changed values into shared memory.
   --
   OS_GUI.Interface.all := Temp_Interface;

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
   -- This user-defined exception occurs if the user enters a value which is
   -- too small for the specified field.
   --
   when Value_Too_Small =>
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
	"The value in field `" & Problem_Item.all & "'" & ASCII.LF
	  & "in panel `" & Problem_Panel.all & "' " & "is too small."
	    & ASCII.LF & "Apply aborted" & ASCII.LF & ASCII.LF
	      & "Please enter a larger value in this field and re-Apply.");

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

end Sim_Apply_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/07/94   D. Forrest
--      - Initial version
--
-- --

