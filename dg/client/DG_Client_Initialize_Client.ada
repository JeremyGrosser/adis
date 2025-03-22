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
-- UNIT NAME        : DG_Client.Initialize_Client
--
-- FILE NAME        : DG_Client_Initialize_Client.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 11, 1994
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

with DG_Client_Configuration_File_Management,
     DG_Client_Error_Processing,
     DG_GUI_Interface_Types,
     DG_IPC_Keys,
     DG_Login_Queue,
     DG_Shared_Memory,
     DG_Start_Client_GUI,
     DG_Synchronization;

separate (DG_Client)

procedure Initialize_Client(
   Load_Configuration_File : in     BOOLEAN := FALSE;
   Configuration_File      : in     STRING  := "";
   Load_GUI                : in     BOOLEAN := FALSE;
   GUI_Program             : in     STRING  := "";
   GUI_Display             : in     STRING  := "0";
   Wait_For_GUI            : in     BOOLEAN := TRUE;
   Client_Name             : in     STRING  := "";
   Status                  :    out DG_Status.STATUS_TYPE) is

   Client_Info   : DG_Login_Queue.CLIENT_INFO_TYPE;
   Local_Status  : DG_Status.STATUS_TYPE;
   Server_Info   : DG_Login_Queue.SERVER_INFO_TYPE;

   LOCAL_FAILURE : EXCEPTION;

