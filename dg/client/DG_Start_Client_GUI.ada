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
-- UNIT NAME        : DG_Start_Client_GUI
--
-- FILE NAME        : DG_Start_Client_GUI.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 24, 1994
--
-- PURPOSE:
--   - This routine starts the DG Client's Graphical User Interface program.
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
     DG_IPC_Keys,
     DG_Status,
     System_Exec,
     U_Env,
     Unix_Prcs;

procedure DG_Start_Client_GUI(
   GUI_Filename : in     STRING;
   Status       :    out DG_Status.STATUS_TYPE) is

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

begin  -- DG_Start_Client_GUI

   Status := DG_Status.SUCCESS;

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
   -- Add an environment variable for the Client/GUI interface key.
   --
   New_Environment(U_Env.EnvC+1)
     := C_Strings.Convert_String_To_C(
          DG_IPC_Keys.Client.Client_GUI_Env_Name
            & "=" & INTEGER'IMAGE(DG_IPC_Keys.Client.Client_GUI_Key));
 
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
         Status := DG_Status.DG_CLIENT_GUI_EXECVE_FAILURE;
      end if;

   end if;

exception

   when OTHERS =>

      Status := DG_Status.DG_CLIENT_GUI_FAILURE;

end DG_Start_Client_GUI;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
