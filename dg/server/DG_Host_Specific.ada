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
-- PACKAGE NAME     : DG_Host_Specific
--
-- FILE NAME        : DG_Host_Specific.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 29, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

package body DG_Host_Specific is

   ---------------------------------------------------------------------------
   -- Translate_Net_To_Host
   ---------------------------------------------------------------------------

   procedure Translate_Net_To_Host(
      PDU    : in out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Status :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Translate_Host_To_Net
   ---------------------------------------------------------------------------

   procedure Translate_Host_To_Net(
      PDU    : in out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Status :    out DG_Status.STATUS_TYPE)
     is separate;

end DG_Host_Specific;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