begin  -- Initialize_Client

   Status := DG_Status.SUCCESS;

   --
   -- Map the Client Parameter interface
   --
   DG_Client_GUI.Map_Interface(
     Create_Interface => TRUE,
     Status           => Local_Status);

   if (DG_Status.Failure(Local_Status)) then
      raise LOCAL_FAILURE;
   end if;

   --
   -- Set the Client's name, if provided.
   --
   if (Client_Name /= "") then

      if (Client_Name'LENGTH
            < DG_Client_GUI.Interface.Client_Name.Name'LENGTH) then

         --
         -- Copy the supplied name into the Client/GUI interface
         --
         DG_Client_GUI.Interface.Client_Name.Name(1..Client_Name'LENGTH)
           := Client_Name;

         DG_Client_GUI.Interface.Client_Name.Length := Client_Name'LENGTH;

      else

         --
         -- Truncate the supplied name to fit the interface bounds
         --
         DG_Client_GUI.Interface.Client_Name.Name
           := Client_Name(
                Client_Name'FIRST
                  ..Client_Name'FIRST
                      + DG_Client_GUI.Interface.Client_Name.Name'LENGTH - 1);

         DG_Client_GUI.Interface.Client_Name.Length
           := DG_Client_GUI.Interface.Client_Name.Name'LENGTH;

      end if;  -- (Client_Name'LENGTH < DG_Client_GUI...Client_Name'LENGTH)

   end if;  -- (Client_Name /= "")

   if (Load_Configuration_File) then

      DG_Client_Configuration_File_Management.Load_Configuration_File(
        Filename => Configuration_File,
        Status   => Local_Status);

      if (DG_Status.Failure(Local_Status)) then
         DG_Client_Error_Processing.Report_Error(Local_Status);
      end if;

   end if;

   --
   -- Start the GUI if requested.  If a GUI was specified by the configuration
   -- file, then this overrides the Load_GUI and GUI_Program parameters passed
   -- to this routine.
   --

   if (DG_Client_Configuration_File_Management.Start_GUI_Flag) then

      DG_Start_Client_GUI(
        GUI_Filename => DG_Client_Configuration_File_Management.
                          GUI_Program.ALL,
        Status       => Local_Status);

      if (DG_Status.Failure(Local_Status)) then
         raise LOCAL_FAILURE;
      end if;

      DG_Client_GUI.Interface.Connect_With_Server := FALSE;

   elsif (Load_GUI) then

      if (GUI_Program /= "") then

         DG_Start_Client_GUI(
           GUI_Filename => GUI_Program,
           Status       => Local_Status);

         if (DG_Status.Failure(Local_Status)) then
            raise LOCAL_FAILURE;
         end if;

         DG_Client_GUI.Interface.Connect_With_Server := FALSE;

      end if;

   else

      --
      -- No GUI is being started, so go directly to the Server login stage.
      --
      DG_Client_GUI.Interface.Connect_With_Server := TRUE;

   end if;

   --
   -- Wait for user to finish entering parameters from the GUI.
   --

   if (Wait_For_GUI) then

      Wait_For_GUI_Loop:
      while (not DG_Client_GUI.Interface.Connect_With_Server) loop

         --
         -- Process requests to save or load configuration files.
         --
         case (DG_Client_GUI.Interface.Configuration_File_Command) is

            when DG_GUI_Interface_Types.SAVE =>

               --
               -- Save the file
               --
               DG_Client_Configuration_File_Management.Save_Configuration_File(
                 Filename => DG_Client_GUI.Interface.Configuration_File.
                               Name(1..DG_Client_GUI.Interface.
                                 Configuration_File.Length),
                 Status   => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Client_Error_Processing.Report_Error(Local_Status);
               end if;

               --
               -- Let the GUI know that the command has been processed
               --
               DG_Client_GUI.Interface.Configuration_File_Command
                 := DG_GUI_Interface_Types.NONE;

            when DG_GUI_Interface_Types.LOAD =>

               DG_Client_Configuration_File_Management.Load_Configuration_File(
                 Filename => DG_Client_GUI.Interface.Configuration_File.
                               Name(1..DG_Client_GUI.Interface.
                                 Configuration_File.Length),
                 Status   => Local_Status);

               if (DG_Status.Failure(Local_Status)) then
                  DG_Client_Error_Processing.Report_Error(Local_Status);
               end if;

               --
               -- Let the GUI know that the command has been processed
               --
               DG_Client_GUI.Interface.Configuration_File_Command
                 := DG_GUI_Interface_Types.NONE;

            when DG_GUI_Interface_Types.NONE =>

               null;  -- No processing to be done

         end case;

         --
         -- Wait a little bit to avoid loading down the system.
         --
         delay 1.0;

      end loop Wait_For_GUI_Loop;

   end if;

   --
   -- Allocate Client/Server interface
   --

   DG_Client_Interface.Map_Interface(
     Create_Interface      => TRUE,
     Simulation_Parameters => DG_Client_GUI.Interface.
                                Simulation_Data_Parameters,
     Memory_Key            => DG_IPC_Keys.Client.Client_Server_Key,
     Interface             => DG_Client_Interface.Interface,
     Status                => Local_Status);

   if (DG_Status.Failure(Local_Status)) then
      raise LOCAL_FAILURE;
   end if;

   --
   -- Allocate a semaphore for synchronization.
   --
   DG_Synchronization.Initialize_Client_Synchronization(
     Status => Local_Status);

   if (DG_Status.Failure(Local_Status)) then
      raise LOCAL_FAILURE;
   end if;

   Client_Info := (
     Client_ID            => DG_IPC_Keys.Client.Client_Server_Key,
     Client_Interface_Key => DG_IPC_Keys.Client.Client_Server_Key,
     Client_Semaphore_Key => DG_IPC_Keys.Client.Sync_Semaphore_Key,
     Login_Flag           => TRUE,
     Interface_Info       => DG_Client_GUI.Interface.
                               Simulation_Data_Parameters);

   DG_Login_Queue.Client_Login(
     Client_Info => Client_Info,
     Server_Info => Server_Info,
     Status      => Local_Status);

   if (DG_Status.Failure(Local_Status)) then
      raise LOCAL_FAILURE;
   end if;

   if (Server_Info.Permit_Login) then

      --
      -- Map the server interface
      --

      DG_Server_Interface.Map_Interface(
        Create_Interface      => FALSE,
        Simulation_Parameters => Server_Info.Interface_Info,
        Status                => Local_Status);

      if (DG_Status.Failure(Local_Status)) then
         raise LOCAL_FAILURE;
      end if;

      --
      -- Synchronize Client and Server for circular PDU buffer indexing.
      --
      DG_Client_Interface.Interface.Buffer_Read_Index
        := DG_Server_Interface.Interface.Buffer_Write_Index;

      --
      -- Inform GUI that the client is now logged in.
      --
      DG_Client_GUI.Interface.Connected_To_Server := TRUE;

   else  -- Server_Info.Permit_Login = FALSE

      Status := DG_Status.CLI_INI_LOGIN_DENIED_FAILURE;

   end if;

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.CLI_INI_FAILURE;

end Initialize_Client;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
