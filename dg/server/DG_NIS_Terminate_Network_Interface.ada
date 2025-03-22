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
-- UNIT NAME        : DG_Network_Interface_Support.Terminate_Network_Interface
--
-- FILE NAME        : DG_NIS_Terminate_Network_Interface.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 17, 1994
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

separate (DG_Network_Interface_Support)

procedure Terminate_Network_Interface(
   Status : out DG_Status.STATUS_TYPE) is

   Socket_Status : INTEGER;

begin  -- Terminate_Network_Interface

   Status := DG_Status.SUCCESS;

   Socket_Status
     := System_Socket.Close(Socket_ID);

   if (Socket_Status = -1) then
      Status := DG_Status.NIS_TNI_CLOSE_FAILURE;
   end if;

exception

   when OTHERS =>

      Status := DG_Status.NIS_TNI_FAILURE;

end Terminate_Network_Interface;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
