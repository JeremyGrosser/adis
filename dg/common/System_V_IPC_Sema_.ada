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
-- PACKAGE NAME     : System_V_IPC_Sema
--
-- FILE NAME        : System_V_IPC_Sema_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 10, 1994
--
-- PURPOSE:
--   - This package defines types and imports system routines to permit
--     access to the System V Interprocess Communication (IPC) semaphore
--     mechanism.
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

package System_V_IPC_Sema is

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
   -- Define modifiers for ShMFlg parameter
   --
   -- Note:  Based on constants in <sys/ipc.h>
   --
   IPC_ALLOC  : constant INTEGER := 8#0100000#;  -- entry currently allocated
   IPC_CREAT  : constant INTEGER := 8#0001000#;  -- create entry if no key
                                                 --   exists
   IPC_EXCL   : constant INTEGER := 8#0002000#;  -- fail if key exists
   IPC_NOWAIT : constant INTEGER := 8#0004000#;  -- error if request must wait

   K_Global_Read_Write : constant := 8#666#;  -- Read and write access for
                                              -- user, group, and other
                                              -- processes

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
   -- Define base size type
   --
   -- Note:  Based on size_t in <sys/types.h>
   --
   subtype SIZE_T is INTEGER;

   --
   -- Define time type
   --
   subtype TIME_T is INTEGER;

   --
   -- Define semaphore ID data structure
   --
   -- Note:  Based on struct semid_ds in <sys/sem.h>
   --
   type SEMID_DS is
     record
       Sem_Perm   : IPC_PERM;        -- operation permission struct
       Sem_Base   : System.ADDRESS;  -- ptr to first semaphore in set
       Sem_NSems  : Numeric_Types.UNSIGNED_16_BIT; -- # of semaphores in set
       Sem_OTime  : TIME_T;   -- last semop time
       Sem_Pad1   : INTEGER;  -- reserved for time_t expansion
       Sem_CTime  : TIME_T;   -- last change time
       Sem_Pad2   : INTEGER;  -- time_t expansion
       Sem_Pad3_1 : INTEGER;  -- reserve area
       Sem_Pad3_2 : INTEGER;  -- reserve area
       Sem_Pad3_3 : INTEGER;  -- reserve area
       Sem_Pad3_4 : INTEGER;  -- reserve area
     end record;

   ---------------------------------------------------------------------------
   -- SemGet
   ---------------------------------------------------------------------------
   -- Purpose: Get set of semaphores
   ---------------------------------------------------------------------------

   function SemGet(
      Key    : in KEY_T;
      NSems  : in INTEGER;
      SemFlg : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, SemGet);

   ---------------------------------------------------------------------------
   -- SemCtl
   ---------------------------------------------------------------------------
   -- Purpose: Semaphore control operations
   ---------------------------------------------------------------------------

   type SEMCTL_COMMAND_TYPE is (
     GETNCNT,    -- Get semncnt        from <sys/sem.h>
     GETPID,     -- Get sempid                "
     GETVAL,     -- Get semval                "
     GETALL,     -- Get all semvals           "
     GETZCNT,    -- Get semzcnt               "
     SETVAL,     -- Set semval                "
     SETALL,     -- Set all semvals           "
     IPC_RMID,   -- Remove identifier  from <sys/ipc.h>
     IPC_SET,    -- Set options               "
     IPC_STAT);  -- Get options               "

   for SEMCTL_COMMAND_TYPE use (
     GETNCNT  => 3,
     GETPID   => 4,
     GETVAL   => 5,
     GETALL   => 6,
     GETZCNT  => 7,
     SETVAL   => 8,
     SETALL   => 9,
     IPC_RMID => 10,
     IPC_SET  => 11,
     IPC_STAT => 12);

   function SemCtl(
      SemID  : in INTEGER;
      SemNum : in INTEGER;
      Cmd    : in SEMCTL_COMMAND_TYPE;
      ArgVal : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, SemCtl);

   ---------------------------------------------------------------------------
   -- SemOp
   ---------------------------------------------------------------------------
   -- Purpose: Semaphore operations
   ---------------------------------------------------------------------------

   --
   -- Define semaphore operation structure
   --
   -- Note:  Based on struct sembuf in <sys/sem.h>
   --
   type SEMBUF is
     record
       SemNum  : Numeric_Types.UNSIGNED_16_BIT;
       Sem_Op  : SHORT_INTEGER;
       Sem_Flg : SHORT_INTEGER;
     end record;

   function SemOp(
      SemID : in INTEGER;
      SOps  : in System.ADDRESS;  -- SEMBUF'ADDRESS
      NSOps : in SIZE_T)
     return INTEGER;

   pragma INTERFACE(C, SemOp);

end System_V_IPC_Sema;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
