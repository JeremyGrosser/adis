--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Unlink_Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 May 94
--
-- PURPOSE :
--   - The UM CSU unlink a linked list entry record from the specified list
--     and returns the Munition_Data_Pointer of the record.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors and OS_Status.
--   - The list is doubly linked to ease unlinking.
--   - The Munition_Data_Pointer is set to null in case the appropriate link
--     is not found.  Units calling UM use the null pointer as an indicator.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Errors;

separate (Active_Frozen_Lists)

procedure Unlink_Munition(
   Entity_ID             :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Top_of_List_Pointer   :  in out LINKED_LIST_ENTRY_RECORD_PTR;
   Munition_Data_Pointer :     out MUNITION_LIST_RECORD_PTR;
   Status                :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Free_Pointer     :  LINKED_LIST_ENTRY_RECORD_PTR;
   Next_Pointer     :  LINKED_LIST_ENTRY_RECORD_PTR;
   Node_Pointer     :  LINKED_LIST_ENTRY_RECORD_PTR;
   Previous_Pointer :  LINKED_LIST_ENTRY_RECORD_PTR;
   Returned_Status  :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   FEDBID_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Unlink_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   Munition_Data_Pointer := null;

   -- Search through the list until the end for a matching Entity ID
   Find_Entity_Data_By_ID(
     Entity_ID           => Entity_ID,
     Top_of_List_Pointer => Top_of_List_Pointer,
     Node_Pointer        => Node_Pointer,
     Status              => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      raise FEDBID_ERROR;
   end if; 

   if Node_Pointer /= null then

      -- Store pointer to record to free and bypass record on list
      Free_Pointer     := Node_Pointer;
      Next_Pointer     := Node_Pointer.Next;
      Previous_Pointer := Node_Pointer.Previous;

      if Previous_Pointer /= null then
         Previous_Pointer.Next := Next_Pointer;
      else -- Free Pointer was located at the top of the list
         Top_of_List_Pointer := Next_Pointer;
      end if;

      if Next_Pointer /= null then 
         Next_Pointer.Previous := Previous_Pointer;
      end if;

      -- Set output to Munition_Data_Pointer found and free record from list
      Munition_Data_Pointer := Free_Pointer.Munition_Data_Pointer;
      Free(Free_Pointer);

   else -- Node_Pointer is null

      Status := OS_Status.UM_MUNITION_NOT_FOUND_ERROR;

   end if;

exception
   when FEDBID_ERROR =>
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.UM_ERROR;

end Unlink_Munition;
