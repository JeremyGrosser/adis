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
-- UNIT NAME        : DG_Server
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 31, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - None.
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
     DIS_Types,
     DG_Client_Tracking,
     DG_Dead_Reckoning_Support,
     DG_Hash_Table_Support,
     DG_Generic_PDU,
     DG_GUI_Interface_Types,
     DG_IPC_Keys,
     DG_Login_Queue,
     DG_Network_Interface_Support,
     DG_PDU_Buffer,
     DG_Remove_Expired_Entities,
     DG_Status,
     DG_Server_Configuration_File_Management,
     DG_Server_Error_Processing,
     DG_Server_GUI,
     DG_Server_Interface,
     DG_Simulation_Management,
     DG_Start_Server_GUI,
     DG_Timer,
     DIS_PDU_Pointer_Types,
     DIS_Types,
     Numeric_Types,
     System,
     System_Errno,
     Text_IO,
     Unchecked_Conversion;

procedure DG_Server is

   Generic_PDU        : DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   IP_Broadcast       : DG_Network_Interface_Support.IP_STRING_TYPE;
   IP_Length          : INTEGER;
   Last_Timeslice     : INTEGER;
   Overrun_Flag       : BOOLEAN;
   Server_Info        : DG_Login_Queue.SERVER_INFO_TYPE;
   Status             : DG_Status.STATUS_TYPE;
   Timer_Microseconds : INTEGER;
   Timer_Seconds      : INTEGER;

   K_Milliseconds_Per_Second      : constant := 1000;
   K_Microseconds_Per_Millisecond : constant := 1000;

   EXIT_FAILURE : EXCEPTION;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

