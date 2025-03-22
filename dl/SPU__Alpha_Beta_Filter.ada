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
-- Unit Name:          Alpha_Beta_Filter
--
-- File Name:          SPU__Alpha_Beta_Filter.ada
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
--   Dampens the effects of rapid changes in the position of an entity 
--   by weighing the new Entity State PDU location with the difference 
--   between the current and the dead-reckoned ( from the stored data)
--   positions to calculate a new dampened location. 
--  
--   Assumes that it is being called every timeslice and the entity is not
--   being dead-reckoned by some other unit.
--
-- Implementation
--
--  If the input data is not a new Entity State PDU dead-reckon the data,
--  else calculate the dampened position using the following formula:
--
--  Position = the weight of the input position + the weight of the difference
--  between the new position and the dead-reckoned stored position
--  (i.e., X1 = Alpa*X1 + ABS(X1-X2)*Beta )
--
--   See Dis Library Software Design Document section 4.6.3.2.9 for a more 
--   detailed explanation of the algorithm used.
--
--
--   Input/Output Parameters:
--
--     
--     Entity_State_PDU - Contains either the currently displayed or new
--                        Entity State PUD position/velocity update 
--                        information.
--
--     Last_Location_Data - Contains the stored position/velocity update for an
--                          entity that is needed to determine whether the new
--                          position information should be limited or smoothed.
--
--   Input Parameters:
--
--     Beta               - Weight which is given to the difference between the 
--                          current position and the stored position dead-reckoned.
--     
--   Output Parameters:
--
--     Status - Indicates whether this unit encountered an error condition. 
--              One of the following status values will be returned:
--
--              DL_Status.SUCCESS - Indicates the unit executed successfully.
--
--              DL_Status.ALPHA_BETA_FILTER_FAILURE - Indicates an exception 
--                was raised in this unit.  
--
-- Exceptions:
--   None.
--
-- Portability Issues:
--   None.
--
-- Anticipated Changes:
--   None.
--
--=============================================================================	
with Dead_Reckoning;

separate(Smooth_Position_Update)

procedure Alpha_Beta_Filter(
   Entity_State_PDU   : in out DIS_TYPES.AN_ENTITY_STATE_PDU; 
   Last_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR;
   Beta               : in     DL_Math.PERCENT;
   Delta_Time         : in     INTEGER;
   Status             :    out DL_Status.STATUS_TYPE) is
 
   --
   -- Declare local variables
   --  
   Call_Status           : DL_Status.STATUS_TYPE;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE : EXCEPTION;

   --======================================================================
   -- CALCULATE_NEW_VECTOR
   --======================================================================
   -- Purpose
   --
   --   Implements the following formula:
   --
   -- Position = the weight of the input position (Update) + the weight of 
   -- the input position minus the last position dead-reckoned (Other)
   -- (i.e., PX1 = Alpa*PX1 + ABS(PX1-PX2)*Beta ).
   --
   --=======================================================================
   procedure Calculate_New_Vector(
      Update : in out DIS_Types.A_WORLD_COORDINATE;
      Other  : in     DIS_Types.A_WORLD_COORDINATE;   
      Beta   : in     Numeric_Types.FLOAT_64_BIT) is

      Alpha : Numeric_Types.FLOAT_64_BIT := 1.0 - Beta;

   begin -- Calculate_New_Vector
   
      --  
      Update.X := (Alpha * Update.X) + 
        (DL_Math.Fabs(Update.X - Other.X) * Beta);

      Update.Y := (Alpha * Update.Y) + 
        (DL_Math.Fabs(Update.Y - Other.Y) * Beta);

      Update.Z := (Alpha * Update.Z) + 
        (DL_Math.Fabs(Update.Z - Other.Z) * Beta);

   end Calculate_New_Vector;

   --======================================================================
   -- CALCULATE_NEW_VECTOR
   --======================================================================
   -- Purpose
   --   Implements the following formula:
   --
   -- Position = the weight of the input velocity (Update) + the weight of 
   -- the input velocity minus the last velocity dead-reckoned (Other)
   -- (i.e., VX1 = Alpa*VX1 + ABS(VX1-VX2)*Beta ).
   --
   --=======================================================================
   procedure Calculate_New_Vector(
      Update : in out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Other  : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Beta   : in     Numeric_Types.FLOAT_32_BIT) is

      Alpha : Numeric_Types.FLOAT_32_BIT := 1.0 - Beta;

   begin  -- Calculate_New_Vector 
      --  
      Update.X := (Alpha * Update.X) + 
        (DL_Math.Fabs(Update.X - Other.X) * Beta);

      Update.Y := (Alpha * Update.Y) + 
        (DL_Math.Fabs(Update.Y - Other.Y) * Beta);

      Update.Z := (Alpha * Update.Z) + 
        (DL_Math.Fabs(Update.Z - Other.Z) * Beta);

   end Calculate_New_Vector;

begin  -- Alpha_Beta_Filter

   Status := DL_Status.SUCCESS;
   
   -- Determine if new data or need to just dead-reckon the data.
  if (Entity_State_PDU.Location = Last_Location_Data.Position) then
  
      -- No new Entity_State PDU so dead-reckon the entity.
      Dead_Reckoning.Update_Position(
        Entity_State_PDU => Entity_State_PDU,
        Delta_Time       => Delta_Time,
        Status           => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
          raise CALL_FAILURE;
      end if; 
 
   else
      -- Calculate new position
      Calculate_New_Vector(
        Update => Entity_State_PDU.Location,
        Other  => Last_Location_Data.Position,
        Beta   => Numeric_Types.FLOAT_64_BIT(Beta));

      -- Calculate new velocity
      Calculate_New_Vector(
        Update => Entity_State_PDU.Linear_Velocity,
        Other  => Last_Location_Data.Velocity,
        Beta   => Beta);
 
    end if;

    -- Keep the current position and velocity for next calculation
    Last_Location_Data.Position := Entity_State_PDU.Location;
    Last_Location_Data.Velocity := Entity_State_PDU.Linear_Velocity;
  
exception

   when CALL_FAILURE => 
      Status := Call_Status;

   when OTHERS => 
      Status := DL_Status.ALPHA_BETA_FILTER_FAILURE;

end Alpha_Beta_Filter;
   
 
