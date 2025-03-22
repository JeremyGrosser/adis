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
-- UNIT NAME        : DG_Login_Queue.Client_Login
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 27, 1994
--
-- PURPOSE:
--   - Informs server of client's presence, and obtains information from the
--     server.
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

with DG_IPC_Keys;

separate (DG_Login_Queue)

procedure Client_Login(
   Client_Info : in     CLIENT_INFO_TYPE;
   Server_Info :    out SERVER_INFO_TYPE;
   Status      :    out DG_Status.STATUS_TYPE) is

   Message    : Login_IPC.MSGBUF;  -- Buffer to send/receive message data
   Msg_Status : INTEGER;           -- Status of calls to IPC routines

begin  -- Client_Login

   Status := DG_Status.SUCCESS;

   --
   -- Get access to Server login message queue
   --
   Message_Queue_ID
     := Login_IPC.MsgGet(
           Key    => K_Server_ID,
           MsgFlg => K_Queue_Protection);

   if (Message_Queue_ID < 0) then

      Status := DG_Status.LQ_CLILOGIN_MSGGET_FAILURE;

   else

      Message.MType := K_Server_ID;

      Message.MText.Client_Info := (
        Client_ID            => DG_IPC_Keys.Client.Client_Server_Key,
        Client_Interface_Key => DG_IPC_Keys.Client.Client_Server_Key,
        Client_Semaphore_Key => DG_IPC_Keys.Client.Sync_Semaphore_Key,
        Login_Flag           => TRUE,
        Interface_Info       => Client_Info.Interface_Info);

      Msg_Status
        := Login_IPC.MsgSnd(
             MsQID => Message_Queue_ID,
             MsgP  => Message'ADDRESS);

      if (Msg_Status < 0) then

         Status := DG_Status.LQ_CLILOGIN_MSGSND_FAILURE;

      else

         Msg_Status
           := Login_IPC.MsgRcv(
                MsQID  => Message_Queue_ID,
                MsgP   => Message'ADDRESS,
                MsgTyp => DG_IPC_Keys.Client.Client_Server_Key);

         if (Msg_Status < 0) then

            Status := DG_Status.LQ_CLILOGIN_MSGRCV_FAILURE;

         else

            Server_Info := Message.MText.Server_Info;

         end if;  -- (Msg_Status < 0)

      end if;  -- (Msg_Status < 0)

   end if;  -- (Message_Queue_ID < 0)

exception

   when OTHERS =>

      Status := DG_Status.LQ_CLILOGIN_FAILURE;

end Client_Login;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
