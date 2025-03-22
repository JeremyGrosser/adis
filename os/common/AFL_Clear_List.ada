--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Clear_List
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 May 94
--
-- PURPOSE :
--   - The CL CSU eliminates all munitions from the specified munition list.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
separate (Active_Frozen_Lists)

procedure Clear_List(
   Top_of_List_Pointer :  in out LINKED_LIST_ENTRY_RECORD_PTR;
   Status              :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Free_Pointer :  LINKED_LIST_ENTRY_RECORD_PTR;

begin -- Clear_List

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   while Top_of_List_Pointer /= null loop 

      -- Move pointer to next entry before freeing entry
      Free_Pointer := Top_of_List_Pointer;
      Top_of_List_Pointer := Top_of_List_Pointer.Next;

      -- Free memory for the munition data pointer in free pointer
      Free(Free_Pointer.Munition_Data_Pointer);

      -- Free memory for the free pointer
      Free(Free_Pointer);

   end loop;

exception
   when OTHERS =>
      Status := OS_Status.CL_ERROR;

end Clear_List;
