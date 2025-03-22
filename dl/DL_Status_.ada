--=============================================================================
--                                UNCLASSIFIED
--
-- *==========================================================================*
-- |                                                                          |
-- |                       Manned Flight Simulator                            |
-- |               Naval Air Warfare Center Aircraft Division                 |
-- |                       Patuxent River, Maryland                           |
-- *==========================================================================*
--
--=============================================================================
--
-- Package Name:       DL_Status
--
-- File Name:          DL_Status_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc
--
-- Origination Date:   May 20, 1994
--
-- Purpose
--
--    Defines an error status code for each of the units in the DL CSCI.
-- 
--				 		
-- Effects:
--	None
--
-- Exceptions:
--	None
--
-- Portability Issues:
--	None
--
-- Anticipated Changes:
--	None
--
--=============================================================================	

package DL_Status is

   type STATUS_TYPE is (
 
     SUCCESS,                      -- default
                                   -- 
                                   --   * Calculate Package * 
                                   --
     CALC_AZ_AND_EL_FAILURE,       -- AZ_And_El unit
     CALC_AZIMUTH_FAILURE,         -- Azimuth unit
     CALC_DISTANCE_FAILURE,        -- Distance unit
     CALC_ELEVATION_FAILURE,       -- Elevation unit
     CALC_VELOCITY_FAILURE,        -- Velocity unit
     CALCULATE_AZ_FAILURE,         -- Calculate_Azimuth unit
     CALCULATE_EL_FAILURE,         -- Calculate_Elevation unit
                                   --
                                   --   * Coordinate_Conversions Package *
                                   -- 
     GCC_GDC_FAILURE,              -- Geocentric_To_Geodetic_Conversion unit
     GCC_ENT_FAILURE,              -- Geocentric_To_Entity_Conversion unit
     GCC_ENT_VEL_FAILURE,          -- Geocentric_To_Entity_Vel_Conversion unit
     GCC_LOC_FAILURE,              -- Geocentric_To_Local_Conversion unit   
     GCC_LOC_M_FAILURE,            -- Geocentric_To_Local_In_Meters_Conversion unit
     GDC_GCC_FAILURE,              -- Geodetic_To_Geocentric_Conversion unit
     GDC_LOC_FAILURE,              -- Geodetic_To_Local_Conversion unit
     ENT_GCC_FAILURE,              -- Entity_To_Geocentric_Conversion unit
     ENT_GCC_VEL_FAILURE,          -- Entity_To_Geocentric_Vel_Conversion unit 
     LOC_GCC_FAILURE,              -- Local_To_Geocentric_Conversion unit 
     LOC_GDC_FAILURE,              -- Local_To_Geodetic_Conversion unit    
                                   -- 
                                   --   * Orientation_Conversions Package *
                                   --
     EUL_ORI_FAILURE,              -- Euler_To_Orientation_Conversion unit
     ORI_EUL_FAILURE,              -- Orientation_To_Euler_Conversion unit
                                   --
                                   --   * Dead_Reckoning Package *
                                   --
     DR_FPW_FAILURE,               -- DRM_FPW unit
     DR_FVW_FAILURE,               -- DRM_FVW unit
     DR_RPW_FAILURE,               -- DRM_RPW unit
     DR_RVW_FAILURE,               -- DRM_RVW unit
     DR_ROTATE_FAILURE,            -- Rotate_Entity
     DR_UDRP_FAILURE,              -- Update_Dead_Reckoned_Position unit
                                   -- 
                                   --   * Filter Package *
                                   --
     FILT_AZ_FAILURE,              -- Azimuth unit
     FILT_AZ_AND_EL_FAILURE,       -- Az_And_El unit
     FILT_DIST_FAILURE,            -- Distance unit
     FILT_EL_FAILURE,              -- Elevation unit
     FILT_MAX_VEL_FAILURE,         -- Maximum_Velocity unit
     FILT_MIN_VEL_FAILURE,         -- Minimum_Velocity unit
                                   --
                                   --   * Filter_By_PDU_Components Package *
                                   --
     FILT_PDU_AZ_AND_EL_FAILURE,   -- Az_And_El unit
                                   --
                                   --   * Filter_List Package *
                                   --
     FILT_AZ_EL_ENT_ST_FAILURE,    -- Entitiy_State_Az_And_El unit
                                   --
                                   --           (Azimuth)  
                                   --
     FILT_AZ_DETON_FAILURE,        -- Detonation_Az unit
     FILT_AZ_ENT_ST_FAILURE,       -- Entity_State_Az unit
     FILT_AZ_FIRE_FAILURE,         -- Fire_AZ unit
                                   --           (Distance)
   
     FILT_DIST_DETON_FAILURE,      -- Detonation_Distance unit
     FILT_DIST_ENT_ST_FAILURE,     -- Entity_State_Distance unit
     FILT_DIST_FIRE_FAILURE,       -- Fire_Distance unit
     FILT_DIST_LASER_FAILURE,      -- Laser_Distance unit
     FILT_DIST_TRANS_FAILURE,      -- Transmitter_Distance unit
                                   --
                                   --            (Elevation)
                                   --
     FILT_EL_DETON_FAILURE,        -- Detonation_El unit
     FILT_EL_ENT_ST_FAILURE,       -- Entity_State_El unit
     FILT_EL_FIRE_FAILURE,         -- Fire_El unit
                                   --
                                   --            (Velocity)
                                   -- 
     FILT_MAX_VEL_ENT_ST_FAILURE,  -- Entity_State_Max_Velocity unit
     FILT_MIN_VEL_ENT_ST_FAILURE,  -- Entity_State_Min_Velocity unit
                                   --
                                   -- * Generic_List package
                                   --
     GEN_LIST_FAILURE,             -- Raised if unhandled Ada exception raised
                                   -- 
                                   --   * Generic_List_Utilities package
     LIST_IS_NULL,                 --
     POSITION_ERROR,               --
     NOT_AT_END,                   --
     NOT_AT_HEAD,                  --
     OVERFLOW,                     --
     ITEM_NOT_FOUND,               --
                                   -- 
     APPEND_LIST_FAILURE,          -- Append_List unit
     ASSIGN_ITEM_FAILURE,          -- Assign_Item unit
     CHANGE_ITEM_FAILURE,          -- Change_The_Item unit
     CHECK_AT_END_FAILURE,         -- Check_At_End unit
     CHECK_AT_HEAD_FAILURE,        -- Check_At_Head unit
     CHECK_LIST_EQUAL_FAILURE,     -- Check_List_Equal unit
     CHECK_NULL_FAILURE,           -- Check_Null unit
     CLEAR_LIST_FAILURE,           -- Clear_The_List unit
     CLEAR_PREVIOUS_FAILURE,       -- Clear_Previous_Ptr unit
     CLEAR_NEXT_FAILURE,           -- Clear_Next_Ptr unit
     CLEAR_NODE_FAILURE,           -- Clear_The_Node unit
     COPY_LIST_FAILURE,            -- Copy_List unit 
     DELETE_ITEM_FAILURE,          -- Delete_Item unit
     DELETE_FREE_ITEM_FAILURE,     -- Delete_Item_And_Free_Storage unit
     FIND_POSITION_OF_FAILURE,     -- Find_Position_Of_Item unit
     FREE_LIST_FAILURE,            -- Free_List unit
     FREE_NODE_FAILURE,            -- Free_Node unit
     GET_FIRST_ITEM_FAILURE,       -- Get_First_Item unit
     GET_LAST_ITEM_FAILURE,        -- Get_Last_Item unit
     GLU_GET_ITEM_FAILURE,         -- Get_Item unit
     GET_PREVIOUS_FAILURE,         -- Get_Previous unit
     GET_NEXT_FAILURE,             -- Get_Next unit
     GET_SIZE_FAILURE,             -- Get_Size unit
     GET_SUBLIST_FAILURE,          -- Get_Sublist units
     INSERT_ITEM_FAILURE,          -- Insert_Item unit
     INSERT_END_FAILURE,           -- Insert_Item_End unit
     INSERT_TOP_FAILURE,           -- Insert_Item_Top unit
     INSERT_LIST_FAILURE,          -- Insert_List unit
     SPLIT_FAILURE,                -- Split unit
     SORT_INSERT_FAILURE,          -- Straight_Insertion_Sort unit
     SWAP_TAILS_FAILURE,           -- Swap_Tails unit
                                   --
                                   --   * Hashing Package *
                                   --
     CAL_HASH_ADDRESS_FAILURE,     -- Calculate_Hash_Table_Address unit
     ADD_ITEM_FAILURE,             -- Add_Item unit
     DELETE_FREE_FAILURE,          -- Delete_Item unit
     GET_ITEM_FAILURE,             -- Get_Item unit    
                                   -- 
                                   --   * Smoothing Package *
                                   --  
     ALPHA_BETA_FILTER_FAILURE,    -- Alpha_Beta_Filter unit
     NO_FLAGS_SET,                 -- Smooth_Position unit 
     RATE_CHANGE_FAILURE,          -- Rate_Change_Smoother unit 
     RATE_LIMITER_FAILURE,         -- Rate_Limiter unit
     SMOOTH_ENTITY_FAILURE,        -- Smooth_Entity unit
                                   --
                                   --   * Generic_Sort_List_By_Distance *
                                   --   * Generic_Sort_List_By_Velocity *
                                   -- 
     SORT_CREATE_ARRAY_FAILURE,    -- Create_Array_To_Sort
     SORT_CREATE_LIST_FAILURE,     -- Create_Sorted_Linked_List

                                   -- Sort by Distance
     SORT_DIST_DETON_FAILURE,      -- Sort_Detonation_Distance unit
     SORT_DIST_ENT_ST_FAILURE,     -- Sort_Entity_State_Distance unit
     SORT_DIST_FIRE_FAILURE,       -- Sort_Fire_Distance unit
     SORT_DIST_LASER_FAILURE,      -- Sort_Laser_Distance unit
     SORT_DIST_TRANS_FAILURE,      -- Sort_Transmitter_Distance unit
                                   -- 
                                   --   * Sort_by_Velocity Package *
                                   --
     SORT_VEL_ENT_ST_FAILURE,      -- Sort_Entity_State_Velocity unit
                                   --
                                   --   * DL_Math Package *
                                   --
     CAL_EULER_TRIG_FAILURE,       -- Calculate_Euler_Trig unit
     SIN_COS_LAT_FAILURE,          -- Sin_Cos_Lat unit
     SIN_COS_LON_FAILURE,          -- Sin_Cos_Lon unit
     ADA_EXCEPTION_RAISED,         --
                                   --
                                   -- * Vector_Math Package *
                                   --
     ADD_OFFSETS_FAILURE,          -- Add_Offsets units    
     CALCULATE_DIFFERENCE_FAILURE, -- Calculate_Difference units
     CALCULATE_OFFSETS_FAILURE,    -- Calculate_Offsets units
     CHECK_TOLERANCE_FAILURE);     -- Check_Vector_Change units       
                 
                 
end DL_Status; 
--==============================================================================
--
-- MODIFICATIONS
--
-- 9 Aug 1994 / Charlotte Mildren / Added GLU_GET_ITEM_FAILURE status code for
--                                  new Get_Item routine in Generic_List_Utilities 
--                                  (GLU was added because a GET_ITEM_FAILURE
--                                   status code already existed.)
--
-- 12 Aug 1994 / Charlotte Mildren / Added Smoothing package and 
--                                   Filter_By_PDU_Components status codes.
--
-- 15 Aug 1994/ Charlotte Mildren / Added status codes for all the new
--                                  Generic_List_Utilities units.
-- 
--==============================================================================
