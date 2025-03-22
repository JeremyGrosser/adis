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
-- UNIT NAME        : OS_Start_GUI
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    Ordnance Server
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 25, 1994
--
-- PURPOSE:
--   - This routine starts the Ordnance Server's Graphical User Interface
--     program.
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

with C_Strings,
     OS_GUI,
     OS_Status,
     System_Exec,
     U_Env,
     Unix,
     Unix_Prcs;

procedure OS_Start_GUI(
   GUI_Filename : in     STRING;
   Status       :    out OS_Status.STATUS_TYPE) is

   --
   -- Declare variable to store simple argument variables
   --
   New_Argument : System_Exec.C_STRING_ARRAY(1..2);

   --
   -- Declare variable large enough to store all existing environment variable
   -- values, as well as the Client/GUI interface key value and the NULL entry
   -- which terminates the environment variable list.
   --
   New_Environment : System_Exec.C_STRING_ARRAY(1..U_Env.EnvC+2);

   --
   -- Result of calling ExecVE
   --
   ExecVE_Status : INTEGER;

begin  -- OS_Start_GUI

   Status := OS_Status.SUCCESS;

   --
   -- Copy all existing environemntal variables into New_Environment.  Note
   -- that the environment variable array (U_Env.EnvP) is indexed from 0 to
   -- U_Env.EnvC-1.
   --

   Copy_Existing_Environment:
   for Env_Index in 1..U_Env.EnvC loop

      New_Environment(Env_Index)
        := C_Strings.Convert_A_To_C(U_Env.EnvP(Env_Index-1));

   end loop Copy_Existing_Environment;

   --
   -- Add an environment variable for the OS/GUI interface key.
   --
   New_Environment(U_Env.EnvC+1)
     := C_Strings.Convert_String_To_C(
          OS_GUI.K_OS_GUI_Env_Var & "=" & INTEGER'IMAGE(Unix.GetPID));
 
   --
   -- Terminate the environment variable list with a NULL pointer.
   --
   New_Environment(U_Env.EnvC+2) := NULL;

   --
   -- Set up a simple argument list...
   --
   New_Argument(1) := C_Strings.Convert_String_To_C(" ");
   New_Argument(2) := NULL;

   --
   -- Fork off a new process to become the GUI
   --
   if (Unix_Prcs.Fork = 0) then

      --
      -- Start the GUI program with the new environment variable list.
      --
      ExecVE_Status
        := System_Exec.ExecVE(
             Path => C_Strings.Convert_String_To_C(GUI_Filename),
             ArgV => New_Argument'ADDRESS,
             EnvP => New_Environment'ADDRESS);

      if (ExecVE_Status = -1) then
         Status := OS_Status.OSSGUI_EXECVE_ERROR;
      end if;

   end if;

exception

   when OTHERS =>

      Status := OS_Status.OSSGUI_ERROR;

end OS_Start_GUI;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
