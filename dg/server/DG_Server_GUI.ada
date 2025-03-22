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
-- FILE NAME        : DG_Server_GUI.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 23, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with Calendar,
     DG_GUI_Interface_Types,
     DG_IPC_Keys,
     DG_Shared_Memory,
     Unchecked_Conversion;

package body DG_Server_GUI is

   --
   -- Instantiate shared memory mapping package for use with the Client/GUI
   -- interface.  Define a pointer for the shared memory area.
   --

   package Shared_Memory is
     new DG_Shared_Memory(INTERFACE_TYPE);

   Shared_Memory_Ptr : Shared_Memory.SHARED_MEMORY_PTR_TYPE;

   --
   -- Instantiate conversion between shared memory pointer type and the
   -- package specification's pointer type.
   --

   function Convert_Ptr is
     new Unchecked_Conversion(
           Shared_Memory.SHARED_MEMORY_PTR_TYPE,
           INTERFACE_PTR_TYPE);

   ---------------------------------------------------------------------------
   -- Map_Interface
   ---------------------------------------------------------------------------

   procedure Map_Interface(
      Create_Interface : in     BOOLEAN;
      Status           :    out DG_Status.STATUS_TYPE) is

   begin  -- Map_Interface

      Status := DG_Status.SUCCESS;

      if (Create_Interface) then

         --
         -- This must be the server creating the interface.
         --

         Shared_Memory.Map_Memory(
           Mem_Key => DG_IPC_Keys.Server.Server_GUI_Key,
           Create  => TRUE,
           Mem_Ptr => Shared_Memory_Ptr,
           Status  => Status);

         --
         -- Initialize the interface to known values.  This will ensure that
         -- the Server runs in the event that configuration file values are
         -- not available.
         --

         Shared_Memory_Ptr.ALL := (

           Shutdown_Server        => FALSE,
           Start_Server           => TRUE,
           Timeslice              => 50,  -- ms
           Error_Queue_Read_Index => 1,

           Network_Parameter_Change => FALSE,
           Network_Parameters => (
             UDP_Port                  => 6994,
             Broadcast_IP_Address      => (164, 217, 255, 255),
             Data_Reception_Enabled    => TRUE,
             Data_Transmission_Enabled => TRUE),

           Threshold_Parameter_Change => FALSE,
           Threshold_Parameters => (
             Distance           => 1.0,    -- m
             Orientation        => 1.0,    -- deg
             Entity_Update      => 5,      -- sec
             Entity_Expiration  => 12,     -- sec
             Emission_Update    => 5000,   -- msec
             Laser_Update       => 100,    -- msec
             Transmitter_Update => 5000,   -- msec
             Receiver_Update    => 5000),  -- msec

           Exercise_Parameter_Change => FALSE,
           Exercise_Parameters => (
             Set_Exercise_ID       => FALSE,
             Exercise_ID           => 1,
             Set_Site_ID           => FALSE,
             Site_ID               => 1,
             Automatic_Timestamp   => TRUE,
             IITSEC_Bit_23_Support    => TRUE,
             Experimental_PDU_Support => FALSE),

           Simulation_Data_Parameter_Change => FALSE,
           Simulation_Data_Parameters => (
             Maximum_Entities     => 101,
             Maximum_Emitters     => 101,
             Maximum_Lasers       => 101,
             Maximum_Transmitters => 101,
             Maximum_Receivers    => 101,
             PDU_Buffer_Size      => 10000),

           Hash_Parameter_Change => FALSE,
           Hash_Parameters => (OTHERS => (
             Index_Increment        => 7,
             Site_Multiplier        => 1,
             Application_Multiplier => 1,
             Entity_Multiplier      => 1)),

           Filter_Parameter_Change => FALSE,
           Filter_Parameters => (
             Keep_Exercise_ID    => FALSE,
             Exercise_ID         => 1,
             Keep_Other_Force    => TRUE,
             Keep_Friendly_Force => TRUE,
             Keep_Opposing_Force => TRUE,
             Keep_Neutral_Force  => TRUE,
             Keep_PDU            => (OTHERS => TRUE)),

           Error_Parameter_Change => FALSE,
           Error_Parameters => (
             Error_Monitor_Enabled => TRUE,
             Error_Log_Enabled     => TRUE,
             Error_Log_File => (
               Length => 0,
               Name   => (OTHERS => ' '))),

           Configuration_File_Command => DG_GUI_Interface_Types.NONE,
           Configuration_File => (
             Length => 0,
             Name   => (OTHERS => ' ')),

           Server_Monitor => (
             Number_Of_Clients          => 0,
             Number_Of_Client_Entities  => 0,
             Number_Of_Network_Entities => 0,
             Number_Of_Client_Emitters  => 0,
             Number_Of_Network_Emitters => 0,
             Number_Of_Client_Lasers    => 0,
             Number_Of_Network_Lasers   => 0),

           Error_Monitor => (

             Error_Queue => (OTHERS => (
               Error           => DG_Status.SUCCESS,
               Occurrence_Time => Calendar.Clock)),

             Error_Queue_Overflow => FALSE,

             Error_History => (OTHERS => (
               Occurrence_Count     => 0,
               Last_Occurrence_Time => Calendar.Clock))),

           Error_Queue_Write_Index => 1);

      else

         --
         -- This must be the GUI mapping the interface.
         --
         Shared_Memory.Map_Memory(
           Mem_Key => DG_IPC_Keys.Server_GUI.Server_GUI_Key,
           Create  => FALSE,
           Mem_Ptr => Shared_Memory_Ptr,
           Status  => Status);

      end if;

      Interface := Convert_Ptr(Shared_Memory_Ptr);

   exception

      when OTHERS =>

         Status := DG_Status.SRVGUI_MI_FAILURE;

   end Map_Interface;

   ---------------------------------------------------------------------------
   -- Unmap_Interface
   ---------------------------------------------------------------------------

   procedure Unmap_Interface(
      Destroy_Interface : in     BOOLEAN;
      Status            :    out DG_Status.STATUS_TYPE) is

      Local_Status : DG_Status.STATUS_TYPE;

   begin  -- Unmap_Interface

      Status := DG_Status.SUCCESS;

      --
      -- Release the shared memory from the process virtual memory space
      --
      Shared_Memory.Unmap_Memory(
        Mem_Ptr => Shared_Memory_Ptr,
        Status  => Local_Status);

      if (DG_Status.Success(Local_Status)) then

         if (Destroy_Interface) then

            --
            -- Destroy the shared memory key.
            --
            Shared_Memory.Remove_Memory(
              Mem_Key => DG_IPC_Keys.Server.Server_GUI_Key,
              Status  => Status);

         end if;

      else

         Status := Local_Status;

      end if;  -- (...Success(Local_Status))

   exception

      when OTHERS =>

         Status := DG_Status.SRVGUI_UI_FAILURE;

   end Unmap_Interface;

end DG_Server_GUI;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
