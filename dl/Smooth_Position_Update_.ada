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
-- Package Name:       Smooth_Position_Update
--
-- File Name:          Smooth_Position_Update_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 25, 1994
--
-- Purpose:
--
--   Contains units which compensates for time discrepanies and network 
--   anomalies which affect the position and speed of an entity.  Also, 
--   compensates for differences in actual data and the data that is displayed
--   by smoothing the data to ensure that the displayed data appears to be 
--   real-time updates (minimizes jumps in position updates).
--
--   These algorithms assume that the Smooth_Position_Update is called every
--   timeslice.
--   
--	
-- Effects:
--   None
--
-- Exceptions:
--   None
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--=============================================================================	

with DL_Math,
     DL_Status,
     DIS_Types,
     Numeric_Types;

package Smooth_Position_Update is

   --==========================================================================
   -- SMOOTH_ENTITY
   --==========================================================================
   --
   -- Purpose
   --
   --   Dead-reckons the entity and provides filters for adjusting new
   --   Entity_State PDU updates which conflict with the dead-reckoned data.
   --   At least one of the filters has to be used.  If no filtering is wanted
   --   the Dead-Reckoning unit should be called instead of this unit.
   --
   --   This unit calls the designated filter to either dead-reckon the 
   --   input data or to compensates for time discrepanies and network 
   --   anomalies by adjusting the data.
   --
   --   NOTE:
   --   All filters are written with the assumption that the entity is being 
   --   dead-reckoned using the Smooth_Entity unit and this unit is called every 
   --   timeslice.  If no flags are set, a Status of DL_Status.NO_FLAGS_SET will 
   --   be returned and the data will not be updated.
   --
   --   Input/Output Parameters:
   --   
   --     Entity_State_PDU - Contains either the currently displayed or new
   --                        Entity State PUD position/velocity update 
   --                        information.
   --
   --   Input Parameters:
   --
   --     Elapsed_Time           - The time (in microseconds) that has elapsed
   --                              since the last position update. 
   --
   --     Alpha_Beta_Coefficient - Weight used by the Alpha_Beta_Filter which
   --                              is given to the difference between the new
   --                              position and the last position dead-reckoned.
   --                              This weight is defined as a percentage between
   --                              0.0..1.0.  The weight given to the new 
   --                              position is 1.0 minus the 
   --                              Alpha_Beta_Coefficient.
   --                              For example, if the coefficient value is 0.1
   --                              the weight of confidence in the new position
   --                              would be 90 percent and the weight of 
   --                              confidence in the difference between the new
   --                              position and the dead-reckoned position would
   --                              be 10 percent.  These two values would be 
   --                              added to get the dampen position.
   --
   --     Rate_Limiter_Tolerance - The tolerance that is used by the Rate_Limiter
   --                              unit to smooth input data for screen display 
   --                              purposes when the input data exceeds the next
   --                              predicted position.  This tolerance is defined 
   --                              as a percentage of the difference between the 
   --                              input position and the dead-reckoned position.
   --                              The offset is dynamically calculated based on 
   --                              this percentage.  The amount calculated is 
   --                              then added to the dead-reckoned position to 
   --                              get an adjusted position which avoids a big
   --                              jump on the display screen.  This percent is
   --                              a value between 0.0..1.0.  For example, if 
   --                              the positional difference is 30 meters and the 
   --                              tolerance is set at 0.1, then the new 
   --                              position will be limited to the dead-reckoned
   --                              position + 3 meters.
   --
   --     Rate_Smoother_Tolerance -  The tolerance that is used by the 
   --                                Rate_Change_Smoother unit to smooth the 
   --                                input data for screen display purposes when
   --                                the input data exceeds the next predicted 
   --                                position.  This tolerance is defined as a 
   --                                percentage of the difference between the 
   --                                last position update and the dead-reckoned
   --                                position which is used to dynamically 
   --                                calculate a variance for each 
   --                                position/velocity component value.  If the 
   --                                difference between the input position/velocity
   --                                and predicted position/velocity exceeds this 
   --                                variance, then an adjustment is made. For
   --                                example, if the difference between the last 
   --                                position update and the next predicted 
   --                                update is 30 meters and the tolerance is 
   --                                set at 0.1 varance of 3 meters would be 
   --                                calculated and allow without any adjustment.
   --                                If the difference between the input 
   --                                position and the predicted position exceeds
   --                                3 meters, then the input data would be 
   --                                adjusted.  The adjustment would be based on
   --                                the difference between the input position 
   --                                and the predicted position.
   --
   --
   --     Use_Alpha_Beta   - Flag which if set TRUE will cause the alpha-beta
   --                        smoothing algorithm to be invoked.
   --
   --     Use_Rate_Smoother - Flag which if set TRUE will cause the 
   --                         Rate_Change_Limiter smoothing algorithm to be 
   --                         invoked.
   --
   --     Use_Rate_Limiter - Flag which if set TRUE will cause the Rate_Limiter
   --                        smoothing algorithm to be invoked.
   --     
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition. 
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.SMOOTH_ENTITY_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   --
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
     procedure Smooth_Entity(
      Entity_State_PDU        : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Elapsed_Time            : in     INTEGER;
      Alpha_Beta_Coefficient  : in     DL_Math.PERCENT := 0.0;
      Rate_Limiter_Tolerance  : in     DL_Math.PERCENT := 0.0;
      Rate_Smoother_Tolerance : in     DL_Math.PERCENT := 0.0;
      Use_Alpha_Beta          : in     BOOLEAN := FALSE;
      Use_Rate_Limiter        : in     BOOLEAN := FALSE; 
      Use_Rate_Smoother       : in     BOOLEAN := FALSE;
      Status                  :    out DL_Status.STATUS_TYPE);
 

end Smooth_Position_Update;
