--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Activate_Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  12 May 94
--
-- PURPOSE :
--   - The AM CSU instantiates a new munition and places the munition on
--     the active munition list.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors, Munition,
--     OS_Hash_Table_Support and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Errors,
     Munition,
     OS_Hash_Table_Support;

separate (Active_Frozen_Lists)

procedure Activate_Munition(
   Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Entity_Type   :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local Variables
   Munition_Data_Pointer  :  MUNITION_LIST_RECORD_PTR;
   Returned_Status        :  OS_Status.STATUS_TYPE;
   Second_Returned_Status :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   IM_ERROR :  exception;
   LM_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Activate_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Allocate memory for new Munition Data Pointer and set values
   Munition_Data_Pointer := new MUNITION_LIST_RECORD;
   Munition_Data_Pointer.Entity_ID     := Entity_ID;
   Munition_Data_Pointer.Entity_Type   := Entity_Type;
   Munition_Data_Pointer.Hashing_Index := Hashing_Index;

   -- Store information for the specified entity type for this munition
   Munition.Instantiate_Munition(
     Entity_Type   => Entity_Type,
     Hashing_Index => Hashing_Index,
     Status        => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      raise IM_ERROR;
   end if;

   Link_Munition(
     Munition_Data_Pointer => Munition_Data_Pointer,
     Top_of_List_Pointer   => Top_of_Active_List_Pointer,
     Status                => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      raise LM_ERROR;
   end if;

exception
   when IM_ERROR | LM_ERROR =>
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

      OS_Hash_Table_Support.Remove_Entity_by_Hashing_Index(
        Hashing_Index => Hashing_Index,
        Status        => Second_Returned_Status);

      if Second_Returned_Status /= OS_Status.SUCCESS then
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Second_Returned_Status);
      end if;

   when OTHERS =>
      Status := OS_Status.AM_ERROR;

end Activate_Munition;
