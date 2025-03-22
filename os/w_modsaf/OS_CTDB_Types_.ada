--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_CTDB_Types_
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  12 July 94
--
-- PURPOSE :
--   - The OS_CTDB_Types_ package defines types needed to interface with the
--     Compact Terrain Database in ModSAF (coded in C) to access height of
--     terrain data.  This data is used by the Terrain Database Interface CSC.
--
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with Numeric_Types;

package OS_CTDB_Types is

   type CTDB_STRUCTURE is array (1..472) of Numeric_Types.UNSIGNED_8_BIT;
   type CTDB_STRUCTURE_PTR is access CTDB_STRUCTURE;

   CTDB_Pointer : CTDB_STRUCTURE_PTR;

end OS_CTDB_Types;
