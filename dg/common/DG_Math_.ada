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
-- PACKAGE NAME     : DG_Math
--
-- FILE NAME        : DG_Math_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : September 02, 1994
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

with Numeric_Types;

package DG_Math is

   ---------------------------------------------------------------------------
   -- Truncate
   ---------------------------------------------------------------------------
   -- Purpose: This function returns an INTEGER which is the truncated value
   --          of the supplied FLOAT (i.e., Truncate(1.99) returns 1).
   ---------------------------------------------------------------------------

   function Truncate(
      Num : in Numeric_Types.FLOAT_32_BIT)
     return INTEGER;

   function Truncate(
      Num : in Numeric_Types.FLOAT_64_BIT)
     return INTEGER;

end DG_Math;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
