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
-- UNIT NAME        : Process_Client_Interfaces
--
-- FILE NAME        : Process_Client_Interfaces.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 21, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - 
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

with Calendar,
     DG_Generic_PDU,
     DG_Hash_Table_Support,
     DG_PDU_Buffer,
     DG_Server_Error_Processing,
     DG_Server_GUI,
     DG_Server_Interface,
     DIS_Types,
     Numeric_Types,
     System;

separate (DG_Client_Tracking)

procedure Process_Client_Interfaces(
   Status : out DG_Status.STATUS_TYPE) is

   Client_Entity_Total : INTEGER := 0;
   Client_Laser_Total  : INTEGER := 0;
   Client_Ptr          : Client_List.LIST_NODE_PTR := Client_List.List_Head;
   Issue_PDU           : BOOLEAN;
   Local_Status        : DG_Status.STATUS_TYPE;
   PDU_Pointer         : DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Server_Index        : INTEGER;
   Temp_Entity_Index   : INTEGER;
   Update_Interval     : Calendar.DAY_DURATION;


   K_MSec_To_Sec        : constant := 0.001;
   K_IITSEC_Bit_23_Mask : constant Numeric_Types.UNSIGNED_16_BIT
                            := 2#0000000010000000#;

   function "="(Left, Right : DG_Hash_Table_Support.ENTRY_STATUS_TYPE)
     return BOOLEAN
       renames DG_Hash_Table_Support."=";

   function "-"(Left, Right : Calendar.TIME)
     return DURATION
       renames Calendar."-";

   function "="(Left, Right : DIS_Types.AN_ENTITY_APPEARANCE)
     return BOOLEAN
       renames DIS_Types."=";

   function "and"(Left, Right : Numeric_Types.UNSIGNED_16_BIT)
     return Numeric_Types.UNSIGNED_16_BIT
       renames Numeric_Types."and";

   function "="(Left, Right : Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
       renames Numeric_Types."=";

   function Generic_PDU_To_Address is
     new Unchecked_Conversion(
           DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE,
           System.ADDRESS);

begin  -- Process_Client_Interfaces

   Status := DG_Status.SUCCESS;

   Process_Client_Loop:
   while (Client_Ptr /= NULL) loop

      Process_Entity_Loop:
      for Entity_Index in 1..Client_Ptr.Data.Interface.Maximum_Entities loop

         if (Client_Ptr.Data.Interface.Simulation_Data.Entity_Hash_Table.
           Entry_Data(Entity_Index).Status = DG_Hash_Table_Support.IN_USE)
         then

            --
            -- Assume no PDU will be issued to begin with.
            --
            Issue_PDU := FALSE;

            --
            -- Check to see if the Client's entity has been cross-referenced
            -- with the Server's main table.
            --
            Server_Index
              := Client_Ptr.Data.Entity_Data(Entity_Index).Server_Hash_Index;

            if (Server_Index = 0) then

               DG_Hash_Table_Support.Entity_Hash_Index(
                 Command    => DG_Hash_Table_Support.ADD,
                 Entity_ID  => Client_Ptr.Data.Interface.Simulation_Data.
                                 Entity_Data_Table(Entity_Index).Entity_ID,
                 Hash_Table => DG_Server_Interface.Interface.Simulation_Data.
                                 Entity_Hash_Table,
                 Hash_Index => Server_Index,
                 Status     => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Server_Error_Processing.Report_Error(Local_Status);
                  Server_Index := 0;
               else

                  Client_Ptr.Data.Entity_Data(Entity_Index).Server_Hash_Index
                    := Server_Index;

                  --
                  -- Update the Server's data for the Client's entity
                  --
                  DG_Server_Interface.Interface.Simulation_Data.
                    Entity_Data_Table(Server_Index)
                      := Client_Ptr.Data.Interface.Simulation_Data.
                           Entity_Data_Table(Entity_Index);

                  --
                  -- Set the update and reception times to the current time.
                  --

                  DG_Server_Interface.Interface.Simulation_Data.
                    Entity_Update_Time(Server_Index) := Calendar.Clock;

                  DG_Server_Interface.Interface.Simulation_Data.
                    Entity_Reception_Time(Server_Index)
                      := DG_Server_Interface.Interface.Simulation_Data.
                           Entity_Update_Time(Server_Index);

                  Issue_PDU := TRUE;

               end if;

            end if;  -- (Server_Index = 0)

            --
            -- Check distance, orientation, and update interval thresholds,
            -- as well as entity appearance fields to determine if a new PDU
            -- needs to be transmitted.
            --

            if (not Issue_PDU) then

               --
               -- Check entity position to see if changes in X, Y, or Z
               -- coordinates has exceeded the distance threshold.
               --

               if (
                 (Numeric_Types.FLOAT_64_BIT(
                   DG_Server_GUI.Interface.Threshold_Parameters.Distance)
                     <= ABS(DG_Server_Interface.Interface.Simulation_Data.
                       Entity_Data_Table(Server_Index).Location.X
                         - Client_Ptr.Data.Interface.Simulation_Data.
                           Entity_Data_Table(Entity_Index).Location.X))
                 or else
                   (Numeric_Types.FLOAT_64_BIT(
                     DG_Server_GUI.Interface.Threshold_Parameters.Distance)
                       <= ABS(DG_Server_Interface.Interface.Simulation_Data.
                         Entity_Data_Table(Server_Index).Location.Y
                           - Client_Ptr.Data.Interface.Simulation_Data.
                             Entity_Data_Table(Entity_Index).Location.Y))
                 or else
                   (Numeric_Types.FLOAT_64_BIT(
                     DG_Server_GUI.Interface.Threshold_Parameters.Distance)
                       <= ABS(DG_Server_Interface.Interface.Simulation_Data.
                         Entity_Data_Table(Server_Index).Location.Z
                           - Client_Ptr.Data.Interface.Simulation_Data.
                             Entity_Data_Table(Entity_Index).Location.Z)))
               then

                  Issue_PDU := TRUE;

               end if;  -- Distance threshold check

            end if;  -- (not Issue_PDU)

            --
            -- !!!!! Need orientation checks here...
            --

            if (not Issue_PDU) then

               --
               -- Check for changes in the entity's appearance
               --

               if (DG_Server_Interface.Interface.Simulation_Data.
                 Entity_Data_Table(Server_Index).Appearance
                   /= Client_Ptr.Data.Interface.Simulation_Data.
                     Entity_Data_Table(Entity_Index).Appearance) then

                  Issue_PDU := TRUE;

               end if;  -- Appearance change check

            end if;  -- (not Issue_PDU)

            if (not Issue_PDU) then

               --
               -- Calculate time since last time this entity was "received"
               -- from the Client.  This time is updated only when a new
               -- entity first appears from the Client, or when a PDU is
               -- broadcast for an entity.
               --

               Update_Interval
                 := Calendar.Clock
                      - DG_Server_Interface.Interface.Simulation_Data.
                          Entity_Reception_Time(Server_Index);

               if (INTEGER(Update_Interval) >= DG_Server_GUI.Interface.
                 Threshold_Parameters.Entity_Update) then

                  Issue_PDU := TRUE;

               end if;

            end if;

            --
            -- Issue an updated PDU if appropriate.
            --

            if (Issue_PDU) then

               --
               -- Update the Server's data for the Client's entity
               --
               DG_Server_Interface.Interface.Simulation_Data.
                 Entity_Data_Table(Server_Index)
                   := Client_Ptr.Data.Interface.Simulation_Data.
                        Entity_Data_Table(Entity_Index);

               --
               -- Set the update and reception times to the current time.
               --

               DG_Server_Interface.Interface.Simulation_Data.
                 Entity_Update_Time(Server_Index) := Calendar.Clock;

               DG_Server_Interface.Interface.Simulation_Data.
                 Entity_Reception_Time(Server_Index)
                   := DG_Server_Interface.Interface.Simulation_Data.
                        Entity_Update_Time(Server_Index);

               --
               -- Send the new information out to the network
               --
               DG_Network_Interface_Support.Transmit_PDU(
                 PDU    => Client_Ptr.Data.Interface.Simulation_Data.
                             Entity_Data_Table(Entity_Index)'ADDRESS,
                 Status => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Server_Error_Processing.Report_Error(Local_Status);
               end if;

            end if;

            --
            -- Update the number of client entities
            --
            Client_Entity_Total := Client_Entity_Total + 1;

            --
            -- If I/ITSEC "Bit 23" entity expiration is enabled, then check
            -- if the entity has been removed by the client.
            --
            if (DG_Server_GUI.Interface.Exercise_Parameters.
              IITSEC_Bit_23_Support) then

               if ((Client_Ptr.Data.Interface.Simulation_Data.
                 Entity_Data_Table(Entity_Index).Appearance.Specific and
                   K_IITSEC_Bit_23_Mask) = K_IITSEC_Bit_23_Mask) then

                  --
                  -- Send one last PDU to ensure that everyone sees Bit 23 set
                  --
                  DG_Network_Interface_Support.Transmit_PDU(
                    PDU    => Client_Ptr.Data.Interface.Simulation_Data.
                                Entity_Data_Table(Entity_Index)'ADDRESS,
                    Status => Local_Status);

                  if (DG_Status.Failure(Local_Status)) then
                     DG_Server_Error_Processing.Report_Error(Local_Status);
                  end if;

                  --
                  -- Remove the hash table entry for this entity
                  --

                  DG_Hash_Table_Support.Entity_Hash_Index(
                    Command    => DG_Hash_Table_Support.DELETE,
                    Entity_ID  => Client_Ptr.Data.Interface.Simulation_Data.
                                    Entity_Data_Table(Entity_Index).Entity_ID,
                    Hash_Table => Client_Ptr.Data.Interface.Simulation_Data.
                                    Entity_Hash_Table,
                    Hash_Index => Temp_Entity_Index,
                    Status     => Local_Status);

                  if (DG_Status.Failure(Local_Status)) then
                     DG_Server_Error_Processing.Report_Error(Local_Status);
                  end if;

                  DG_Hash_Table_Support.Entity_Hash_Index(
                    Command    => DG_Hash_Table_Support.DELETE,
                    Entity_ID  => DG_Server_Interface.Interface.
                                    Simulation_Data.Entity_Data_Table(
                                      Server_Index).Entity_ID,
                    Hash_Table => DG_Server_Interface.Interface.
                                    Simulation_Data.Entity_Hash_Table,
                    Hash_Index => Temp_Entity_Index,
                    Status     => Local_Status);

                  if (DG_Status.Failure(Local_Status)) then
                     DG_Server_Error_Processing.Report_Error(Local_Status);
                  end if;

                  Client_Ptr.Data.Entity_Data(Entity_Index).Server_Hash_Index
                    := 0;

                  --
                  -- Update the number of client entities
                  --
                  Client_Entity_Total := Client_Entity_Total - 1;

               end if;

            end if;  -- I/ITSEC Bit 23

            --
            -- Calculate time since last time this entity was "received"
            -- from the Client.  This time is updated only when new data
            -- is provided by the Client.
            --
            Update_Interval
              := Calendar.Clock
                   - Client_Ptr.Data.Interface.Simulation_Data.
                       Entity_Reception_Time(Entity_Index);

            if (INTEGER(Update_Interval) >= DG_Server_GUI.Interface.
              Threshold_Parameters.Entity_Expiration) then

               --
               -- Remove the client from its hash table
               --
               DG_Hash_Table_Support.Entity_Hash_Index(
                 Command    => DG_Hash_Table_Support.DELETE,
                 Entity_ID  => Client_Ptr.Data.Interface.Simulation_Data.
                                 Entity_Data_Table(Entity_Index).Entity_ID,
                 Hash_Table => Client_Ptr.Data.Interface.Simulation_Data.
                                 Entity_Hash_Table,
                 Hash_Index => Temp_Entity_Index,
                 Status     => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Server_Error_Processing.Report_Error(Local_Status);
               end if;

               DG_Hash_Table_Support.Entity_Hash_Index(
                 Command    => DG_Hash_Table_Support.DELETE,
                 Entity_ID  => DG_Server_Interface.Interface.
                                 Simulation_Data.Entity_Data_Table(
                                   Server_Index).Entity_ID,
                 Hash_Table => DG_Server_Interface.Interface.
                                 Simulation_Data.Entity_Hash_Table,
                 Hash_Index => Temp_Entity_Index,
                 Status     => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Server_Error_Processing.Report_Error(Local_Status);
               end if;

               Client_Ptr.Data.Entity_Data(Entity_Index).Server_Hash_Index
                 := 0;

               --
               -- Update the number of client entities
               --
               Client_Entity_Total := Client_Entity_Total - 1;

            end if;

         end if;  -- ...Entry_Data(Entity_Index).Status = ...IN_USE

      end loop Process_Entity_Loop;

      Process_Laser_Loop:
      for Laser_Index in 1..Client_Ptr.Data.Interface.Maximum_Lasers loop

         if (Client_Ptr.Data.Interface.Simulation_Data.Laser_Hash_Table.
           Entry_Data(Laser_Index).Status = DG_Hash_Table_Support.IN_USE)
         then

            --
            -- Assume no PDU will be issued to begin with.
            --
            Issue_PDU := FALSE;

            --
            -- Check to see if the Client's laser has been cross-referenced
            -- with the Server's main table.
            --
            Server_Index
              := Client_Ptr.Data.Laser_Data(Laser_Index).Server_Hash_Index;

            if (Server_Index = 0) then

               DG_Hash_Table_Support.Entity_Hash_Index(
                 Command    => DG_Hash_Table_Support.ADD,
                 Entity_ID  => Client_Ptr.Data.Interface.Simulation_Data.
                                 Laser_Data_Table(Laser_Index).
                                   Lasing_Entity_ID,
                 Hash_Table => DG_Server_Interface.Interface.Simulation_Data.
                                 Laser_Hash_Table,
                 Hash_Index => Server_Index,
                 Status     => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Server_Error_Processing.Report_Error(Local_Status);
                  Server_Index := 0;
               else

                  Client_Ptr.Data.Laser_Data(Laser_Index).Server_Hash_Index
                    := Server_Index;

                  --
                  -- Update the Server's data for the Client's entity
                  --
                  DG_Server_Interface.Interface.Simulation_Data.
                    Laser_Data_Table(Laser_Index)
                      := Client_Ptr.Data.Interface.Simulation_Data.
                           Laser_Data_Table(Laser_Index);

                  --
                  -- Set the update and reception times to the current time.
                  --

                  DG_Server_Interface.Interface.Simulation_Data.
                    Laser_Update_Time(Server_Index) := Calendar.Clock;

                  DG_Server_Interface.Interface.Simulation_Data.
                    Laser_Reception_Time(Server_Index)
                      := DG_Server_Interface.Interface.Simulation_Data.
                           Laser_Update_Time(Server_Index);

                  Issue_PDU := TRUE;

               end if;

            end if;  -- (Server_Index = 0)

            --
            -- Check update interval threshold to determine if a new PDU
            -- needs to be transmitted.
            --

            if (not Issue_PDU) then

               --
               -- Calculate time since last time this laser was "received"
               -- from the Client.  This time is updated only when a new
               -- laser first appears from the Client, or when a PDU is
               -- broadcast for a laser.
               --

               Update_Interval
                 := Calendar.Clock
                      - DG_Server_Interface.Interface.Simulation_Data.
                          Laser_Reception_Time(Server_Index);

               if (FLOAT(Update_Interval) >= FLOAT(DG_Server_GUI.Interface.
                 Threshold_Parameters.Laser_Update) * K_MSec_To_Sec) then

                  Issue_PDU := TRUE;

               end if;

            end if;

            --
            -- Issue an updated PDU if appropriate.
            --

            if (Issue_PDU) then

               --
               -- Update the Server's data for the Client's entity
               --
               DG_Server_Interface.Interface.Simulation_Data.
                 Laser_Data_Table(Server_Index)
                   := Client_Ptr.Data.Interface.Simulation_Data.
                        Laser_Data_Table(Laser_Index);

               --
               -- Set the update and reception times to the current time.
               --

               DG_Server_Interface.Interface.Simulation_Data.
                 Laser_Update_Time(Server_Index) := Calendar.Clock;

               DG_Server_Interface.Interface.Simulation_Data.
                 Laser_Reception_Time(Server_Index)
                   := DG_Server_Interface.Interface.Simulation_Data.
                        Laser_Update_Time(Server_Index);

               --
               -- Send the new information out to the network
               --
               DG_Network_Interface_Support.Transmit_PDU(
                 PDU    => Client_Ptr.Data.Interface.Simulation_Data.
                             Laser_Data_Table(Laser_Index)'ADDRESS,
                 Status => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Server_Error_Processing.Report_Error(Local_Status);
               end if;

            end if;

            --
            -- Update the number of client entities
            --
            Client_Laser_Total := Client_Laser_Total + 1;

         end if;

      end loop Process_Laser_Loop;

      Process_PDUs_Loop:
      loop

         --
         -- Read the next PDU sent by this client
         --

         DG_PDU_Buffer.Read(
           PDU_Read_Index  => Client_Ptr.Data.Buffer_Read_Index,
           PDU_Write_Index => Client_Ptr.Data.Interface.Buffer_Write_Index,
           PDU_Buffer      => Client_Ptr.Data.Interface.PDU_Buffer,
           PDU             => PDU_Pointer,
           Status          => Local_Status);

         if (DG_Status.Failure(Local_Status)) then
            DG_Server_Error_Processing.Report_Error(Local_Status);
         end if;

         --
         -- Exit the loop if all PDUs have been processed.
         --
         exit Process_PDUs_Loop when
           DG_Generic_PDU.Null_Generic_PDU_Ptr(PDU_Pointer);

         --
         -- If network transmissions are enabled, then use Transmit_PDU to
         -- send perform the transmission.  If transmissions are disabled,
         -- then call Add_PDU directly to send the PDU to any local clients.
         --

         if (DG_Server_GUI.Interface.Network_Parameters.
           Data_Transmission_Enabled) then

            --
            -- Transmit the PDU to the network
            --
            DG_Network_Interface_Support.Transmit_PDU(
              PDU    => Generic_PDU_To_Address(PDU_Pointer),
              Status => Local_Status);

            if (DG_Status.Failure(Local_Status)) then
               DG_Server_Error_Processing.Report_Error(Local_Status);
            end if;

         else

            --
            -- Echo the PDU back to the Server PDU buffer
            --
            DG_PDU_Buffer.Add(
              PDU             => PDU_Pointer.ALL,
              PDU_Buffer      => DG_Server_Interface.Interface.PDU_Buffer,
              PDU_Write_Index => DG_Server_Interface.Interface.
                                   Buffer_Write_Index,
              Status          => Local_Status);

            if (DG_Status.Failure(Local_Status)) then
               DG_Server_Error_Processing.Report_Error(Local_Status);
            end if;

         end if;  -- (...Data_Transmission_Enabled)

      end loop Process_PDUs_Loop;

      Client_Ptr := Client_Ptr.Next;

   end loop Process_Client_Loop;

   DG_Server_GUI.Interface.Server_Monitor.Number_Of_Client_Entities
     := Client_Entity_Total;

   DG_Server_GUI.Interface.Server_Monitor.Number_Of_Client_Lasers
     := Client_Laser_Total;

exception

   when OTHERS =>

      Status := DG_Status.TRACK_PCI_FAILURE;

end Process_Client_Interfaces;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
