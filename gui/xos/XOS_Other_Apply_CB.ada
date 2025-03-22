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
-- UNIT NAME:          Other_Apply_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 8, 1994
--
-- PURPOSE:
--   This procedure writes all changed values in all Set Other
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
procedure Other_Apply_CB (
   Parent                : in     Xt.WIDGET;
   Other_Parameters_Data : in out XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR;
   Call_Data             :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

   --
   -- Declare panel name constant strings
   --
   K_Error_Parameters_Panel_Name    : constant STRING
     := "Error Parameters";

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
   -- Extract data from Other Error Parameters widgets.
   -- --- -------------------------------------------------------------
   if (Other_Parameters_Data.Error.Shell /= Xt.XNULL) then

      --
      -- Extract the value from the Error Parameters
      -- GUI_Error_Reporting option menu.
      --
      Temp_Interface.Error_Parameters.Display_Error
        := XOS.GUI_Error_Reporting_Flag;

      --
      -- Extract the value from the Error Parameters
      -- Error_Logging option menu.
      --
      Temp_Interface.Error_Parameters.Log_Error
        := XOS.Error_Logging_Flag;

      --
      -- Extract the value from the Error Parameters panel
      -- Error_Logfile field.
      --
      Temp_Text := Xm.TextfieldGetString (Other_Parameters_Data.Error.
	Error_Logfile);

      if (Utilities.Length_Of_String(Temp_Text.all) = 0) then

         Temp_Interface.Error_Parameters.Log_File.Name
           := (OTHERS => ASCII.NUL);
         Temp_Interface.Error_Parameters.Log_File.Length := 0;

      elsif (Temp_Text'length < 80) then

	 Utilities.Strip_Spaces(Temp_Text.all);
         Temp_Interface.Error_Parameters.Log_File.Name(
           Temp_Interface.Error_Parameters.Log_File.Name'first..
             Temp_Interface.Error_Parameters.Log_File.Name'first
               + Temp_Text'length - 1) := Temp_Text.all;
         Temp_Interface.Error_Parameters.Log_File.Length :=
           Utilities.Length_Of_String (Temp_Text.all);

      else -- Temp_Text'length >= 80

	 Utilities.Strip_Spaces(Temp_Text.all);
         Temp_Interface.Error_Parameters.Log_File.Name :=
           Temp_Text(Temp_Text'first..Temp_Text'first
             + Temp_Interface.Error_Parameters.Log_File.Name'length - 1);
         Temp_Interface.Error_Parameters.Log_File.Length :=
           Temp_Interface.Error_Parameters.Log_File.Name'length;

      end if;

      --
      -- Don't free this (as you normally would), because Verdix Ada
      -- corrupts memory when you do...
      --
      --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Temp_Text));

      --
      -- Tell the OS that the Other Error Parameters have changed.
      --
      --Temp_Interface.Error_Parameters.Error_Parameter_Change
      --  := True;

   else
      --
      -- Tell the OS that the Other Error Parameters have not changed.
      --
      --Temp_Interface.Error_Parameters.Error_Parameter_Change
      --  := False;
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

end Other_Apply_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/08/94   D. Forrest
--      - Initial version
--
-- --

