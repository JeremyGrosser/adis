--
--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--
------------------------------------------------------------------------------
--
-- UNIT NAME        : DG_Client_Tracking.Synchronize_Clients
--
-- FILE NAME        : DG_CT_Synchronize_Clients.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - 
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

separate (DG_Client_Tracking)

procedure Synchronize_Clients(
   Status : out DG_Status.STATUS_TYPE) is

   Client_Ptr   : Client_List.LIST_NODE_PTR := Client_List.List_Head;
   Local_Status : DG_Status.STATUS_TYPE;

   LOCAL_FAILURE : EXCEPTION;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

   function "="(Left, Right : Client_List.LIST_NODE_PTR)
     return BOOLEAN
       renames Client_List."=";

begin  -- Synchronize_Clients

   Status := DG_Status.SUCCESS;

   Synchronization_Loop:
   while (Client_Ptr /= NULL) loop

      DG_Synchronization.Synchronize_Client(
        Semaphore_ID => Client_Ptr.Data.Sync_Semaphore,
        Status       => Local_Status);

      if (Local_Status /= DG_Status.SUCCESS) then
         raise LOCAL_FAILURE;
      end if;

      Client_Ptr := Client_Ptr.Next;

   end loop Synchronization_Loop;

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.TRACK_SYNC_FAILURE;

end Synchronize_Clients;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
