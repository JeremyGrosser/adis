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
-- PACKAGE NAME     : DG_Status
--
-- FILE NAME        : DG_Status_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 02, 1994
--
-- PURPOSE:
--   - Defines status codes for the DG CSCI.
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

package DG_Status is

   ---------------------------------------------------------------------------
   --
   -- Define type used to report status of DG calls.  If a call completes
   -- without error, then SUCCESS is returned, otherwise the cause of the
   -- error will be returned.
   --
   ---------------------------------------------------------------------------

   type STATUS_TYPE is (

      ------------------------------------------------------------------------
      -- Success
      ------------------------------------------------------------------------

      SUCCESS,

      ------------------------------------------------------------------------
      -- Hash Table Support
      ------------------------------------------------------------------------

      ENTIDX_LOOP_FAILURE,
      ENTIDX_FAILURE,

      ------------------------------------------------------------------------
      -- DG_Login_Queue
      ------------------------------------------------------------------------

                                          -- Client_Login
      LQ_CLILOGIN_FAILURE,                --   OTHERS exception
      LQ_CLILOGIN_MSGGET_FAILURE,         --   MsgGet call failed
      LQ_CLILOGIN_MSGSND_FAILURE,         --   MsgSnd call failed
      LQ_CLILOGIN_MSGRCV_FAILURE,         --   MsgRcv call failed

                                          -- Client_Logout
      LQ_CLILOGOUT_FAILURE,               --   OTHERS exception
      LQ_CLILOGOUT_MSGSND_FAILURE,        --   MsgSnd call failed
      LQ_CLILOGOUT_MSGRCV_FAILURE,        --   MsgRcv call failed

                                          -- Create_Login_Queue
      LQ_CLQ_FAILURE,                     --   OTHERS exception
      LQ_CLQ_MSGGET_FAILURE,              --   MsgGet call failed

                                          -- Get_Client_Login
      LQ_GCL_FAILURE,                     --   OTHERS exception

                                          -- Remove_Login_Queue
      LQ_RLQ_FAILURE,                     --   OTHERS exception
      LQ_RLQ_MSGCTL_FAILURE,              --   MsgCtl call failed

                                          -- Send_Server_Info
      LQ_SSI_FAILURE,                     --   OTHERS exception
      LQ_SSI_MSGSND_FAILURE,              --   MsgSnd call failed

      ------------------------------------------------------------------------
      -- DG_Shared_Memory
      ------------------------------------------------------------------------

                                          -- Map_Memory
      SM_MAPMEM_FAILURE,                  --   OTHERS exception
      SM_MAPMEM_SHMAT_FAILURE,            --   ShMAt call failed
      SM_MAPMEM_SHMGET_FAILURE,           --   ShMGet call failed

                                          -- Remove_Memory
      SM_REMMEM_FAILURE,                  --   OTHERS exception
      SM_REMMEM_SHMCTL_FAILURE,           --   ShMCtl call failed
      SM_REMMEM_SHMGET_FAILURE,           --   ShMGet call failed

                                          -- Unmap_Memory
      SM_UNMAPMEM_FAILURE,                --   OTHERS exception
      SM_UNMAPMEM_SHMDT_FAILURE,          --   ShMDt call failed

      ------------------------------------------------------------------------
      -- DG_Synchronization
      ------------------------------------------------------------------------

                                          -- Initialize_Client_Synchronization
      SYNC_INITCLI_FAILURE,               --   OTHERS exception
      SYNC_INITCLI_SEMCTL_FAILURE,        --   SemCtl call failed
      SYNC_INITCLI_SEMGET_FAILURE,        --   SemGet call failed

                                          -- Initialize_Server_Synchronization
      SYNC_INISRV_FAILURE,                --   OTHERS exception
      SYNC_INISRV_SEMGET_FAILURE,         --   SemGet call failed

                                          -- Synchronize_Client
      SYNC_CLI_FAILURE,                   --   OTHERS exception
      SYNC_CLI_SEMCTL_FAILURE,            --   SemCtl call failed

                                          -- Synchronize_With_Server
      SYNC_SRV_FAILURE,                   --   OTHERS exception
      SYNC_SRV_SEMCTL_FAILURE,            --   SemCtl call failed
      SYNC_SRV_SEMOP_FAILURE,             --   SemOp call failed

                                          -- Terminate_Client_Synchronization
      SYNC_TERMCLI_FAILURE,               --   OTHERS exception
      SYNC_TERMCLI_SEMCTL_FAILURE,        --   SemCtl call failed

      ------------------------------------------------------------------------
      -- DG_Start_Server_GUI
      ------------------------------------------------------------------------

                                          -- DG_Start_Server_GUI
      DG_SERVER_GUI_FAILURE,              --   OTHERS exception
      DG_SERVER_GUI_EXECVE_FAILURE,       --   ExecVE call failed

      ------------------------------------------------------------------------
      -- DG_Start_Client_GUI
      ------------------------------------------------------------------------

                                          -- DG_Start_Client_GUI
      DG_CLIENT_GUI_FAILURE,              --   OTHERS exception
      DG_CLIENT_GUI_EXECVE_FAILURE,       --   ExecVE call failed

      ------------------------------------------------------------------------
      -- DG_Timer
      ------------------------------------------------------------------------

                                          -- Change_Timer
      TIMER_CHANGE_FAILURE,               --   OTHERS exception
      TIMER_CHANGE_SETITIMER_FAILURE,     --   SetITimer call failed

                                          -- Initialize_Timer
      TIMER_INIT_FAILURE,                 --   OTHERS exception
      TIMER_INIT_SETITIMER_FAILURE,       --   SetITimer call failed

                                          -- Synchronize
      TIMER_SYNC_FAILURE,                 --   OTHERS exception

                                          -- Terminate_Timer
      TIMER_TERM_FAILURE,                 --   OTHERS exception
      TIMER_TERM_SETITIMER_FAILURE,       --   SetITimer call failed

                                          -- SIGALRM_Handler
      TIMER_SIGALRM_FAILURE,              --   OTHERS exception
      TIMER_SIGALRM_SETITIMER_FAILURE,    --   SetITimer call failed

      ------------------------------------------------------------------------
      -- DG_Client_Tracking
      ------------------------------------------------------------------------

                                          -- Process_Login_Queue
      TRACK_PLQ_FAILURE,                  --   OTHERS exception
      TRACK_PLQ_UNKNOWN_CLIENT_FAILURE,   --   Logout by unknown client

                                          -- Add_Client
      TRACK_ADD_FAILURE,                  --   OTHERS exception

                                          -- Remove_Client
      TRACK_REM_FAILURE,                  --   OTHERS exception
      TRACK_REM_UNKNOWN_CLIENT,           --   Client not found in list

                                          -- Synchronize_Clients
      TRACK_SYNC_FAILURE,                 --   OTHERS exception

                                          -- Shutdown_Clients
      TRACK_SHUTDOWN_FAILURE,             --   OTHERS exception

                                          -- Process_Client_Interfaces
      TRACK_PCI_FAILURE,                  --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_PDU_Buffer
      ------------------------------------------------------------------------

                                          -- Read
      PB_READ_FAILURE,                    --   OTHERS exception

                                          -- Add
      PB_ADD_FAILURE,                     --   OTHERS exception
      PB_ADD_PDU_TOO_BIG_FAILURE,         --   PDU larger than buffer

      ------------------------------------------------------------------------
      -- DG_Server_Interface
      ------------------------------------------------------------------------

                                          -- Map_Interface
      SVRIF_MAP_FAILURE,                  --   OTHERS exception

                                          -- Unmap_Interface
      SVRIF_UNMAP_FAILURE,                --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_Client_Interface
      ------------------------------------------------------------------------

                                          -- Map_Interface
      CLIIF_MAP_FAILURE,                  --   OTHERS exception

                                          -- Unmap_Interface
      CLIIF_UNMAP_FAILURE,                --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_Client
      ------------------------------------------------------------------------

                                          -- Synchronize_With_Server
      CLI_SYNC_FAILURE,                   --   OTHERS exception
      CLI_SYNC_SHUTDOWN,                  --   Server commanding shutdown

                                          -- Terminate_Server_Interface
      CLI_TSI_FAILURE,                    --   OTHERS exception

                                          -- Get_Next_PDU
      CLI_GNP_FAILURE,                    --   OTHERS exception

                                          -- Get_Entity_Info
      CLI_GEI_FAILURE,                    --   OTHERS exception
      CLI_GEI_ENTITY_NOT_FOUND_FAILURE,   --   Entity ID not found

                                          -- Get_Entity_List
      CLI_GEL_FAILURE,                    --   OTHERS exception

                                          -- Client_Connected
      CLI_CONNECT_FAILURE,                --   OTHERS exception

                                          -- Initialize_Client
      CLI_INI_FAILURE,                    --   OTHERS exception
      CLI_INI_LOGIN_DENIED_FAILURE,       --   Server did not permit login

                                          -- Send_PDU
      CLI_SEND_FAILURE,                   --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_Server_GUI
      ------------------------------------------------------------------------

                                          -- Map_Interface
      SRVGUI_MI_FAILURE,                  --   OTHERS exception

                                          -- Unmap_Interface
      SRVGUI_UI_FAILURE,                  --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_Client_GUI
      ------------------------------------------------------------------------

                                          -- Map_Interface
      CLIGUI_MI_FAILURE,                  --   OTHERS exception

                                          -- Unmap_Interface
      CLIGUI_UI_FAILURE,                  --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_Network_Interface_Support
      ------------------------------------------------------------------------

                                          -- Establish_Network_Interface
      NIS_ENI_FAILURE,                    --   OTHERS exception
      NIS_ENI_SOCKET_FAILURE,             --   Socket call failed
      NIS_ENI_SETSOCKOPT_FAILURE,         --   SetSockOpt call failed
      NIS_ENI_FCNTL_SETOWN_FAILURE,       --   FCntl(F_SETOWN) call failed
      NIS_ENI_FCNTL_SETFL_FAILURE,        --   FCntl(F_SETFL) call failed
      NIS_ENI_BIND_FAILURE,               --   Bind call failed

                                          -- Terminate_Network_Interface
      NIS_TNI_FAILURE,                    --   OTHERS exception
      NIS_TNI_CLOSE_FAILURE,              --   Close call failed

                                          -- Receive_PDU
      NIS_RCVPDU_FAILURE,                 --   OTHERS exception
      NIS_RCVPDU_RECVFROM_FAILURE,        --   RecvFrom call failed

                                          -- Transmit_PDU
      NIS_TXPDU_FAILURE,                  --   OTHERS exception
      NIS_TXPDU_SENDTO_FAILURE,           --   SendTo call failed

      ------------------------------------------------------------------------
      -- DG_Dead_Reckoning_Support
      ------------------------------------------------------------------------

                                          -- Update_Entity_Positions
      DRS_EEP_FAILURE,                    --   OTHERS exception
      DRS_EEP_UPDATE_POSITION_FAILURE,    --   DL Update_Position call failed

      ------------------------------------------------------------------------
      -- DG_Filter_PDU
      ------------------------------------------------------------------------

                                          -- DG_Filter_PDU
      FILTER_FAILURE,                     --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_Simulation_Management
      ------------------------------------------------------------------------

                                          -- Store_Emitter_Data
      SIMMGMT_STREMIT_FAILURE,            --   OTHERS exception
      SIMMGMT_STREMIT_NO_ENTITY_FAILURE,  --   Emitter's entity unknown
      SIMMGMT_STREMIT_TABLE_FULL,         --   Emitter hash table full

                                          -- Store_Entity_Data
      SIMMGMT_STRENTITY_FAILURE,          --   OTHERS exception
      SIMMGMT_STRENTITY_TABLE_FULL,       --   Entity hash table full

                                          -- Store_Laser_Data
      SIMMGMT_STRLAS_FAILURE,             --   OTHERS exception
      SIMMGMT_STRLAS_NO_ENTITY_FAILURE,   --   Laser's entity unknown
      SIMMGMT_STRLAS_TABLE_FULL,          --   Laser hash table full

                                          -- Store_Receiver_Data
      SIMMGMT_STRREC_FAILURE,             --   OTHERS exception
      SIMMGMT_STRREC_NO_ENTITY_FAILURE,   --   Receiver's entity unknown
      SIMMGMT_STRREC_TABLE_FULL,          --   Receiver hash table full

                                          -- Store_Simulation_Data
      SIMMGMT_STRSIM_FAILURE,             --   OTHERS exception
      SIMMGMT_STRSIM_UNKNOWN_PDU_FAILURE, --   Unrecognized/unhandled PDU

                                          -- Store_Transmitter_Data
      SIMMGMT_STRTRAN_FAILURE,            --   OTHERS exception
      SIMMGMT_STRTRAN_NO_ENTITY_FAILURE,  --   Transmitter's entity unknown
      SIMMGMT_STRTRAN_TABLE_FULL,         --   Transmitter hash table full

      ------------------------------------------------------------------------
      -- DG_Remove_Expired_Entities
      ------------------------------------------------------------------------

                                          -- DG_Remove_Expired_Entities
      REE_FAILURE,                        --   OTHERS exception

      ------------------------------------------------------------------------
      -- DG_Configuration_File_Management
      ------------------------------------------------------------------------

                                          -- Load_Configuration_File
      CFM_LCF_FAILURE,                    --   OTHERS exception
      CFM_LCF_VALUE_MISSING_FAILURE,      --   No value in line
      CFM_LCF_EQUAL_MISSING_FAILURE,      --   No "=" in line
      CFM_LCF_KEYWORD_MISSING_FAILURE,    --   No keyword in line
      CFM_LCF_INVALID_FILENAME_FAILURE,   --   Invalid config filename

      ------------------------------------------------------------------------
      -- DG_Server_Configuration_File_Management
      ------------------------------------------------------------------------

                                          -- Save_Configuration_File
      SRVCFM_SCF_FAILURE,                 --   OTHERS exception

                                          -- Process_Server_Configuration_Data
      SRVCFM_PSCD_FAILURE,                --   OTHERS exception
      SRVCFM_PSCD_KEYWORD_FAILURE,        --   Invalid keyword detected

      ------------------------------------------------------------------------
      -- DG_Client_Configuration_File_Management
      ------------------------------------------------------------------------

                                          -- Save_Configuration_File
      CLICFM_SCF_FAILURE,                 --   OTHERS exception

                                          -- Process_Client_Configuration_Data
      CLICFM_PCCD_FAILURE,                --   OTHERS exception
      CLICFM_PCCD_KEYWORD_FAILURE,        --   Invalid keyword detected

      ------------------------------------------------------------------------
      -- DG_Generic_Error_Processing
      ------------------------------------------------------------------------

                                          -- Report_Error
      GEP_RE_OVERFLOW,                    --   Error queue overflow

      ------------------------------------------------------------------------
      -- DG_Server
      ------------------------------------------------------------------------

                                          -- DG_Server
      SRV_OVERRUN,                        --   Timeslice exceeded

      ------------------------------------------------------------------------
      -- Placeholder (developmental use ONLY!)
      ------------------------------------------------------------------------

      DG_PLACEHOLDER_ERROR);

   ---------------------------------------------------------------------------
   -- Success
   ---------------------------------------------------------------------------
   --
   -- Purpose : Tests a status value to see if it is SUCCESS.
   --
   -- Returns : TRUE  if Status is equal to SUCCESS.
   --           FALSE otherwise.
   --
   ---------------------------------------------------------------------------

   function Success(Status : in STATUS_TYPE)
     return BOOLEAN;

   ---------------------------------------------------------------------------
   -- Failure
   ---------------------------------------------------------------------------
   --
   -- Purpose : Tests a status value to see if it is not SUCCESS.
   --
   -- Returns : FALSE if Status is equal to SUCCESS.
   --           TRUE  otherwise.
   --
   ---------------------------------------------------------------------------

   function Failure(Status : in STATUS_TYPE)
     return BOOLEAN;

end DG_Status;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
