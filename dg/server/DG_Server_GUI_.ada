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
-- PACKAGE NAME     : DG_Server_GUI
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 01, 1994
--
-- PURPOSE:
--   - This package defines types and routines to support the DG Server's
--     parameter interface.
--
-- EFFECTS:
--   - The expected usage is:
--     1.  Call Map_Interface before referencing Interface.  The DG Server
--         should make this call with Create_Interface set to TRUE.  The DG
--         Server GUI should make this call with Create_Interface set to
--         FALSE.
--     2.  Call Unmap_Interface when Interface access is no longer needed.
--         The DG Server should make this call with Destroy_Interface set to
--         TRUE.  The DG Server GUI should make this call with
--         Destroy_Interface set to FALSE.
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

with DG_GUI_Interface_Types,
     DG_Status,
     DIS_Types,
     Numeric_Types;

package DG_Server_GUI is

   ---------------------------------------------------------------------------
   -- Define types for specifying the IP parameters.
   ---------------------------------------------------------------------------

   --
   -- Define type to store a "dot-notation" IP address.  The IP address
   -- components are stored as follows:
   --
   --    For the dot address "140.229.22.227", the array components would be:
   --       (1) = 140
   --       (2) = 229
   --       (3) = 22
   --       (4) = 227
   --
   type IP_DOT_ADDRESS_TYPE is array (1..4) of Numeric_Types.UNSIGNED_8_BIT;

   type NETWORK_PARAMETERS_TYPE is
     record
       UDP_Port                  : Numeric_Types.UNSIGNED_16_BIT;
       Broadcast_IP_Address      : IP_DOT_ADDRESS_TYPE;
       Data_Reception_Enabled    : BOOLEAN;
       Data_Transmission_Enabled : BOOLEAN;
     end record;

   ---------------------------------------------------------------------------
   -- Define types for update threshold parameters
   ---------------------------------------------------------------------------

   type THRESHOLD_PARAMETERS_TYPE is
     record
       Distance           : Numeric_Types.FLOAT_32_BIT;
       Orientation        : Numeric_Types.FLOAT_32_BIT;
       Entity_Update      : INTEGER;  -- sec
       Entity_Expiration  : INTEGER;  -- sec
       Emission_Update    : INTEGER;  -- msec
       Laser_Update       : INTEGER;  -- msec
       Transmitter_Update : INTEGER;  -- msec
       Receiver_Update    : INTEGER;  -- msec
     end record;

   ---------------------------------------------------------------------------
   -- Define types for exercise-related parameters
   ---------------------------------------------------------------------------

   --
   -- If Set_Exercise_ID is TRUE, then the DG Server will set the Exercise ID
   --    fields of all outbound PDUs to the value in Exerise_ID.  If
   --    Set_Exericse_ID is FALSE, then all clients must specify their own
   --    Exercise_ID field values.
   --
   -- Set_Site_ID and Site_ID function similarly.
   --
   -- If Automatic_Timestamp is TRUE, then the DG Server will overwrite the
   -- Timestamp component of all PDU headers based on the system time when
   -- the PDU was issued by the Server.
   --
   -- If IITSEC_Bit_23_Support is TRUE, then bit 23 of Entity State PDUs will
   -- be treated as an "immediate entity expiration" flag.  This was used in
   -- I/ITSEC '93 to remove munitions from displays at the time of detonation,
   -- rather than 12 seconds later (as would be the case with normal entity
   -- expiration guidelines).
   --
   type EXERCISE_PARAMETERS_TYPE is
     record
       Set_Exercise_ID          : BOOLEAN;
       Exercise_ID              : DIS_Types.AN_EXERCISE_IDENTIFIER;
       Set_Site_ID              : BOOLEAN;
       Site_ID                  : Numeric_Types.UNSIGNED_16_BIT;
       Automatic_Timestamp      : BOOLEAN;
       IITSEC_Bit_23_Support    : BOOLEAN;
       Experimental_PDU_Support : BOOLEAN;
     end record;

   ---------------------------------------------------------------------------
   -- Define type to store DG Server filter parameters
   --
   -- If Keep_Exercise_ID is FALSE, then no PDUs will be eliminated due to
   -- their Exercise ID field values.  If Keep_Exercise_ID is TRUE, then only
   -- PDUs with Exercise ID's equal to "Exercise_ID" will be kept, and all
   -- others will be discarded.
   --
   -- For the remaining components of this record, a TRUE value indicates that
   -- PDUs matching the specified criteria will be kept, and a FALSE value
   -- indicates that these PDUs will be discarded.
   --
   ---------------------------------------------------------------------------

   type PDU_FILTER_TYPE is
     array (DIS_Types.A_PDU_KIND) of BOOLEAN;

   type FILTER_PARAMETERS_TYPE is
     record
       Keep_Exercise_ID    : BOOLEAN;
       Exercise_ID         : DIS_Types.AN_EXERCISE_IDENTIFIER;
       Keep_Other_Force    : BOOLEAN;
       Keep_Friendly_Force : BOOLEAN;
       Keep_Opposing_Force : BOOLEAN;
       Keep_Neutral_Force  : BOOLEAN;
       Keep_PDU            : PDU_FILTER_TYPE;
     end record;

   ---------------------------------------------------------------------------
   -- Define type to store DG Server monitor information
   ---------------------------------------------------------------------------

   type SERVER_MONITOR_TYPE is
     record
       Number_Of_Clients          : INTEGER;
       Number_Of_Client_Entities  : INTEGER;
       Number_Of_Network_Entities : INTEGER;
       Number_Of_Client_Emitters  : INTEGER;
       Number_Of_Network_Emitters : INTEGER;
       Number_Of_Client_Lasers    : INTEGER;
       Number_Of_Network_Lasers   : INTEGER;
     end record;

   ---------------------------------------------------------------------------
   -- Define type for the shared memory interface
   ---------------------------------------------------------------------------

   type INTERFACE_TYPE is
     record

       --
       -- Data which can be altered by the GUI.
       --

       Shutdown_Server            : BOOLEAN;

       Start_Server               : BOOLEAN;

       Timeslice                  : INTEGER;  -- ms

       Error_Queue_Read_Index     : INTEGER;

       Network_Parameter_Change   : BOOLEAN;
       Network_Parameters         : NETWORK_PARAMETERS_TYPE;

       Threshold_Parameter_Change : BOOLEAN;
       Threshold_Parameters       : THRESHOLD_PARAMETERS_TYPE;

       Exercise_Parameter_Change  : BOOLEAN;
       Exercise_Parameters        : EXERCISE_PARAMETERS_TYPE;

       Simulation_Data_Parameter_Change : BOOLEAN;
       Simulation_Data_Parameters       : DG_GUI_Interface_Types.
                                            SIMULATION_DATA_PARAMETERS_TYPE;

       Hash_Parameter_Change   : BOOLEAN;
       Hash_Parameters         : DG_GUI_Interface_Types.HASH_PARAMETERS_TYPE;

       Filter_Parameter_Change : BOOLEAN;
       Filter_Parameters       : FILTER_PARAMETERS_TYPE;

       Error_Parameter_Change  : BOOLEAN;
       Error_Parameters        : DG_GUI_Interface_Types.ERROR_PARAMETERS_TYPE;

       Configuration_File_Command : DG_GUI_Interface_Types.
                                      CONFIGURATION_FILE_COMMAND_TYPE;
       Configuration_File         : DG_GUI_Interface_Types.
                                      CONFIGURATION_FILE_TYPE;

       --
       -- Data which is for display or tracking purposes only, and is not
       -- altered by the GUI.
       --

       Server_Monitor          : SERVER_MONITOR_TYPE;

       Error_Monitor           : DG_GUI_Interface_Types.ERROR_MONITOR_TYPE;
       Error_Queue_Write_Index : INTEGER;

     end record;

   ---------------------------------------------------------------------------
   -- Define access for INTERFACE_TYPE.
   ---------------------------------------------------------------------------

   type INTERFACE_PTR_TYPE is access INTERFACE_TYPE;

   Interface : INTERFACE_PTR_TYPE;

   ---------------------------------------------------------------------------
   -- Map_Interface
   ---------------------------------------------------------------------------
   --
   -- Purpose : Initializes access to the DG Server/GUI shared memory
   --           interface.  If Create_Interface is TRUE, then a new shared
   --           memory area is created.  This should only be done once, and
   --           should only be done by the DG Server.  An unsuccessful status
   --           is returned if Create_Interface is FALSE and the shared memory
   --           area does not exist.
   --
   -- Effects : This routine changes the value of Interface so that it can be
   --           used to access the shared memory interface.
   -- 
   ---------------------------------------------------------------------------

   procedure Map_Interface(
      Create_Interface : in     BOOLEAN;
      Status           :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Unmap_Interface
   ---------------------------------------------------------------------------
   --
   -- Purpose : Terminates access to the DG Server/GUI shared memory
   --           interface.  If Destroy_Interface is FALSE, then the shared
   --           memory area for the interface will still exist.  This is
   --           the proper method for the GUI to terminate access to the
   --           interface.  If Destroy_Interface is TRUE, then the shared
   --           memory area will be removed from the system.  Any subsequent
   --           references to the interface by any program will result in an
   --           error.  This termination method should only be used by the
   --           DG Server.
   --
   -- Effects : This routine change the value of Interface to NULL so that it
   --           can no longer be used to access the shared memory interface.
   --
   ---------------------------------------------------------------------------

   procedure Unmap_Interface(
      Destroy_Interface : in     BOOLEAN;
      Status            :    out DG_Status.STATUS_TYPE);

end DG_Server_GUI;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
