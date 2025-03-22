--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Active_Frozen_Lists
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
-- 
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  10 May 94
--
-- PURPOSE :
--   - The AFL CSC is responsible for maintaining Active and Frozen Lists
--     for the OS CSCI.  These linked lists contain the Entity ID, Entity
--     Type, and the Hashing Index for each munition under the control of
--     the OS CSCI.  Entries can be unlinked from one list and linked to
--     another, added, removed, or the lists can be completely cleared.
--
-- EFFECTS :
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES:
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
package body Active_Frozen_Lists is

   procedure Link_Munition(
      Munition_Data_Pointer :  in     MUNITION_LIST_RECORD_PTR;
      Top_of_List_Pointer   :  in out LINKED_LIST_ENTRY_RECORD_PTR;
      Status                :     out OS_Status.STATUS_TYPE)
     is separate; 

   procedure Unlink_Munition(
      Entity_ID             :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Top_of_List_Pointer   :  in out LINKED_LIST_ENTRY_RECORD_PTR;
      Munition_Data_Pointer :     out MUNITION_LIST_RECORD_PTR;
      Status                :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Activate_Munition(
      Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Entity_Type   :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Deactivate_Munition(
      Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Freeze_Munition(
      Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Resume_Munition(
      Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Clear_List(
      Top_of_List_Pointer :  in out LINKED_LIST_ENTRY_RECORD_PTR;
      Status              :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Find_Entity_Data_By_ID(
      Entity_ID           :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Top_of_List_Pointer :  in     LINKED_LIST_ENTRY_RECORD_PTR;
      Node_Pointer        :     out LINKED_LIST_ENTRY_RECORD_PTR;
      Status              :     out OS_Status.STATUS_TYPE)
     is separate;

end Active_Frozen_Lists;
