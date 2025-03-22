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
-- PACKAGE NAME     : DG_Login_Queue
--
-- FILE NAME        : DG_Login_Queue.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 27, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with System_V_IPC_Msg;

package body DG_Login_Queue is

   ---------------------------------------------------------------------------
   -- Declare type for passing messages between Clients and Server on the
   -- login message queue.
   ---------------------------------------------------------------------------

   type LOGIN_MESSAGE_TYPE is
     record
       Client_Info : CLIENT_INFO_TYPE;
       Server_Info : SERVER_INFO_TYPE;
     end record;

   ---------------------------------------------------------------------------
   -- Instantiate the generic System V Interprocess Communications package
   -- for use with the login message queue.
   ---------------------------------------------------------------------------

   package Login_IPC is new System_V_IPC_Msg(LOGIN_MESSAGE_TYPE);

   ---------------------------------------------------------------------------
   -- Define constant for the DG Server identifier
   ---------------------------------------------------------------------------

   K_Server_ID : constant := 1;

   ---------------------------------------------------------------------------
   -- Define a constant for the message queue protection value.  This value
   -- is of the same form as the Unix file protection values, and permits
   -- read and write access to the queue by owner, group, and other (i.e.,
   -- by everyone).
   ---------------------------------------------------------------------------

   K_Queue_Protection : constant := 8#666#;

   ---------------------------------------------------------------------------
   -- Declare storage for the message queue identifier.
   ---------------------------------------------------------------------------

   Message_Queue_ID : INTEGER;

   ---------------------------------------------------------------------------
   -- Create_Login_Queue
   ---------------------------------------------------------------------------
   procedure Create_Login_Queue(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Get_Client_Login
   ---------------------------------------------------------------------------
   procedure Get_Client_Login(
      Login_Present : out BOOLEAN;
      Client_Info   : out CLIENT_INFO_TYPE;
      Status        : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Send_Server_Info
   ---------------------------------------------------------------------------
   procedure Send_Server_Info(
      Server_Info : in     SERVER_INFO_TYPE;
      Client_ID   : in     INTEGER;
      Status      :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Remove_Login_Queue
   ---------------------------------------------------------------------------
   procedure Remove_Login_Queue(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Client_Login
   ---------------------------------------------------------------------------
   procedure Client_Login(
      Client_Info : in     CLIENT_INFO_TYPE;
      Server_Info :    out SERVER_INFO_TYPE;
      Status      :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Client_Logout
   ---------------------------------------------------------------------------
   procedure Client_Logout(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

end DG_Login_Queue;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
