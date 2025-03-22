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
-- PACKAGE NAME     : DG_Dead_Reckoning_Support
--
-- FILE NAME        : DG_Dead_Reckoning_Support_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 19, 1994
--
-- PURPOSE:
--   - This package contains routines to support the dead reckoning of
--     entities in a simulation.
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

with DG_Status;

package DG_Dead_Reckoning_Support is

   ---------------------------------------------------------------------------
   -- Update_Entity_Positions
   ---------------------------------------------------------------------------
   -- Purpose: This routine updates the dead reckoned position of each entity
   --          in the simulation.
   ---------------------------------------------------------------------------

   procedure Update_Entity_Positions(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- 
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

end DG_Dead_Reckoning_Support;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
