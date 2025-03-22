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
-- Unit Name:          Rate_Limiter
--
-- File Name:          SPU__Rate_Limiter.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   Aug 10, 1994
--
-- Purpose
--
--  To make the position updates that are displayed appear to be realistic 
--  (smooth without jumping across the screen).
--
--   Assumes that it is being called every timeslice and the entity is not
--   being dead-reckoned by some other unit.
--
-- Implementation:
--
--   First determines whether the new update is a new Entity_State PDU update
--   or dead-reckoning data.  
--
--   If it is new entity state data, the last saved position is dead-reckoned to 
--   determine the maximum limit the new data can achieve.
--  
--   If the new data is greater than the dead-reckoned data the new data is changed
--   to the dead-reckoned data plus an offset.
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
--     Delta_Time    - The time (in microseconds) that has elapsed since the 
--                     last position update. 
--
--     Offset        - The percent of the difference between the input position
--                     and the dead-reckoned position that is added to the 
--                     dead-reckoned position when the input position exceeds the
--                     normal dead-reckoning position.  This percent is a value
--                     between 0.0..1.0.  For example if the difference was 300
--                     meters and the Offset was 0.1 then the new position would 
--                     be the dead-reckoned position + 30 meters.
-- 
--   Output Parameters:
--
--     Status - Indicates whether this unit encountered an error condition. 
--              One of the following status values will be returned:
--
--              DL_Status.SUCCESS - Indicates the unit executed successfully.
--
--              DL_Status.RATE_LIMITER_FAILURE - Indicates an exception 
--                was raised in this unit.  
--
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
with Dead_Reckoning,
     Vector_Math;

separate(Smooth_Position_Update)

procedure Rate_Limiter(
      Entity_State_PDU   : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Last_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR;       
      Delta_Time         : in     INTEGER; 
      Fudge_Factor       : in     DL_Math.PERCENT;
      Status             :    out DL_Status.STATUS_TYPE) is 

   --
   -- Declare local variables
   --  
   Call_Status       : DL_Status.STATUS_TYPE;

   Dead_Reckoned_PDU : DIS_TYPES.AN_ENTITY_STATE_PDU
                         := Entity_State_PDU;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE      : EXCEPTION;

   --======================================================================
   -- CALCULATE_NEW_VECTOR
   --======================================================================
   -- Purpose
   --   Implements the following formula:
   --
   -- Position = the dead-reckoned position + the abs value of the difference
   -- between the new and the dead-reckoned positions multiplied times a fudge 
   -- factor (i.e., X1 = X2 + abs(X1 - X2)*fudge 
   --=======================================================================
   procedure Calculate_New_Vector(
      Update : in out DIS_Types.A_WORLD_COORDINATE;
      Other  : in     DIS_Types.A_WORLD_COORDINATE;
      Factor : in     Numeric_Types.FLOAT_64_BIT) is

   begin -- Calculate_New_Vector
   
     Update.X := Other.X + (DL_Math.FAbs(Update.X - Other.X) * Factor);
     Update.Y := Other.Y + (DL_Math.FAbs(Update.Y - Other.Y) * Factor);
     Update.Z := Other.Z + (DL_Math.FAbs(Update.Z - Other.Z) * Factor);

   end Calculate_New_Vector;

   --======================================================================
   -- CALCULATE_NEW_VECTOR
   --======================================================================
   -- Purpose
   --   Implements the following formula:
   --
   -- Velocity = the dead-reckoned velocity + the abs value of the difference
   -- between the new and dead-reckoned velocity multiplied times a fudge 
   -- factor (i.e., X1 = X2 + abs(X1 - X2)*fudge 
   --=======================================================================
   procedure Calculate_New_Vector(
      Update : in out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Other  : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Factor : in     Numeric_Types.FLOAT_32_BIT) is

   begin -- Calculate_New_Vector
   
     Update.X := Other.X + (DL_Math.FAbs(Update.X - Other.X) * Factor);
     Update.Y := Other.Y + (DL_Math.FAbs(Update.Y - Other.Y) * Factor);
     Update.Z := Other.Z + (DL_Math.FAbs(Update.Z - Other.Z) * Factor);

   end Calculate_New_Vector;
   
begin -- Rate_Limiter

   Status := DL_Status.SUCCESS;
 
   if (Entity_State_PDU.Location = Last_Location_Data.Position) then
    
      -- No new Entity_State PDU so dead-reckon the entity.
      Dead_Reckoning.Update_Position(
        Entity_State_PDU => Entity_State_PDU,
        Delta_Time       => Delta_Time,
        Status           => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
          raise CALL_FAILURE;
      end if;

   else -- New Entity_State PDU
     
      -- Calculate the dead-reckoned position from the data that is stored.
      Dead_Reckoned_PDU.Location        := Last_Location_Data.Position;
      Dead_Reckoned_PDU.Linear_Velocity := Last_Location_Data.Velocity;

      Dead_Reckoning.Update_Position(
        Entity_State_PDU => Dead_Reckoned_PDU,
        Delta_Time       => Delta_Time,
        Status           => Call_Status);
         
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      --(First > Second)
      if Vector_Math.Greater_Than(
           Entity_State_PDU.Location,
           Dead_Reckoned_PDU.Location)
      then
 
         -- Input position exceeds the dead-reckoned position so assign the new
         -- position to be the dead-reckoned position plus a percentage of the
         -- difference between the input position and the dead-reckoned position.

         Calculate_New_Vector(
           Update => Entity_State_PDU.Location,
           Other  => Dead_Reckoned_PDU.Location,
           Factor => Numeric_Types.FLOAT_64_BIT(Fudge_Factor));

          --(First > Second)
          if Vector_Math.Greater_Than(
               Entity_State_PDU.Linear_Velocity,
               Dead_Reckoned_PDU.Linear_Velocity)
          then

             -- Input velocity exceeds the dead-reckoned velocity so assign the 
             -- new velocity to be the dead-reckoned velocity plus a percentage 
             -- of the difference between the input velocity and the dead-reckoned
             -- velocity.

             Calculate_New_Vector(
               Update => Entity_State_PDU.Linear_Velocity,
               Other  => Dead_Reckoned_PDU.Linear_Velocity,
               Factor => Fudge_Factor);

          end if; -- velocity exceeded
   
      end if; -- position exceeded

   end if; -- New Entity_State PDU ?

   -- Save the current position data.
   Last_Location_Data.Position := Entity_State_PDU.Location;
   Last_Location_Data.Velocity := Entity_State_PDU.Linear_Velocity;

exception

      when CALL_FAILURE =>
        Status := Call_Status;

      when OTHERS       => 
        Status := DL_Status.RATE_LIMITER_FAILURE;

end Rate_Limiter;
  
