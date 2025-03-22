--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Deactivate_Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 May 94
--
-- PURPOSE :
--   - The DM CSU eliminates a munition such that it is no longer part of
--     the simulation which includes requesting its removal from the munition
--     hash table.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors, OS_Hash_Table_Support and
--     OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Errors,
     OS_Hash_Table_Support;

separate (Active_Frozen_Lists)

procedure Deactivate_Munition(
   Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Status    :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Munition_Data_Pointer :  MUNITION_LIST_RECORD_PTR;
   Returned_Status       :  OS_Status.STATUS_TYPE;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Deactivate_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Unlink munition from Active List
   Unlink_Munition(
     Entity_ID             => Entity_ID,
     Top_of_List_Pointer   => Top_of_Active_List_Pointer,
     Munition_Data_Pointer => Munition_Data_Pointer,
     Status                => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if;

   -- If Munition Data Pointer is null, then the munition was not on the Active
   -- List; therefore, unlink munition from Frozen List
   if Munition_Data_Pointer = null then

      Unlink_Munition(
        Entity_ID             => Entity_ID,
        Top_of_List_Pointer   => Top_of_Frozen_List_Pointer,
        Munition_Data_Pointer => Munition_Data_Pointer,
        Status                => Returned_Status);

      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

   end if;

   if Munition_Data_Pointer /= null then
      -- Request removal of munition from munition hash table
      OS_Hash_Table_Support.Remove_Entity_by_Hashing_Index(
        Hashing_Index => Munition_Data_Pointer.Hashing_Index,
        Status        => Returned_Status);

      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

      -- Free memory for data being unlinked
      Free(Munition_Data_Pointer);

   end if;

exception
   when OTHERS =>
      Status := OS_Status.DM_ERROR;

end Deactivate_Munition;
