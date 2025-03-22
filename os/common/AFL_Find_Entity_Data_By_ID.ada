--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Find_Entity_Data_By_ID
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  19 May 94
--
-- PURPOSE :
--   - The FEDBID CSU loops through all the munitions on the specified list
--     until the specified munition is found and then returns a pointer to the
--     munition's data.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
separate (Active_Frozen_Lists)

procedure Find_Entity_Data_By_ID(
   Entity_ID           :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Top_of_List_Pointer :  in     LINKED_LIST_ENTRY_RECORD_PTR;
   Node_Pointer        :     out LINKED_LIST_ENTRY_RECORD_PTR;
   Status              :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Current_Pointer :  LINKED_LIST_ENTRY_RECORD_PTR;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DIS_Types.AN_ENTITY_IDENTIFIER)
     return BOOLEAN
     renames DIS_Types."=";

begin -- Find_Entity_Data_By_ID

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   Node_Pointer := null;

   -- Initialize Node Pointer
   Current_Pointer := Top_of_List_Pointer;

   -- Loop through munitions until a matching Entity ID is found or the
   -- end of the list is reached
   while Current_Pointer /= null
     and then Current_Pointer.Munition_Data_Pointer.Entity_ID /= Entity_ID
   loop

      Current_Pointer := Current_Pointer.Next;
   end loop;

   Node_Pointer := Current_Pointer;

exception
   when OTHERS =>
      Status := OS_Status.FEDBID_ERROR;

end Find_Entity_Data_By_ID;
