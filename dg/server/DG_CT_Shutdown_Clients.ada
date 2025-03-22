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
-- UNIT NAME        : DG_Client_Tracking.Shutdown_Clients
--
-- FILE NAME        : DG_CT_Shutdown_Clients.ada
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

procedure Shutdown_Clients(
   Status : out DG_Status.STATUS_TYPE) is

   Client_Ptr   : Client_List.LIST_NODE_PTR;
   Local_Status : DG_Status.STATUS_TYPE;

   LOCAL_FAILURE : EXCEPTION;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

   function "="(Left, Right : Client_List.LIST_NODE_PTR)
     return BOOLEAN
       renames Client_List."=";

begin  -- Shutdown_Clients

   Status := DG_Status.SUCCESS;

   Shutdown_Loop:
   while (Client_List.List_Head /= NULL) loop

      Client_Ptr := Client_List.List_Head;

      --
      -- Set Client to offline.  This alerts the Client that the Server
      -- is executing a shutdown.
      --
      Client_Ptr.Data.Interface.Client_Online := FALSE;

      --
      -- Unmap the Client's memory.
      --
      DG_Client_Interface.Unmap_Interface(
        Destroy_Interface => FALSE,
        Memory_Key        => Client_Ptr.Data.Login_Info.Client_Interface_Key,
        Interface         => Client_Ptr.Data.Interface,
        Status            => Local_Status);

      if (Local_Status /= DG_Status.SUCCESS) then
         raise LOCAL_FAILURE;
      end if;

      Remove_Client(
        Client_ID => Client_Ptr.Data.Login_Info.Client_ID,
        Status    => Local_Status);

      if (Local_Status /= DG_Status.SUCCESS) then
         raise LOCAL_FAILURE;
      end if;

   end loop Shutdown_Loop;

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.TRACK_SHUTDOWN_FAILURE;

end Shutdown_Clients;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
