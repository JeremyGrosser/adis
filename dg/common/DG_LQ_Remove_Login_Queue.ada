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
-- UNIT NAME        : DG_Login_Queue.Remove_Login_Queue
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 27, 1994
--
-- PURPOSE:
--   - Removes the DG Server's login message queue.  Any pending requests
--     are discarded.
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

procedure Remove_Login_Queue(
   Status : out DG_Status.STATUS_TYPE) is

   Ctl_Status : INTEGER;

begin  -- Remove_Login_Queue

   Status := DG_Status.SUCCESS;

   Ctl_Status
      := Login_IPC.MsgCtl(
            MsQID => Message_Queue_ID,
            Cmd   => Login_IPC.IPC_RMID);

   if (Ctl_Status = -1) then
      Status := DG_Status.LQ_RLQ_MSGCTL_FAILURE;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.LQ_RLQ_FAILURE;

end Remove_Login_Queue;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
