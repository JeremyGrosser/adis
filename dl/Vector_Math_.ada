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
-- Package Name:       Vector_Math
--
-- File Name:          Vector_Math_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   August 17, 1994
--
-- Purpose:
--
--   Contains units which perform mathematical operations on vectors.
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
with DL_Status,
     DL_Math,
     DIS_Types,
     Hashing;
 

package Vector_Math is
  
   --==========================================================================  
   -- ADD_OFFSETS
   --========================================================================== 
   --
   -- Purpose
   --
   --   This unit adds an input offset to a position vector.
   --
   --   Input/Output Parameters:
   --     
   --     Vector - The position of an entity.
   --
   --   Input Parameters:
   --
   --     Offset  - The amount the position will be adjusted.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.ADD_OFFSETS_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Add_Offsets(
      Vector : in out DIS_TYPES.A_WORLD_COORDINATE;
      Offset : in     Hashing.POSITION_OFFSETS;
      Status :    out DL_Status.STATUS_TYPE);
  
   --==========================================================================  
   -- ADD_OFFSETS
   --========================================================================== 
   --
   -- Purpose
   --
   --   This unit adds an input offset to a velocity vector.
   --
   --   Input/Output Parameters:
   --     
   --     Vector - The velocity of an entity.
   --
   --   Input Parameters:
   --
   --     Offset  - The amount the velocity will be adjusted.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.ADD_OFFSETS_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --    			
   --
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Add_Offsets(
      Vector : in out DIS_TYPES.A_LINEAR_VELOCITY_VECTOR;
      Offset : in     Hashing.VELOCITY_OFFSETS;
      Status :    out DL_Status.STATUS_TYPE);

   --========================================================================== 
   -- CALCULATE_VECTOR_DIFFERENCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Subtracts the First position vector components from the Second 
   --   position vector components (i.e., X2 - X1).
   --
   --   Input Parameters:
   --     
   --     First - Position vector that will be subtracted from Second.
   --
   --     Second - Position vector that will have First subtracted from it.
   --
   --   Output Parameters:
   --
   --     Difference - The result of the subtraction of (X2 - X1).
   --
   --     Status - Indicates whether this unit encountered an error condition.  
   --              One of the following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALCULATE_DIFFERENCE_FAILURE - Indicates an 
   --              exception was raised in this unit.
   --
   -- Exceptions:
   --   None.
   -- 
   --========================================================================== 
   procedure Calculate_Vector_Difference(
      First         : in     DIS_TYPES.A_WORLD_COORDINATE;
      Second        : in     DIS_TYPES.A_WORLD_COORDINATE;
      Difference    :    out Hashing.POSITION_OFFSETS;
      Status        :    out DL_Status.STATUS_TYPE);

   --========================================================================== 
   -- CALCULATE_VECTOR_DIFFERENCE
   --===========================================================================
   --
   -- Purpose
   --
   --   Subtracts the First velocity vector components from the Second 
   --   velocity vector components (i.e., X2 - X1).
   --
   --   Input Parameters:
   --     
   --     First - Velocity vector that will be subtracted from Second.
   --
   --     Second - Velocity vector that will have First subtracted from it.
   --
   --   Output Parameters:
   --
   --     Difference - The result of the subtraction of (X2 - X1).
   --
   --     Status - Indicates whether this unit encountered an error condition.  
   --              One of the following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALCULATE_DIFFERENCE_FAILURE - Indicates an 
   --              exception was raised in this unit.
   --
   -- 
   -- Exceptions:
   --   None.
   -- 
   --========================================================================== 
   procedure Calculate_Vector_Difference(
      First         : in     DIS_TYPES.A_LINEAR_VELOCITY_VECTOR;
      Second        : in     DIS_TYPES.A_LINEAR_VELOCITY_VECTOR;
      Difference    :    out Hashing.VELOCITY_OFFSETS;
      Status        :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- CALCULATE_VECTOR_OFFSETS
   --===========================================================================
   --
   -- Purpose
   --
   --   Calculates the offsets that should be used when smoothing the position
   --   data over several timeslices.
   --
   --   Input Parameters:
   --     
   --     Difference - The difference between two position vectors.
   --
   --     Timeslices - The number of timeslices since the last Entity State PDU
   --                  for the entity was received.
   --
   --   Output Parameters:
   --
   --     Offsets - The amount of adjustment that will be applied to the 
   --               position vector for each succeeding timeslice.
   --
   --     Status - Indicates whether this unit encountered an error condition.  
   --              One of the following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALCULATE_OFFSETS_FAILURE - Indicates an 
   --              exception was raised in this unit.
   --
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Calculate_Vector_Offsets(
      Difference : in     Hashing.POSITION_OFFSETS;
      Timeslices : in     POSITIVE;
      Offsets    :    out Hashing.POSITION_OFFSETS; 
      Status     :    out DL_Status.STATUS_TYPE);   

   --==========================================================================
   -- CALCULATE_VECTOR_OFFSETS
   --===========================================================================
   --
   -- Purpose
   --
   --   Calculates the offsets that should be used when smoothing velocity data
   --   over several timeslices.
   --
   --   Input Parameters:
   --     
   --     Difference - The difference between two velocity vectors.
   --
   --     Timeslices - The number of timeslices since the last Entity State PDU
   --                  for the entity was received.
   --
   --   Output Parameters:
   --
   --     Offsets - The amount of adjustment that will be applied to the 
   --               velocity vector for each succeeding timeslice.
   --
   --     Status - Indicates whether this unit encountered an error condition.  
   --              One of the following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CALCULATE_OFFSETS_FAILURE - Indicates an 
   --              exception was raised in this unit.
   -- 
   -- Exceptions:
   --   None.
   -- 
   --==========================================================================
   procedure Calculate_Vector_Offsets(
      Difference : in     Hashing.VELOCITY_OFFSETS;
      Timeslices : in     POSITIVE;
      Offsets    :    out Hashing.VELOCITY_OFFSETS; 
      Status     :    out DL_Status.STATUS_TYPE);
     
   --==========================================================================
   -- CHECK_TOLERANCE
   --===========================================================================
   --
   -- Purpose
   --
   --   Determines whether the position tolerance has been exceeded.
   --
   --   Input Parameters:
   --     
   --     Predicted_Last_Difference - Difference between the predicted 
   --                                 and stored positions (P - S).
   --
   --     Current_Predicted_Difference - Difference between the new and predicted 
   --                                    (next dead-reckoned) positions (N -P).
   --
   --     Tolerance - The percent of the difference of the last position update
   --                 and the predicted position update which is the variance
   --                 allowed when determining if the tolerance has been 
   --                 exceeded.
   --
   --   Output Parameters:
   --
   --     Exceeded - Returns TRUE if the tolerance was exceeded and FALSE if it
   --                was not exceeded.
   --
   --     Status - Indicates whether this unit encountered an error condition.  
   --              One of the following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CHECK_TOLERANCE_FAILURE - Indicates an 
   --              exception was raised in this unit.
   -- 
   -- 
   -- Exceptions:
   --   None.
   -- 
   --========================================================================== 
   procedure Check_Tolerance(
      Predicted_Last_Difference    : in     Hashing.POSITION_OFFSETS;
      Current_Predicted_Difference : in     Hashing.POSITION_OFFSETS;
      Tolerance                    : in     DL_Math.PERCENT; 
      Exceeded                     :    out BOOLEAN;
      Status                       :    out DL_Status.STATUS_TYPE);
  
   --==========================================================================
   -- CHECK_TOLERANCE
   --===========================================================================
   --
   -- Purpose
   --
   --   Determines whether the velocity tolerance has been exceeded.
   --
   --   Input Parameters:
   --     
   --     Predicted_Last_Difference - Difference between the predicted 
   --                                 and stored velocities (P - S).
   --
   --     Current_Predicted_Difference - Difference between the new and predicted 
   --                                    (next dead-reckoned) velocities (N -P).
   --
   --     Tolerance - The percent of the difference of the last velocity update
   --                 and the predicted velocity update which is the variance
   --                 allowed when determining if the tolerance has been 
   --                 exceeded.
   --
   --   Output Parameters:
   --
   --     Exceeded - Returns TRUE if the tolerance was exceeded and FALSE if it
   --                was not exceeded.
   --
   --     Status - Indicates whether this unit encountered an error condition.  
   --              One of the following status values may be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CHECK_TOLERANCE_FAILURE - Indicates an 
   --              exception was raised in this unit.
   -- 
   -- 
   -- Exceptions:
   --   None.
   -- 
   --========================================================================== 
   procedure Check_Tolerance(
      Predicted_Last_Difference    : in     Hashing.VELOCITY_OFFSETS;
      Current_Predicted_Difference : in     Hashing.VELOCITY_OFFSETS;
      Tolerance                    : in     DL_Math.PERCENT; 
      Exceeded                     :    out BOOLEAN;
      Status                       :    out DL_Status.STATUS_TYPE);

   --============================================================================
   -- LESS_THAN 
   --===========================================================================
   --
   -- Purpose
   --
   --   Determines if any of the first vector components are less than the
   --   corresponding second vector components.
   --
   --   Input Parameters:
   --     
   --     First - Position vector.
   --
   --     Second - Position vector.
   --
   --   Output Parameters:
   --
   --     BOOLEAN - Returns TRUE if any of the first vector components are less
   --               than the corresponding second vector components.
   -- 
   -- Exceptions:
   --   None.
   --
   --============================================================================
   function Less_Than(
      First  : in  DIS_Types.A_WORLD_COORDINATE;
      Second : in  DIS_Types.A_WORLD_COORDINATE)
     return BOOLEAN;
  
   --============================================================================
   -- LESS_THAN
   --===========================================================================
   --
   -- Purpose
   --
   --   Determines if any of the first vector components are less than the
   --   corresponding second vector components.
   --
   --   Input Parameters:
   --     
   --     First - Velocity vector.
   --
   --     Second - Velocity vector.
   --
   --   Output Parameters:
   --
   --     BOOLEAN - Returns TRUE if any of the first vector components are less
   --               than the corresponding second vector components.
   -- 
   -- Exceptions:
   --   None.
   --
   --============================================================================
   function Less_Than(
      First  : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Second : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR)
     return BOOLEAN;

   --============================================================================
   -- GREATER_THAN
   --===========================================================================
   --
   -- Purpose
   --
   --   Determines if any of the first vector components are greater than the
   --   corresponding second vector components.
   --
   --   Input Parameters:
   --     
   --     First - Position vector.
   --
   --     Second - Position vector.
   --
   --   Output Parameters:
   --
   --     BOOLEAN - Returns TRUE if any of the first vector components are 
   --               greater than the corresponding second vector components.
   -- 
   -- Exceptions:
   --   None.
   --
   --============================================================================
   function Greater_Than(
      First  : in  DIS_Types.A_WORLD_COORDINATE;
      Second : in  DIS_Types.A_WORLD_COORDINATE)
     return BOOLEAN;
  
   --============================================================================
   -- GREATER_THAN
   --===========================================================================
   --
   -- Purpose
   --
   --   Determines if any of the first vector components are greater than the
   --   corresponding second vector components.
   --
   --   Input Parameters:
   --     
   --     First - Velocity vector.
   --
   --     Second - Velocity vector.
   --
   --   Output Parameters:
   --
   --     BOOLEAN - Returns TRUE if any of the first vector components are 
   --               greater than the corresponding second vector components.
   -- 
   -- Exceptions:
   --   None.
   --
   --============================================================================
   function Greater_Than(
      First  : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Second : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR)
     return BOOLEAN; 

end Vector_Math;
