--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_GUI (spec)
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  15 June 94
--
-- PURPOSE :
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
with OS_Data_Types,
     OS_Simulation_Types,
     OS_Status;

package OS_GUI is

   type ORDNANCE_COMMAND_TYPE is (
      NONE,
      NEXT,
      PREVIOUS,
      APPLY);

   type ORDNANCE_DISPLAY_TYPE is
     record
       Command     : ORDNANCE_COMMAND_TYPE;
       Top_Of_List : BOOLEAN;
       End_Of_List : BOOLEAN;
     end record;

   -- Variables global to this package
   type OS_GUI_INTERFACE_RECORD is
     record
       Error_Parameters           :  OS_Data_Types.ERROR_PARAMETERS_RECORD;
       General_Parameters         :  OS_Data_Types.GENERAL_PARAMETERS_RECORD;
       Simulation_Parameters      :  OS_Simulation_Types.
                                       SIMULATION_PARAMETERS_RECORD;
       Ordnance_Display           :  ORDNANCE_DISPLAY_TYPE;
       Configuration_File         :  OS_Data_Types.CONFIGURATION_FILE_TYPE;
       Configuration_File_Command :  OS_Data_Types.CONFIGURATION_COMMAND_TYPE;
     end record;

   type OS_GUI_INTERFACE_POINTER is
     access OS_GUI_INTERFACE_RECORD;

   Interface :  OS_GUI_INTERFACE_POINTER;

   -- Define an environment variable name for use in passing interface
   -- information from the OS to the GUI.

   K_OS_GUI_Env_Var : constant STRING := "ADIS_OS_GUI_KEY";

   ---------------------------------------------------------------------------
   -- Map_Interface
   ---------------------------------------------------------------------------
   --
   -- Purpose : Initializes access to the Ordnance Server/GUI shared memory
   --           interface.  If Create_Interface is TRUE, then a new shared
   --           memory area is created.  This should only be done once, and
   --           should only be done by the Ordnance Server.  An unsuccessful
   --           status is returned if Create_Interface is FALSE and the shared
   --           memory area does not exist.
   --
   -- Effects : This routine changes the value of Interface so that it can be
   --           used to access the shared memory interface.
   --
   ---------------------------------------------------------------------------

   procedure Map_Interface(
      Create_Interface : in     BOOLEAN;
      Status           :    out OS_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Unmap_Interface
   ---------------------------------------------------------------------------
   --
   -- Purpose : Terminates access to the Ordnance Server/GUI shared memory
   --           interface.  If Destroy_Interface is FALSE, then the shared
   --           memory area for the interface will still exist.  This is
   --           the proper method for the GUI to terminate access to the
   --           interface.  If Destroy_Interface is TRUE, then the shared
   --           memory area will be removed from the system.  Any subsequent
   --           references to the interface by any program will result in an
   --           error.  This termination method should only be used by the
   --           Ordnance Server.
   --
   -- Effects : This routine change the value of Interface to NULL so that it
   --           can no longer be used to access the shared memory interface.
   --
   ---------------------------------------------------------------------------

   procedure Unmap_Interface(
      Destroy_Interface : in     BOOLEAN;
      Status            :    out OS_Status.STATUS_TYPE);

end OS_GUI;
