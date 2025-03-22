--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Freeze_Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 May 94
--
-- PURPOSE :
--   - The FM CSU places a munition data record on the Frozen List, after
--     removing it from the Active List.  This action causes processing of the
--     munition to stop, but the data will be saved if the munition is resumed
--     in the future.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors and OS_Status.
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

procedure Freeze_Munition(
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

begin -- Freeze_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Unlink from Active List
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

   -- A null pointer indicates the munition's entry was not found which should
   -- only occur if an error occurred in Unlink_Munition
   if Munition_Data_Pointer /= null then

      -- Link to Frozen List
      Link_Munition(
        Munition_Data_Pointer => Munition_Data_Pointer,
        Top_of_List_Pointer   => Top_of_Frozen_List_Pointer,
        Status                => Returned_Status);
 
     if Returned_Status /= OS_Status.SUCCESS then
        Errors.Report_Error(
          Detonated_Prematurely => FALSE,
          Error                 => Returned_Status);
     end if;
         
   end if;

exception
   when OTHERS =>
      Status := OS_Status.FM_ERROR;

end Freeze_Munition;
