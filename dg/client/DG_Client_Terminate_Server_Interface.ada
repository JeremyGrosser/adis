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
-- UNIT NAME        : DG_Client.Terminate_Server_Interface
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 31, 1994
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

with DG_IPC_Keys,
     DG_Login_Queue,
     DG_Synchronization;

separate (DG_Client)

procedure Terminate_Server_Interface(
   Status : out DG_Status.STATUS_TYPE) is

   Local_Status  : DG_Status.STATUS_TYPE;

   LOCAL_FAILURE : EXCEPTION;

begin -- Terminate_Server_Interface

   Status := DG_Status.SUCCESS;

   --
   -- Check if the client is controlling the shutdown (in which case
   -- Client_Online will be TRUE), or if the server has commanded the
   -- shutdown (in which case Client_Online will be FALSE).
   --
   if (DG_Client_Interface.Interface.Client_Online) then

      --
      -- Send server a logout message
      --
      DG_Login_Queue.Client_Logout(
        Status => Local_Status);

      if (DG_Status.Failure(Local_Status)) then
         raise LOCAL_FAILURE;
      end if;

   end if;

   --
   -- Deallocate the Client/GUI interface
   --

   DG_Client_GUI.Unmap_Interface(
     Destroy_Interface => TRUE,
     Status            => Local_Status);

   if (DG_Status.Failure(Local_Status)) then
      raise LOCAL_FAILURE;
   end if;

   --
   -- Deallocate the Server/Client interface
   --

   DG_Server_Interface.Unmap_Interface(
     Destroy_Interface => FALSE,
     Status            => Local_Status);

   if (DG_Status.Failure(Local_Status)) then
      raise LOCAL_FAILURE;
   end if;

   --
   -- Deallocate the Client/Server interface
   --

   DG_Client_Interface.Unmap_Interface(
     Destroy_Interface => TRUE,
     Memory_Key        => DG_IPC_Keys.Client.Client_Server_Key,
     Interface         => DG_Client_Interface.Interface,
     Status            => Local_Status);

   if (DG_Status.Failure(Local_Status)) then
      raise LOCAL_FAILURE;
   end if;

   --
   -- Remove client synchronization semaphore
   --
   DG_Synchronization.Terminate_Client_Synchronization(
     Status => Status);

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.CLI_TSI_FAILURE;

end Terminate_Server_Interface;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
