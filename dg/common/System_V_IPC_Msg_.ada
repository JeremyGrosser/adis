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
-- PACKAGE NAME     : System_V_IPC_Msg
--
-- FILE NAME        : System_V_IPC_Msg_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 26, 1994
--
-- PURPOSE:
--   - This package defines types and imports system routines to permit
--     access to the System V Interprocess Communication (IPC) message
--     queue mechanism.
--
-- EFFECTS:
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

with Numeric_Types,
     System;

generic

   type MESSAGE_TEXT is limited private;

package System_V_IPC_Msg is

   --
   -- Define IPC key type
   --
   -- Note:  Based on key_t in <sys/types.h>
   --
   subtype KEY_T is INTEGER;

   IPC_PRIVATE : constant KEY_T := 0;  -- private key

   --
   -- Define message queue permission type
   --
   -- Note:  Based on struct ipc_perm in <sys/ipc.h>
   --
   type IPC_PERM is
   record
      UID  : Numeric_Types.UNSIGNED_16_BIT;  -- owner's user id
      GID  : Numeric_Types.UNSIGNED_16_BIT;  -- owner's group id
      CUID : Numeric_Types.UNSIGNED_16_BIT;  -- creator's user id
      CGID : Numeric_Types.UNSIGNED_16_BIT;  -- creator's group id
      Mode : Numeric_Types.UNSIGNED_16_BIT;  -- access modes
      Seq  : Numeric_Types.UNSIGNED_16_BIT;  -- slot usage sequence number
      Key  : KEY_T;                          -- key
   end record;

   --
   -- Define core address type
   --
   -- Note:  Based on caddr_t in <sys/types.h>
   --
   subtype CADDR_T is System.ADDRESS;

   --
   -- Define message type
   --
   -- Note:  Based on struct msg in <sys/msg.h>
   --
   type MSG;

   type MSG_PTR is access MSG;

   type MSG is
   record
      Msg_Next  : MSG_PTR;                        -- ptr to next message on q
      Msg_Type  : Numeric_Types.UNSIGNED_32_BIT;  -- message type
      Msg_TS    : SHORT_INTEGER;                  -- message text size
      Msg_Spot  : CADDR_T;                        -- message text map address
   end record;

   --
   -- Define time type
   --
   subtype TIME_T is Numeric_Types.UNSIGNED_32_BIT;

   --
   -- Define message queue ID descriptor
   --
   -- Note:  Based on struct msqid_ds in <sys/msg.h>
   --
   type MSQID_DS is
   record
      Msg_Perm   : IPC_PERM;  -- Operation permission
      Msg_First  : MSG_PTR;   -- Ptr to first message on q
      Msg_Last   : MSG_PTR;   -- Ptr to last message on q
      Msg_CBytes : Numeric_Types.UNSIGNED_16_BIT;  -- Current # bytes on q
      Msg_QNum   : Numeric_Types.UNSIGNED_16_BIT;  -- # of messages on q
      Msg_QBytes : Numeric_Types.UNSIGNED_16_BIT;  -- max # of bytes on q
      Msg_LSPID  : Numeric_Types.UNSIGNED_16_BIT;  -- pid of last msgsnd
      Msg_LRPID  : Numeric_Types.UNSIGNED_16_BIT;  -- pid of last msgrcv
      Msg_STime  : TIME_T;  -- last msgsnd time
      Msg_RTime  : TIME_T;  -- last msgrcv time
      Msg_CTime  : TIME_T;  -- last change time
   end record;

   --
   -- Import the msgget routine
   --
   -- Note:  Based on manpage for msgget
   --
   -- Purpose - get message queue
   --
   -- Returns - message queue identifier associated with Key, or -1 on error
   --
   function MsgGet(
      Key    : in KEY_T;
      MsgFlg : in INTEGER) return INTEGER;

   pragma INTERFACE(C, MsgGet);

   --
   -- Define IPC control command type
   --
   -- Note:  Based on constants defined in <ipc.h>
   --
   type IPC_CONTROL_COMMAND is (
      IPC_RMID,   -- remove identifier
      IPC_SET,    -- set options
      IPC_STAT);  -- get options

   for IPC_CONTROL_COMMAND use (
      IPC_RMID => 10,
      IPC_SET  => 11,
      IPC_STAT => 12);

   --
   -- Import the msgctl routine
   --
   -- Note:  Based on manpage for msgctl
   --
   -- Purpose  - message control operations
   --
   -- Commands -
   --
   --   IPC_STAT - Place the current value of each member of the data
   --              structure associated with MsQID into the structure pointed
   --              to by Buf.
   --   IPC_SET  - Set the value of the following members of the data
   --              structure associated with MsQID to the corresponding value
   --              found in the structure pointed to by Buf:
   --                  Msg_Perm.UID
   --                  Msg_Perm.GID
   --                  Msg_Perm.Mode (only low 9 bits)
   --                  Msg_QBytes
   --   IPC_RMID - Remove the message queue identifier specified by MsQID
   --              from the system and destroy the message queue and data
   --              structure associated with it.
   --
   -- Returns - 0 if successful, -1 if error occurred
   --
   function MsgCtl(
      MsQID    : in INTEGER;
      Cmd      : in IPC_CONTROL_COMMAND;
      MsQID_DS : in System.ADDRESS := System.NO_ADDR)  -- MSQID_DS'ADDRESS
     return INTEGER;

   pragma INTERFACE(C, MsgCtl);

   --
   -- Define message buffer type
   --
   -- Note:  Based on struct msgbuf in <sys/msg.h>
   --
   type MSGBUF is
   record
      MType : INTEGER;       -- message type
      MText : MESSAGE_TEXT;  -- message text
   end record;

   --
   -- Define modifiers for MsgFlg in MsgSnd() and MsgRcv()
   --
   -- Note:  Based on constants in <sys/ipc.h>
   --
   IPC_ALLOC  : constant INTEGER := 8#0100000#;  -- entry currently allocated
   IPC_CREAT  : constant INTEGER := 8#0001000#;  -- create entry if no key
                                                 --   exists
   IPC_EXCL   : constant INTEGER := 8#0002000#;  -- fail if key exists
   IPC_NOWAIT : constant INTEGER := 8#0004000#;  -- error if request must wait

   --
   -- Import the msgsnd routine
   --
   -- Note:  Based on manpage for msgsnd
   --
   -- Purpose - send a message to the queue associated with the message queue
   --           identifier specified by MsQID.
   --
   -- Returns - 0 on successful completion, -1 on error
   --
   function MsgSnd(
      MsQID  : in INTEGER;
      MsgP   : in System.ADDRESS;  -- MSGBUF'ADDRESS
      MsgSz  : in INTEGER := (MESSAGE_TEXT'SIZE+7)/8;
      MsgFlg : in INTEGER := 0)
     return INTEGER;

   pragma INTERFACE(C, MsgSnd);

   --
   -- Import the msgrcv routine
   --
   -- Note:  Based on manpage for msgrcv
   --
   -- Purpose - reads a message from the queue associated with the message
   --           queue identifier specified by MsQID and places it in the
   --           structure pointed to by MsgP.
   --
   -- Returns - 0 on successful completion, -1 on error
   --
   function MsgRcv(
      MsQID  : in INTEGER;
      MsgP   : in System.ADDRESS;  -- MSGBUF'ADDRESS
      MsgSz  : in INTEGER  := (MESSAGE_TEXT'SIZE+7)/8;
      MsgTyp : in INTEGER := 0;
      MsgFlg : in INTEGER  := 0)
     return INTEGER;

   pragma INTERFACE(C, MsgRcv);

end System_V_IPC_Msg;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
