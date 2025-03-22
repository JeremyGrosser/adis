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
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Client_GUI,
     DG_Client_Interface,
     DG_Hash_Table_Support,
     DG_PDU_Buffer,
     DG_Server_Interface,
     Unchecked_Conversion;

package body DG_Client is

   --
   -- Import commonly used functions
   --

   function Addr_To_Ptr is
     new Unchecked_Conversion(
           System.ADDRESS,
           DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR);

   function Addr_To_Ptr is
     new Unchecked_Conversion(
           System.ADDRESS,
           DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR);

   function Addr_To_Ptr is
     new Unchecked_Conversion(
           System.ADDRESS,
           DIS_PDU_Pointer_Types.EMISSION_PDU_PTR);

   function "="(Left, Right : DG_Hash_Table_Support.ENTRY_STATUS_TYPE)
     return BOOLEAN
       renames DG_Hash_Table_Support."=";

   ---------------------------------------------------------------------------
   -- First/Next Hash Table Indexes
   ---------------------------------------------------------------------------
   -- These variables store the current hash table index for each of the
   -- pairs of "first/next" simulation data retrieval routines, such as
   -- Get_First_Simulation_Entity/Get_Next_Simulation_Entity.
   ---------------------------------------------------------------------------

   Sim_Entity_Index : INTEGER;
   Sim_Laser_Index  : INTEGER;

   ---------------------------------------------------------------------------
   -- Client/Server Interface
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Initialize_Client
   ---------------------------------------------------------------------------

   procedure Initialize_Client(
      Load_Configuration_File : in     BOOLEAN := FALSE;
      Configuration_File      : in     STRING  := "";
      Load_GUI                : in     BOOLEAN := FALSE;
      GUI_Program             : in     STRING  := "";
      GUI_Display             : in     STRING  := "0";
      Wait_For_GUI            : in     BOOLEAN := TRUE;
      Client_Name             : in     STRING  := "";
      Status                  :    out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Terminate_Server_Interface
   --
   procedure Terminate_Server_Interface(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Synchronize_With_Server
   --
   procedure Synchronize_With_Server(
      Overrun : out BOOLEAN;
      Status  : out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Client_Connected
   --
   procedure Client_Connected(
      Status : out DG_Status.STATUS_TYPE)
     is separate;


   ---------------------------------------------------------------------------
   -- Graphical User Interface
   ---------------------------------------------------------------------------

   procedure Initialize_GUI(
      Display : in     STRING := "0";  -- Current display
      Status  :    out DG_Status.STATUS_TYPE) is
   begin
      Status := DG_Status.SUCCESS;
   end Initialize_GUI;

   ---------------------------------------------------------------------------
   -- Simulation Input
   ---------------------------------------------------------------------------

   --
   -- Get_Next_PDU
   --

   procedure Get_Next_PDU(
      PDU_Pointer : out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Status      : out DG_Status.STATUS_TYPE) is

   begin  -- Get_Next_PDU

      DG_PDU_Buffer.Read(
        PDU_Read_Index  => DG_Client_Interface.Interface.Buffer_Read_Index,
        PDU_Write_Index => DG_Server_Interface.Interface.Buffer_Write_Index,
        PDU_Buffer      => DG_Server_Interface.Interface.PDU_Buffer,
        PDU             => PDU_Pointer,
        Status          => Status);

   exception

      when OTHERS =>

         Status := DG_Status.CLI_GNP_FAILURE;

   end Get_Next_PDU;

   --
   -- Get_Simulation_State
   --
   procedure Get_Simulation_State(
      Simulation_State   : out SIMULATION_STATE_TYPE;
      Stop_Freeze_Reason : out DIS_Types.A_REASON_TO_STOP;
      Status             : out DG_Status.STATUS_TYPE) is
   begin
      Simulation_State   := START_RESUME;
      Stop_Freeze_Reason := DIS_Types.OTHER_REASON;
      Status             := DG_Status.SUCCESS;
   end Get_Simulation_State;

   --
   -- Get_Entity_Info
   --
   procedure Get_Entity_Info(
      Entity_ID   : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Entity_Info :    out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status      :    out DG_Status.STATUS_TYPE) is

      Entity_Index : INTEGER;
      Local_Status : DG_Status.STATUS_TYPE;

   begin  -- Get_Entity_Info

      Entity_Info := NULL;
      Status      := DG_Status.SUCCESS;

      DG_Hash_Table_Support.Entity_Hash_Index(
        Command    => DG_Hash_Table_Support.FIND,
        Entity_ID  => Entity_ID,
        Hash_Table => DG_Server_Interface.Interface.Simulation_Data.
                        Entity_Hash_Table,
        Hash_Index => Entity_Index,
        Status     => Local_Status);

      if (DG_Status.Failure(Local_Status)) then

         Status := Local_Status;

      elsif (Entity_Index = 0) then

         --
         -- Entity was not found in the table
         --
         Status := DG_Status.CLI_GEI_ENTITY_NOT_FOUND_FAILURE;

      else

         Get_Entity_Info_By_Hash_Index(
           Entity_Index => Entity_Index,
           Entity_Info  => Entity_Info,
           Status       => Status);

      end if;

   exception

      when OTHERS =>

         Status := DG_Status.CLI_GEI_FAILURE;

   end Get_Entity_Info;

   --
   -- Get_Entity_Information_By_Hash_Index
   --
   procedure Get_Entity_Info_By_Hash_Index(
      Entity_Index : in     INTEGER;
      Entity_Info  :    out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status       :    out DG_Status.STATUS_TYPE) is

   begin

      Entity_Info := NULL;
      Status      := DG_Status.SUCCESS;

      if (DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.Entry_Data(
        Entity_Index).Status = DG_Hash_Table_Support.IN_USE) then

         Entity_Info
           := Addr_To_Ptr(
                DG_Server_Interface.Interface.Simulation_Data.Entity_Data_Table(
                  Entity_Index)'ADDRESS);

      end if;

   end Get_Entity_Info_By_Hash_Index;

   --
   -- Get_First_Simulation_Entity
   --
   procedure Get_First_Simulation_Entity(
      Entity_Info :    out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status      :    out DG_Status.STATUS_TYPE) is
   begin

      Sim_Entity_Index := 0;  -- Reset first/next sim entity index
      Entity_Info      := NULL;
      Status           := DG_Status.SUCCESS;

      Search_For_First_Entity:
      for Search_Index in DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.
        Entry_Data'RANGE loop

         if (DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.Entry_Data(
           Search_Index).Status = DG_Hash_Table_Support.IN_USE) then

            Sim_Entity_Index := Search_Index;

            Get_Entity_Info_By_Hash_Index(
              Entity_Index => Search_Index,
              Entity_Info  => Entity_Info,
              Status       => Status);

            exit Search_For_First_Entity;

         end if;

      end loop Search_For_First_Entity;

   end Get_First_Simulation_Entity;

   --
   -- Get_Next_Simulation_Entity
   --
   procedure Get_Next_Simulation_Entity(
      Entity_Info : out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status      : out DG_Status.STATUS_TYPE) is
   begin

      Entity_Info      := NULL;
      Status           := DG_Status.SUCCESS;

      if ((Sim_Entity_Index+1)
        <= DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.Entry_Data'LAST)
      then

         Search_For_Next_Entity:
         for Search_Index in (Sim_Entity_Index+1)
           ..DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.
               Entry_Data'LAST loop

            if (DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.Entry_Data(
              Search_Index).Status = DG_Hash_Table_Support.IN_USE) then

               Sim_Entity_Index := Search_Index;

               Get_Entity_Info_By_Hash_Index(
                 Entity_Index => Search_Index,
                 Entity_Info  => Entity_Info,
                 Status       => Status);

               exit Search_For_Next_Entity;

            end if;

         end loop Search_For_Next_Entity;

      end if;

   end Get_Next_Simulation_Entity;

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

   procedure Get_First_Simulation_Laser(
      Laser_Info : out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status     : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Get_Next_Simulation_Laser
   ---------------------------------------------------------------------------

   procedure Get_Next_Simulation_Laser(
      Laser_Info : out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status     : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Get_Laser_By_Code
   ---------------------------------------------------------------------------

   procedure Get_Laser_By_Code(
      Laser_Code : in     Numeric_Types.UNSIGNED_8_BIT;
      Laser_Info :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status     :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Get_Laser_By_Lasing_Entity
   ---------------------------------------------------------------------------

   procedure Get_Laser_By_Lasing_Entity(
      Lasing_Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Laser_Info       :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status           :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Get_Laser_By_Lased_Entity
   ---------------------------------------------------------------------------

   procedure Get_Laser_By_Lased_Entity(
      Lased_Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Laser_Info      :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Get_Entity_Transmitter
   --
   procedure Get_Entity_Transmitter(
      Entity_ID        : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Transmitter_Info :    out DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR;
      Status           :    out DG_Status.STATUS_TYPE) is

      Entity_Index      : INTEGER;
      Local_Status      : DG_Status.STATUS_TYPE;
      Transmitter_Index : INTEGER;

   begin  -- Get_Entity_Transmitter

      Transmitter_Info := NULL;
      Status           := DG_Status.SUCCESS;

      DG_Hash_Table_Support.Entity_Hash_Index(
        Command    => DG_Hash_Table_Support.FIND,
        Entity_ID  => Entity_ID,
        Hash_Table => DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table,
        Hash_Index => Entity_Index,
        Status     => Local_Status);

      if (DG_Status.Success(Local_Status)) then

         if (Entity_Index /= 0) then

            Transmitter_Index
              := DG_Server_Interface.Interface.Simulation_Data.Entity_XRef_Table(
                   Entity_Index).Transmitter_Index;

            if (Transmitter_Index /= 0) then

               Transmitter_Info
                 := Addr_To_Ptr(
                      DG_Server_Interface.Interface.Simulation_Data.Transmitter_Data_Table(
                        Transmitter_Index)'ADDRESS);

            end if;

         end if;

      else

         Status := Local_Status;

      end if;

   end Get_Entity_Transmitter;

   procedure Get_Entity_Emission(
      Entity_ID        : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Emission_Info    :    out DIS_PDU_Pointer_Types.EMISSION_PDU_PTR;
      Status           :    out DG_Status.STATUS_TYPE) is


      Emission_Index : INTEGER;
      Entity_Index   : INTEGER;
      Local_Status   : DG_Status.STATUS_TYPE;

   begin  -- Get_Entity_Emission

      Emission_Info := NULL;
      Status        := DG_Status.SUCCESS;

      DG_Hash_Table_Support.Entity_Hash_Index(
        Command    => DG_Hash_Table_Support.FIND,
        Entity_ID  => Entity_ID,
        Hash_Table => DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table,
        Hash_Index => Entity_Index,
        Status     => Local_Status);

      if (DG_Status.Success(Local_Status)) then

         if (Entity_Index /= 0) then

            Emission_Index
              := DG_Server_Interface.Interface.Simulation_Data.Entity_XRef_Table(
                   Entity_Index).Emitter_Index;

            if (Emission_Index /= 0) then

               Emission_Info
                 := Addr_To_Ptr(
                      DG_Server_Interface.Interface.Simulation_Data.Emitter_Data_Table(
                        Emission_Index)'ADDRESS);

            end if;

         end if;

      else

         Status := Local_Status;

      end if;

   end Get_Entity_Emission;

   ---------------------------------------------------------------------------
   -- Simulation Output
   ---------------------------------------------------------------------------

   --
   -- Send_PDU
   --
   procedure Send_PDU(
      PDU_Address : in     System.ADDRESS;
      Status      :    out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Set_Emission_Info
   --
   procedure Set_Emission_Info(
      Emission_Info : in     DIS_Types.AN_EMISSION_PDU;
      Status        :    out DG_Status.STATUS_TYPE)
     is separate;

   --
   -- Set_Entity_Info
   --
   procedure Set_Entity_Info(
      Entity_Info : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status      :    out DG_Status.STATUS_TYPE) is
   begin
      Status := DG_Status.SUCCESS;
   end Set_Entity_Info;

   --
   -- Remove_Entity
   --
   procedure Remove_Entity(
      Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status    :    out DG_Status.STATUS_TYPE) is
   begin
      Status := DG_Status.SUCCESS;
   end Remove_Entity;

   --
   -- Remove_Entity_By_Hash_Index
   --
   procedure Remove_Entity_By_Hash_Index(
      Entity_Index : in     INTEGER;
      Status       :    out DG_Status.STATUS_TYPE) is
   begin
      Status := DG_Status.SUCCESS;
   end Remove_Entity_By_Hash_Index;

   ---------------------------------------------------------------------------
   -- DIS Library (DL) Support Routines
   ---------------------------------------------------------------------------

   --
   -- Get_Entity_List
   --
   procedure Get_Entity_List(
      Entity_List : out DL_Linked_List_Types.Entity_State_List.PTR;
      Status      : out DG_Status.STATUS_TYPE) is

      Local_List : DL_Linked_List_Types.Entity_State_List.PTR;

      function Addr_To_Ptr is
        new Unchecked_Conversion(
              System.ADDRESS,
              DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR);

      function "="(Left, Right : DG_Hash_Table_Support.ENTRY_STATUS_TYPE)
        return BOOLEAN
          renames DG_Hash_Table_Support."=";

   begin  -- Get_Entity_List

      Status := DG_Status.SUCCESS;

      Add_Entities:
      for Entity_Index in 1..DG_Server_Interface.Interface.Maximum_Entities loop

         if (DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.Entry_Data(
           Entity_Index).Status = DG_Hash_Table_Support.IN_USE) then

            DL_Linked_List_Types.Entity_State_List.Construct_Top(
              The_Item => Addr_To_Ptr(DG_Server_Interface.Interface.Simulation_Data.
                            Entity_Data_Table(Entity_Index)'ADDRESS),
              Head     => Local_List);

         end if;

      end loop Add_Entities;

      Entity_List := Local_List;

   exception

      when OTHERS =>

         Status := DG_Status.CLI_GEL_FAILURE;

   end Get_Entity_List;

end DG_Client;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
