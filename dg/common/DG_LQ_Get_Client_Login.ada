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
-- UNIT NAME        : DG_Login_Queue.Get_Client_Login
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 27, 1994
--
-- PURPOSE:
--   - Returns a flag (Login_Present), indicating if a client is attempting
--     to log into the server.  If Login_Present is TRUE, then Client_Info
--     will contain information for the new client.
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

procedure Get_Client_Login(
   Login_Present : out BOOLEAN;
   Client_Info   : out CLIENT_INFO_TYPE;
   Status        : out DG_Status.STATUS_TYPE) is

   Client_Message : Login_IPC.MSGBUF;
   Msg_Status     : INTEGER;

begin  -- Get_Client_Login

   Status := DG_Status.SUCCESS;

   --
   -- Receive the next message if one is available.  If no message is
   -- available, then immediately continue processing.
   --
   Msg_Status
     := Login_IPC.MsgRcv(
           MsQID  => Message_Queue_ID,
           MsgP   => Client_Message'ADDRESS,
           MsgTyp => K_Server_ID,
           MsgFlg => Login_IPC.IPC_NOWAIT);

   --
   -- Check the status returned by MsgRcv to see if a message was read
   -- (Msg_Status >= 0) or if there was no message ready (Msg_Status = -1).
   --
   if (Msg_Status = -1) then
      Login_Present := FALSE;
   else
      Login_Present := TRUE;
      Client_Info   := Client_Message.MText.Client_Info;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.LQ_GCL_FAILURE;

end Get_Client_Login;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
