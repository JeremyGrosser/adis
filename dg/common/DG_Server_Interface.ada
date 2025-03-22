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
-- PACKAGE NAME     : DG_Server_Interface
--
-- FILE NAME        : DG_Server_Interface.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 05, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Hash_Table_Support,
     DG_IPC_Keys,
     DG_Shared_Memory,
     System,
     Unchecked_Conversion;

package body DG_Server_Interface is

   ---------------------------------------------------------------------------
   -- Map_Interface
   ---------------------------------------------------------------------------

   procedure Map_Interface(
      Create_Interface      : in     BOOLEAN;
      Simulation_Parameters : in     DG_GUI_Interface_Types.
                                       SIMULATION_DATA_PARAMETERS_TYPE;
      Status                :    out DG_Status.STATUS_TYPE) is


      Local_Status  : DG_Status.STATUS_TYPE;
      LOCAL_FAILURE : EXCEPTION;

      --
      -- Instantiate shared memory mapping package for use with the Server/
      -- Client interface.  Define a pointer for the shared memory area.
      --

      subtype CURRENT_SERVER_INTERFACE_TYPE is
        SERVER_INTERFACE_TYPE(
          Maximum_Entities     => Simulation_Parameters.Maximum_Entities,
          Maximum_Emitters     => Simulation_Parameters.Maximum_Emitters,
          Maximum_Lasers       => Simulation_Parameters.Maximum_Lasers,
          Maximum_Transmitters => Simulation_Parameters.Maximum_Transmitters,
          Maximum_Receivers    => Simulation_Parameters.Maximum_Receivers,
          PDU_Buffer_Size      => Simulation_Parameters.PDU_Buffer_Size);

      package Shared_Memory is
        new DG_Shared_Memory(CURRENT_SERVER_INTERFACE_TYPE);

      Shared_Memory_Ptr : Shared_Memory.SHARED_MEMORY_PTR_TYPE;

      --
      -- Instantiate conversion between shared memory pointer type and the
      -- package specification's pointer type.
      --

      function Convert_Ptr is
        new Unchecked_Conversion(
              Shared_Memory.SHARED_MEMORY_PTR_TYPE,
              SERVER_INTERFACE_PTR_TYPE);

   begin  -- Map_Interface

      Status := DG_Status.SUCCESS;

      if (Create_Interface) then

         --
         -- This must be the server creating the interface.
         --

         Shared_Memory.Map_Memory(
           Mem_Key => DG_IPC_Keys.Server.Server_Client_Key,
           Create  => TRUE,
           Mem_Ptr => Shared_Memory_Ptr,
           Status  => Local_Status);

         if (DG_Status.Failure(Local_Status)) then
            raise LOCAL_FAILURE;
         end if;

         --
         -- Mapping the shared memory interface does not initialize the
         -- values of the variants.  These variants can be initialized by
         -- creating an object of type CURRENT_SERVER_INTERFACE_TYPE and
         -- using the "use at" representation clause to force the object
         -- to be located in the shared memory area.
         --
         Initialize_Variants:
         declare

            function Convert_Ptr_To_Address is
               new Unchecked_Conversion(
                     Shared_Memory.SHARED_MEMORY_PTR_TYPE,
                     System.ADDRESS);

            Set_Variant_Values : CURRENT_SERVER_INTERFACE_TYPE;

            for Set_Variant_Values
              use at Convert_Ptr_To_Address(Shared_Memory_Ptr);

         begin  -- Initialize_Variants

            null;  -- The only purpose of this block is to initialize the
                   -- variants in shared memory.  This is done automatically
                   -- when Set_Variants is declared.  No further processing
                   -- is required.

         end Initialize_Variants;

         --
         -- Initialize key sections of the interface.
         --

         Shared_Memory_Ptr.Simulation_Data.Entity_Hash_Table := (
           Number_Of_Entries        => Shared_Memory_Ptr.Simulation_Data.
                                         Entity_Hash_Table.Number_Of_Entries,
           Secondary_Hash_Increment => 7,
           Site_Multiplier          => 1,
           Application_Multiplier   => 1,
           Entity_Multiplier        => 1,
           Entry_Data => (OTHERS => (
             Status    => DG_Hash_Table_Support.FREE,
             Entity_ID => (
               Sim_Address => (
                 Site_ID        => 0,
                 Application_ID => 0),
               Entity_ID => 0))));

         Shared_Memory_Ptr.Simulation_Data.Emitter_Hash_Table := (
           Number_Of_Entries        => Shared_Memory_Ptr.Simulation_Data.
                                         Emitter_Hash_Table.Number_Of_Entries,
           Secondary_Hash_Increment => 7,
           Site_Multiplier          => 1,
           Application_Multiplier   => 1,
           Entity_Multiplier        => 1,
           Entry_Data => (OTHERS => (
             Status    => DG_Hash_Table_Support.FREE,
             Entity_ID => (
               Sim_Address => (
                 Site_ID        => 0,
                 Application_ID => 0),
               Entity_ID => 0))));

         Shared_Memory_Ptr.Simulation_Data.Laser_Hash_Table := (
           Number_Of_Entries        => Shared_Memory_Ptr.Simulation_Data.
                                         Laser_Hash_Table.Number_Of_Entries,
           Secondary_Hash_Increment => 7,
           Site_Multiplier          => 1,
           Application_Multiplier   => 1,
           Entity_Multiplier        => 1,
           Entry_Data => (OTHERS => (
             Status    => DG_Hash_Table_Support.FREE,
             Entity_ID => (
               Sim_Address => (
                 Site_ID        => 0,
                 Application_ID => 0),
               Entity_ID => 0))));

         Shared_Memory_Ptr.Simulation_Data.Transmitter_Hash_Table := (
           Number_Of_Entries        => Shared_Memory_Ptr.Simulation_Data.
                                         Transmitter_Hash_Table.
                                           Number_Of_Entries,
           Secondary_Hash_Increment => 7,
           Site_Multiplier          => 1,
           Application_Multiplier   => 1,
           Entity_Multiplier        => 1,
           Entry_Data => (OTHERS => (
             Status    => DG_Hash_Table_Support.FREE,
             Entity_ID => (
               Sim_Address => (
                 Site_ID        => 0,
                 Application_ID => 0),
               Entity_ID => 0))));

         Shared_Memory_Ptr.Simulation_Data.Receiver_Hash_Table := (
           Number_Of_Entries        => Shared_Memory_Ptr.Simulation_Data.
                                         Receiver_Hash_Table.
                                           Number_Of_Entries,
           Secondary_Hash_Increment => 7,
           Site_Multiplier          => 1,
           Application_Multiplier   => 1,
           Entity_Multiplier        => 1,
           Entry_Data => (OTHERS => (
             Status    => DG_Hash_Table_Support.FREE,
             Entity_ID => (
               Sim_Address => (
                 Site_ID        => 0,
                 Application_ID => 0),
               Entity_ID => 0))));

         --
         -- Initialize the cross-reference tables
         --

         Shared_Memory_Ptr.Simulation_Data.Entity_XRef_Table := (OTHERS => (
           Emitter_Index     => 0,
           Laser_Index       => 0,
           Lased_Index       => 0,
           Transmitter_Index => 0,
           Receiver_Index    => 0));

         --
         -- Indicate that the server in online
         --
         Shared_Memory_Ptr.Server_Online := TRUE;

         --
         -- Initialize PDU buffer index
         --
         Shared_Memory_Ptr.Buffer_Write_Index := 1;

      else

         --
         -- This must be a client mapping the interface.
         --

         Shared_Memory.Map_Memory(
           Mem_Key => DG_IPC_Keys.Client.Server_Client_Key,
           Create  => FALSE,
           Mem_Ptr => Shared_Memory_Ptr,
           Status  => Status);

      end if;

      Interface := Convert_Ptr(Shared_Memory_Ptr);

   exception

      when LOCAL_FAILURE =>

         Status := Local_Status;

      when OTHERS =>

         Status := DG_Status.SVRIF_MAP_FAILURE;

   end Map_Interface;

   ---------------------------------------------------------------------------
   -- Unmap_Interface
   ---------------------------------------------------------------------------

   procedure Unmap_Interface(
      Destroy_Interface : in     BOOLEAN;
      Status            :    out DG_Status.STATUS_TYPE) is

      Local_Status : DG_Status.STATUS_TYPE;

      --
      -- Instantiate shared memory mapping package for use with the Server/
      -- Client interface.  Define a pointer for the shared memory area.
      --

      subtype CURRENT_SERVER_INTERFACE_TYPE is
        SERVER_INTERFACE_TYPE(
          Maximum_Entities     => Interface.Maximum_Entities,
          Maximum_Emitters     => Interface.Maximum_Emitters,
          Maximum_Lasers       => Interface.Maximum_Lasers,
          Maximum_Transmitters => Interface.Maximum_Transmitters,
          Maximum_Receivers    => Interface.Maximum_Receivers,
          PDU_Buffer_Size      => Interface.PDU_Buffer_Size);

      package Shared_Memory is
        new DG_Shared_Memory(CURRENT_SERVER_INTERFACE_TYPE);

      Shared_Memory_Ptr : Shared_Memory.SHARED_MEMORY_PTR_TYPE;

      --
      -- Instantiate conversion between shared memory pointer type and the
      -- package specification's pointer type.
      --

      function Convert_Ptr is
        new Unchecked_Conversion(
              SERVER_INTERFACE_PTR_TYPE,
              Shared_Memory.SHARED_MEMORY_PTR_TYPE);

   begin  -- Unmap_Interface

      Status := DG_Status.SUCCESS;

      Shared_Memory_Ptr := Convert_Ptr(Interface);

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
              Mem_Key => DG_IPC_Keys.Server.Server_Client_Key,
              Status  => Status);

         end if;

      else

         Status := Local_Status;

      end if;  -- (...Success(Local_Status))

   exception

      when OTHERS =>

         Status := DG_Status.SVRIF_UNMAP_FAILURE;

   end Unmap_Interface;

end DG_Server_Interface;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
