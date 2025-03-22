--
-- OS_UI - An extremely simple user interface for the OS.  Allows the system
--         state to be changed between RUN/FREEZE/HALT/RESET/SINGLE_STEP.
--

with OS_GUI,
     OS_Simulation_Types,
     OS_Status,
     Text_IO;

procedure OS_UI is

   State_Len : INTEGER;
   State_Str : STRING(1..80);
   Status_OS : OS_Status.STATUS_TYPE;

   EXIT_FAILURE : EXCEPTION;

   function "="(Left, Right : OS_Status.STATUS_TYPE)
     return BOOLEAN
       renames OS_Status."=";

   function "="(Left, Right : OS_Simulation_Types.SIMULATION_STATE_TYPE)
     return BOOLEAN
       renames OS_Simulation_Types."=";

begin  -- OS_UI

   OS_GUI.Map_Interface(
     Create_Interface => TRUE,
     Status           => Status_OS);
   if (Status_OS /= OS_Status.SUCCESS) then
      Text_IO.Put_Line("Error in Map_Interface");
      raise EXIT_FAILURE;
   end if;

   Text_IO.Put_Line("Sanity check - the ModSAF Database is: "
     & OS_GUI.Interface.Simulation_Parameters.ModSAF_Database_Filename);

   State_Change_Loop:
   while (OS_GUI.Interface.Simulation_Parameters.Simulation_State
     /= OS_Simulation_Types.HALT) loop

      Text_IO.Put("The current OS state is "
        & OS_Simulation_Types.SIMULATION_STATE_TYPE'IMAGE(
            OS_GUI.Interface.Simulation_Parameters.Simulation_State));

      Text_IO.New_Line;

      Text_IO.Put_Line("Please enter the next simulation state, one of:");

      Print_States:
      for State_Index in OS_Simulation_Types.SIMULATION_STATE_TYPE loop

         Text_IO.Put_Line("    "
           & OS_Simulation_Types.SIMULATION_STATE_TYPE'IMAGE(State_Index));

      end loop Print_States;

      Text_IO.New_Line;

      Trap_Bad_States:
      begin

           Text_IO.Put("New state: ");
           Text_IO.Get_Line(State_Str, State_Len);

           if (State_Len > 0) then

              OS_GUI.Interface.Simulation_Parameters.Simulation_State
                := OS_Simulation_Types.SIMULATION_STATE_TYPE'VALUE(
                     State_Str(1..State_Len));

           end if;

      exception

         when OTHERS =>

            Text_IO.New_Line;
            Text_IO.Put_Line("Invalid state entered, please try again.");
            Text_IO.New_LIne;

      end Trap_Bad_States;

   end loop State_Change_Loop;

   OS_GUI.Unmap_Interface(
     Destroy_Interface => TRUE,
     Status            => Status_OS);
   if (Status_OS /= OS_Status.SUCCESS) then
      Text_IO.Put_Line("Error in Unmap_Interface");
      raise EXIT_FAILURE;
   end if;

exception

   when EXIT_FAILURE =>

      Text_IO.Put_Line("OS_UI exiting due to error");

end OS_UI;
