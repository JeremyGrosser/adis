--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--

package OS_Status is

   type STATUS_TYPE is
     (SUCCESS,             -- No error occurred
      DG_ERROR,            -- Error occurred in a DG routine
      DL_ERROR,            -- Error occurred in a DL routine

      -- Active_Frozen_Lists CSC
      LM_ERROR,            -- Error in Link_Munition
      UM_MUNITION_NOT_FOUND_ERROR, -- Munition identified is not found on
                                   -- specified list to be unlinked
      UM_ERROR,            -- Error in Unlink_Munition
      AM_ERROR,            -- Error in Activate_Munition
      DM_ERROR,            -- Error in Deactivate_Munition
      FM_ERROR,            -- Error in Freeze_Munition
      RM_ERROR,            -- Error in Resume_Munition
      CL_ERROR,            -- Error in Clear_List
      FEDBID_ERROR,        -- Error in Find_Entity_Data_By_ID

      -- OS_Hash_Table_Support CSC
      MEHI_ADD_ENTITY_ERROR,    -- An call was made to add an entity to the
                           -- hash table when the entity already existed there 
      MEHI_INFINITE_LOOP_ERROR, -- An infinite loop was detected while
                                -- searching for a hashing index
      MEHI_ERROR,          -- Error in Modify_Entity_Hashing_Index
      REBHI_ERROR,         -- Error in Remove_Entity_by_Hashing_Index

      -- Gateway_Interface CSC
      GESD_ERROR,          -- Error in Get_Entity_State_Data
      GE_ERROR,            -- Error in Get_Events
      PCPDU_ERROR,         -- Error in Process_Collision_PDU
      PDPDU_ERROR,         -- Error in Process_Detonation_PDU
      PFPDU_ERROR,         -- Error in Process_Fire_PDU
      PSMPDU_ERROR,        -- Error in Process_Sim_Mgmt_PDU
      PSRSPDU_ERROR,       -- Error in Process_Start_Resume_Simulation_PDU
      PSFSPDU_ERROR,       -- Error in Process_Stop_Freeze_Simulation_PDU
      PSREPDU_ERROR,       -- Error in Process_Start_Resume_Entity_PDU
      PSFEPDU_ERROR,       -- Error in Process_Stop_Freeze_Entity_PDU
      PREPDU_ERROR,        -- Error in Process_Remove_Entity_PDU
      IAPDU_ERROR,         -- Error in Issue_Acknowledge_PDU
      ICPDU_ERROR,         -- Error in Issue_Collision_PDU
      IDPDU_ERROR,         -- Error in Issue_Detonation_PDU
      IEPDU_ERROR,         -- Error in Issue_Emission_PDU
      IESPDU_ERROR,        -- Error in Issue_Entity_State_PDU
      INP_ERROR,           -- Error in Initialize_Network_Parameters

      -- Simulation_Control CSC
      OS_ERROR,            -- Error in Ordnance Server's control unit
      IS_ERROR,            -- Error in Initialize_Simulation
      OSSGUI_ERROR,        -- Error in OS_Start_GUI
      OSSGUI_EXECVE_ERROR, -- Error occurred when OS_Start_GUI called
                           -- System_Exec.ExecVE

      -- Terrain_Database_Interface CSC
      GHAT_ERROR,          -- Error in Get_Height_Above_Terrain

      -- Munition CSC
      IM_ERROR,            -- Error in Instantiate_Munition
      ARED_ERROR,          -- Error in Add_Related_Entity_Data
      UGUID_ERROR,         -- Error in Update_GUI_Display
      FRED_ERROR,          -- Error in Find_Related_Entity_Data
      FRED_TYPE_DNE_ERROR, -- Entity type does not exist in list searched by
                           -- Find_Related_Entity_Data
      UPM_ERROR,           -- Error in Update_Munition
      UPM_OVERRUN,         -- Timeslice was overrun in Update_Munition

      -- Target_Tracking CSC
      CFPI_ERROR,          -- Error in Check_for_Parent_Illumination
      FCE_ERROR,           -- Error in Find_Closest_Entity
      UT_ERROR,            -- Error in Update_Target
      SFT_ERROR,           -- Error in Search_for_Target

      -- Fly_Out_Model CSC
      IFOM_ERROR,          -- Error in Instantiate_Fly_Out_Model
      MM_ERROR,            -- Error in Move_Munition
      DFFOM_ERROR,         -- Error in DRA_FPW_Fly_Out_Model
      GFOM_ERROR,          -- Error in Generic_Fly_Out_Model
      KFOM_ERROR,          -- Error in Kinematic_Fly_Out_Model
      BRG_ERROR,           -- Error in Beam_Rider_Guidance
      CG_ERROR,            -- Error in Collision_Guidance
      PG_ERROR,            -- Error in Pursuit_Guidance

      -- G_Utilities
      FG_ERROR,            -- Error in Find_G

      -- DCM_Calculations CSC
      CDCM_ERROR,          -- Error in Calculate_DCM
      CEA_VEL_MAG_EQUAL_ZERO_ERROR, -- Velocity magnitude approximates zero and
                           -- would have caused a divide by zero in
                           -- Calculate_Euler_Angles
      CEA_ERROR,           -- Error in Calculate_Euler_Angles
      CFO_ERROR,           -- Error in Calculate_Firing_Orientation
      CIDCM_ERROR,         -- Error in Calculate_Inverse_DCM
      CLVTW_ERROR,         -- Error in Convert_Loc_Vel_to_WorldC
      CELTW_ERROR,         -- Error in Convert_EC_Location_to_WC
      CWLTE_ERROR,         -- Error in Convert_WC_Location_to_EC
      MMAV_ERROR,          -- Error in Multiply_Vector_and_Matrix

      -- Detonation_Event CSC
      CFD_ERROR,           -- Error in Check_for_Detonation
      DDR_ERROR,           -- Error in Determine_Detonation_Result

      -- Configuration_Files CSC
      LCF_ERROR,           -- Error in Load_Configuration_File
      LCF_CANNOT_OPEN_FILE_ERROR, -- Name of the configuration file could not
                                  -- be read
      LCF_INCOMPLETE_LINE_IN_CONFIG_FILE_ERROR, -- Line in config file was
                           -- incomplete and could not be processed
      SCF_ERROR,           -- Error in Save_Configuration_File
      PCD_ERROR,           -- Error in Process_Configuration_Data
      PCD_STRING_NOT_KEYWORD_ERROR, -- String could not be converted to keyword

      -- OS GUI CSC
      MI_ERROR,            -- Error in Map_Interface
      UI_ERROR,            -- Error in Unmap_Interface

      -- OS_Timer CSC
      CT_ERROR,            -- Error in Cancel_Timer
      CT_SETITIMER_FAILED_ERROR,  -- Error occurred when Cancel_Timer called
                           -- System_ITimer.SetITimer
      ST_ERROR,            -- Error in Set_Timer
      ST_SETITIMER_FAILED_ERROR,  -- Error occurred when Set_Timer called
                           -- System_ITimer.SetITimer

      -- Errors CSC
      DDTE_ERROR,          -- Error in Detonate_Due_to_Error
      RE_OVERFLOW_ERROR    -- Error buffer overflowed in Report_Error
      );

end OS_Status;
