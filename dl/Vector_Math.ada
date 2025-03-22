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
-- File Name:          Vector_Math.ada
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
--   Performs mathematical computations and comparisons on vectors.  
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
with Numeric_types;

package body Vector_Math is

   --==========================================================================  
   -- ADD_OFFSETS
   --========================================================================== 
   --
   -- Purpose
   --
   --   This unit adds an input offset to a position vector.
   --
   -- Implementation:
   --   
   --   Add the corresponding components of the two input vectors.
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
   --========================================================================
   procedure Add_Offsets(
      Vector : in out DIS_TYPES.A_WORLD_COORDINATE;
      Offset : in     Hashing.POSITION_OFFSETS;
      Status :    out DL_Status.STATUS_TYPE) is
  
   begin 

      Status := DL_Status.SUCCESS;

      Vector.X := Vector.X + Offset.X;
      Vector.Y := Vector.Y + Offset.Y;
      Vector.Z := Vector.Z + Offset.Z;

   exception
  
      when OTHERS => 
         Status    := DL_Status.ADD_OFFSETS_FAILURE;

   end Add_Offsets;

   --==========================================================================  
   -- ADD_OFFSETS
   --========================================================================== 
   --
   -- Purpose
   --
   --   This unit adds an input offset to a velocity vector.
   --
   -- Implementation:
   --   
   --   Add the corresponding components of the two input vectors.
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
   --========================================================================
   procedure Add_Offsets(
      Vector : in out DIS_TYPES.A_LINEAR_VELOCITY_VECTOR;
      Offset : in     Hashing.VELOCITY_OFFSETS;
      Status :    out DL_Status.STATUS_TYPE) is
  
   begin 

      Status := DL_Status.SUCCESS;

      Vector.X := Vector.X + Offset.X;
      Vector.Y := Vector.Y + Offset.Y;
      Vector.Z := Vector.Z + Offset.Z;

   exception
  
      when OTHERS => 
         Status    := DL_Status.ADD_OFFSETS_FAILURE;

   end Add_Offsets;

   --========================================================================== 
   -- CALCULATE_VECTOR_DIFFERENCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Subtracts the First position vector components from the Second 
   --   position vector components (i.e., X2 - X1).
   --
   -- Implementation:
   --   
   --   Subtract the corresponding components of the two input vectors and then
   --   determine whether the value should be negative or positive.
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
   --======================================================================== 
   procedure Calculate_Vector_Difference(
      First         : in     DIS_TYPES.A_WORLD_COORDINATE;
      Second        : in     DIS_TYPES.A_WORLD_COORDINATE;
      Difference    :    out Hashing.POSITION_OFFSETS;
      Status        :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables.
      --
 
      X : Numeric_Types.FLOAT_64_BIT;
      Y : Numeric_Types.FLOAT_64_BIT;
      Z : Numeric_Types.FLOAT_64_BIT;

   begin
   
      Status := DL_Status.SUCCESS;
  
      X :=  DL_Math.FAbs(Second.X - First.X);
      Y :=  DL_Math.FAbs(Second.Y - First.Y);
      Z :=  DL_Math.FAbs(Second.Z - First.Z);

      -- The offsets will be calculated from this difference, so 
      -- determine whether the offset value should be negative or 
      -- positive.
      if Second.X < 0.0 then
         Difference.X := -X;
      else
         Difference.X :=  X;
      end if;

      if Second.Y < 0.0 then
         Difference.Y := Y;
      else
         Difference.Y := Y;
      end if;

      if Second.Z < 0.0 then
         Difference.Z := -Z;
      else
         Difference.Z :=  Z;
      end if;     

   exception
  
      when OTHERS => 
         Status    := DL_Status.CALCULATE_DIFFERENCE_FAILURE;
     
   end Calculate_Vector_Difference;

   --========================================================================== 
   -- CALCULATE_VECTOR_DIFFERENCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Subtracts the First velocity vector components from the Second 
   --   velocity vector components (i.e., X2 - X1).
   --
   -- Implementation:
   --   
   --   Subtract the corresponding components of the two input vectors and then
   --   determine whether the value should be negative or positive.
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
   --========================================================================== 
   procedure Calculate_Vector_Difference(
      First         : in     DIS_TYPES.A_LINEAR_VELOCITY_VECTOR;
      Second        : in     DIS_TYPES.A_LINEAR_VELOCITY_VECTOR;
      Difference    :    out Hashing.VELOCITY_OFFSETS;
      Status        :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables.
      --
 
      X : Numeric_Types.FLOAT_32_BIT;
      Y : Numeric_Types.FLOAT_32_BIT;
      Z : Numeric_Types.FLOAT_32_BIT;

   begin
   
      Status := DL_Status.SUCCESS;
         
      X :=  DL_Math.FAbs(Second.X - First.X);
      Y :=  DL_Math.FAbs(Second.Y - First.Y);
      Z :=  DL_Math.FAbs(Second.Z - First.Z);

      -- The offsets will be calculated from this difference, so 
      -- determine whether the offset value should be negative or 
      -- positive.
      if Second.X < 0.0 then
         Difference.X := -X;
      else
         Difference.X :=  X;
      end if;

      if Second.Y < 0.0 then
         Difference.Y := -Y;
      else
         Difference.Y :=  Y;
      end if;

      if Second.Z < 0.0 then
         Difference.Z := -Z;
      else
         Difference.Z :=  Z;
      end if;     

   exception
  
      when OTHERS => 
         Status    := DL_Status.CALCULATE_DIFFERENCE_FAILURE;
     
   end Calculate_Vector_Difference;
 
   --==========================================================================
   -- CALCULATE_VECTOR_OFFSETS
   --==========================================================================
   --
   -- Purpose
   --
   --   Calculates the offsets that should be used when smoothing the position
   --   data over several timeslices.
   --
   -- Implementation:
   --   
   --   Divide each component of the Difference by the number of timeslices since
   --   the last Entity State PDU was received.  (The data will be smoothed over
   --   this number of succeeding timeslices.)
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
   --==========================================================================
   procedure Calculate_Vector_Offsets(
      Difference : in     Hashing.POSITION_OFFSETS;
      Timeslices : in     POSITIVE;
      Offsets    :    out Hashing.POSITION_OFFSETS; 
      Status     :    out DL_Status.STATUS_TYPE) is
 
      --
      -- Declare local variables
      --

      Number_Timeslices : Numeric_Types.FLOAT_64_BIT 
                            := Numeric_Types.FLOAT_64_BIT(Timeslices);

   begin

      -- Note: Timeslices is POSITIVE so it cannot = 0

      -- Calculate component offsets for smoothing
      Offsets.X := DL_Math.FAbs(Difference.X) / Number_Timeslices;
      Offsets.Y := DL_Math.FAbs(Difference.Y) / Number_Timeslices;
      Offsets.Z := DL_Math.FAbs(Difference.Z) / Number_Timeslices;

   exception
  
      when OTHERS => 
         Status    := DL_Status.CALCULATE_OFFSETS_FAILURE;
     
   end Calculate_Vector_Offsets;

   --==========================================================================
   -- CALCULATE_VECTOR_OFFSETS
   --==========================================================================
   --
   -- Purpose
   --
   --   Calculates the offsets that should be used when smoothing the velocity
   --   data over several timeslices.
   --
   -- Implementation:
   --   
   --   Divide each component of the Difference by the number of timeslices since
   --   the last Entity State PDU was received.  (The data will be smoothed over
   --   this number of succeeding timeslices.)
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
   --==========================================================================
   procedure Calculate_Vector_Offsets(
      Difference : in     Hashing.VELOCITY_OFFSETS;
      Timeslices : in     POSITIVE;
      Offsets    :    out Hashing.VELOCITY_OFFSETS; 
      Status     :    out DL_Status.STATUS_TYPE) is
 
      --
      -- Declare local variables
      --

      Number_Timeslices : Numeric_Types.FLOAT_32_BIT 
                            := Numeric_Types.FLOAT_32_BIT(Timeslices);

   begin

      -- Note: Timeslices is POSITIVE so it cannot = 0
    
      -- Calculate component offsets for smoothing
      Offsets.X := DL_Math.FAbs(Difference.X) / Number_Timeslices;
      Offsets.Y := DL_Math.FAbs(Difference.Y) / Number_Timeslices;
      Offsets.Z := DL_Math.FAbs(Difference.Z) / Number_Timeslices;

   exception
  
      when OTHERS => 
         Status    := DL_Status.CALCULATE_OFFSETS_FAILURE;
     
   end Calculate_Vector_Offsets;

   --==========================================================================
   -- CHECK_TOLERANCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the position tolerance has been exceeded.
   --
   -- Implementation:
   --   
   --   Calculate the tolerance based on the difference between the predicted
   --   and stored positions for each vector component and then compare the 
   --   difference between the current and predicted positions to determine 
   --   if the tolerance was exceeded.
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
   --========================================================================== 
   procedure Check_Tolerance(
      Predicted_Last_Difference    : in     Hashing.POSITION_OFFSETS;
      Current_Predicted_Difference : in     Hashing.POSITION_OFFSETS;
      Tolerance                    : in     DL_Math.PERCENT; 
      Exceeded                     :    out BOOLEAN;
      Status                       :    out DL_Status.STATUS_TYPE) is 
   
      --
      -- Declare local variables.
      --
      X_Tolerance      : Numeric_Types.FLOAT_64_BIT;                    
      Y_Tolerance      : Numeric_Types.FLOAT_64_BIT;                   
      Z_Tolerance      : Numeric_Types.FLOAT_64_BIT;

      Float_Tolerance  : Numeric_Types.FLOAT_64_BIT
                           := Numeric_Types.FLOAT_64_BIT(Tolerance);
   begin
   
      Status := DL_Status.SUCCESS;

      -- Calculate component tolerances
      X_Tolerance := DL_Math.FAbs(Predicted_Last_Difference.X) * Float_Tolerance;
      Y_Tolerance := DL_Math.FAbs(Predicted_Last_Difference.Y) * Float_Tolerance;
      Z_Tolerance := DL_Math.FAbs(Predicted_Last_Difference.Z) * Float_Tolerance;
  
      -- Check to see if any vector component exceeds the tolerance.
      if DL_Math.FAbs(Current_Predicted_Difference.X) > X_Tolerance
        or
         DL_Math.FAbs(Current_Predicted_Difference.Y) > Y_Tolerance
        or 
         DL_Math.FAbs(Current_Predicted_Difference.Z) > Z_Tolerance    
      then
         Exceeded := TRUE;    
      else
         Exceeded := FALSE;
      end if;

   exception
  
      when OTHERS => 
         Status    := DL_Status.CHECK_TOLERANCE_FAILURE;
     
   end Check_Tolerance;

   --==========================================================================
   -- CHECK_TOLERANCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the velocity tolerance has been exceeded.
   --
   -- Implementation:
   --   
   --   Calculate the tolerance based on the difference between the predicted
   --   and stored velocities for each vector component and then compare the 
   --   difference between the current and predicted velocities to determine 
   --   if the tolerance was exceeded.
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
   --========================================================================== 
   procedure Check_Tolerance(
      Predicted_Last_Difference    : in     Hashing.VELOCITY_OFFSETS;
      Current_Predicted_Difference : in     Hashing.VELOCITY_OFFSETS;
      Tolerance                    : in     DL_Math.PERCENT; 
      Exceeded                     :    out BOOLEAN;
      Status                       :    out DL_Status.STATUS_TYPE) is
  
      --
      -- Declare local variables.
      --
      X_Tolerance      : Numeric_Types.FLOAT_32_BIT;                    
      Y_Tolerance      : Numeric_Types.FLOAT_32_BIT;                   
      Z_Tolerance      : Numeric_Types.FLOAT_32_BIT;

   begin
   
      Status := DL_Status.SUCCESS;

       -- Calculate component tolerances
      X_Tolerance := DL_Math.FAbs(Predicted_Last_Difference.X) * Tolerance;
      Y_Tolerance := DL_Math.FAbs(Predicted_Last_Difference.Y) * Tolerance;
      Z_Tolerance := DL_Math.FAbs(Predicted_Last_Difference.Z) * Tolerance;
  
      -- Check to see if any vector component exceeds the tolerance.
      if DL_Math.FAbs(Current_Predicted_Difference.X) > X_Tolerance
        or
         DL_Math.FAbs(Current_Predicted_Difference.Y) > Y_Tolerance
        or 
         DL_Math.FAbs(Current_Predicted_Difference.Z) > Z_Tolerance    
      then
         Exceeded := TRUE;    
      else
         Exceeded := FALSE;
      end if;

   exception
  
      when OTHERS => 
         Status    := DL_Status.CHECK_TOLERANCE_FAILURE;
     
   end Check_Tolerance;

   --============================================================================
   -- LESS_THAN
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines if any of the first vector components are less than the
   --   corresponding second vector components.
   --
   -- Implementation:
   --   
   --   Compares each component of the First vector with the corresponding 
   --   component of the second vector if any of the First components are less
   --   than the corresponding Second components, return TRUE; else return FALSE.
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
   --============================================================================
   function Less_Than(
      First  : in  DIS_Types.A_WORLD_COORDINATE;
      Second : in  DIS_Types.A_WORLD_COORDINATE)
     return BOOLEAN is
  
   begin -- Less_Than

      if First.X < Second.X 
        or
         First.Y < Second.Y
        or
         First.Z < Second.Z
      then
         return TRUE;
      else
         return FALSE;
      end if;

   end Less_Than;

   --============================================================================
   -- LESS_THAN
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines if any of the first vector components are less than the
   --   corresponding second vector components.
   --
   -- Implementation:
   --   
   --   Compares each component of the First vector with the corresponding 
   --   component of the second vector if any of the First components are less
   --   than the corresponding Second components, return TRUE; else return FALSE.
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
   --============================================================================
   function Less_Than(
      First  : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Second : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR)
     return BOOLEAN is
  

   begin -- Less_Than

      if First.X < Second.X 
        or
         First.Y < Second.Y
        or
         First.Z < Second.Z
      then
         return TRUE;
      else
         return FALSE;
      end if;

   end Less_Than;

   --============================================================================
   -- GREATER_THAN
   --============================================================================
   -- Purpose
   --
   --   Determines if any of the first vector components are less than the
   --   corresponding second vector components.
   --
   -- Implementation:
   --   
   --   Compares each component of the First vector with the corresponding 
   --   component of the second vector if any of the First components are greater
   --   than the corresponding Second components, return TRUE; else return FALSE.
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
   --============================================================================
   function Greater_Than(
      First  : in  DIS_Types.A_WORLD_COORDINATE;
      Second : in  DIS_Types.A_WORLD_COORDINATE)
     return BOOLEAN is
  
   begin -- Less_Than

      if First.X > Second.X 
        or
         First.Y > Second.Y
        or
         First.Z > Second.Z
      then
         return TRUE;
      else
         return FALSE;
      end if;

   end Greater_Than;

   --============================================================================
   -- GREATER_THAN
   --============================================================================
   -- Purpose
   --
   --   Determines if any of the first vector components are less than the
   --   corresponding second vector components.
   --
   -- Implementation:
   --   
   --   Compares each component of the First vector with the corresponding 
   --   component of the second vector if any of the First components are greater
   --   than the corresponding Second components, return TRUE; else return FALSE.
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
   --============================================================================
   function Greater_Than(
      First  : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Second : in  DIS_Types.A_LINEAR_VELOCITY_VECTOR)
     return BOOLEAN is
  

   begin -- Less_Than

      if First.X > Second.X 
        or
         First.Y > Second.Y
        or
         First.Z > Second.Z
      then
         return TRUE;
      else
         return FALSE;
      end if;

   end Greater_Than;

end Vector_Math;
