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
-- PACKAGE NAME     : DG_Status
--
-- FILE NAME        : DG_Status.ada
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

package body DG_Status is

   ---------------------------------------------------------------------------
   -- Success
   ---------------------------------------------------------------------------

   function Success(Status : in STATUS_TYPE)
     return BOOLEAN is
   begin
     return (Status = SUCCESS);
   end Success;

   ---------------------------------------------------------------------------
   -- Failure
   ---------------------------------------------------------------------------

   function Failure(Status : in STATUS_TYPE)
     return BOOLEAN is
   begin
     return (Status /= SUCCESS);
   end Failure;

end DG_Status;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
