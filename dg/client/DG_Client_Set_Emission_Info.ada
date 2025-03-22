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
-- UNIT NAME        : DG_Client.Set_Emission_Info
--
-- FILE NAME        : DG_Client_Set_Emission_Info.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : November 8, 1994
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

with DG_Generic_PDU,
     DG_Simulation_Management,
     Unchecked_Conversion;

separate (DG_Client)

procedure Set_Emission_Info(
   Emission_Info : in     DIS_Types.AN_EMISSION_PDU;
   Status        :    out DG_Status.STATUS_TYPE) is

begin  -- Set_Emission_Info

   DG_Simulation_Management.Store_Emitter_Data(
      Emitter_Info    => Emission_Info,
      Simulation_Data => DG_Client_Interface.Interface.Simulation_Data,
      Status          => Status);

exception

   when OTHERS =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

end Set_Emission_Info;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
