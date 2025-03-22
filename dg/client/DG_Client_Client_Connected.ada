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
-- UNIT NAME        : DG_Client.Client_Connected
--
-- FILE NAME        : DG_Client_Client_Connected.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 28, 1994
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

separate (DG_Client)

procedure Client_Connected(
   Status : out DG_Status.STATUS_TYPE) is

begin  -- Client_Connected

   if ((not DG_Client_Interface.Interface.Client_Online)
     or else (DG_Client_GUI.Interface.Shutdown_Client)) then

      --
      -- Server or GUI has commanded the Client to shut down.
      --
      Status := DG_Status.CLI_SYNC_SHUTDOWN;

   else

      --
      -- Client should remain connected.
      --
      Status := DG_Status.SUCCESS;

   end if;

exception

   when OTHERS =>

      Status := DG_Status.CLI_CONNECT_FAILURE;

end Client_Connected;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