begin  -- DG_Server

   --
   -- Establish Client login queue
   --
   DG_Client_Tracking.Create_Login_Queue(Status);

   if (Status /= DG_Status.SUCCESS) then
      raise EXIT_FAILURE;
   end if;

   --
   -- Establish GUI interface
   --
   DG_Server_GUI.Map_Interface(
     Create_Interface => TRUE,
     Status           => Status);

   if (Status /= DG_Status.SUCCESS) then
      raise EXIT_FAILURE;
   end if;

   --
   -- Load the configuration file
   --

   DG_Server_GUI.Interface.Configuration_File.Length := 16;
   DG_Server_GUI.Interface.Configuration_File.Name(
     1..DG_Server_GUI.Interface.Configuration_File.Length)
       := "DG_Server.Config";

   DG_Server_Configuration_File_Management.Load_Configuration_File(
     Filename => "DG_Server.Config",
     Status   => Status);

   if (DG_Status.Failure(Status)) then
      DG_Server_Error_Processing.Report_Error(Status);
   end if;

   --
   -- Check if the configuration file specified automatic startup of the
   -- GUI for parameter entry/modification.
   --
   if (DG_Server_Configuration_File_Management.Start_GUI_Flag) then

      --
      -- Indicate that the server is holding off startup until GUI parameter
      -- entry is complete.
      --
      DG_Server_GUI.Interface.Start_Server := FALSE;

      --
      -- Start the GUI
      --
      DG_Start_Server_GUI(
        GUI_Filename => DG_Server_Configuration_File_Management.
                          GUI_Program.ALL,
        Status       => Status);

      if (Status /= DG_Status.SUCCESS) then

         --
         -- Log the problem with starting the GUI.
         --
         DG_Server_Error_Processing.Report_Error(Status);

         --
         -- Set flag to enable startup of Server
         --
         DG_Server_GUI.Interface.Start_Server := TRUE;

      end if;

      --
      -- Wait while user inputs operational parameters
      --
      Wait_For_GUI:
      while (not DG_Server_GUI.Interface.Start_Server) loop

         --
         -- While the Server waits, process any configuration file requests
         -- made by the user.
         --
         case (DG_Server_GUI.Interface.Configuration_File_Command) is

            when DG_GUI_Interface_Types.SAVE =>

               --
               -- Save the current configuration
               --
               DG_Server_Configuration_File_Management.
                 Save_Configuration_File(
                   Filename => DG_Server_GUI.Interface.Configuration_File.
                                 Name(1..DG_Server_GUI.Interface.
                                   Configuration_File.Length),
                   Status   => Status);

               if (DG_Status.Failure(Status)) then
                  DG_Server_Error_Processing.Report_Error(Status);
               end if;

               --
               -- Inform the GUI that the command has been processed.
               --
               DG_Server_GUI.Interface.Configuration_File_Command
                 := DG_GUI_Interface_Types.NONE;

            when DG_GUI_Interface_Types.LOAD =>

               --
               -- Load the configuration file
               --
               DG_Server_Configuration_File_Management.
                 Load_Configuration_File(
                   Filename => DG_Server_GUI.Interface.Configuration_File.
                                 Name(1..DG_Server_GUI.Interface.
                                   Configuration_File.Length),
                   Status   => Status);

               if (DG_Status.Failure(Status)) then
                  DG_Server_Error_Processing.Report_Error(Status);
               end if;

               --
               -- Inform the GUI that the command has been processed.
               --
               DG_Server_GUI.Interface.Configuration_File_Command
                 := DG_GUI_Interface_Types.NONE;

            when DG_GUI_Interface_Types.NONE =>

               null;  -- No processing to perform

         end case;

         --
         -- Delay a small amount of time to free up the CPU.
         --
         delay 0.5;

      end loop Wait_For_GUI;

   end if;

   --
   -- Translate the components of the IP broadcast address into a single,
   -- "dotted quad" format string.
   --
   DG_Network_Interface_Support.Create_IP_Address_String(
     IP_Address => DG_Server_GUI.Interface.Network_Parameters.Broadcast_IP_Address,
     IP_String  => IP_Broadcast,
     IP_Length  => IP_Length,
     Status     => Status);

   if (DG_Status.Failure(Status)) then
      raise EXIT_FAILURE;
   end if;

   DG_Network_Interface_Support.Establish_Network_Interface(
     UDP_Port          => DG_Server_GUI.Interface.Network_Parameters.UDP_Port,
     Broadcast_Address => IP_Broadcast(1..IP_Length),
     Status            => Status);

   if (DG_Status.Failure(Status)) then
      raise EXIT_FAILURE;
   end if;

   --
   -- Create the Server/Client interface
   --
   DG_Server_Interface.Map_Interface(
     Create_Interface      => TRUE,
     Simulation_Parameters => DG_Server_GUI.Interface.
                                Simulation_Data_Parameters,
     Status                => Status);

   if (DG_Status.Failure(Status)) then
      raise EXIT_FAILURE;
   end if;

   --
   -- Now that the Server Interface has been established, the Server_Info
   -- data used in responding to client logins can be initialized.
   --
   Server_Info := (
     Server_ID      => DG_IPC_Keys.Server.Server_Client_Key,
     Permit_Login   => TRUE,
     Interface_Info => (
       Maximum_Entities     => DG_Server_Interface.Interface.Maximum_Entities,
       Maximum_Emitters     => DG_Server_Interface.Interface.Maximum_Emitters,
       Maximum_Lasers       => DG_Server_Interface.Interface.Maximum_Lasers,
       Maximum_Transmitters => DG_Server_Interface.Interface.
                                 Maximum_Transmitters,
       Maximum_Receivers    => DG_Server_Interface.Interface.
                                 Maximum_Receivers,
       PDU_Buffer_Size      => DG_Server_Interface.Interface.
                                 PDU_Buffer_Size));

   --
   -- Set up the synchronization timer.  The timeslice data in the
   -- Server/GUI parameter interface is in milliseconds.
   --

   Last_Timeslice := DG_Server_GUI.Interface.Timeslice;

   Timer_Seconds := DG_Server_GUI.Interface.Timeslice / K_Milliseconds_Per_Second;

   Timer_Microseconds
     := (DG_Server_GUI.Interface.Timeslice - Timer_Seconds * K_Milliseconds_Per_Second)
          * K_Microseconds_Per_Millisecond;

   DG_Timer.Initialize_Timer(
     Seconds      => Timer_Seconds,
     Microseconds => Timer_Microseconds,
     Status       => Status);

   if (Status /= DG_Status.SUCCESS) then
      raise EXIT_FAILURE;
   end if;

   --
   -- Perform following processing until the Server is shut down by the
   -- GUI.
   --

   Server_Processing_Loop:
   while (not DG_Server_GUI.Interface.Shutdown_Server) loop

      --
      -- While the Server waits, process any configuration file requests
      -- made by the user.
      --
      case (DG_Server_GUI.Interface.Configuration_File_Command) is

         when DG_GUI_Interface_Types.SAVE =>

            --
            -- Save the current configuration
            --
            DG_Server_Configuration_File_Management.
              Save_Configuration_File(
                Filename => DG_Server_GUI.Interface.Configuration_File.
                              Name(1..DG_Server_GUI.Interface.
                                Configuration_File.Length),
                Status   => Status);

            if (DG_Status.Failure(Status)) then
               DG_Server_Error_Processing.Report_Error(Status);
            end if;

            --
            -- Inform the GUI that the command has been processed.
            --
            DG_Server_GUI.Interface.Configuration_File_Command
              := DG_GUI_Interface_Types.NONE;

         when DG_GUI_Interface_Types.LOAD =>

            --
            -- Load the configuration file
            --
            DG_Server_Configuration_File_Management.
              Load_Configuration_File(
                Filename => DG_Server_GUI.Interface.Configuration_File.
                              Name(1..DG_Server_GUI.Interface.
                                Configuration_File.Length),
                Status   => Status);

            if (DG_Status.Failure(Status)) then
               DG_Server_Error_Processing.Report_Error(Status);
            end if;

            --
            -- Inform the GUI that the command has been processed.
            --
            DG_Server_GUI.Interface.Configuration_File_Command
              := DG_GUI_Interface_Types.NONE;

         when DG_GUI_Interface_Types.NONE =>

            null;  -- No processing to perform

      end case;

      --
      -- Process Client logins and logouts
      --
      DG_Client_Tracking.Process_Login_Queue(
        Server_Info => Server_Info,
        Status      => Status);

      if (Status /= DG_Status.SUCCESS) then
         DG_Server_Error_Processing.Report_Error(Status);
      end if;

      --
      -- Process data received from the network
      --

      Process_Received_PDUs:
      loop

         DG_Network_Interface_Support.Receive_PDU(
            PDU_Ptr => Generic_PDU,
            Status  => Status);

         if (DG_Status.Failure(Status)) then

            DG_Server_Error_Processing.Report_Error(Status);

         elsif (DG_Generic_PDU.Valid_Generic_PDU_Ptr(Generic_PDU)) then

            case (DG_Generic_PDU.Generic_Ptr_To_PDU_Header_Ptr(
              Generic_PDU).PDU_Type) is

               when DIS_Types.ENTITY_STATE |
                    DIS_Types.EMISSION     |
                    DIS_Types.LASER        |
                    DIS_Types.TRANSMITTER  |
                    DIS_Types.RECEIVER     =>

                  DG_Simulation_Management.Store_Simulation_Data(
                    Generic_PDU     => Generic_PDU,
                    Simulation_Data => DG_Server_Interface.Interface.
                                         Simulation_Data,
                    Status          => Status);

                  if (DG_Status.Failure(Status)) then
                     DG_Server_Error_Processing.Report_Error(Status);
                  end if;

               when OTHERS =>

                  DG_PDU_Buffer.Add(
                    PDU             => Generic_PDU.ALL,
                    PDU_Buffer      => DG_Server_Interface.Interface.
                                          PDU_Buffer,
                    PDU_Write_Index => DG_Server_Interface.Interface.
                                          Buffer_Write_Index,
                    Status          => Status);

                  if (DG_Status.Failure(Status)) then
                     DG_Server_Error_Processing.Report_Error(Status);
                  end if;

            end case;

            DG_Generic_PDU.Free_Generic_PDU(Generic_PDU);

         else

            exit Process_Received_PDUs;

         end if;

      end loop Process_Received_PDUs;

      --
      -- Check thresholds for entity state updates, empty Client/Server
      -- PDU buffers, etc.
      --
      DG_Client_Tracking.Process_Client_Interfaces(Status);

      if (DG_Status.Failure(Status)) then
         DG_Server_Error_Processing.Report_Error(Status);
      end if;

      --
      -- Synchronize the Server
      --
      DG_Timer.Synchronize(
        Overrun => Overrun_Flag,
        Status  => Status);

      if (Status /= DG_Status.SUCCESS) then
         raise EXIT_FAILURE;
      end if;

      --
      -- Report any synchronization overruns
      --
      if (Overrun_Flag) then
         DG_Server_Error_Processing.Report_Error(DG_Status.SRV_OVERRUN);
      end if;

      --
      -- Check for synchronization timer changes from the GUI
      --
      if (Last_Timeslice /= DG_Server_GUI.Interface.Timeslice) then

         Timer_Seconds := DG_Server_GUI.Interface.Timeslice / K_Milliseconds_Per_Second;

         Timer_Microseconds
           := (DG_Server_GUI.Interface.Timeslice - Timer_Seconds
                * K_Milliseconds_Per_Second) * K_Microseconds_Per_Millisecond;

         DG_Timer.Change_Timer(
           Seconds      => Timer_Seconds,
           Microseconds => Timer_Microseconds,
           Status       => Status);

         if (DG_Status.Failure(Status)) then
            DG_Server_Error_Processing.Report_Error(Status);
         end if;

         Last_Timeslice := DG_Server_GUI.Interface.Timeslice;

      end if;

      --
      -- Look for expired entities, and eliminate them.
      --
      DG_Remove_Expired_Entities(
        Simulation_Data => DG_Server_Interface.Interface.Simulation_Data,
        Status          => Status);

      if (DG_Status.Failure(Status)) then
         DG_Server_Error_Processing.Report_Error(Status);
      end if;

      --
      -- Update dead reckoned positions of active entities
      --
      DG_Dead_Reckoning_Support.Update_Entity_Positions(
        Status => Status);

      if (DG_Status.Failure(Status)) then
         DG_Server_Error_Processing.Report_Error(Status);
      end if;

      --
      -- Synchronize all the clients
      --
      DG_Client_Tracking.Synchronize_Clients(
        Status => Status);

      if (Status /= DG_Status.SUCCESS) then
         DG_Server_Error_Processing.Report_Error(Status);
      end if;

   end loop Server_Processing_Loop;

   --
   -- Turn off synchronization timer
   --
   DG_Timer.Terminate_Timer(
     Status => Status);

   if (Status /= DG_Status.SUCCESS) then
      DG_Server_Error_Processing.Report_Error(Status);
   end if;

   --
   -- Inform clients that Server is now offline
   --
   DG_Server_Interface.Interface.Server_Online := FALSE;

   --
   -- Deallocate the client login queue
   --

   DG_Client_Tracking.Remove_Login_Queue(Status);

   if (Status /= DG_Status.SUCCESS) then
      DG_Server_Error_Processing.Report_Error(Status);
   end if;

   --
   -- Shutdown all clients
   --
   DG_Client_Tracking.Shutdown_Clients(
     Status => Status);

   if (Status /= DG_Status.SUCCESS) then
      DG_Server_Error_Processing.Report_Error(Status);
   end if;

   --
   -- Terminate the Server/Client interface
   --
   DG_Server_Interface.Unmap_Interface(
     Destroy_Interface => TRUE,
     Status            => Status);

   if (Status /= DG_Status.SUCCESS) then
      DG_Server_Error_Processing.Report_Error(Status);
   end if;

   --
   -- Shut down the network interface
   --
   DG_Network_Interface_Support.Terminate_Network_Interface(
     Status => Status);

   if (DG_Status.Failure(Status)) then
      DG_Server_Error_Processing.Report_Error(Status);
   end if;

   --
   -- Deallocate the server parameter interface
   --
   DG_Server_GUI.Unmap_Interface(
     Destroy_Interface => TRUE,
     Status            => Status);

   if (Status /= DG_Status.SUCCESS) then
      raise EXIT_FAILURE;
   end if;

exception

   when EXIT_FAILURE =>

      Text_IO.Put_Line(
        "*** INFO  : Status Value  = " & DG_Status.STATUS_TYPE'IMAGE(Status));
      Text_IO.Put_Line(
        "*** INFO  : Errno Message = " & System_Errno.Error_Message);
      Text_IO.Put_Line("*** ERROR : DG_Server failed ***");

   when OTHERS =>

      Text_IO.Put_Line("OTHERS exception terminating DG Server");

end DG_Server;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
