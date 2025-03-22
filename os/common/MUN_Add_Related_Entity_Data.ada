--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Add_Related_Entity_Data
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Brett E. Dufault - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  20 September 94
--
-- PURPOSE :
--   - The ARED CSU adds a new entry in the General Parameters list used
--     by the Find_Related_Entity_Data (FRED) CSU.  The search methodology
--     implemented by the FRED CSU assumes that this list is organized in
--     a particular order (from specific Entity Type entries at the top to
--     more generalized entries at the bottom -- for more information see the
--     "IMPLEMENTATION NOTES" section of MUN_Find_Related_Entity_Data.ada).
--     The ARED CSU will insert the new entry in the correct list location.
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

procedure Add_Related_Entity_Data(
   General_Parameters : in      OS_Data_Types.GENERAL_PARAMETERS_RECORD;
   Status             :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   New_Record : OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR
                  := new OS_Data_Types.USER_SUPPLIED_DATA_RECORD;

   -- Rename routines
   function "="(Left, Right : OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR)
     return BOOLEAN
       renames OS_Data_Types."=";

begin -- Add_Related_Entity_Data

   New_Record.General_Parameters
     := new OS_Data_Types.GENERAL_PARAMETERS_RECORD;

   New_Record.General_Parameters.ALL := General_Parameters;

   if (Top_of_Entity_Data_List_Pointer = NULL) then

      -- The list is empty, so link this record to the top
      Top_of_Entity_Data_List_Pointer := New_Record;

   else

      -- Link the existing list after the new entry, then set the list top
      -- to the new entry.
      New_Record.Next                      := Top_of_Entity_Data_List_Pointer;
      Top_of_Entity_Data_List_Pointer.Prev := New_Record;
      Top_of_Entity_Data_List_Pointer      := New_Record;

   end if;

   Current_Display_Entry := Top_of_Entity_Data_List_Pointer;

   OS_GUI.Interface.Ordnance_Display.Top_Of_List
     := (Current_Display_Entry.Prev = NULL);

   OS_GUI.Interface.Ordnance_Display.End_Of_List
     := (Current_Display_Entry.Next = NULL);

exception
   when OTHERS =>
      Status := OS_Status.ARED_ERROR;

end Add_Related_Entity_Data;
