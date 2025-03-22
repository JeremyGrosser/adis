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
-- UNIT NAME        : DG_Login_Queue.Client_Logout
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 09, 1994
--
-- PURPOSE:
--   - Informs server that the client is logging out.
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

procedure Client_Logout(
   Status      :    out DG_Status.STATUS_TYPE) is

   Client_ID  : INTEGER;
   Message    : Login_IPC.MSGBUF;  -- Buffer to send/receive message data
   Msg_Status : INTEGER;

begin  -- Client_Logout

   Status := DG_Status.SUCCESS;

   --
   -- Get process ID for use as unique Client identifier
   --
   Client_ID := DG_IPC_Keys.Client.Client_Server_Key;

   --
   -- Fill in the message information for a client logout message
   --
   Message.MType                        := K_Server_ID;
   Message.MText.Client_Info.Client_ID  := Client_ID;
   Message.MText.Client_Info.Login_Flag := FALSE;

   Msg_Status
     := Login_IPC.MsgSnd(
          MsQID => Message_Queue_ID,
          MsgP  => Message'ADDRESS);

   if (Msg_Status < 0) then

      Status := DG_Status.LQ_CLILOGOUT_MSGSND_FAILURE;

   else

      --
      -- Wait for acknowledgement from server
      --
      Msg_Status
        := Login_IPC.MsgRcv(
             MsQID  => Message_Queue_ID,
             MsgP   => Message'ADDRESS,
             MsgTyp => Client_ID);

      if (Msg_Status < 0) then
         Status := DG_Status.LQ_CLILOGOUT_MSGRCV_FAILURE;
      end if;

   end if;  -- (Msg_Status < 0)

exception

   when OTHERS =>

      Status := DG_Status.LQ_CLILOGOUT_FAILURE;

end Client_Logout;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
