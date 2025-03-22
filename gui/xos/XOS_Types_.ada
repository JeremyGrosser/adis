--                          U N C L A S S I F I E D
--
--  *=======================================================================*
--  |                                                                       |
--  |                       Manned Flight Simulator                         |
--  |              Naval Air Warfare Center Aircraft Division               |
--  |                      Patuxent River, Maryland                         |
--  |                                                                       |
--  *=======================================================================*
--

with DIS_Types;
with Motif_Utilities;
with OS_Data_Types;
with OS_Simulation_Types;
with OS_Status;
with System;
with Unchecked_Conversion;
with Xt;

package XOS_Types is

   --
   -- XOS constants
   --
   K_Config_File_Base_Directory : constant STRING := "./";
   K_Config_File_Extension      : constant STRING := "cfg";
   K_Config_File_Mask           : constant STRING
     := "*." & K_Config_File_Extension;
   K_Default_Config_Filename    : constant STRING :=
     "XOS." & K_Config_File_Extension & ASCII.NUL;

   K_Detonated_Prematurely_Error_Message : constant STRING
     := "The munition was detonated prematurely because ...";

   --
   -- XOS Simulation Simulation GUI types
   --
   subtype XOS_SIMULATION_STATE_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       OS_Simulation_Types.SIMULATION_STATE_TYPE'pos(
         OS_Simulation_Types.SIMULATION_STATE_TYPE'first)..
           OS_Simulation_Types.SIMULATION_STATE_TYPE'pos(
             OS_Simulation_Types.SIMULATION_STATE_TYPE'last));
   type XOS_SIMULATION_STATE_PUSHBUTTON_ARRAY
     is array(OS_Simulation_Types.SIMULATION_STATE_TYPE'first..
       OS_Simulation_Types.SIMULATION_STATE_TYPE'last)
         of Motif_Utilities.AWIDGET;

   --
   -- XOS Simulation Simulation Parameters Data Record
   --
   type XOS_SIM_SIM_PARM_DATA_REC is
   record
      --
      -- Simulation Parameters Widgets
      --
      Shell                        : Xt.WIDGET;

      Contact_Threshold            : Xt.WIDGET;        -- User Data Widget
      Cycle_Time                   : Xt.WIDGET;        -- User Data Widget
      DB_Origin_Latitude           : Xt.WIDGET;        -- User Data Widget
      DB_Origin_Longitude          : Xt.WIDGET;        -- User Data Widget
      DB_Origin_Altitude           : Xt.WIDGET;        -- User Data Widget
      DB_Origin_X_WC               : Xt.WIDGET;        -- User Data Widget
      DB_Origin_Y_WC               : Xt.WIDGET;        -- User Data Widget
      DB_Origin_Z_WC               : Xt.WIDGET;        -- User Data Widget
      Exercise_ID                  : Xt.WIDGET;        -- User Data Widget
      Hash_Table_Increment         : Xt.WIDGET;        -- User Data Widget
      Hash_Table_Size              : Xt.WIDGET;        -- User Data Widget
      ModSAF_Database_Filename     : Xt.WIDGET;        -- User Data Widget
      Memory_Limit_For_ModSAF_File : Xt.WIDGET;        -- User Data Widget
      Number_Of_Loops_Until_Update : Xt.WIDGET;        -- User Data Widget
      Parent_Entity_ID_Sim_Address_Site_ID        : Xt.WIDGET;
      Parent_Entity_ID_Sim_Address_Application_ID : Xt.WIDGET;
      Parent_Entity_ID_Entity_ID                  : Xt.WIDGET;
      Protocol_Version             : Xt.WIDGET;        -- User Data Widget
      Simulation_State             : Xt.WIDGET;        -- User Data Widget
   end record;

   ----
   ---- XOS Simulation Error Parameters Data Record
   ----
   --type XOS_SIM_ERROR_PARM_DATA_REC is
   --record
   --   --
   --   -- Simulation Parameters Widgets
   --   --
   --   Shell          : Xt.WIDGET;
   --
   --   Display_Error  : Xt.WIDGET;        -- User Data Widget
   --   Log_Error      : Xt.WIDGET;        -- User Data Widget
   --   Log_File       : Xt.WIDGET;        -- User Data Widget
   --end record;

   --
   -- XOS Simulation Parameters Data Record
   --
   type XOS_SIM_PARM_DATA_REC;
   type XOS_SIM_PARM_DATA_REC_PTR 
     is access XOS_SIM_PARM_DATA_REC;
   type XOS_SIM_PARM_DATA_REC is
   record
      --
      -- Window widgets
      --
      Shell       : Xt.WIDGET;                -- Window shell
      Title       : Xt.WIDGET;
      Description : Xt.WIDGET;                -- Help decription field

      --
      -- Parameter Area widgets
      --
      Parameter_Scrolled_Window  : Xt.WIDGET; -- Scrolled window widget holding
				              -- parameters to be set
      Parameter_Active_Hierarchy : Xt.WIDGET; -- (Sub)root widget of currently
					      -- active parameter widget
					      -- sub-hierarchy.

      Sim   : XOS_SIM_SIM_PARM_DATA_REC;
      --Error :  XOS_SIM_ERROR_PARM_DATA_REC;

   end record;
   function XOS_SIM_PARM_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XOS_SIM_PARM_DATA_REC_PTR,
			    Target => Xt.POINTER);



   --
   -- XOS Aerodynamic Guidance GUI types
   --
   subtype XOS_GUIDANCE_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'pos(
         OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'first)..
           OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'pos(
             OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'last));
   type XOS_GUIDANCE_PUSHBUTTON_ARRAY
     is array(OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'first..
       OS_Data_Types.GUIDANCE_MODEL_IDENTIFIER'last)
         of Motif_Utilities.AWIDGET;
   --
   -- XOS Aerodynamic Illumination GUI types
   --
   subtype XOS_ILLUMINATION_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       OS_Data_Types.ILLUMINATION_IDENTIFIER'pos(
         OS_Data_Types.ILLUMINATION_IDENTIFIER'first)..
           OS_Data_Types.ILLUMINATION_IDENTIFIER'pos(
             OS_Data_Types.ILLUMINATION_IDENTIFIER'last));
   type XOS_ILLUMINATION_PUSHBUTTON_ARRAY
     is array(OS_Data_Types.ILLUMINATION_IDENTIFIER'first..
       OS_Data_Types.ILLUMINATION_IDENTIFIER'last)
         of Motif_Utilities.AWIDGET;

   --
   -- XOS Ordnance Aerodynamic Parameters Data Record
   --
   type XOS_ORD_AERO_DRAG_COOEF_ARRAY is array (
     OS_Data_Types.DRAG_COEFFICIENTS_ARRAY'range) of Xt.WIDGET;
   type XOS_ORD_AERO_PARM_DATA_REC is
   record
      Shell                     : Xt.WIDGET;

      Burn_Rate                 : Xt.WIDGET;
      Burn_Time                 : Xt.WIDGET;
      Azimuth_Detection_Angle   : Xt.WIDGET;
      Elevation_Detection_Angle : Xt.WIDGET;
      Drag_Coefficients         : XOS_ORD_AERO_DRAG_COOEF_ARRAY;
      Frontal_Area              : Xt.WIDGET;
      G_Gain                    : Xt.WIDGET;
      Guidance                  : Xt.WIDGET;
      Illumination_Flag         : Xt.WIDGET;
      Initial_Mass              : Xt.WIDGET;
      Max_Gs                    : Xt.WIDGET;
      Max_Speed                 : Xt.WIDGET;
      Thrust                    : Xt.WIDGET;
      Laser_Code                : Xt.WIDGET;
   end record;


   --
   -- XOS Termination Fuze GUI types
   --
   subtype XOS_FUZE_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       DIS_Types.A_FUZE_TYPE'pos(DIS_Types.A_FUZE_TYPE'first)..
	 DIS_Types.A_FUZE_TYPE'pos(DIS_Types.A_FUZE_TYPE'last));
   type XOS_FUZE_PUSHBUTTON_ARRAY
     is array(DIS_Types.A_FUZE_TYPE'first..DIS_Types.A_FUZE_TYPE'last)
       of Motif_Utilities.AWIDGET;

   --
   -- XOS Termination Warhead GUI types
   --
   subtype XOS_WARHEAD_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       DIS_Types.A_WARHEAD_TYPE'pos(DIS_Types.A_WARHEAD_TYPE'first)..
	 DIS_Types.A_WARHEAD_TYPE'pos(DIS_Types.A_WARHEAD_TYPE'last));
   type XOS_WARHEAD_PUSHBUTTON_ARRAY
     is array(DIS_Types.A_WARHEAD_TYPE'first..DIS_Types.A_WARHEAD_TYPE'last)
       of Motif_Utilities.AWIDGET;

   --
   -- XOS Ordnance Termination Parameters Data Record
   --
   type XOS_ORD_TERM_PARM_DATA_REC is
   record
      Shell                                         : Xt.WIDGET;

      Fuze                                          : Xt.WIDGET;
      Fuze_Detonation_Proximity                     : Xt.WIDGET;
      Fuze_Height_Relative_To_Sea_Level_To_Detonate : Xt.WIDGET;
      Fuze_Time_To_Detonation                       : Xt.WIDGET;
      Warhead                                       : Xt.WIDGET;
      Warhead_Range_To_Damage                       : Xt.WIDGET;
      Warhead_Hard_Kill                             : Xt.WIDGET;
      Max_Range                                     : Xt.WIDGET;
   end record;

   --
   -- XOS General Dead_Reckoning GUI types
   --
   subtype XOS_DEAD_RECKONING_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       DIS_Types.A_DEAD_RECKONING_ALGORITHM'pos(
         DIS_Types.A_DEAD_RECKONING_ALGORITHM'first)..
           DIS_Types.A_DEAD_RECKONING_ALGORITHM'pos(
             DIS_Types.A_DEAD_RECKONING_ALGORITHM'last));
   type XOS_DEAD_RECKONING_PUSHBUTTON_ARRAY
     is array(DIS_Types.A_DEAD_RECKONING_ALGORITHM'first..
       DIS_Types.A_DEAD_RECKONING_ALGORITHM'last)
         of Motif_Utilities.AWIDGET;
   --
   -- XOS General Entity_Kind GUI types
   --
   subtype XOS_ENTITY_KIND_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       DIS_Types.AN_ENTITY_KIND'pos(DIS_Types.AN_ENTITY_KIND'first)..
         DIS_Types.AN_ENTITY_KIND'pos(DIS_Types.AN_ENTITY_KIND'last));
   type XOS_ENTITY_KIND_PUSHBUTTON_ARRAY
     is array(DIS_Types.AN_ENTITY_KIND'first..DIS_Types.AN_ENTITY_KIND'last)
       of Motif_Utilities.AWIDGET;
   --
   -- XOS General COUNTRY GUI types
   --
   subtype XOS_COUNTRY_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       DIS_Types.A_COUNTRY_ID'pos(DIS_Types.A_COUNTRY_ID'first)..
         DIS_Types.A_COUNTRY_ID'pos(DIS_Types.A_COUNTRY_ID'last));
   type XOS_COUNTRY_PUSHBUTTON_ARRAY
     is array(DIS_Types.A_COUNTRY_ID'first..DIS_Types.A_COUNTRY_ID'last)
       of Motif_Utilities.AWIDGET;
   --
   -- XOS General Fly-Out Model ID GUI types
   --
   subtype XOS_FLY_OUT_MODEL_ID_OPTION_MENU_TYPE
     is Motif_Utilities.MENU_ITEM_ARRAY(
       OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'pos(
         OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'first)..
           OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'pos(
             OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'last));
   type XOS_FLY_OUT_MODEL_ID_PUSHBUTTON_ARRAY
     is array(OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'first..
       OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER'last)
         of Motif_Utilities.AWIDGET;
   --
   -- XOS Ordnance General Parameters Data Record
   --
   type XOS_ORD_GEN_PARM_DATA_REC is
   record
      Shell                    : Xt.WIDGET;

      Dead_Reckoning_Algorithm : Xt.WIDGET;
      Entity_Type              : Xt.WIDGET;
      Entity_Kind              : Xt.WIDGET;
      Domain                   : Xt.WIDGET;
      Country                  : Xt.WIDGET;
      Country_String           : Xt.WIDGET;
      Category                 : Xt.WIDGET;
      Subcategory              : Xt.WIDGET;
      Specific                 : Xt.WIDGET;
      Fly_Out_Model_ID         : Xt.WIDGET;
   end record;

   --
   -- XOS Ord Emitter Parameters Data Record
   --
   type XOS_ORD_EMITTER_PARM_DATA_REC is
   record
      Shell                     : Xt.WIDGET;

      -- Emitter System
      Emitter_Name              : Xt.WIDGET;
      Emitter_Function          : Xt.WIDGET;
      Emitter_ID                : Xt.WIDGET;

      -- Location
      Location_X                : Xt.WIDGET;
      Location_Y                : Xt.WIDGET;
      Location_Z                : Xt.WIDGET;

      -- Fundamental Parameter Data
      Frequency                 : Xt.WIDGET;
      Frequency_Range           : Xt.WIDGET;
      ERP                       : Xt.WIDGET;
      PRF                       : Xt.WIDGET;
      Pulse_Width               : Xt.WIDGET;
      Beam_Azimuth_Center       : Xt.WIDGET;
      Beam_Elevation_Center     : Xt.WIDGET;
      Beam_Sweep_Sync           : Xt.WIDGET;

      -- Beam Data
      Beam_Parameter_Index      : Xt.WIDGET;
      Beam_Function             : Xt.WIDGET;
      High_Density_Track_Jam    : Xt.WIDGET;
      Jamming_Mode_Sequence     : Xt.WIDGET;

   end record;

   --
   -- XOS Ord Entity Parameters Data Record
   --
   type XOS_ORD_ENTITY_PARM_DATA_REC is
   record
      Shell                : Xt.WIDGET;

      -- Alternate Entity Type
      Entity_Kind          : Xt.WIDGET;
      Domain               : Xt.WIDGET;
      Country              : Xt.WIDGET;
      Country_String       : Xt.WIDGET;
      Category             : Xt.WIDGET;
      Subcategory          : Xt.WIDGET;
      Specific             : Xt.WIDGET;
      Extra                : Xt.WIDGET;

      -- Capabilities
      Capabilities         : Xt.WIDGET;

      -- Entity Appearance
      Paint                : Xt.WIDGET;
      Mobility             : Xt.WIDGET;
      Fire_Power           : Xt.WIDGET;
      Damage               : Xt.WIDGET;
      Smoke                : Xt.WIDGET;
      Trailing             : Xt.WIDGET;
      Hatch                : Xt.WIDGET;
      Lights               : Xt.WIDGET;
      Flaming              : Xt.WIDGET;
      EA_Specific          : Xt.WIDGET;

      -- Entity Marking
      Entity_Marking       : Xt.WIDGET;

   end record;

   --
   -- XOS Ordnance Parameters Data Record
   --
   type XOS_ORD_PARM_DATA_REC;
   type XOS_ORD_PARM_DATA_REC_PTR 
     is access XOS_ORD_PARM_DATA_REC;
   type XOS_ORD_PARM_DATA_REC is
   record
       --
       -- Window widgets
       --
       Shell       : Xt.WIDGET;                -- Parent Window shell
       Title       : Xt.WIDGET;                -- Window Panel Title label
       Description : Xt.WIDGET;                -- Help decription field

       Apply_Button      : Xt.WIDGET;          -- Window Apply Pushbutton
       Previous_Button   : Xt.WIDGET;          -- Window Previous Pushbutton
       Next_Button       : Xt.WIDGET;          -- Window Next Pushbutton
       Cancel_Button     : Xt.WIDGET;          -- Window Cancel Pushbutton

       --
       -- Parameter Area widgets
       --
       Parameter_Scrolled_Window  : Xt.WIDGET; -- Scrolled window widget holding
					       -- parameters to be set
       Parameter_Active_Hierarchy : Xt.WIDGET; -- (Sub)root widget of currently
					       -- active parameter widget
					       -- sub-hierarchy.
       --
       -- Ordnance Parameters Text Widget Records
       --
       Aero    : XOS_ORD_AERO_PARM_DATA_REC;
       Term    : XOS_ORD_TERM_PARM_DATA_REC;
       Gen     : XOS_ORD_GEN_PARM_DATA_REC;
       Emitter : XOS_ORD_EMITTER_PARM_DATA_REC;
       Entity  : XOS_ORD_ENTITY_PARM_DATA_REC;

   end record;
   function XOS_ORD_PARM_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XOS_ORD_PARM_DATA_REC_PTR,
			    Target => Xt.POINTER);


   --
   -- XOS Other Error Parameters Data Record
   --
   type XOS_OTHER_ERROR_PARM_DATA_REC is
   record
      Shell                : Xt.WIDGET;

      GUI_Error_Reporting  : Xt.WIDGET;        -- User Data Widget
      Error_Logging        : Xt.WIDGET;        -- User Data Widget
      Error_Logfile        : Xt.WIDGET;        -- User Data Widget
   end record;
   --
   -- XOS Other Parameters Data Record
   --
   type XOS_OTHER_PARM_DATA_REC;
   type XOS_OTHER_PARM_DATA_REC_PTR 
     is access XOS_OTHER_PARM_DATA_REC;
   type XOS_OTHER_PARM_DATA_REC is
   record
       --
       -- Window widgets
       --
       Shell       : Xt.WIDGET;
       Title       : Xt.WIDGET;
       Description : Xt.WIDGET;                -- Help decription field

       --
       -- Parameter Area widgets
       --
       Parameter_Scrolled_Window  : Xt.WIDGET; -- Scrolled window widget holding
					       -- parameters to be set
       Parameter_Active_Hierarchy : Xt.WIDGET; -- (Sub)root widget of currently
					       -- active parameter widget
					       -- sub-hierarchy.
       --
       -- Error Parameters Text Widget Records
       --
       Error   : XOS_OTHER_ERROR_PARM_DATA_REC;

   end record;
   function XOS_OTHER_PARM_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XOS_OTHER_PARM_DATA_REC_PTR,
			    Target => Xt.POINTER);



   --
   -- Widget for each error history entry
   --
   type XOS_MON_ERROR_HISTORY_ENTRY_DATA_REC is
   record
      Time           : Xt.WIDGET; -- label for time of last occurrence
      Occurrences    : Xt.WIDGET; -- label for number of occurrences
      Message        : Xt.WIDGET; -- label for message
   end record;
   --
   -- Array of error history entries (one for each DG Status error type).
   --
   type XOS_MON_ERROR_HISTORY_ENTRY_ARRAY is
     array(OS_Status.STATUS_TYPE) of XOS_MON_ERROR_HISTORY_ENTRY_DATA_REC;
   --
   -- Monitor Error History Widgets
   --
   type XOS_MON_ERROR_HISTORY_DATA_REC;
   type XOS_MON_ERROR_HISTORY_DATA_REC_PTR
     is access XOS_MON_ERROR_HISTORY_DATA_REC;
   type XOS_MON_ERROR_HISTORY_DATA_REC is
   record
      Shell                           : Xt.WIDGET;

      Error_History_Scrolled_Window   : Xt.WIDGET;
      Error_History_Form              : Xt.WIDGET;
      Error_History_Time_RC           : Xt.WIDGET;
      Error_History_Occurrences_RC    : Xt.WIDGET;
      Error_History_Message_RC        : Xt.WIDGET;

      History                         : XOS_MON_ERROR_HISTORY_ENTRY_ARRAY;

   end record;
   function XOS_MON_ERROR_HISTORY_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XOS_MON_ERROR_HISTORY_DATA_REC_PTR,
                            Target => Xt.POINTER);


   --
   -- XOS Monitors Data Record
   --
   type XOS_MONITORS_DATA_REC;
   type XOS_MONITORS_DATA_REC_PTR
     is access XOS_MONITORS_DATA_REC;
   type XOS_MONITORS_DATA_REC is
   record
      --
      -- Window widgets
      --
      Shell       : Xt.WIDGET;                -- Window shell
      Title       : Xt.WIDGET;                -- Panel Title
      Description : Xt.WIDGET;                -- Help decription field

      --
      -- Parameter Area widgets
      --
      Parameter_Scrolled_Window  : Xt.WIDGET; -- Scrolled window widget holding
                                              -- parameters to be set
      Parameter_Active_Hierarchy : Xt.WIDGET; -- (Sub)root widget of currently
                                              -- active parameter widget
                                              -- sub-hierarchy.

      Error_History : XOS_MON_ERROR_HISTORY_DATA_REC_PTR;

   end record;
   function XOS_MONITORS_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XOS_MONITORS_DATA_REC_PTR,
                            Target => Xt.POINTER);


   --
   -- XOS Error Notices Monitor Data Record
   --
   type XOS_ERROR_NOTICES_MONITOR_DATA_REC;
   type XOS_ERROR_NOTICES_MONITOR_DATA_REC_PTR
     is access XOS_ERROR_NOTICES_MONITOR_DATA_REC;
   type XOS_ERROR_NOTICES_MONITOR_DATA_REC is
   record
      --
      -- Window widgets
      --
      Shell               : Xt.WIDGET;  -- Window shell
      Title               : Xt.WIDGET;  -- Panel Title
      Description         : Xt.WIDGET;  -- Help decription field

      --
      -- Window widgets
      --
      Error_Notices_Text  : Xt.WIDGET;  -- ScrolledText holding error notices

      --
      -- Status information (used internally)
      --
      Error_Notices_Count : INTEGER;

   end record;
   function XOS_ERROR_NOTICES_MONITOR_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XOS_ERROR_NOTICES_MONITOR_DATA_REC_PTR,
                            Target => Xt.POINTER);

   --
   -- XOS Parameters (All) Data Record
   --
   type XOS_PARM_DATA_REC;
   type XOS_PARM_DATA_REC_PTR 
     is access XOS_PARM_DATA_REC;
   type XOS_PARM_DATA_REC is
   record
       Sim_Data   : XOS_SIM_PARM_DATA_REC_PTR;    -- Simulation Data
       Ord_Data   : XOS_ORD_PARM_DATA_REC_PTR;    -- Ordnance Data
       Other_Data : XOS_OTHER_PARM_DATA_REC_PTR;  -- Error Data

       Monitors_Data       : XOS_MONITORS_DATA_REC_PTR;
       Error_Notices_Data  : XOS_ERROR_NOTICES_MONITOR_DATA_REC_PTR;
   end record;
   function XOS_PARM_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XOS_PARM_DATA_REC_PTR,
			    Target => Xt.POINTER);

end XOS_Types;
 
----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

