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
-- UNIT NAME:          Ord_Update_Previous_Next_Buttons
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 21, 1994
--
-- PURPOSE:
--   This procedure updates the Next and Previous buttons on the Ordnance
--   parameters window based on OS_GUI.Interface.Ordnance_Display.Top_Of_List
--   and OS_GUI.Interface.Ordnance_Display.End_Of_List.
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
procedure Ord_Update_Previous_Next_Buttons(
   Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR) is

   K_Delay_Amount_In_Seconds : constant DURATION := 0.1;

   function "="(Left, Right : OS_GUI.ORDNANCE_COMMAND_TYPE)
     return BOOLEAN
       renames OS_GUI."=";

begin

   null;

   --
   -- Wait for previous command to complete
   --
   while (OS_GUI.Interface.Ordnance_Display.Command /= OS_GUI.NONE) loop
      Delay (K_Delay_Amount_In_Seconds);
   end loop;

   --
   -- Sensitize Previous_Button based on value of Top_Of_List
   --
   if OS_GUI.Interface.Ordnance_Display.Top_Of_List then
      Xt.SetSensitive (Ord_Parameters_Data.Previous_Button, FALSE);
   else
      Xt.SetSensitive (Ord_Parameters_Data.Previous_Button, TRUE);
   end if;
   
   --
   -- Sensitize Next_Button based on value of End_Of_List
   --
   if OS_GUI.Interface.Ordnance_Display.End_Of_List then
      Xt.SetSensitive (Ord_Parameters_Data.Next_Button, FALSE);
   else
      Xt.SetSensitive (Ord_Parameters_Data.Next_Button, TRUE);
   end if;

   --
   -- Reinitialize the Ordnance Parameters panels.
   --
   Initialize_Ord_Parms_Panels(Ord_Parameters_Data);

end Ord_Update_Previous_Next_Buttons;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/21/94   D. Forrest
--      - Initial version
--
-- --

