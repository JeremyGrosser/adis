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
-- PACKAGE NAME     : DG_PDU_Buffer
--
-- FILE NAME        : DG_PDU_Buffer.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 22, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

package body DG_PDU_Buffer is

   ---------------------------------------------------------------------------
   -- Add
   ---------------------------------------------------------------------------

   procedure Add(
      PDU             : in     DG_Generic_PDU.GENERIC_PDU_TYPE;
      PDU_Buffer      : in out PDU_BUFFER_TYPE;
      PDU_Write_Index : in out INTEGER;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Read
   ---------------------------------------------------------------------------

   procedure Read(
      PDU_Read_Index  : in out INTEGER;
      PDU_Write_Index : in     INTEGER;
      PDU_Buffer      : in     PDU_BUFFER_TYPE;
      PDU             :    out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Status          :    out DG_Status.STATUS_TYPE)
     is separate;

end DG_PDU_Buffer;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
