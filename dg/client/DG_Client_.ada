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
-- PACKAGE NAME     : DG_Client
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 19, 1994
--
-- PURPOSE:
--   - Define types and routines to permit external CSCIs to interface with
--     the DIS Gateway Client.
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

with DIS_PDU_Pointer_Types,
     DIS_Types,
     DG_Generic_PDU,
     DG_Status,
     DL_Linked_List_Types,
     Numeric_Types,
     System;

package DG_Client is

   ---------------------------------------------------------------------------
   -- Client/Server Interface
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Initialize_Client
   ---------------------------------------------------------------------------
   -- Purpose:  Allows complete control over Client initialization.
   --
   --           Load_Configuration_File
   --             If TRUE, then parameters are set based on the contents of
   --             the file given by the Configuration_File parameter.
   --
   --           Configuration_File
   --             Provides the name of the file containing configuration
   --             parameters.  If empty (""), the environmental variable
   --             ADIS_DG_CLIENT_CONFIG is used to provide the file name.  If
   --             this is undefined, then a final attempt will be made using
   --             the file "DG_Client.Config" in the current directory.
   --
   --           Load_GUI
   --             If TRUE, then the program given by the GUI_Program parameter
   --             will be started.
   --
   --           GUI_Program
   --             Provides the name of the program which is the Graphical User
   --             Interface for the DG Client.
   --
   --           Wait_For_GUI
   --             If TRUE, the DG Client will wait for the user to set new
   --             parameter values before proceeding.  If FALSE, the DG Client
   --             will continue processing immediately after starting the GUI.
   --
   --           Use_GUI_Parameters
   --             If TRUE, the DG Client will wait for the user to alter
   --             operational parameters using the GUI.  If FALSE, then the
   --             DG Client uses the existing parameters (either based on the
   --             configuration file, or default values).
   --
   ---------------------------------------------------------------------------

   procedure Initialize_Client(
      Load_Configuration_File : in     BOOLEAN := FALSE;
      Configuration_File      : in     STRING  := "";
      Load_GUI                : in     BOOLEAN := FALSE;
      GUI_Program             : in     STRING  := "";
      GUI_Display             : in     STRING  := "0";
      Wait_For_GUI            : in     BOOLEAN := TRUE;
      Client_Name             : in     STRING  := "";
      Status                  :    out DG_Status.STATUS_TYPE);

   --
   -- Terminate_Server_Interface
   --
   procedure Terminate_Server_Interface(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   --
   -- Note:  Either Synchronize_With_Server or Client_Connected should be
   --        called periodically during client execution.  If the Client/
   --        Server connection has been shut down (for example, by quitting
   --        the Client GUI or by commanding a simulation shutdown from the
   --        Server GUI), then these routines will return a non-SUCCESS
   --        Status.
   --
   ---------------------------------------------------------------------------

   --
   -- Synchronize_With_Server
   --
   procedure Synchronize_With_Server(
      Overrun : out BOOLEAN;
      Status  : out DG_Status.STATUS_TYPE);

   --
   -- Client_Connected
   --
   procedure Client_Connected(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Graphical User Interface
   ---------------------------------------------------------------------------

   procedure Initialize_GUI(
      Display : in      STRING := "0";  -- Current display
      Status  :     out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Simulation Input
   ---------------------------------------------------------------------------

   --
   -- SIMULATION_STATE_TYPE
   --
   type SIMULATION_STATE_TYPE is (
     START_RESUME,  -- The last state-related PDU was a Start/Resume PDU
     STOP_FREEZE);  -- The last state-related PDU was a Stop/Freeze PDU

   --
   -- Get_Next_PDU
   --
   procedure Get_Next_PDU(
      PDU_Pointer : out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Status      : out DG_Status.STATUS_TYPE);

   --
   -- Get_Simulation_State
   --
   procedure Get_Simulation_State(
      Simulation_State   : out SIMULATION_STATE_TYPE;
      Stop_Freeze_Reason : out DIS_Types.A_REASON_TO_STOP;
      Status             : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   --
   -- Entity routines
   --
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Get_Entity_Info
   ---------------------------------------------------------------------------
   -- Purpose:  Retrieves the entity state information for the specified
   --           Site/Application/Entity ID provided in the Entity_ID
   --           parameter.
   ---------------------------------------------------------------------------

   procedure Get_Entity_Info(
      Entity_ID   : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Entity_Info :    out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status      :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Entity_Information_By_Hash_Index
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Get_Entity_Info_By_Hash_Index(
      Entity_Index : in     INTEGER;
      Entity_Info  :    out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status       :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_First_Simulation_Entity
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Get_First_Simulation_Entity(
      Entity_Info :    out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status      :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Next_Simulation_Entity
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Get_Next_Simulation_Entity(
      Entity_Info : out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status      : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   --
   -- Laser routines
   --
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Get_First_Simulation_Laser
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Get_First_Simulation_Laser(
      Laser_Info : out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status     : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Next_Simulation_Laser
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Get_Next_Simulation_Laser(
      Laser_Info : out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status     : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Laser_By_Code
   ---------------------------------------------------------------------------
   -- Purpose:  Returns information on the laser associated with the specified
   --           code, or else returns NULL if no laser can be found that uses
   --           the code.
   ---------------------------------------------------------------------------

   procedure Get_Laser_By_Code(
      Laser_Code : in     Numeric_Types.UNSIGNED_8_BIT;
      Laser_Info :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status     :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Laser_By_Lasing_Entity
   ---------------------------------------------------------------------------
   -- Purpose:  Returns information on the laser associated with the specified
   --           entity, or else returns NULL if no laser is currently
   --           associated with the entity.
   ---------------------------------------------------------------------------

   procedure Get_Laser_By_Lasing_Entity(
      Lasing_Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Laser_Info       :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status           :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Laser_By_Lased_Entity
   ---------------------------------------------------------------------------
   -- Purpose:  Returns information on the laser illuminating the specified
   --           entity, or else returns NULL if no laser is currently
   --           illuminating the entity.
   ---------------------------------------------------------------------------

   procedure Get_Laser_By_Lased_Entity(
      Lased_Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Laser_Info      :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status          :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   --
   -- Transmitter routines
   --
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------

   --
   -- Get_Entity_Transmitter
   --
   procedure Get_Entity_Transmitter(
      Entity_ID        : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Transmitter_Info :    out DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR;
      Status           :    out DG_Status.STATUS_TYPE);

   procedure Get_Entity_Emission(
      Entity_ID        : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Emission_Info    :    out DIS_PDU_Pointer_Types.EMISSION_PDU_PTR;
      Status           :    out DG_Status.STATUS_TYPE);
      
   ---------------------------------------------------------------------------
   -- Simulation Output
   ---------------------------------------------------------------------------

   --
   -- Send_PDU
   --
   procedure Send_PDU(
      PDU_Address : in     System.ADDRESS;
      Status      :    out DG_Status.STATUS_TYPE);

   --
   -- Set_Emission_Info
   --
   procedure Set_Emission_Info(
      Emission_Info : in     DIS_Types.AN_EMISSION_PDU;
      Status        :    out DG_Status.STATUS_TYPE);

   --
   -- Set_Entity_Info
   --
   procedure Set_Entity_Info(
      Entity_Info : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status      :    out DG_Status.STATUS_TYPE);

   --
   -- Remove_Entity
   --
   procedure Remove_Entity(
      Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :    out DG_Status.STATUS_TYPE);

   --
   -- Remove_Entity_By_Hash_Index
   --
   procedure Remove_Entity_By_Hash_Index(
      Entity_Index : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- DIS Library (DL) Support Routines
   ---------------------------------------------------------------------------

   --
   -- Get_Entity_List
   --
   procedure Get_Entity_List(
      Entity_List : out DL_Linked_List_Types.Entity_State_List.PTR;
      Status      : out DG_Status.STATUS_TYPE);

end DG_Client;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
