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
-- PACKAGE NAME     : DG_Client_GUI
--
-- FILE NAME        : DG_Client_GUI_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 16, 1994
--
-- PURPOSE:
--   - This package defines types and routines to support the DG Client's
--     parameter interface.
--
-- EFFECTS:
--   - The expected usage is:
--     1.  Call Map_Interface before referencing Interface.  The DG Client
--         should make this call with Create_Interface set to TRUE.  The DG
--         Client GUI should make this call with Create_Interface set to
--         FALSE.
--     2.  Call Unmap_Interface when Interface access is no longer needed.
--         The DG Client should make this call with Destroy_Interface set to
--         TRUE.  The DG Client GUI should make this call with
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
     Numeric_Types;

package DG_Client_GUI is

   ---------------------------------------------------------------------------
   -- Define types for exercise-related parameters
   ---------------------------------------------------------------------------

   --
   -- If Set_Application_ID is TRUE, then the DG Client will set the
   --    Application ID fields of all outbound PDUs to the value in
   --    Application_ID.  If Set_Application_ID is FALSE, then the
   --    application software is responsible for setting this data.
   --
   type EXERCISE_PARAMETERS_TYPE is
     record
       Set_Application_ID : BOOLEAN;
       Application_ID     : Numeric_Types.UNSIGNED_16_BIT;
     end record;

   ---------------------------------------------------------------------------
   -- Define type to store DG Client monitor information
   ---------------------------------------------------------------------------

   type CLIENT_MONITOR_TYPE is
     record
       Number_Of_Entities : INTEGER;
       Number_Of_Emitters : INTEGER;
       Number_Of_Lasers   : INTEGER;
     end record;

   ---------------------------------------------------------------------------
   -- Define type to store DG Client's name
   ---------------------------------------------------------------------------

   K_Max_Client_Name_Length : constant INTEGER := 20;

   subtype CLIENT_NAME_LENGTH_TYPE is
     INTEGER range 0..K_Max_Client_Name_Length;

   type CLIENT_NAME_TYPE is
     record
       Length : CLIENT_NAME_LENGTH_TYPE;
       Name   : STRING(1..K_Max_Client_Name_Length);
     end record;

   ---------------------------------------------------------------------------
   -- Define type for the shared memory interface
   ---------------------------------------------------------------------------

   type INTERFACE_TYPE is
     record

       --
       -- Data which can be altered by the GUI.
       --

       Shutdown_Client           : BOOLEAN;

       Synchronize_With_Server   : BOOLEAN;

       Connect_With_Server       : BOOLEAN;

       Error_Queue_Read_Index    : INTEGER;

       Exercise_Parameter_Change : BOOLEAN;
       Exercise_Parameters       : EXERCISE_PARAMETERS_TYPE;

       Simulation_Data_Parameter_Change : BOOLEAN;
       Simulation_Data_Parameters       : DG_GUI_Interface_Types.
                                            SIMULATION_DATA_PARAMETERS_TYPE;

       Hash_Parameter_Change  : BOOLEAN;
       Hash_Parameters        : DG_GUI_Interface_Types.HASH_PARAMETERS_TYPE;

       Error_Parameter_Change : BOOLEAN;
       Error_Parameters       : DG_GUI_Interface_Types.ERROR_PARAMETERS_TYPE;

       Configuration_File_Command : DG_GUI_Interface_Types.
                                      CONFIGURATION_FILE_COMMAND_TYPE;
       Configuration_File         : DG_GUI_Interface_Types.
                                      CONFIGURATION_FILE_TYPE;

       --
       -- Data which is for display or tracking purposes only, and is not
       -- altered by the GUI.
       --

       Client_Name             : CLIENT_NAME_TYPE;

       Connected_To_Server     : BOOLEAN;

       Client_Monitor          : CLIENT_MONITOR_TYPE;

       Error_Monitor           : DG_GUI_Interface_Types.ERROR_MONITOR_TYPE;
       Error_Queue_Write_Index : INTEGER;

     end record;

   type INTERFACE_PTR_TYPE is access INTERFACE_TYPE;

   Interface : INTERFACE_PTR_TYPE;

   ---------------------------------------------------------------------------
   -- Map_Interface
   ---------------------------------------------------------------------------
   --
   -- Purpose : Initializes access to the DG Client/GUI shared memory
   --           interface.  If Create_Interface is TRUE, then a new shared
   --           memory area is created.  This should only be done once, and
   --           should only be done by the DG Client.  An unsuccessful status
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
   -- Purpose : Terminates access to the DG Client/GUI shared memory
   --           interface.  If Destroy_Interface is FALSE, then the shared
   --           memory area for the interface will still exist.  This is
   --           the proper method for the GUI to terminate access to the
   --           interface.  If Destroy_Interface is TRUE, then the shared
   --           memory area will be removed from the system.  Any subsequent
   --           references to the interface by any program will result in an
   --           error.  This termination method should only be used by the
   --           DG Client.
   --
   -- Effects : This routine change the value of Interface to NULL so that it
   --           can no longer be used to access the shared memory interface.
   --
   ---------------------------------------------------------------------------

   procedure Unmap_Interface(
      Destroy_Interface : in     BOOLEAN;
      Status            :    out DG_Status.STATUS_TYPE);

end DG_Client_GUI;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
