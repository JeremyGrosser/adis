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
-- PACKAGE NAME     : DG_IPC_Keys
--
-- FILE NAME        : DG_IPC_Keys.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 24, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with A_Strings,
     U_Env;

package body DG_IPC_Keys is

   ---------------------------------------------------------------------------
   -- DG Client GUI Keys
   ---------------------------------------------------------------------------

   package body Client_GUI is

      ------------------------------------------------------------------------
      -- Client_GUI_Key
      ------------------------------------------------------------------------

      function Client_GUI_Key return INTEGER is

         Env_Value : A_Strings.A_STRING;
         Key_Value : INTEGER;

         --
         -- Rename equality function to improve code readability
         --
         function "="(Left, Right : in A_Strings.A_STRING)
           return BOOLEAN
             renames A_Strings."=";

      begin  -- Client_GUI_Key

         --
         -- Find the Client/GUI interface key value from the environment.
         --
         Env_Value
           := U_Env.GetEnv(
                Var_Name => A_Strings.To_A(
                              DG_IPC_Keys.Client.Client_GUI_Env_Name));

         Key_Value := INTEGER'VALUE(Env_Value.S);

         return (Key_Value);

      exception

         when OTHERS =>

            --
            -- An error occurred in retrieving the environment variable value.
            --

            return 0;

      end Client_GUI_Key;

   end Client_GUI;

end DG_IPC_Keys;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
