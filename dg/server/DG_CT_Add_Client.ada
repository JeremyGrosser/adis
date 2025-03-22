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
-- UNIT NAME        : DG_Client_Tracking.Add_Client
--
-- FILE NAME        : DG_CT_Add_Client.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
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

separate (DG_Client_Tracking)

procedure Add_Client(
   Client_Data : in     CLIENT_TRACKING_DATA;
   Status      :    out DG_Status.STATUS_TYPE) is

   New_Tracking_Data : CLIENT_TRACKING_DATA_PTR;

begin  -- Add_Client

   Status := DG_Status.SUCCESS;

   New_Tracking_Data := new CLIENT_TRACKING_DATA'(Client_Data);

   Client_List.Add_Node(Data => New_Tracking_Data);

   Number_Of_Clients := Number_Of_Clients + 1;

exception

   when OTHERS =>

      Status := DG_Status.TRACK_ADD_FAILURE;

end Add_Client;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
