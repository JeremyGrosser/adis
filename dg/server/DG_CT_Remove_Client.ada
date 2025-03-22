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
-- UNIT NAME        : DG_Client_Tracking.Remove_Client
--
-- FILE NAME        : DG_CT_Remove_Client.ada
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

procedure Remove_Client(
   Client_ID : in     INTEGER;
   Status    :    out DG_Status.STATUS_TYPE) is

   Client_Ptr : Client_List.LIST_NODE_PTR := Client_List.List_Head;

begin  -- Remove_Client

   Status := DG_Status.TRACK_REM_UNKNOWN_CLIENT;

   Find_Client_Loop:
   while (Client_Ptr /= NULL) loop

      if (Client_ID = Client_Ptr.Data.Login_Info.Client_ID) then

         Free(Client_Ptr.Data);

         Client_List.Remove_Node(Client_Ptr);

         Number_Of_Clients := Number_Of_Clients - 1;

         Status := DG_Status.SUCCESS;

         exit Find_Client_Loop;

      end if;

      Client_Ptr := Client_Ptr.Next;

   end loop Find_Client_Loop;

exception

   when OTHERS =>

      Status := DG_Status.TRACK_REM_FAILURE;

end Remove_Client;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
