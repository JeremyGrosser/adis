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
with Motif_Utilities;
with Numeric_Types;
with Text_IO;
with Utilities;
with XDG_Server_Types;
with Xlib;
with Xm;
with Xt;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Panel_Exercise
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 9, 1994
--
-- PURPOSE:
--   This procedure initializes the Exercise Panel widgets with the
--   values from the DG Shared Memory interface.
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
procedure Initialize_Panel_Exercise (
   Exercise : in     XDG_Server_Types.XDG_EXERCISE_PARAMETERS_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Server.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Automatic_Exercise_ID option menu widget
   --
   if (Exercise.Automatic_Exercise_ID /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Exercise_Parameters.Set_Exercise_ID
	= XDG_Server.K_Enabled) then
	 XDG_Server.Automatic_Exercise_ID_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Exercise.Automatic_Exercise_ID), K_Enabled_String);
      else
	 XDG_Server.Automatic_Exercise_ID_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Exercise.Automatic_Exercise_ID), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Exercise_ID text widget
   --
   if (Exercise.Exercise_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Exercise_Parameters.Exercise_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Exercise.Exercise_ID, Temp_String);
   end if;

   --
   -- Initialize Automatic_Site_ID option menu widget
   --
   if (Exercise.Automatic_Site_ID /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Exercise_Parameters.Set_Site_ID
	= XDG_Server.K_Enabled) then
	 XDG_Server.Automatic_Site_ID_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Exercise.Automatic_Site_ID), K_Enabled_String);
      else
	 XDG_Server.Automatic_Site_ID_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Exercise.Automatic_Site_ID), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Site_ID text widget
   --
   if (Exercise.Site_ID /= Xt.XNULL) then
      Utilities.Integer_To_String (
	Integer_Value => INTEGER(
	  DG_Server_GUI.Interface.Exercise_Parameters.Site_ID),
	Return_String => Temp_String);
      Xm.TextFieldSetString (Exercise.Site_ID, Temp_String);
   end if;

   --
   -- Initialize Automatic_Timestamp option menu widget
   --
   if (Exercise.Automatic_Timestamp /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Exercise_Parameters.Automatic_Timestamp) then
         XDG_Server.Automatic_Timestamp_Flag := XDG_Server.K_Enabled;
         Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
           Exercise.Automatic_Timestamp), K_Enabled_String);
      else
         XDG_Server.Automatic_Timestamp_Flag := XDG_Server.K_Disabled;
         Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
           Exercise.Automatic_Timestamp), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize IITSEC_Bit_23_Support option menu widget
   --
   if (Exercise.IITSEC_Bit_23_Support /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Exercise_Parameters.
        IITSEC_Bit_23_Support) then

         XDG_Server.IITSEC_Bit_23_Support_Flag := XDG_Server.K_Enabled;
         Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
           Exercise.IITSEC_Bit_23_Support), K_Enabled_String);

      else

         XDG_Server.IITSEC_Bit_23_Support_Flag := XDG_Server.K_Disabled;
         Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
           Exercise.IITSEC_Bit_23_Support), K_Disabled_String);

      end if;
   end if;

   --
   -- Initialize Experimental_PDUs option menu widget
   --
   if (Exercise.Experimental_PDUs /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Exercise_Parameters.Experimental_PDU_Support)
	then
         XDG_Server.Experimental_PDUs_Flag := XDG_Server.K_Enabled;
         Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
           Exercise.Experimental_PDUs), K_Enabled_String);
      else
         XDG_Server.Experimental_PDUs_Flag := XDG_Server.K_Disabled;
         Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
           Exercise.Experimental_PDUs), K_Disabled_String);
      end if;
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Exercise;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/09/94   D. Forrest
--      - Initial version
--
-- --

