--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Update_GUI_Display
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Brett E. Dufault - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  26 September 94
--
-- PURPOSE :
--   - The UGUID CSU processes any Ordnance Display requests sent by the
--     OS's Graphical User Interface.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires ??
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------

with OS_GUI;

separate (Munition)

procedure Update_GUI_Display(
   Status : out OS_Status.STATUS_TYPE) is

   function "="(Left, Right : OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR)
     return BOOLEAN
       renames OS_Data_Types."=";

begin -- Update_GUI_Display

   case (OS_GUI.Interface.Ordnance_Display.Command) is

      when OS_GUI.NONE =>

         null;

      when OS_GUI.NEXT =>

         if (Current_Display_Entry.Next /= NULL) then

            Current_Display_Entry := Current_Display_Entry.Next;

            OS_GUI.Interface.General_Parameters
              := Current_Display_Entry.General_Parameters.ALL;

         end if;

      when OS_GUI.PREVIOUS =>

         if (Current_Display_Entry.Prev /= NULL) then

            Current_Display_Entry := Current_Display_Entry.Prev;

            OS_GUI.Interface.General_Parameters
              := Current_Display_Entry.General_Parameters.ALL;

         end if;

      when OS_GUI.APPLY =>

         Add_Related_Entity_Data(
           General_Parameters => OS_GUI.Interface.General_Parameters,
           Status             => Status);

   end case;

   OS_GUI.Interface.Ordnance_Display.Top_Of_List
     := (Current_Display_Entry.Prev = NULL);

   OS_GUI.Interface.Ordnance_Display.End_Of_List
     := (Current_Display_Entry.Next = NULL);

   OS_GUI.Interface.Ordnance_Display.Command := OS_GUI.NONE;

exception
   when OTHERS =>
      Status := OS_Status.UGUID_ERROR;

end Update_GUI_Display;
