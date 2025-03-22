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
-- PACKAGE NAME     : DG_Status_Message
--
-- FILE NAME        : DG_Status_Message_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : September 9, 1994
--
-- PURPOSE:
--   - 
--
-- EFFECTS:
--   - The expected usage is:
--     1. 
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

with DG_Status;

package DG_Status_Message is

   --
   -- Declare the error messages associated with each of the DG status codes
   --

   type STRING_PTR is access STRING;

   type DG_STATUS_MESSAGE_TYPE is
     array (DG_Status.STATUS_TYPE) of STRING_PTR;

   Error_Message : DG_STATUS_MESSAGE_TYPE := (

     ------------------------------------------------------------------------
     -- Success
     ------------------------------------------------------------------------

     DG_Status.SUCCESS => new STRING'(
       "Success"),

     ------------------------------------------------------------------------
     -- Hash Table Support
     ------------------------------------------------------------------------

     DG_Status.ENTIDX_LOOP_FAILURE => new STRING'(
       "Hash table is full in Entity_Hash_Index"),
     DG_Status.ENTIDX_FAILURE => new STRING'(
       "An unidentified error occurred in Entity_Hash_Index"),

     ------------------------------------------------------------------------
     -- DG_Login_Queue
     ------------------------------------------------------------------------

     DG_Status.LQ_CLILOGIN_FAILURE => new STRING'(
       "An unidentified error occurred in Client_Login"),
     DG_Status.LQ_CLILOGIN_MSGGET_FAILURE => new STRING'(
       "An error occurred calling the system msgget() routine in"
         & " Client_Login"),
     DG_Status.LQ_CLILOGIN_MSGSND_FAILURE => new STRING'(
       "An error occurred calling the system msgsnd() routine in"
         & " Client_Login"),
     DG_Status.LQ_CLILOGIN_MSGRCV_FAILURE => new STRING'(
       "An error occurred calling the system msgrcv() routine in"
         & " Client_Login"),

     DG_Status.LQ_CLILOGOUT_FAILURE => new STRING'(
       "An unidentified error occurred in Client_Logout"),
     DG_Status.LQ_CLILOGOUT_MSGSND_FAILURE => new STRING'(
       "An error occurred calling the system msgsnd() routine in"
         & " Client_Logout"),
     DG_Status.LQ_CLILOGOUT_MSGRCV_FAILURE => new STRING'(
       "An error occurred calling the system msgrcv() routine in"
         & " Client_Logout"),

     DG_Status.LQ_CLQ_FAILURE => new STRING'(
       "An unidentified error occurred in Create_Login_Queue"),
     DG_Status.LQ_CLQ_MSGGET_FAILURE => new STRING'(
       "An error occurred calling the system msgget() routine in"
         & " Create_Login_Queue"),

     DG_Status.LQ_GCL_FAILURE => new STRING'(
       "An unidentified error occurred in Get_Client_Login"),

     DG_Status.LQ_RLQ_FAILURE => new STRING'(
       "An unidentified error occurred in Remove_Login_Queue"),
     DG_Status.LQ_RLQ_MSGCTL_FAILURE => new STRING'(
       "An error occurred calling the system msgctl() routine in"
         & " Remove_Login_Queue"),

     DG_Status.LQ_SSI_FAILURE => new STRING'(
       "An unidentified error occurred in Send_Server_Info"),
     DG_Status.LQ_SSI_MSGSND_FAILURE => new STRING'(
       "An error occurred calling the system msgsnd() routine in"
         & " Send_Sever_Info"),

     ------------------------------------------------------------------------
     -- DG_Shared_Memory
     ------------------------------------------------------------------------

     DG_Status.SM_MAPMEM_FAILURE => new STRING'(
       "An unidentified error occurred in Map_Memory"),
     DG_Status.SM_MAPMEM_SHMAT_FAILURE => new STRING'(
       "An error occurred calling the system shmat() routine in Map_Memory"),
     DG_Status.SM_MAPMEM_SHMGET_FAILURE => new STRING'(
       "An error occurred calling the system shmget() routine in Map_Memory"),

     DG_Status.SM_REMMEM_FAILURE => new STRING'(
       "An unidentified error occurred in Remove_Memory"),
     DG_Status.SM_REMMEM_SHMCTL_FAILURE => new STRING'(
       "An error occurred calling the system shmctl() routine in"
         & " Remove_Memory"),
     DG_Status.SM_REMMEM_SHMGET_FAILURE => new STRING'(
       "An error occurred calling the system shmget() routine in"
         & " Remove_Memory"),

     DG_Status.SM_UNMAPMEM_FAILURE => new STRING'(
       "An unidentified error occurred in Unmap_Memory"),
     DG_Status.SM_UNMAPMEM_SHMDT_FAILURE => new STRING'(
       "An error occurred calling the system shmdt() routine in"
         & " Unmap_Memory"),

     ------------------------------------------------------------------------
     -- DG_Synchronization
     ------------------------------------------------------------------------

     DG_Status.SYNC_INITCLI_FAILURE => new STRING'(
       "An unidentified error occurred calling"
         & " Initialize_Client_Synchronization"),
     DG_Status.SYNC_INITCLI_SEMCTL_FAILURE => new STRING'(
       "An error occurred calling the system semctl() routine in"
         & " Initialize_Client_Synchronization"),
     DG_Status.SYNC_INITCLI_SEMGET_FAILURE => new STRING'(
       "An error occurred calling the system semget() routine in"
         & " Initialize_Client_Synchronization"),

     DG_Status.SYNC_INISRV_FAILURE => new STRING'(
       "An unidentified error occurred calling"
         & " Initialize_Server_Synchronization"),
     DG_Status.SYNC_INISRV_SEMGET_FAILURE => new STRING'(
       "An error occurred calling the system semget() routine in"
         & " Initialize_Server_Synchronization"),

     DG_Status.SYNC_CLI_FAILURE => new STRING'(
       "An unidentified error occurred calling Synchronize_Client"),
     DG_Status.SYNC_CLI_SEMCTL_FAILURE => new STRING'(
       "An error occurred calling the system semctl() routine in"
         & " Synchronize_Client"),

     DG_Status.SYNC_SRV_FAILURE => new STRING'(
       "An unidentified error occurred calling Synchronize_With_Server"),
     DG_Status.SYNC_SRV_SEMCTL_FAILURE => new STRING'(
       "An error occurred calling the system semctl() routine in"
         & " Synchronize_With_Server"),
     DG_Status.SYNC_SRV_SEMOP_FAILURE => new STRING'(
       "An error occurred calling the system semop() routine in"
         & " Synchronize_With_Server"),

     DG_Status.SYNC_TERMCLI_FAILURE => new STRING'(
       "An unidentified error occurred calling"
         & " Terminate_Client_Synchronization"),
     DG_Status.SYNC_TERMCLI_SEMCTL_FAILURE => new STRING'(
       "An error occurred calling the system semctl() routine in"
         & " Terminate_Client_Synchronization"),

     ------------------------------------------------------------------------
     -- DG_Start_Server_GUI
     ------------------------------------------------------------------------

     DG_Status.DG_SERVER_GUI_FAILURE => new STRING'(
       "An unidentified error occurred calling DG_Start_Server_GUI"),
     DG_Status.DG_SERVER_GUI_EXECVE_FAILURE => new STRING'(
       "An error occurred calling the system execve() routine in"
         & " DG_Start_Server_GUI"),

     ------------------------------------------------------------------------
     -- DG_Start_Client_GUI
     ------------------------------------------------------------------------

     DG_Status.DG_CLIENT_GUI_FAILURE => new STRING'(
       "An unidentified error occurred calling DG_Client_Start_GUI"),
     DG_Status.DG_CLIENT_GUI_EXECVE_FAILURE => new STRING'(
       "An error occurred calling the system execve() routine in"
         & " DG_Client_Server_GUI"),

     ------------------------------------------------------------------------
     -- DG_Timer
     ------------------------------------------------------------------------

     DG_Status.TIMER_CHANGE_FAILURE => new STRING'(
       "An unidentified error occurred calling Change_Timer"),
     DG_Status.TIMER_CHANGE_SETITIMER_FAILURE => new STRING'(
       "An error occurred calling the system setitimer() routine in"
         & " Change_Timer"),

     DG_Status.TIMER_INIT_FAILURE => new STRING'(
       "An unidentified error occurred calling Initialize_Timer"),
     DG_Status.TIMER_INIT_SETITIMER_FAILURE => new STRING'(
       "An error occurred calling the system setitimer() routine in"
         & " Initialize_Timer"),

     DG_Status.TIMER_SYNC_FAILURE => new STRING'(
       "An unidentified error occurred calling Synchronize"),

     DG_Status.TIMER_TERM_FAILURE => new STRING'(
       "An unidentified error occurred calling Terminate_Timer"),
     DG_Status.TIMER_TERM_SETITIMER_FAILURE => new STRING'(
       "An error occurred calling the system setitimer() routine in"
         & " Terminate_Timer"),

     DG_Status.TIMER_SIGALRM_FAILURE => new STRING'(
       "An unidentified error occurred in SIGALRM_Handler"),
     DG_Status.TIMER_SIGALRM_SETITIMER_FAILURE => new STRING'(
       "An error occurred calling the system setitimer() routine in"
         & " SIGALRM_Handler"),

     ------------------------------------------------------------------------
     -- DG_Client_Tracking
     ------------------------------------------------------------------------

     DG_Status.TRACK_PLQ_FAILURE => new STRING'(
       "An unidentified error occurred in Process_Login_Queue"),
     DG_Status.TRACK_PLQ_UNKNOWN_CLIENT_FAILURE => new STRING'(
       "A logout message was received for an unknown client in"
         & " Process_Logout_Queue"),

     DG_Status.TRACK_ADD_FAILURE => new STRING'(
       "An unidentified error occurred in Add_Client"),

     DG_Status.TRACK_REM_FAILURE => new STRING'(
       "An unidentified error occurred in Remove_Client"),
     DG_Status.TRACK_REM_UNKNOWN_CLIENT => new STRING'(
       "An attempt was made to remove an unknown client in Remove_Client"),

     DG_Status.TRACK_SYNC_FAILURE => new STRING'(
       "An unidentified error occurred in Synchronize_Clients"),

     DG_Status.TRACK_SHUTDOWN_FAILURE => new STRING'(
       "An unidentified error occurred in Shutdown_Clients"),

     DG_Status.TRACK_PCI_FAILURE => new STRING'(
       "An unidentified error occurred in Process_Client_Interfaces"),

     ------------------------------------------------------------------------
     -- DG_PDU_Buffer
     ------------------------------------------------------------------------

     DG_Status.PB_READ_FAILURE => new STRING'(
       "An unidentified error occurred in Read"),

     DG_Status.PB_ADD_FAILURE => new STRING'(
       "An unidentified error occurred in Add"),
     DG_Status.PB_ADD_PDU_TOO_BIG_FAILURE => new STRING'(
       "Add could not put the PDU in the buffer because it the PDU is"
         & " larger than the buffer is"),

     ------------------------------------------------------------------------
     -- DG_Server_Interface
     ------------------------------------------------------------------------

     DG_Status.SVRIF_MAP_FAILURE => new STRING'(
       "An unidentified error occurred in the Server's Map_Interface"),

     DG_Status.SVRIF_UNMAP_FAILURE => new STRING'(
       "An unidentified error occurred in the Server's Unmap_Interface"),

     ------------------------------------------------------------------------
     -- DG_Client_Interface
     ------------------------------------------------------------------------

     DG_Status.CLIIF_MAP_FAILURE => new STRING'(
       "An unidentified error occurred in the Client's Map_Interface"),

     DG_Status.CLIIF_UNMAP_FAILURE => new STRING'(
       "An unidentified error occurred in the Client's Unmap_Interface"),

     ------------------------------------------------------------------------
     -- DG_Client
     ------------------------------------------------------------------------

     DG_Status.CLI_SYNC_FAILURE => new STRING'(
       "An unidentified error occurred in Synchronize_With_Server"),

     DG_Status.CLI_SYNC_SHUTDOWN => new STRING'(
       "The Client was commanded to shut down by either the Server or the"
         & " Client's GUI"),

     DG_Status.CLI_TSI_FAILURE => new STRING'(
       "An unidentified error occurred in Terminate_Server_Interface"),

     DG_Status.CLI_GNP_FAILURE => new STRING'(
       "An unidentified error occurred in Get_Next_PDU"),

     DG_Status.CLI_GEI_FAILURE => new STRING'(
       "An unidentified error occurred in Get_Entity_Information"),
     DG_Status.CLI_GEI_ENTITY_NOT_FOUND_FAILURE => new STRING'(
       "An unknown entity ID was given to Get_Entity_Information"),

     DG_Status.CLI_GEL_FAILURE => new STRING'(
       "An unidentified error occurred in Get_Entity_List"),

     DG_Status.CLI_CONNECT_FAILURE => new STRING'(
       "An unidentified error occurred in Client_Connected"),

     DG_Status.CLI_INI_FAILURE => new STRING'(
       "An unidentified error occurred in Initialize_Client"),
     DG_Status.CLI_INI_LOGIN_DENIED_FAILURE => new STRING'(
       "The Server denied the Client's login attempt in Initialize_Client"),

     DG_Status.CLI_SEND_FAILURE => new STRING'(
       "An unidentified error occurred in Send"),

     ------------------------------------------------------------------------
     -- DG_Server_GUI
     ------------------------------------------------------------------------

     DG_Status.SRVGUI_MI_FAILURE => new STRING'(
       "An unidentified error occurred in the Server's GUI Map_Interface"),

     DG_Status.SRVGUI_UI_FAILURE => new STRING'(
       "An unidentified error occurred in the Server's GUI Unmap_Interface"),

     ------------------------------------------------------------------------
     -- DG_Client_GUI
     ------------------------------------------------------------------------

     DG_Status.CLIGUI_MI_FAILURE => new STRING'(
       "An unidentified error occurred in the Client's GUI Map_Interface"),

     DG_Status.CLIGUI_UI_FAILURE => new STRING'(
       "An unidentified error occurred in the Client's GUI Unmap_Interface"),

     ------------------------------------------------------------------------
     -- DG_Network_Interface_Support
     ------------------------------------------------------------------------

     DG_Status.NIS_ENI_FAILURE => new STRING'(
       "An unidentified error occurred in Establish_Network_Interface"),
     DG_Status.NIS_ENI_SOCKET_FAILURE => new STRING'(
       "An error occurred calling the system socket() routine in"
         & " Establish_Network_Interface"),
     DG_Status.NIS_ENI_SETSOCKOPT_FAILURE => new STRING'(
       "An error occurred calling the system setsockopt() routine in"
         & " Establish_Network_Interface"),
     DG_Status.NIS_ENI_FCNTL_SETOWN_FAILURE => new STRING'(
       "An error occurred calling the system fcntl() routine with SETOWN in"
         & " Establish_Network_Interface"),
     DG_Status.NIS_ENI_FCNTL_SETFL_FAILURE => new STRING'(
       "An error occurred calling the system fcntl() routine with SETFL in"
         & " Establish_Network_Interface"),
     DG_Status.NIS_ENI_BIND_FAILURE => new STRING'(
       "An error occurred calling the system bind() routine in"
         & " Establish_Network_Interface"),

     DG_Status.NIS_TNI_FAILURE => new STRING'(
       "An unidentified error occurred in Terminate_Network_Interface"),
     DG_Status.NIS_TNI_CLOSE_FAILURE => new STRING'(
       "An error occurred calling the system close() routien in"
         & " Terminate_Network_Interface"),

     DG_Status.NIS_RCVPDU_FAILURE => new STRING'(
       "An unidentified error occurred in Receive_PDU"),
     DG_Status.NIS_RCVPDU_RECVFROM_FAILURE => new STRING'(
       "An error occurred calling the system recvfrom() routine in"
         & " Receive_PDU"),

     DG_Status.NIS_TXPDU_FAILURE => new STRING'(
       "An unidentified error occurred in Transmit_PDU"),
     DG_Status.NIS_TXPDU_SENDTO_FAILURE => new STRING'(
       "An error occurred calling the system sendto() routine in"
         & " Transmit_PDU"),

     ------------------------------------------------------------------------
     -- DG_Dead_Reckoning_Support
     ------------------------------------------------------------------------

     DG_Status.DRS_EEP_FAILURE => new STRING'(
       "An unidentified error occurred in Update_Entity_Position"),
     DG_Status.DRS_EEP_UPDATE_POSITION_FAILURE => new STRING'(
       "An error occurred calling the DL Update_Position routine in"
         & " Update_Entity_Position"),

     ------------------------------------------------------------------------
     -- DG_Filter_PDU
     ------------------------------------------------------------------------

     DG_Status.FILTER_FAILURE => new STRING'(
       "An unidentified error occurred in DG_Filter_PDU"),

     ------------------------------------------------------------------------
     -- DG_Simulation_Management
     ------------------------------------------------------------------------

     DG_Status.SIMMGMT_STREMIT_FAILURE => new STRING'(
       "An unidentified error occurred in Store_Emitter_Data"),
     DG_Status.SIMMGMT_STREMIT_NO_ENTITY_FAILURE => new STRING'(
       "No associated entity was found for the emitter in"
         & " Store_Emitter_Data"),
     DG_Status.SIMMGMT_STREMIT_TABLE_FULL => new STRING'(
       "Store_Emitter_Data was unable to save an emitter because the hash"
         & " table was full"),

     DG_Status.SIMMGMT_STRENTITY_FAILURE => new STRING'(
       "An unidentified error occurred in Store_Entity_Data"),
     DG_Status.SIMMGMT_STRENTITY_TABLE_FULL => new STRING'(
       "Store_Entity_Data was unable to save an entity because the hash"
         & " table was full"),

     DG_Status.SIMMGMT_STRLAS_FAILURE => new STRING'(
       "An unidentified error occurred in Store_Laser_Data"),
     DG_Status.SIMMGMT_STRLAS_NO_ENTITY_FAILURE => new STRING'(
       "No associated entity was found for the laser in"
         & " Store_Laser_Data"),
     DG_Status.SIMMGMT_STRLAS_TABLE_FULL => new STRING'(
       "Store_Laser_Data was unable to save a laser because the hash table"
         & " was full"),

     DG_Status.SIMMGMT_STRREC_FAILURE => new STRING'(
       "An unidentified error occurred in Store_Receiver_Data"),
     DG_Status.SIMMGMT_STRREC_NO_ENTITY_FAILURE => new STRING'(
       "No associated entity was found for the receiver in"
         & " Store_Receiver_Data"),
     DG_Status.SIMMGMT_STRREC_TABLE_FULL => new STRING'(
       "Store_Receiver_Data was unable to save a receiver because the hash"
         & " table was full"),

     DG_Status.SIMMGMT_STRSIM_FAILURE => new STRING'(
       "An unidentified error occurred in Store_Simulation_Data"),
     DG_Status.SIMMGMT_STRSIM_UNKNOWN_PDU_FAILURE => new STRING'(
       "An event-type PDU was discarded by Store_Simulation_Data"),

     DG_Status.SIMMGMT_STRTRAN_FAILURE => new STRING'(
       "An unidentified error occurred in Store_Transmitter_Data"),
     DG_Status.SIMMGMT_STRTRAN_NO_ENTITY_FAILURE => new STRING'(
       "No associated entity was found for the transmitter because the hash"
         & " Store_Transmitter_Data"),
     DG_Status.SIMMGMT_STRTRAN_TABLE_FULL => new STRING'(
       "Store_Transmitter_Data was unable to save a transmitter because the"
         & " hash table was full"),

     ------------------------------------------------------------------------
     -- DG_Remove_Expired_Entities
     ------------------------------------------------------------------------

     DG_Status.REE_FAILURE => new STRING'(
       "An unidentified error occurred in DG_Remove_Expired_Entities"),

     ------------------------------------------------------------------------
     -- DG_Configuration_File_Management
     ------------------------------------------------------------------------

     DG_Status.CFM_LCF_FAILURE => new STRING'(
       "An unidentified error occurred in Load_Configuration_File"),
     DG_Status.CFM_LCF_VALUE_MISSING_FAILURE => new STRING'(
       "Load_Configuration_File discarded an entry because it is missing a"
         & " value"),
     DG_Status.CFM_LCF_EQUAL_MISSING_FAILURE => new STRING'(
       "Load_Configuration_File discarded an entry because it is missing"
         & "the '='"),
     DG_Status.CFM_LCF_KEYWORD_MISSING_FAILURE => new STRING'(
       "Load_Configuration_File discarded an entry because it is missing a"
         & " keyword"),
     DG_Status.CFM_LCF_INVALID_FILENAME_FAILURE => new STRING'(
       "Load_Configuration_File was called with a non-existent filename"),

     ------------------------------------------------------------------------
     -- DG_Server_Configuration_File_Management
     ------------------------------------------------------------------------

     DG_Status.SRVCFM_SCF_FAILURE => new STRING'(
       "An unidentified error occurred in the Server's"
         & " Save_Configuration_File"),

     DG_Status.SRVCFM_PSCD_FAILURE => new STRING'(
       "An unidentified error occurred in"
         & " Process_Server_Configuration_File"),
     DG_Status.SRVCFM_PSCD_KEYWORD_FAILURE => new STRING'(
       "An invalid keyword was detected in"
         & " Process_Server_Configuration_File"),

     ------------------------------------------------------------------------
     -- DG_Client_Configuration_File_Management
     ------------------------------------------------------------------------

     DG_Status.CLICFM_SCF_FAILURE => new STRING'(
       "An unidentified error occurred in the Client's"
         & " Save_Configuration_File"),

     DG_Status.CLICFM_PCCD_FAILURE => new STRING'(
       "An unidentified error occurred in"
         & " Process_Client_Configuration_File"),
     DG_Status.CLICFM_PCCD_KEYWORD_FAILURE => new STRING'(
       "An invalid keyword was detected in"
         & " Process_Client_Configuration_File"),

     ------------------------------------------------------------------------
     -- DG_Generic_Error_Processing
     ------------------------------------------------------------------------

     DG_Status.GEP_RE_OVERFLOW => new STRING'(
       "An error buffer overflow was detected in Read_Error"),

     ------------------------------------------------------------------------
     -- DG_Server
     ------------------------------------------------------------------------

     DG_Status.SRV_OVERRUN => new STRING'(
       "The DG Server was unable to complete its processing within a"
         & " timeslice"),

     ------------------------------------------------------------------------
     -- Placeholder (developmental use ONLY!)
     --
     -- Adding errors to this package forces a recompilation of virtually
     -- *all* the DG code.  Since this can take considerable time, the
     -- DG_PLACEHOLDER_ERROR can be used as a temporary error value in
     -- routines under development.  Once all the new routines are compiled
     -- and tested, appropriate errors can be added to this package, the
     -- DG_PLACEHOLDER_ERRORs removed from the new code, and the entire DG
     -- recompiled.
     ------------------------------------------------------------------------

     DG_Status.DG_PLACEHOLDER_ERROR => new STRING'(
       "DG_PLACEHOLDER_ERROR - This is for developmental use ONLY!"));

end DG_Status_Message;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
