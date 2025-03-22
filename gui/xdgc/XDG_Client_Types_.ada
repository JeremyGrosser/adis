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

with DG_Status;
with System;
with Unchecked_Conversion;
with Xt;

package XDG_Client_Types is

   --
   -- XDG Client constants
   -- 
   K_Config_File_Base_Directory : constant STRING := "./";
   K_Config_File_Extension      : constant STRING := "cfg";
   K_Config_File_Mask           : constant STRING
     := "*." & K_Config_File_Extension;
   K_Default_Config_Filename    : constant STRING :=
     "XDG_Client." & K_Config_File_Extension & ASCII.NUL;

   --
   -- DG Parameters Widgets
   --
   type XDG_DG_PARAMETERS_DATA_REC is
   record
      Shell                : Xt.WIDGET;

      Max_Entities         : Xt.WIDGET;        -- User Data Widget
      Max_Emitters         : Xt.WIDGET;        -- User Data Widget
      Max_Lasers           : Xt.WIDGET;        -- User Data Widget
      Max_Transmitters     : Xt.WIDGET;        -- User Data Widget
      Max_Receivers        : Xt.WIDGET;        -- User Data Widget
      PDU_Buffer_Size      : Xt.WIDGET;        -- User Data Widget

   end record;

   --
   -- Error Parameters Widgets
   --
   type XDG_ERROR_PARAMETERS_DATA_REC is
   record
      Shell                : Xt.WIDGET;

      GUI_Error_Reporting  : Xt.WIDGET;        -- User Data Widget
      Error_Logging        : Xt.WIDGET;        -- User Data Widget
      Error_Logfile        : Xt.WIDGET;        -- User Data Widget

   end record;

   --
   -- PDU Hash Parameters Widgets
   --
   type XDG_PDU_HASH_PARAMETERS_REC is
   record
      Rehash_Increment       : Xt.WIDGET;       -- User Data Widget
      Site_Multiplier        : Xt.WIDGET;       -- User Data Widget
      Application_Multiplier : Xt.WIDGET;       -- User Data Widget
      Entity_Multiplier      : Xt.WIDGET;       -- User Data Widget
   end record;

   --
   -- Hash Parameters PDUs enumeration
   --
   type XDG_HASH_PARAMETERS_PDUS is
   (
      ENTITY,
      EMITTER,
      LASER,
      TRANSMITTER,
      RECEIVER
   );

   --
   -- Hash Parameters PDUs Widgets
   --
   type XDG_HASH_PARAMETERS_ARRAY is 
     array(XDG_HASH_PARAMETERS_PDUS) of XDG_PDU_HASH_PARAMETERS_REC;

   --
   -- Hash Parameters Widgets
   --
   type XDG_HASH_PARAMETERS_DATA_REC is
   record
      Shell                : Xt.WIDGET;

      PDU                  : XDG_HASH_PARAMETERS_ARRAY;

   end record;

   --
   -- Exercise Parameters Widgets
   --
   type XDG_EXERCISE_PARAMETERS_DATA_REC is
   record
      Shell                    : Xt.WIDGET;

      Automatic_Application_ID : Xt.WIDGET;       -- User Data Widget
      Application_ID           : Xt.WIDGET;       -- User Data Widget

   end record;

   --
   -- Synchronization Parameters Widgets
   --
   type XDG_SYNCHRONIZATION_PARAMETERS_DATA_REC is
   record
      Shell                  : Xt.WIDGET;

      Server_Synchronization : Xt.WIDGET;       -- User Data Widget

   end record;

   --
   -- XDG Set Parameters Data Record
   --
   type XDG_SET_PARM_DATA_REC;
   type XDG_SET_PARM_DATA_REC_PTR 
     is access XDG_SET_PARM_DATA_REC;
   type XDG_SET_PARM_DATA_REC is
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

      DG_Parameters              : XDG_DG_PARAMETERS_DATA_REC;
      Error                      : XDG_ERROR_PARAMETERS_DATA_REC;
      Hash                       : XDG_HASH_PARAMETERS_DATA_REC;
      Exercise                   : XDG_EXERCISE_PARAMETERS_DATA_REC;
      Synchronization            : XDG_SYNCHRONIZATION_PARAMETERS_DATA_REC;

   end record;
   function XDG_SET_PARM_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XDG_SET_PARM_DATA_REC_PTR,
			    Target => Xt.POINTER);




   --
   -- Monitor Entities Widgets
   --
   type XDG_MON_ENTITIES_DATA_REC is
   record
      Shell         : Xt.WIDGET;

      Entities_List : Xt.WIDGET;        -- User Data Widget

   end record;

   --
   -- Monitor Gateway Widgets
   --
   type XDG_MON_GATEWAY_DATA_REC is
   record
      Shell                    : Xt.WIDGET;

      Number_Of_Clients        : Xt.WIDGET;        -- User Data Widget
      Number_Of_Local_Entities : Xt.WIDGET;        -- User Data Widget

   end record;

   --
   -- Widget for each error history entry
   --
   type XDG_MON_ERROR_HISTORY_ENTRY_DATA_REC is
   record
      Time           : Xt.WIDGET; -- label for time of last occurrence
      Occurrences    : Xt.WIDGET; -- label for number of occurrences
      Message        : Xt.WIDGET; -- label for message
   end record;
   --
   -- Array of error history entries (one for each DG Status error type).
   --
   type XDG_MON_ERROR_HISTORY_ENTRY_ARRAY is
     array(DG_Status.STATUS_TYPE) of XDG_MON_ERROR_HISTORY_ENTRY_DATA_REC;
   --
   -- Monitor Error History Widgets
   --
   type XDG_MON_ERROR_HISTORY_DATA_REC;
   type XDG_MON_ERROR_HISTORY_DATA_REC_PTR
     is access XDG_MON_ERROR_HISTORY_DATA_REC;
   type XDG_MON_ERROR_HISTORY_DATA_REC is
   record
      Shell                           : Xt.WIDGET;

      Error_History_Scrolled_Window   : Xt.WIDGET;
      Error_History_Form              : Xt.WIDGET;
      Error_History_Time_RC           : Xt.WIDGET;
      Error_History_Occurrences_RC    : Xt.WIDGET;
      Error_History_Message_RC        : Xt.WIDGET;

      History                         : XDG_MON_ERROR_HISTORY_ENTRY_ARRAY;

   end record;
   function XDG_MON_ERROR_HISTORY_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XDG_MON_ERROR_HISTORY_DATA_REC_PTR,
                            Target => Xt.POINTER);

   --
   -- XDG Monitors Data Record
   --
   type XDG_MONITORS_DATA_REC;
   type XDG_MONITORS_DATA_REC_PTR 
     is access XDG_MONITORS_DATA_REC;
   type XDG_MONITORS_DATA_REC is
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

      Entities      : XDG_MON_ENTITIES_DATA_REC;
      Gateway       : XDG_MON_GATEWAY_DATA_REC;
      Error_History : XDG_MON_ERROR_HISTORY_DATA_REC_PTR;

   end record;
   function XDG_MONITORS_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XDG_MONITORS_DATA_REC_PTR,
			    Target => Xt.POINTER);


   --
   -- XDG Error Notices Monitor Data Record
   --
   type XDG_ERROR_NOTICES_MONITOR_DATA_REC;
   type XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR
     is access XDG_ERROR_NOTICES_MONITOR_DATA_REC;
   type XDG_ERROR_NOTICES_MONITOR_DATA_REC is
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
   function XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR,
                            Target => Xt.POINTER);


   --
   -- XDG Parameters (All) Data Record
   --
   type XDG_DATA_REC;
   type XDG_DATA_REC_PTR 
     is access XDG_DATA_REC;
   type XDG_DATA_REC is
   record
       Set_Parameters_Data : XDG_SET_PARM_DATA_REC_PTR; -- Set Parameters Data
       Monitors_Data       : XDG_MONITORS_DATA_REC_PTR; -- Monitor Data
       Error_Notices_Data  : XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR;
   end record;
   function XDG_DATA_REC_PTR_to_XtPOINTER is new
      Unchecked_Conversion (Source => XDG_DATA_REC_PTR,
			    Target => Xt.POINTER);

end XDG_Client_Types;
 
----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

