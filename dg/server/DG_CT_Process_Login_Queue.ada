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
-- UNIT NAME        : DG_Client_Tracking.Process_Login_Queue
--
-- FILE NAME        : DG_CT_Process_Login_Queue.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
--
-- PURPOSE:
--   - Checks the Server login queue for Client logins and logouts, and
--     updates the Client information database accordingly.
--
-- IMPLEMENTATION NOTES:
--   - None.
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

with DG_Server_GUI,
     DG_Shared_Memory,
     DG_Synchronization,
     Unchecked_Conversion;

separate (DG_Client_Tracking)

procedure Process_Login_Queue(
   Server_Info : in     DG_Login_Queue.SERVER_INFO_TYPE;
   Status      :    out DG_Status.STATUS_TYPE) is

   Client_Info         : DG_Login_Queue.CLIENT_INFO_TYPE;
   Client_Interface    : DG_Client_Interface.CLIENT_INTERFACE_PTR_TYPE;
   Client_Semaphore_ID : INTEGER;
   Local_Status        : DG_Status.STATUS_TYPE;
   Login_Present       : BOOLEAN;
   Temp_Entity_Data    : CLIENT_ENTITY_TRACKING_DATA_PTR;
   Temp_Laser_Data     : CLIENT_ENTITY_TRACKING_DATA_PTR;

   LOCAL_FAILURE : EXCEPTION;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

begin  -- Process_Login_Queue

   Status := DG_Status.SUCCESS;

   Process_Clients_Loop:
   loop

      --
      -- Check for any Client messages
      --
      DG_Login_Queue.Get_Client_Login(
        Login_Present => Login_Present,
        Client_Info   => Client_Info,
        Status        => Local_Status);

      if (Local_Status /= DG_Status.SUCCESS) then
         raise LOCAL_FAILURE;
      end if;

      if (Login_Present) then

         if (Client_Info.Login_Flag) then

            DG_Login_Queue.Send_Server_Info(
               Server_Info => Server_Info,
               Client_ID   => Client_Info.Client_ID,
               Status      => Local_Status);

            if (Local_Status /= DG_Status.SUCCESS) then
               raise LOCAL_FAILURE;
            end if;

            DG_Client_Interface.Map_Interface(
              Create_Interface      => FALSE,
              Simulation_Parameters => Client_Info.Interface_Info,
              Memory_Key            => Client_Info.Client_Interface_Key,
              Interface             => Client_Interface,
              Status                => Local_Status);

            if (DG_Status.Failure(Local_Status)) then
               raise LOCAL_FAILURE;
            end if;

            DG_Synchronization.Initialize_Server_Synchronization(
              Client_ID    => Client_Info.Client_Semaphore_Key,
              Semaphore_ID => Client_Semaphore_ID,
              Status       => Local_Status);

            if (Local_Status /= DG_Status.SUCCESS) then
               raise LOCAL_FAILURE;
            end if;

            Temp_Entity_Data
              := new CLIENT_ENTITY_TRACKING_DATA(
                       1..Client_Info.Interface_Info.Maximum_Entities);

            Temp_Entity_Data.ALL := (OTHERS => (Server_Hash_Index => 0));

            Temp_Laser_Data
              := new CLIENT_ENTITY_TRACKING_DATA(
                       1..Client_Info.Interface_Info.Maximum_Lasers);

            Temp_Laser_Data.ALL := (OTHERS => (Server_Hash_Index => 0));

            Add_Client(
              Client_Data => (Interface         => Client_Interface,
                              Buffer_Read_Index => Client_Interface.
                                                     Buffer_Write_Index,
                              Sync_Semaphore    => Client_Semaphore_ID,
                              Login_Info        => Client_Info,
                              Entity_Data       => Temp_Entity_Data,
                              Laser_Data        => Temp_Laser_Data),
              Status => Local_Status);

            if (Local_Status /= DG_Status.SUCCESS) then
               raise LOCAL_FAILURE;
            end if;

            DG_Server_GUI.Interface.Server_Monitor.Number_Of_Clients
              := DG_Server_GUI.Interface.Server_Monitor.Number_Of_Clients + 1;

         else  -- not (Login_Flag)

            Logout_Client_Block:
            declare

               Client_Ptr : Client_List.LIST_NODE_PTR
                              := Client_List.List_Head;

            begin  -- Logout_Client_Block

               Locate_Client_Loop:
               while (Client_Ptr /= NULL) loop

                  if (Client_Ptr.Data.Login_Info.Client_ID
                    = Client_Info.Client_ID) then

                     Remove_Client_Interface:
                     declare

                        subtype CURRENT_CLIENT_INTERFACE_TYPE is
                          DG_Client_Interface.CLIENT_INTERFACE_TYPE(
                            Maximum_Entities =>
                              Client_Ptr.Data.Interface.Maximum_Entities,
                            Maximum_Emitters =>
                              Client_Ptr.Data.Interface.Maximum_Emitters,
                            Maximum_Lasers =>
                              Client_Ptr.Data.Interface.Maximum_Lasers,
                            Maximum_Transmitters =>
                              Client_Ptr.Data.Interface.Maximum_Transmitters,
                            Maximum_Receivers =>
                              Client_Ptr.Data.Interface.Maximum_Receivers,
                            PDU_Buffer_Size  =>
                              Client_Ptr.Data.Interface.PDU_Buffer_Size);

                        package Client_Memory is
                          new DG_Shared_Memory(CURRENT_CLIENT_INTERFACE_TYPE);

                        Mem_Ptr : Client_Memory.SHARED_MEMORY_PTR_TYPE;

                        function Convert_Ptr is
                          new Unchecked_Conversion(
                                DG_Client_Interface.CLIENT_INTERFACE_PTR_TYPE,
                                Client_Memory.SHARED_MEMORY_PTR_TYPE);

                     begin  -- Remove_Client_Interface

                        Mem_Ptr := Convert_Ptr(Client_Ptr.Data.Interface);

                        Client_Memory.Unmap_Memory(
                          Mem_Ptr => Mem_Ptr,
                          Status  => Local_Status);

                        if (Local_Status /= DG_Status.SUCCESS) then
                           raise LOCAL_FAILURE;
                        end if;

                     end Remove_Client_Interface;

                     DG_Login_Queue.Send_Server_Info(
                        Server_Info => Server_Info,
                        Client_ID   => Client_Info.Client_ID,
                        Status      => Local_Status);

                     if (Local_Status /= DG_Status.SUCCESS) then
                        raise LOCAL_FAILURE;
                     end if;

                     Client_List.Remove_Node(Client_Ptr);

                     DG_Server_GUI.Interface.Server_Monitor.Number_Of_Clients
                       := DG_Server_GUI.Interface.Server_Monitor.
                            Number_Of_Clients - 1;

                     exit Locate_Client_Loop;

                  end if;

                  Client_Ptr := Client_Ptr.Next;

                  if (Client_Ptr = NULL) then  -- No client info found

                     Status := DG_Status.TRACK_PLQ_UNKNOWN_CLIENT_FAILURE;

                  end if;

               end loop Locate_Client_Loop;

            end Logout_Client_Block;

         end if;  -- (Login_Flag)

      else

         exit Process_Clients_Loop;

      end if;  -- (Login_Present)

   end loop Process_Clients_Loop;

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.TRACK_PLQ_FAILURE;

end Process_Login_Queue;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
