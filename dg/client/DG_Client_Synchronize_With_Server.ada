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
-- UNIT NAME        : DG_Client.Synchronize_With_Server
--
-- FILE NAME        : DG_Client_Synchronize_With_Server.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 09, 1994
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

with DG_Synchronization;

separate (DG_Client)

procedure Synchronize_With_Server(
   Overrun : out BOOLEAN;
   Status  : out DG_Status.STATUS_TYPE) is

begin  -- Synchronize_With_Server

   if ((not DG_Client_Interface.Interface.Client_Online)
     or else (DG_Client_GUI.Interface.Shutdown_Client)) then

      --
      -- Server or GUI has commanded the Client to shut down.
      --
      Status := DG_Status.CLI_SYNC_SHUTDOWN;

   else

      DG_Synchronization.Synchronize_With_Server(
        Overrun => Overrun,
        Status  => Status);

   end if;

exception

   when OTHERS =>

      Status := DG_Status.CLI_SYNC_FAILURE;

end Synchronize_With_Server;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
