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
-- UNIT NAME        : DG_Login_Queue.Create_Login_Queue
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 27, 1994
--
-- PURPOSE:
--   - Establishes the DG Server's login message queue.
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

procedure Create_Login_Queue(
   Status : out DG_Status.STATUS_TYPE) is

begin  -- Create_Login_Queue

   Status := DG_Status.SUCCESS;

   --
   -- Create a messsage queue which everyone can read and write to.
   --
   Message_Queue_ID
     := Login_IPC.MsgGet(
           Key    => K_Server_ID,
           MsgFlg => Login_IPC.IPC_CREAT + K_Queue_Protection);

   --
   -- Check for any errors in creating the queue.
   --
   if (Message_Queue_ID < 0) then
      Status := DG_Status.LQ_CLQ_MSGGET_FAILURE;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.LQ_CLQ_FAILURE;

end Create_Login_Queue;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
