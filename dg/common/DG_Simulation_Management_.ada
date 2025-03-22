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
-- FILE NAME        : DG_Simulation_Management_.ada
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
-- EFFECTS:
--   - The expected usage is:
--     1. 
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
     DG_Interface_Types,
     DG_Status,
     DIS_Types;

package DG_Simulation_Management is

   ---------------------------------------------------------------------------
   -- Store_Simulation_Data
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Store_Simulation_Data(
      Generic_PDU     : in     DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status          :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Store_Emitter_Data
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Store_Emitter_Data(
      Emitter_Info    : in     DIS_Types.AN_EMISSION_PDU;
      Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
      Status          :    out DG_Status.STATUS_TYPE);

end DG_Simulation_Management;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
