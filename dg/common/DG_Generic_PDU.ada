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
-- PACKAGE NAME     : DG_Generic_PDU
--
-- FILE NAME        : DG_Generic_PDU.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 17, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

package body DG_Generic_PDU is

   function Null_Generic_PDU_Ptr(
      Ptr : in GENERIC_PDU_POINTER_TYPE)
     return BOOLEAN is
   begin
      return (Ptr = NULL);
   end Null_Generic_PDU_Ptr;

   function Valid_Generic_PDU_Ptr(
      Ptr : in GENERIC_PDU_POINTER_TYPE)
     return BOOLEAN is
   begin
      return (Ptr /= NULL);
   end Valid_Generic_PDU_Ptr;

end DG_Generic_PDU;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
