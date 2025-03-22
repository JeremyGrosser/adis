--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Link_Munition 
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 May 94
--
-- PURPOSE :
--   - The LM CSU links a munition data record to the top of the specified
--     list.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires OS_Status.
--   - New entries are added to the top of the list to ease linking.
--   - The list is doubly linked to ease unlinking.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
separate (Active_Frozen_Lists)

procedure Link_Munition(
   Munition_Data_Pointer :  in     MUNITION_LIST_RECORD_PTR;
   Top_of_List_Pointer   :  in out LINKED_LIST_ENTRY_RECORD_PTR;
   Status                :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   New_Node :  LINKED_LIST_ENTRY_RECORD_PTR;

begin -- Link_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Allocate memory for new node and set values
   New_Node := new LINKED_LIST_ENTRY_RECORD;

   New_Node.Previous              := null;
   New_Node.Next                  := Top_of_List_Pointer;
   New_Node.Munition_Data_Pointer := Munition_Data_Pointer;

   -- Do not set previous when the list is empty
   if Top_of_List_Pointer /= null then
      Top_of_List_Pointer.Previous := New_Node;
   end if;

   Top_of_List_Pointer := New_Node;

exception
   when OTHERS =>
      Status := OS_Status.LM_ERROR;

end Link_Munition; 
