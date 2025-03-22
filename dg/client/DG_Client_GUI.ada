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
-- FILE NAME        : DG_Client_GUI.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 22, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with Calendar,
     DG_IPC_Keys,
     DG_Shared_Memory,
     Unchecked_Conversion;

package body DG_Client_GUI is

   --
   -- Instantiate shared memory mapping package for use with the Server/GUI
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

      Memory_Key : INTEGER;

   begin  -- Map_Interface

      Status := DG_Status.SUCCESS;

      if (Create_Interface) then

         --
         -- This must be the client creating the interface.
         --
         Shared_Memory.Map_Memory(
           Mem_Key => DG_IPC_Keys.Client.Client_GUI_Key,
           Create  => TRUE,
           Mem_Ptr => Shared_Memory_Ptr,
           Status  => Status);

         --
         -- Initialize the interface to legal values.
         --
         Shared_Memory_Ptr.ALL := (

           Shutdown_Client         => FALSE,
           Synchronize_With_Server => TRUE,
           Connect_With_Server     => FALSE,
           Error_Queue_Read_Index  => 1,

           Exercise_Parameter_Change => FALSE,
           Exercise_Parameters       => (
             Set_Application_ID => FALSE,
             Application_ID     => 0),

           Simulation_Data_Parameter_Change => FALSE,
           Simulation_Data_Parameters       => (
             Maximum_Entities     => 321,
             Maximum_Emitters     => 2,
             Maximum_Lasers       => 2,
             Maximum_Transmitters => 2,
             Maximum_Receivers    => 2,
             PDU_Buffer_Size      => 1024),

           Hash_Parameter_Change => FALSE,
           Hash_Parameters => (OTHERS => (
             Index_Increment        => 7,
             Site_Multiplier        => 1,
             Application_Multiplier => 1,
             Entity_Multiplier      => 1)),

           Error_Parameter_Change => FALSE,
           Error_Parameters => (
             Error_Monitor_Enabled => TRUE,
             Error_Log_Enabled     => TRUE,
             Error_Log_File => (
               Length => 0,
               Name   => (OTHERS => ' '))),

           Configuration_File_Command => DG_GUI_Interface_Types.NONE,
           Configuration_File         => (
             Length => 0,
             Name   => (OTHERS => ASCII.NUL)),

           Client_Name => (
             Length => 0,
             Name   => (OTHERS => ' ')),

           Connected_To_Server => FALSE,

           Client_Monitor => (
             Number_Of_Entities => 0,
             Number_Of_Emitters => 0,
             Number_Of_Lasers   => 0),

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

         Memory_Key := DG_IPC_Keys.Client_GUI.Client_GUI_Key;

         if (Memory_Key /= 0) then

            --
            -- The memory key was retrieved without error, so map the memory.
            --
            Shared_Memory.Map_Memory(
              Mem_Key => Memory_Key,
              Create  => FALSE,
              Mem_Ptr => Shared_Memory_Ptr,
              Status  => Status);

         else

            --
            -- A Client_GUI.Client_GUI_Key value of 0 indicates that the
            -- memory key could not be determined.
            --
            Status := DG_Status.DG_PLACEHOLDER_ERROR;

         end if;  -- (Memory_Key /= 0)

      end if;  -- (Map_Interface)

      Interface := Convert_Ptr(Shared_Memory_Ptr);

   exception

      when OTHERS =>

         Status := DG_Status.CLIGUI_MI_FAILURE;

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
            -- This must be the client destroying the shared memory key.
            --
            Shared_Memory.Remove_Memory(
              Mem_Key => DG_IPC_Keys.Client.Client_GUI_Key,
              Status  => Status);

         end if;  -- (Destroy_Interface)

      else

         Status := Local_Status;

      end if;  -- (...Success(Local_Status))

   exception

      when OTHERS =>

         Status := DG_Status.CLIGUI_UI_FAILURE;

   end Unmap_Interface;

end DG_Client_GUI;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
