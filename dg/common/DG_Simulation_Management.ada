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
-- PACKAGE NAME     : DG_Simulation_Management
--
-- FILE NAME        : DG_Simulation_Management.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 08, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DIS_Types;

package body DG_Simulation_Management is

   ---------------------------------------------------------------------------
   -- Store_Entity_Data
   ---------------------------------------------------------------------------

   procedure Store_Entity_Data(
      Entity_Info     : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Store_Emitter_Data
   ---------------------------------------------------------------------------

   procedure Store_Emitter_Data(
      Emitter_Info    : in     DIS_Types.AN_EMISSION_PDU;
      Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Store_Laser_Data
   ---------------------------------------------------------------------------

   procedure Store_Laser_Data(
      Laser_Info      : in     DIS_Types.A_LASER_PDU;
      Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Store_Transmitter_Data
   ---------------------------------------------------------------------------

   procedure Store_Transmitter_Data(
      Transmitter_Info : in     DIS_Types.A_TRANSMITTER_PDU;
      Simulation_Data  : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status           :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Store_Receiver_Data
   ---------------------------------------------------------------------------

   procedure Store_Receiver_Data(
      Receiver_Info   : in     DIS_Types.A_RECEIVER_PDU;
      Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Store_Simulation_Data
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Store_Simulation_Data(
      Generic_PDU     : in     DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

end DG_Simulation_Management;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
