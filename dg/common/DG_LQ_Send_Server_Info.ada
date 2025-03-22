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
-- UNIT NAME        : DG_Login_Queue.Send_Server_Info
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 27, 1994
--
-- PURPOSE:
--   - Sends information from the DG Server to the DG Client with the
--     identifier of Client_ID.  This identifier is contained in the
--     Client_Info record returned by the Get_Client_Login procedure.
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

separate (DG_Login_Queue)

procedure Send_Server_Info(
   Server_Info : in     SERVER_INFO_TYPE;
   Client_ID   : in     INTEGER;
   Status      :    out DG_Status.STATUS_TYPE) is

   Send_Status    : INTEGER;
   Server_Message : Login_IPC.MSGBUF;

begin  -- Send_Server_Info

   Status := DG_Status.SUCCESS;

   --
   -- Fill in the message components to respond to the proper Client.
   --
   Server_Message.MType             := Client_ID;
   Server_Message.MText.Server_Info := Server_Info;

   --
   -- Place the message in the message queue.
   --
   Send_Status
     := Login_IPC.MsgSnd(
           MsQID   => Message_Queue_ID,
           MsgP    => Server_Message'ADDRESS);

   if (Send_Status < 0) then
      Status := DG_Status.LQ_SSI_MSGSND_FAILURE;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.LQ_SSI_FAILURE;

end Send_Server_Info;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
