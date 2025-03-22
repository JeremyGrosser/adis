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
-- PACKAGE NAME     : System_V_IPC_ShMem
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 02, 1994
--
-- PURPOSE:
--   - This package defines types and imports system routines to permit
--     access to the System V Interprocess Communication (IPC) shared
--     memory mechanism.
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

   type MEMORY_AREA_TYPE is limited private;

package System_V_IPC_ShMem is

   --
   -- Define an access type for the memory area type
   --
   type AREA_ACCESS_TYPE is access MEMORY_AREA_TYPE;

   --
   -- Define IPC key type
   --
   -- Note:  Based on key_t in <sys/types.h>
   --
   subtype KEY_T is INTEGER;

   IPC_PRIVATE : constant KEY_T := 0;  -- private key

   --
   -- Define process ID type
   --
   -- Note:  Based on pid_t in <sys/types.h>
   --
   subtype PID_T is INTEGER;

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
                                                 -- exists
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
   -- Define time type
   --
   subtype TIME_T is INTEGER;

   --
   -- Define shared memory ID data structure
   --
   -- Note:  Based on struct shmid_ds in <sys/shm.h>
   --
   type SHMID_DS is
     record
       ShM_Perm     : IPC_PERM;        -- operation permission struct
       ShM_SegSz    : INTEGER;         -- size of segment in bytes
       ShM_Reg      : System.ADDRESS;  -- ptr to region structure
       Pad          : STRING(1..4);    -- for swap compatibility
       ShM_LPID     : PID_T;           -- pid of last shmop
       ShM_CPID     : PID_T;           -- pid of creator
       ShM_NAttach  : Numeric_Types.UNSIGNED_32_BIT;  -- used only for shminfo
       ShM_CNAttach : Numeric_Types.UNSIGNED_32_BIT;  -- used only for shminfo
       ShM_ATime    : TIME_T;   -- last shmat time
       ShM_Pad1     : INTEGER;  -- reserved for time_t expansion
       ShM_DTime    : TIME_T;   -- last shmdt time
       ShM_Pad2     : INTEGER;  -- reserved for time_t expansion
       ShM_CTime    : TIME_T;   -- last change time
       ShM_Pad3     : INTEGER;  -- reserved for time_t expansion
       ShM_Pad4_1   : INTEGER;  -- reserve area
       ShM_Pad4_2   : INTEGER;  -- reserve area
       ShM_Pad4_3   : INTEGER;  -- reserve area
       ShM_Pad4_4   : INTEGER;  -- reserve area
     end record;

   --
   -- Import the shmget routine
   --
   -- Note:  Based on manpage for shmget
   --
   -- Purpose - get shared memory segment identifier
   --
   -- Returns - shared memory identifier associated with Key, or -1 on error
   --
   function ShMGet(
      Key    : in KEY_T;
      Size   : in INTEGER := (MEMORY_AREA_TYPE'SIZE+7)/8;
      ShMFlg : in INTEGER := 0)
     return INTEGER;

   pragma INTERFACE(C, ShMGet);

   --
   -- Import the shmat routine
   --
   -- Note:  Based on manpage for shmat
   --
   -- Purpose - attaches the shared memory segment associated with the shared
   --           memory identifier specified by ShMID to the data segment of
   --           the calling process.
   --
   -- Returns - Pointer to new memory area
   --
   function ShMAt(
      ShMID   : in INTEGER;
      ShMAddr : in AREA_ACCESS_TYPE := NULL;
      ShMFlg  : in INTEGER := 0)
     return AREA_ACCESS_TYPE;

   pragma INTERFACE(C, ShMAt);

   --
   -- Import the shmdt routine
   --
   -- Note:  Based on manpage for shmdt
   --
   -- Purpose - detaches from the calling process's data segment the shared
   --           memory segment located at the address specified by ShMAddr.
   --
   -- Returns - 0 if successful, -1 if error occurred.
   --
   function ShMDt(
      ShMAddr : in AREA_ACCESS_TYPE)
     return INTEGER;

   pragma INTERFACE(C, ShMDt);

   --
   -- Import the shmctl routine
   --
   -- Note:  Based on manpage for shmctl
   --
   -- Purpose  - shared memory control operations
   --
   -- Commands -
   --
   --   IPC_STAT   - Place the current value of each member of the data
   --                structure associated with ShMID into the structure
   --                pointed to by Buf.
   --   IPC_SET    - Set the value of the following members of the data
   --                structure associated with ShMID to the corresponding
   --                value found in the structure pointed to by Buf:
   --                    ShM_Perm.UID
   --                    ShM_Perm.GID
   --                    ShM_Perm.Mode (only access permission bits)
   --   IPC_RMID   - Remove the shared memory identifier specified by ShMID
   --                from the system and destroy the shared memory segment and
   --                data structure associated with it.
   --   SHM_LOCK   - Lock the shared memory segment specified by ShMID in
   --                memory.
   --   SHM_UNLOCK - Unlock the shared memory segment specified by ShMID.
   --
   -- Returns - 0 if successful, -1 if error occurred.
   --
   function ShMCtl(
      ShMID : in INTEGER;
      Cmd   : in IPC_CONTROL_COMMAND;
      Buf   : in System.ADDRESS := System.NO_ADDR)  -- SHMID_DS'ADDRESS
     return INTEGER;

   pragma INTERFACE(C, ShMCtl);

end System_V_IPC_ShMem;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
