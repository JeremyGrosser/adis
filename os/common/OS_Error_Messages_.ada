--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_Error_Messages 
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  22 July 94
--
-- PURPOSE :
--   - This package defines the error message to be displayed to the user.  The
--     error message indicates whether the munition was detonated prematurely
--     to handle the error.
--
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with Errors,
     OS_Data_Types,
     OS_Status;

package OS_Error_Messages is

   -- Rename function
   function "+" (RIGHT :  STRING)
     return OS_Data_Types.V_STRING
     renames Errors."+";

   -- Define error mesages for each status
   K_Error_Message :  constant OS_Data_Types.ERROR_MESSAGE_ARRAY := (
   OS_Status.SUCCESS  => +"No error occurred",
   OS_Status.DG_ERROR => +"An error occurred in a DG routine called by the OS",
   OS_Status.DL_ERROR => +"An error occurred in a DL routine called by the OS",

   OS_Status.LM_ERROR =>
     +"An undefined error occurred in Link_Munition",
   OS_Status.UM_MUNITION_NOT_FOUND_ERROR =>
     +"The munition identified is not found on the specified list to be unlinked in Unlink_Munition",
   OS_Status.UM_ERROR =>
     +"An undefined error occurred in Unlink_Munition",
   OS_Status.AM_ERROR =>
     +"An undefined error occurred in Activate_Munition",
   OS_Status.DM_ERROR =>
     +"An undefined error occurred in Deactivate_Munition",
   OS_Status.FM_ERROR =>
     +"An undefined error occurred in Freeze_Munition",
   OS_Status.RM_ERROR =>
     +"An undefined error occurred in Resume_Munition",
   OS_Status.CL_ERROR =>
     +"An undefined error occurred in Clear_List",
   OS_Status.FEDBID_ERROR =>
     +"An undefined error occurred in Find_Entity_Data_By_ID",

   OS_Status.MEHI_ADD_ENTITY_ERROR =>
     +"A call was made to Modify_Entity_Hashing_Index to add an entity to the munition hash table, but the entity was already in the hash table",
   OS_Status.MEHI_INFINITE_LOOP_ERROR =>
     +"An infinite loop was detected while searching for a hashing index in Modify_Entity_Hashing_Index",
   OS_Status.MEHI_ERROR =>
     +"An undefined error occurred in Modify_Entity_Hashing_Index",
   OS_Status.REBHI_ERROR =>
     +"An undefined error occurred in Remove_Entity_By_Hashing_Index",

   OS_Status.GESD_ERROR =>
     +"An undefined error occurred in Get_Entity_State_Data",
   OS_Status.GE_ERROR =>
     +"An undefined error occurred in Get_Events",
   OS_Status.PCPDU_ERROR =>
     +"An undefined error occurred in Process_Collision_PDU",
   OS_Status.PDPDU_ERROR =>
     +"An undefined error occurred in Process_Detonation_PDU",
   OS_Status.PFPDU_ERROR =>
     +"An undefined error occurred in Process_Fire_PDU",
   OS_Status.PSMPDU_ERROR =>
     +"An undefined error occurred in Process_Sim_Mgmt_PDU",
   OS_Status.PSRSPDU_ERROR =>
     +"An undefined error occurred in Process_Start_Resume_Simulation_PDU",
   OS_Status.PSFSPDU_ERROR =>
     +"An undefined error occurred in Process_Stop_Freeze_Simulation_PDU",
   OS_Status.PSREPDU_ERROR =>
     +"An undefined error occurred in Process_Start_Resume_Entity_PDU",
   OS_Status.PSFEPDU_ERROR =>
     +"An undefined error occurred in Process_Stop_Freeze_Entity_PDU",
   OS_Status.PREPDU_ERROR =>
     +"An undefined error occurred in Process_Remove_Entity_PDU",
   OS_Status.IAPDU_ERROR =>
     +"An undefined error occurred in Issue_Acknowledge_PDU",
   OS_Status.ICPDU_ERROR =>
     +"An undefined error occurred in Issue_Collision_PDU",
   OS_Status.IDPDU_ERROR =>
     +"An undefined error occurred in Issue_Detonation_PDU",
   OS_Status.IEPDU_ERROR =>
     +"An undefined error occurred in Issue_Emission_PDU",
   OS_Status.IESPDU_ERROR =>
     +"An undefined error occurred in Issue_Entity_State_PDU",
   OS_Status.INP_ERROR =>
     +"An undefined error occurred in Initialize_Network_Parameters",

   OS_Status.OS_ERROR =>
     +"An undefined error occurred in OS (Ordnance Server)",
   OS_Status.IS_ERROR =>
     +"An undefined error occurred in Initialize_Simulation",
   OS_Status.OSSGUI_ERROR =>
     +"An undefined error occurred in OS_Start_GUI",
   OS_Status.OSSGUI_EXECVE_ERROR =>
     +"An error occurred when OS_Start_GUI called System_Exec.ExecVE",

   OS_Status.GHAT_ERROR =>
     +"An undefined error occurred in Get_Height_Above_Terrain",

   OS_Status.IM_ERROR =>
     +"An undefined error occurred in Instantiate_Munition",
   OS_Status.ARED_ERROR =>
     +"An undefined error occurred in Add_Related_Entity_Data",
   OS_Status.UGUID_ERROR =>
     +"An undefined error occurred in Update_GUI_Display",
   OS_Status.FRED_ERROR =>
     +"An undefined error occurred in Find_Related_Entity_Data",
   OS_Status.FRED_TYPE_DNE_ERROR =>
     +"Entity type does not exist in list searched by Find_Related_Entity_Data",
   OS_Status.UPM_ERROR =>
     +"An undefined error occurred in Update_Munition",
   OS_Status.UPM_OVERRUN =>
     +"The timeslice was exceeded in Update_Munition, but processing is continuing smoothly",

   OS_Status.MI_ERROR =>
     +"An undefined error occurred in Map_Interface",
   OS_Status.UI_ERROR =>
     +"An undefined error occurred in Unmap_Interface",

   OS_Status.CFPI_ERROR =>
     +"An undefined error occurred in Check_for_Parent_Illumination",
   OS_Status.FCE_ERROR =>
     +"An undefined error occurred in Find_Closest_Entities",
   OS_Status.UT_ERROR =>
     +"An undefined error occurred in Update_Target",
   OS_Status.SFT_ERROR =>
     +"An undefined error occurred in Search_for_Target",

   OS_Status.IFOM_ERROR =>
     +"An undefined error occurred in Instantiate_Fly_Out_Model",
   OS_Status.MM_ERROR =>
     +"An undefined error occurred in Move_Munition",
   OS_Status.DFFOM_ERROR =>
     +"An undefined error occurred in DRA_FPW_Fly_Out_Model",
   OS_Status.GFOM_ERROR =>
     +"An undefined error occurred in Generic_Fly_Out_Model",
   OS_Status.KFOM_ERROR =>
     +"An undefined error occurred in Kinematic_Fly_Out_Model",
   OS_Status.BRG_ERROR =>
     +"An undefined error occurred in Beam_Rider_Guidance",
   OS_Status.CG_ERROR =>
     +"An undefined error occurred in Collision_Guidance",
   OS_Status.PG_ERROR =>
     +"An undefined error occurred in Pursuit_Guidance",

   OS_Status.FG_ERROR =>
     +"An undefined error occurred in Find_G",

   OS_Status.CDCM_ERROR =>
     +"An undefined error occurred in Calculate_DCM",
   OS_Status.CEA_VEL_MAG_EQUAL_ZERO_ERROR =>
     +"Velocity magnitude approximates zero and would have caused a divide by zero error in Calculate_Euler_Angles",
   OS_Status.CEA_ERROR =>
     +"An undefined error occurred in Calculate_Euler_Angles",
   OS_Status.CFO_ERROR =>
     +"An undefined error occurred in Calculate_Firing_Orientation",
   OS_Status.CIDCM_ERROR =>
     +"An undefined error occurred in Calculate_Inverse_DCM",
   OS_Status.CLVTW_ERROR =>
     +"An undefined error occurred in Convert_Loc_Vel_to_WorldC",
   OS_Status.CELTW_ERROR =>
     +"An undefined error occurred in Convert_EC_Location_to_WC",
   OS_Status.CWLTE_ERROR =>
     +"An undefined error occurred in Convert_WC_Location_to_EC",
   OS_Status.MMAV_ERROR =>
     +"An undefined error occurred in Multiply_Vector_and_Matrix",

   OS_Status.CFD_ERROR =>
     +"An undefined error occurred in Check_for_Detonation",
   OS_Status.DDR_ERROR =>
     +"An undefined error occurred in Determine_Detonation_Result",

   OS_Status.LCF_ERROR =>
     +"An undefined error occurred in Load_Configuration_File",
   OS_Status.LCF_CANNOT_OPEN_FILE_ERROR =>
     +"Specified file in Load_Configuration_File could not be opened",
   OS_Status.LCF_INCOMPLETE_LINE_IN_CONFIG_FILE_ERROR =>
     +"An incomplete line exists in the configuration file being read by Load_Configuration_File",
   OS_Status.SCF_ERROR =>
     +"An undefined error occurred in Save_Configuration_File",
   OS_Status.PCD_ERROR =>
     +"An undefined error occurred in Process_Configuration_Data",
   OS_Status.PCD_STRING_NOT_KEYWORD_ERROR =>
     +"String in configuration file is not identified as a keyword by Process_Configuration_Data",

   OS_Status.CT_ERROR =>
     +"An undefined error occurred in Cancel_Timer",
   OS_Status.CT_SETITIMER_FAILED_ERROR =>
     +"An error occurred when Cancel_Timer called System_ITimer.SetITimer",
   OS_Status.ST_ERROR =>
     +"An undefined error occurred in Set_Timer",
   OS_Status.ST_SETITIMER_FAILED_ERROR =>
     +"An error occurred when Set_Timer called System_ITimer.SetITimer",

   OS_Status.DDTE_ERROR =>
     +"An undefined error occurred in Detonate_Due_to_Error",
   OS_Status.RE_OVERFLOW_ERROR =>
     +"The error was not placed on the queue because the queue is full in Report_Error");

end OS_Error_Messages;
