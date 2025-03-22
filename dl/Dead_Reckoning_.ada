--=============================================================================
--                                UNCLASSIFIED
--
-- *==========================================================================*
-- |                                                                          |
-- |                       Manned Flight Simulator                            |
-- |               Naval Air Warfare Center Aircraft Division                 |
-- |                       Patuxent River, Maryland                           |
-- *==========================================================================*
--
--=============================================================================
--
-- Package Name:       Dead_Reckoning
--
-- File Name:          Dead_Reckoning_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 22, 1994
--
-- Purpose:
--
--  Contains the units necessary to:
--
--     1. Determine the dead-reckoning algorithm to use (Static, DRM(F,P,W),
--        DRM(F,V,W), DRM(R,P,W), and DRM(R,V,W)).
--
--     2. Performs entity dead-reckoning calculations.
--
--
-- Effects:
--   None
--
-- Exceptions:
--
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--==============================================================================
with DL_Status,
     DIS_Types;

package Dead_Reckoning is

   -----------------------------------------------------------------------------
   -- UPDATE_POSITION
   -----------------------------------------------------------------------------
   -- Purpose:
   --
   --   Calculates the entities next dead-reckoned position.
   --
   --   Input/Output Parameters:
   --
   --     Entity_State_PDU - Provides all the entity information required to 
   --                        dead reckon the entity's position.
   --
   --   Input Parameters:
   --     
   --     Delta_Time - The time (in microseconds) that has elapsed since the 
   --                  position values were last assigned.
   --
   --   Output Parameters:
   --     
   --     Status - Indicates whether this unit encountered an error condition.
   --              The following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.DR_UDRP_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None. 
   -----------------------------------------------------------------------------
   procedure Update_Position(
      Entity_State_PDU : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Delta_Time       : in     INTEGER;
      Status           :    out DL_Status.STATUS_TYPE);
  
     

end Dead_Reckoning;
