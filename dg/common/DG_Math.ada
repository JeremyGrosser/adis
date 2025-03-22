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
-- FILE NAME        : DG_Math.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June dd, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

package body DG_Math is

   ---------------------------------------------------------------------------
   -- Truncate
   ---------------------------------------------------------------------------

   function Truncate(
      Num : in Numeric_Types.FLOAT_32_BIT)
     return INTEGER is

   begin  -- Truncate for FLOAT_32_BIT

      return 0;

   end Truncate;  -- for FLOAT_32_BIT

   function Truncate(
      Num : in Numeric_Types.FLOAT_64_BIT)
     return INTEGER is

   begin  -- Truncate for FLOAT_64_BIT

      return 0;

   end Truncate;  -- for FLOAT_64_BIT

end DG_Math;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
