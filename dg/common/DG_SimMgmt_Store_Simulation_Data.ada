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
-- UNIT NAME        : DG_Simulation_Management.Store_Simulation_Data
--
-- FILE NAME        : DG_SimMgmt_Store_Simulation_Data.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 08, 1994
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

with Numeric_Types,
     System;

separate (DG_Simulation_Management)

procedure Store_Simulation_Data(
   Generic_PDU     : in     DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
   Status          :    out DG_Status.STATUS_TYPE) is

begin  -- Store_Simulation_Data

   Status := DG_Status.SUCCESS;

   case (DG_Generic_PDU.Generic_Ptr_To_PDU_Header_Ptr(
     Generic_PDU).PDU_Type) is

      when DIS_Types.ENTITY_STATE =>

         Store_Entity_Data(
           Entity_Info     => DG_Generic_PDU.
                                Generic_Ptr_To_Entity_State_PDU_Ptr(
                                  Generic_PDU).ALL,
           Simulation_Data => Simulation_Data,
           Status          => Status);

      when DIS_Types.LASER =>

         Store_Laser_Data(
           Laser_Info      => DG_Generic_PDU.Generic_Ptr_To_Laser_PDU_Ptr(
                                Generic_PDU).ALL,
           Simulation_Data => Simulation_Data,
           Status          => Status);

      when DIS_Types.EMISSION =>

         Build_ADIS_Emission_PDU:
         declare

            System_Length     : Numeric_Types.UNSIGNED_16_BIT
                                  := Numeric_Types.UNSIGNED_16_BIT(
                                         Generic_PDU.ALL'SIZE/8
                                       - DIS_Types.A_PDU_HEADER'SIZE/8
                                       - DIS_Types.AN_ENTITY_IDENTIFIER'SIZE/8
                                       - DIS_Types.AN_EVENT_IDENTIFIER'SIZE/8
                                       - DIS_Types.A_STATE_UPDATE_INDICATOR
                                           'SIZE/8
                                       - 1
                                       - 2);

            ADIS_Emission_PDU : DIS_Types.AN_EMISSION_PDU(System_Length);

            Emission_Data : DG_Generic_PDU.GENERIC_PDU_TYPE(
                              1..Generic_PDU.ALL'SIZE/8);
              for Emission_Data use at ADIS_Emission_PDU.PDU_Header'ADDRESS;

         begin  -- Build_ADIS_Emission_PDU

            Emission_Data := Generic_PDU.ALL;

            Store_Emitter_Data(
              Emitter_Info    => ADIS_Emission_PDU,
              Simulation_Data => Simulation_Data,
              Status          => Status);

         end Build_ADIS_Emission_PDU;

      when DIS_Types.TRANSMITTER =>

         Store_Transmitter_Data(
           Transmitter_Info => DG_Generic_PDU.
                                 Generic_Ptr_To_Transmitter_PDU_Ptr(
                                   Generic_PDU).ALL,
           Simulation_Data  => Simulation_Data,
           Status           => Status);

      when DIS_Types.RECEIVER =>

         Store_Receiver_Data(
           Receiver_Info   => DG_Generic_PDU.
                                Generic_Ptr_To_Receiver_PDU_Ptr(
                                  Generic_PDU).ALL,
           Simulation_Data => Simulation_Data,
           Status          => Status);

      when OTHERS =>

         Status := DG_Status.SIMMGMT_STRSIM_UNKNOWN_PDU_FAILURE;

   end case;

exception

   when OTHERS =>

      Status := DG_Status.SIMMGMT_STRSIM_FAILURE;

end Store_Simulation_Data;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
