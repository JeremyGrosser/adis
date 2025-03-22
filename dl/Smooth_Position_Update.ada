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
-- File Name:          Smooth_Position_Update.ada
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
--   Contains units which compensates for time discrepanies and network 
--   anomalies which affect the position and speed of an entity. 
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
with Hashing;

package body Smooth_Position_Update is

   --
   -- Import functions to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

  
   function "="(Left, Right : DIS_TYPES.A_WORLD_COORDINATE) 
     return BOOLEAN
     renames DIS_TYPES."=";

   function "="(Left, Right : DIS_TYPES.A_LINEAR_VELOCITY_VECTOR) 
     return BOOLEAN
     renames DIS_TYPES."=";

   function "="(Left, Right : DIS_TYPES.AN_EULER_ANGLES_RECORD) 
     return BOOLEAN
     renames DIS_TYPES."=";

   --==========================================================================
   -- ALPHA_BETA_FILTER
   --==========================================================================
   procedure Alpha_Beta_Filter(
      Entity_State_PDU   : in out DIS_TYPES.AN_ENTITY_STATE_PDU; 
      Last_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR;  
      Beta               : in     DL_Math.PERCENT;
      Delta_Time         : in     INTEGER;
      Status             :    out DL_Status.STATUS_TYPE) 
   is separate;

   --==========================================================================
   -- RATE_CHANGE_SMOOTHER
   --==========================================================================
   procedure Rate_Change_Smoother(
      Entity_State_PDU   : in out DIS_TYPES.AN_ENTITY_STATE_PDU; 
      Last_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR; 
      Delta_Time         : in     INTEGER;
      Tolerance          : in     DL_Math.PERCENT;
      Status             :    out DL_Status.STATUS_TYPE)
   is separate;

   --==========================================================================
   -- RATE_LIMITER
   --==========================================================================
   procedure Rate_Limiter(
      Entity_State_PDU   : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Last_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR;    
      Delta_Time         : in     INTEGER;    
      Fudge_Factor       : in     DL_Math.PERCENT;
      Status             :    out DL_Status.STATUS_TYPE) 
     is separate;
  
   --==========================================================================
   -- SMOOTH_ENTITY
   --==========================================================================
   procedure Smooth_Entity(
      Entity_State_PDU        : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Elapsed_Time            : in     Integer;
      Alpha_Beta_Coefficient  : in     DL_Math.PERCENT := 0.0;
      Rate_Limiter_Tolerance  : in     DL_Math.PERCENT := 0.0;
      Rate_Smoother_Tolerance : in     DL_Math.PERCENT := 0.0;
      Use_Alpha_Beta          : in     BOOLEAN := FALSE;
      Use_Rate_Limiter        : in     BOOLEAN := FALSE; 
      Use_Rate_Smoother       : in     BOOLEAN := FALSE;
      Status                  :    out DL_Status.STATUS_TYPE)
   is separate;

end Smooth_Position_Update;
