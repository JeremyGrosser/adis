--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Active_Frozen_Lists (spec)
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
with DIS_Types,
     OS_Status,
     Unchecked_Deallocation;

package Active_Frozen_Lists is

   -- Linked list types
   type MUNITION_LIST_RECORD is
     record
       Entity_ID     :  DIS_Types.AN_ENTITY_IDENTIFIER;
       Entity_Type   :  DIS_Types.AN_ENTITY_TYPE_RECORD;
       Hashing_Index :  INTEGER;
     end record;
   type MUNITION_LIST_RECORD_PTR is access MUNITION_LIST_RECORD;

   type LINKED_LIST_ENTRY_RECORD;
   type LINKED_LIST_ENTRY_RECORD_PTR is access LINKED_LIST_ENTRY_RECORD;
   type LINKED_LIST_ENTRY_RECORD is
     record
       Previous              :  LINKED_LIST_ENTRY_RECORD_PTR;
       Next                  :  LINKED_LIST_ENTRY_RECORD_PTR;
       Munition_Data_Pointer :  MUNITION_LIST_RECORD_PTR;
     end record;

   -- Instantiate FREE
   procedure Free is new Unchecked_Deallocation(
      LINKED_LIST_ENTRY_RECORD, LINKED_LIST_ENTRY_RECORD_PTR);
   procedure Free is new Unchecked_Deallocation(
      MUNITION_LIST_RECORD, MUNITION_LIST_RECORD_PTR);

   -- Variables global to this package
   Top_of_Active_List_Pointer :  LINKED_LIST_ENTRY_RECORD_PTR := null;
   Top_of_Frozen_List_Pointer :  LINKED_LIST_ENTRY_RECORD_PTR := null;

   -- Procedure specs
   procedure Link_Munition(
      Munition_Data_Pointer :  in     MUNITION_LIST_RECORD_PTR;
      Top_of_List_Pointer   :  in out LINKED_LIST_ENTRY_RECORD_PTR;
      Status                :     out OS_Status.STATUS_TYPE);

   procedure Unlink_Munition(
      Entity_ID             :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Top_of_List_Pointer   :  in out LINKED_LIST_ENTRY_RECORD_PTR;
      Munition_Data_Pointer :     out MUNITION_LIST_RECORD_PTR;
      Status                :     out OS_Status.STATUS_TYPE);

   procedure Activate_Munition(
      Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Entity_Type   :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE);

   procedure Deactivate_Munition(
      Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :     out OS_Status.STATUS_TYPE);

   procedure Freeze_Munition(
      Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :     out OS_Status.STATUS_TYPE);

   procedure Resume_Munition(
      Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :     out OS_Status.STATUS_TYPE);

   procedure Clear_List(
      Top_of_List_Pointer :  in out LINKED_LIST_ENTRY_RECORD_PTR;
      Status              :     out OS_Status.STATUS_TYPE);

   procedure Find_Entity_Data_By_ID(
      Entity_ID           :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Top_of_List_Pointer :  in     LINKED_LIST_ENTRY_RECORD_PTR;
      Node_Pointer        :     out LINKED_LIST_ENTRY_RECORD_PTR;
      Status              :     out OS_Status.STATUS_TYPE);

end Active_Frozen_Lists;
