--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         OS
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  1 August 94
--
-- PURPOSE :
--   - This unit provides all set up functions and controls the operation 
--     through the simulation states of the Ordnance Server.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Active_Frozen_Lists, DG_Client, Errors,
--     Gateway_Interface, Munition, OS_GUI, OS_Simulation_Types, OS_Status and
--     OS_Timer.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     DG_Client,
     DG_Status,
     Errors,
     Gateway_Interface,
     Initialize_Simulation,
     Munition,
     OS_Configuration_Files,
     OS_Data_Types,
     OS_GUI,
     OS_Simulation_Types,
     OS_Status,
     OS_Timer;

procedure OS is

   -- Local variables
   K_Seconds_to_Microseconds :  constant := 1000000.0;
   K_Ten_Millisecond_Equivalent :  constant := 10000;
   Current_Pointer   :  Active_Frozen_Lists.LINKED_LIST_ENTRY_RECORD_PTR;
   Events_List_Empty :  BOOLEAN;
   Microseconds      :  INTEGER;
   Munition_Pointer  :  Active_Frozen_Lists.LINKED_LIST_ENTRY_RECORD_PTR;
   Overrun           :  BOOLEAN; -- Not important to OS
   Returned_Status   :  OS_Status.STATUS_TYPE;
   Status_DG         :  DG_Status.STATUS_TYPE;

   -- Local exceptions
   CT_ERROR :  exception;
   DG_ERROR :  exception;
   IS_ERROR :  exception;
   ST_ERROR :  exception;

   -- Rename functions
   function "=" (
     LEFT, RIGHT :  Active_Frozen_Lists.LINKED_LIST_ENTRY_RECORD_PTR)
     return BOOLEAN
     renames Active_Frozen_Lists."=";
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- OS

   -- Initialize Client
   DG_Client.Initialize_Client(
     Status => Status_DG);
   if Status_DG /= DG_Status.SUCCESS then
      raise DG_ERROR;
   end if;

   -- Initialize Simulation
   Initialize_Simulation(
     Status => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise IS_ERROR;
   end if;

   Microseconds := INTEGER(OS_GUI.Interface.Simulation_Parameters.Cycle_Time
     * K_Seconds_to_Microseconds);

   Operation_Loop:
   loop

      DG_Client.Synchronize_With_Server(
        Overrun => Overrun,
        Status  => Status_DG);
      if Status_DG /= DG_Status.SUCCESS then
         -- Report error and exit loop
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => OS_Status.DG_ERROR);
         exit Operation_Loop;
      end if;

      OS_Timer.Set_Timer(
        Seconds      => 0,
        Microseconds => Microseconds,
        Status       => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise ST_ERROR;
      end if;

      Sim_State_Case:
      declare
         -- Rename variables
         Simulation_Parameters :  OS_Simulation_Types.
           SIMULATION_PARAMETERS_RECORD
           renames OS_GUI.Interface.Simulation_Parameters;

      begin -- Sim_State_Loop

         Munition.Update_GUI_Display(
           Status => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            Errors.Report_Error(
              Detonated_Prematurely => FALSE,
              Error                 => Returned_Status);
         end if;

         -- Control flow of simulation based on simulation states
         case Simulation_Parameters.Simulation_State is

            when OS_Simulation_Types.HALT =>
               exit Operation_Loop;
            when OS_Simulation_Types.RUN =>
               Current_Pointer := Active_Frozen_Lists.
                 Top_of_Active_List_Pointer;
               -- Loop through all active munitions to update them
               while Current_Pointer /= null loop
                  -- Munition_Pointer is used to avoid losing the current
                  -- point if a munition is removed from the list (detonated)
                  Munition_Pointer := Current_Pointer;
                  Current_Pointer  := Current_Pointer.Next;
                  Munition.Update_Munition(
                    Hashing_Index => Munition_Pointer.Munition_Data_Pointer.
                                     Hashing_Index,
                    Status        => Returned_Status);
                  if Returned_Status /= OS_Status.SUCCESS then
                     -- Report error
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;
                  if not OS_Timer.Time_Remains then
                     -- Report overrun
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => OS_Status.UPM_OVERRUN);
                     -- Have overrun timeslice and need to allow for processing
                     -- events before next timeslice ends;  Use Microseconds
                     -- minus 10 milliseconds because only 10 millisecond
                     -- accuracy
                     OS_Timer.Set_Timer(
                       Seconds      => 0,
                       Microseconds => (Microseconds
                                        - K_Ten_Millisecond_Equivalent),
                       Status       => Returned_Status);
                     if Returned_Status /= OS_Status.SUCCESS then
                        raise ST_ERROR;
                     end if;
                  end if;
               end loop;

               Events_List_Empty := FALSE;
               -- Get events from network
               while OS_Timer.Time_Remains and then not Events_List_Empty loop
                  Gateway_Interface.Get_Events(
                    Events_List_Empty => Events_List_Empty,
                    Status            => Returned_Status);
                  if Returned_Status /= OS_Status.SUCCESS then
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;
               end loop;

            when OS_Simulation_Types.FREEZE =>
               Events_List_Empty := FALSE;
               -- Get events from network
               while OS_Timer.Time_Remains and then not Events_List_Empty loop
                  Gateway_Interface.Get_Events(
                    Events_List_Empty => Events_List_Empty,
                    Status            => Returned_Status);
                  if Returned_Status /= OS_Status.SUCCESS then
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;
               end loop;
 
            when OS_Simulation_Types.RESET =>
               -- Clear active list
               Active_Frozen_Lists.Clear_List(
                 Top_of_List_Pointer => Active_Frozen_Lists.
                                        Top_of_Active_List_Pointer,
                 Status              => Returned_Status);
               if Returned_Status /= OS_Status.SUCCESS then
                  -- Report error
                  Errors.Report_Error(
                    Detonated_Prematurely => FALSE,
                    Error                 => Returned_Status);
               end if;

               -- Clear frozen list
               Active_Frozen_Lists.Clear_List(
                 Top_of_List_Pointer => Active_Frozen_Lists.
                                        Top_of_Frozen_List_Pointer,
                 Status              => Returned_Status);
               if Returned_Status /= OS_Status.SUCCESS then
                  -- Report error
                  Errors.Report_Error(
                    Detonated_Prematurely => FALSE,
                    Error                 => Returned_Status);
               end if;

               Simulation_Parameters.Simulation_State
                 := OS_Simulation_Types.FREEZE;

            when OS_Simulation_Types.SINGLE_STEP =>
               Current_Pointer := Active_Frozen_Lists.
                 Top_of_Active_List_Pointer;
               -- Loop through all active munitions to update them
               while OS_Timer.Time_Remains and then Current_Pointer /= null
               loop
                  Munition.Update_Munition(
                    Hashing_Index => Current_Pointer.Munition_Data_Pointer.
                                     Hashing_Index,
                    Status        => Returned_Status);
                  if Returned_Status /= OS_Status.SUCCESS then
                     -- Report error
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;
                  Current_Pointer := Current_Pointer.Next;
                  if not OS_Timer.Time_Remains then
                     -- Have overrun timeslice and need to allow for processing
                     -- events before next timeslice ends;  Use Microseconds
                     -- minus 10 milliseconds because only 10 millisecond
                     -- accuracy
                     OS_Timer.Set_Timer(
                       Seconds      => 0,
                       Microseconds => (Microseconds
                                        - K_Ten_Millisecond_Equivalent),
                       Status       => Returned_Status);
                     if Returned_Status /= OS_Status.SUCCESS then
                        raise ST_ERROR;
                     end if;
                  end if;
               end loop;

               Events_List_Empty := FALSE;
               -- Get events from network
               while OS_Timer.Time_Remains and then not Events_List_Empty loop
                  Gateway_Interface.Get_Events(
                    Events_List_Empty => Events_List_Empty,
                    Status            => Returned_Status);
                  if Returned_Status /= OS_Status.SUCCESS then
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;
               end loop;
               Simulation_Parameters.Simulation_State
                 := OS_Simulation_Types.FREEZE; 

         end case;
      end Sim_State_Case;

      OS_Timer.Cancel_Timer(
        Status => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CT_ERROR;
      end if;

      -- Process any configuration file commands from the GUI
      case (OS_GUI.Interface.Configuration_File_Command) is

         when OS_Data_Types.NONE =>

            null;

         when OS_Data_Types.SAVE =>

            OS_Configuration_Files.Save_Configuration_File(
              Filename => OS_GUI.Interface.Configuration_File.Name(
                            1..OS_GUI.Interface.Configuration_File.Length),
              Status   => Returned_Status);
            if (Returned_Status /= OS_Status.SUCCESS) then
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => Returned_Status);
            end if;

         when OS_Data_Types.LOAD =>

            OS_Configuration_Files.Load_Configuration_File(
              Filename => OS_GUI.Interface.Configuration_File.Name(
                            1..OS_GUI.Interface.Configuration_File.Length),
              Status   => Returned_Status);
            if (Returned_Status /= OS_Status.SUCCESS) then
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => Returned_Status);
            end if;

      end case;

      -- Inform GUI that any configuration file commands were processed
      OS_GUI.Interface.Configuration_File_Command := OS_Data_Types.NONE;

   end loop Operation_Loop;

   -- Close GUI interface
   OS_GUI.Unmap_Interface(
     Destroy_Interface => TRUE,
     Status            => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if;

   DG_Client.Terminate_Server_Interface(
     Status => Status_DG);
   if Status_DG /= DG_Status.SUCCESS then
      Returned_Status := OS_Status.DG_ERROR;
      raise DG_ERROR;
   end if;

exception
   when CT_ERROR | DG_ERROR | IS_ERROR | ST_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => OS_Status.OS_ERROR);
 
end OS;
