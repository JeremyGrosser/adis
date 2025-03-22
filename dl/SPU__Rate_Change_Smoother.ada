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
-- Unit Name:          Rate_Change_Smoother
--
-- File Name:          SPU__Rate_Change_Smoother.ada
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
--   First determine whether the new update is a new Entity_State PDU update
--   or the last processed dead-reckoning data. 
--
--   If the input data and the stored data are the same, then a flag is checked
--   to determine if the data is being smoothed.  If it is not being smoothed,
--   the input data is dead-reckoned. If it is being smoothed, the appropriate
--   smoothing is used to calculate the new position.
-- 
--   If the data is different, then it is either a new Entity_State PDU or it
--   is display data which is greater than the last received Entity_State PDU.
--
--   If the latter is true, a new dead-reckoned position is calculated from the
--   stored data and compared with the input data.  If the dead-reckoned position
--   is still less than the new position and the orientation has not changed the
--   input data is not updated.
--
--   If it is a new Entity_State PDU, then the stored position is dead-reckoned
--   and the new position is compared with it.  If the new data is less than the
--   dead-reckoned position the new position is checked to see whether it is less
--   than the stored (currently displayed) position .  If it is less, then 
--   that means this new position will cause the displayed position to jump 
--   backward.  The orientation is not adjusted, but it is kept track of and used 
--   to determine whether or not to allow the new display position to jump back.
--   If the orientation has changed, the jump backward is allowed.  If it has not 
--   changed, then the velocity is checked to determine if the entity is slowing down.
--   If the velocity has decreased then the entity is allowed to jump backward.  
--   Otherwise, it is assumed that the previous dead-reckoning over-calculated
--   the real position and the new update is reset to the currently displayed 
--   position and the current actual position is stored for future dead-reckoning.
--   A flag is set which denotes that the displayed data is greater than the 
--   current "real" (stored) data.  During the succeeding timeslices, the stored 
--   data is dead-reckoned until it exceeds the displayed data.  At that time, 
--   the output position is updated to exceed the displayed position.
--  
--   If the new data exceeds the stored dead-reckoned position plus a tolerance, 
--   the velocity is checked to see if it changed.  If the velocity changed,
--   offset values for the velocity are calculated and the stored velocity is
--   incremented by the offset.  The position is then calculated by
--   dead-reckoned the stored position with the new velocity.  If the velocity 
--   did not change, then position offsets are calculated and added to the already
--   dead-reckokned position.
--
--   The tolerance is calculated as a percentage of the difference 
--   between the predicted vector and the stored vector.  The difference between
--   the predicted vector and the new vector is calculated and compared with
--   this tolerance to determine if the tolerance was exceeded. 
-- 
--   The offset values are calculated by dividing the differece
--   between the predicted vector and the new vector by the number of 
--   timeslices since the last Entity_State PUD update was received. 
--   If an adjustment is made a flag is set and each succeeding timeslice the
--   same adjusted value is calculated.  This process continues for the number of 
--   timeslices used to calculate the offset values or until a new Entity_State PDU
--   is received.
--
--   If the tolerance was not exceeded, or the new data is between the last
--   position and the next predicted (dead-reckoned) position the data is 
--   determined to be good data and no adjustments are made.
--
--   Input/Output Parameters:
--     
--     Entity_State_PDU - Contains either the currently displayed or new
--                        Entity State PUD position/velocity update 
--                        information.
--
--
--     Last_Location_Data - Contains the stored position/velocity update for an
--                          entity that is needed to determine whether the new
--                          position information should be limited or smoothed.
--
--   Input Parameters:
--
--     Delta_Time       -  The time (in microseconds) that has elapsed since the 
--                         last position update. 
--
--     Tolerance        -  Variance that is allowed when comparing two 
--                         position/velocity vectors defined as a percentage 
--                         from 0.0..1.0.  For example, a position component
--                         of 3 and 0.1 tolerance would be allowed a variance
--                         of +/- 0.3.
--     
--   Output Parameters:
--
--     Status - Indicates whether this unit encountered an error condition. 
--              One of the following status values will be returned:
--
--              DL_Status.SUCCESS - Indicates the unit executed successfully.
--
--              DL_Status.RATE_CHANGE_FAILURE - Indicates an exception 
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
with Dead_Reckoning,
     Vector_Math;

separate(Smooth_Position_Update)

procedure Rate_Change_Smoother(
   Entity_State_PDU   : in out DIS_TYPES.AN_ENTITY_STATE_PDU; 
   Last_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR; 
   Delta_Time         : in     INTEGER;
   Tolerance          : in     DL_Math.PERCENT;
   Status             :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables
   --  
   Call_Status           : DL_Status.STATUS_TYPE;

   Tolerance_Exceeded    : BOOLEAN;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE : EXCEPTION;

   --============================================================================
   -- DEAD_RECKON_WITH_OFFSETS_ADDED
   --============================================================================
   -- 
   -- Purpose
   --
   --  Smooth the new position by adding an offset to the dead-reckoned position.
   --
   -- Implementation
   --
   --   If the velocity changed, add the velocity offset and then dead-reckon to
   --   find the new position.
   --
   --   If the velocity has not changed, add the position offsets to the 
   --   dead-reckoned data.
   --
   --============================================================================
   procedure Dead_Reckon_With_Offsets_Added( 
      Dead_Reckoning_PDU   : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Stored_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR;
      Status               :    out DL_Status.STATUS_TYPE) is

   begin --Dead_Reckon_With_Offsets_Added
    
      Status := DL_Status.SUCCESS;

      if Stored_Location_Data.Velocity_Changed then

         -- Add the velocity offsets and let the dead-reckoning increase the 
         -- position based on the new velocity.
         Vector_Math.Add_Offsets(
           Vector => Stored_Location_Data.Velocity,
           Offset => Stored_Location_Data.Offsets.Velocity,
           Status => Call_Status);

         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;

         Dead_Reckoning_PDU.Linear_Velocity := Stored_Location_Data.Velocity;
 
      else

         -- Update the position components before it is dead-reckoned.
         Vector_Math.Add_Offsets(
           Vector => Stored_Location_Data.Position,
           Offset => Stored_Location_Data.Offsets.Position,
           Status => Call_Status);

         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;

         Dead_Reckoning_PDU.Location := Stored_Location_Data.Position;

      end if;
            
      Dead_Reckoning.Update_Position(
        Entity_State_PDU => Dead_Reckoning_PDU,
        Delta_Time       => Delta_Time,
        Status           => Call_Status);
  
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      -- Store the new position data.
      Stored_Location_Data.Position    := Dead_Reckoning_PDU.Location;
      Stored_Location_Data.Velocity    := Dead_Reckoning_PDU.Linear_Velocity;
      Stored_Location_Data.Orientation := Dead_Reckoning_PDU.Orientation;

      Stored_Location_Data.Smooth_Timeslices :=
        Stored_Location_Data.Smooth_Timeslices - 1; 

   end Dead_Reckon_With_Offsets_Added;

   --============================================================================
   -- DISPLAYED_EXCEEDS_ACTUAL
   --============================================================================
   -- 
   -- Purpose
   --
   --   Smooth position update when displayed position is greater than the real
   --   position.
   -- 
   -- Implementation
   --
   --   Call Dead-Reckon_With_Offsets_Added to get the next smoothed predicted position.
   --   Check to see if this position exceeds the displayed position.  If it does, then
   --   output this position.  If it does not, then output the displayed position and 
   --   keep the current dead-reckoned position.
   --     
   --============================================================================
   procedure Displayed_Exceeds_Actual( 
      Current_Position     : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Stored_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR;
      Status               :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables
      --  
 
      Dead_Reckoning_PDU : DIS_Types.AN_ENTITY_STATE_PDU := Current_Position;
 
   begin --  Dead_Reckoning_Exceeded_Acutal_Position

      Status := DL_Status.SUCCESS;

      Dead_Reckon_With_Offsets_Added( 
        Dead_Reckoning_PDU   => Dead_Reckoning_PDU,
        Stored_Location_Data => Last_Location_Data,
        Status               => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      -- Store the dead-reckoned position.
      Stored_Location_Data.Position    := Dead_Reckoning_PDU.Location;
      Stored_Location_Data.Velocity    := Dead_Reckoning_PDU.Linear_Velocity;
      Stored_Location_Data.Orientation := Dead_Reckoning_PDU.Orientation;

      -- (First < Second)
      if Vector_Math.Less_Than(
           Current_Position.Location, -- displayed position
           Dead_Reckoning_PDU.Location)
        or 
         (Current_Position.Location = Dead_Reckoning_PDU.Location)
      then
      
         -- Dead-reckoned position exceeded or is equal to the displayed 
         -- position so update new position to allow the display to show 
         -- the entity moving.

         if Current_Position.Location /= Dead_Reckoning_PDU.Location then
            Current_Position := Dead_Reckoning_PDU;
         end if;

         -- Initialize stored flags and offset values.
         Stored_Location_Data.Offsets  := Hashing.Initialize_Vector_Offsets;     
         Stored_Location_Data.Overshot := FALSE;
         Stored_Location_Data.Smooth_Timeslices := 0;
         Stored_Location_Data.Velocity_Changed  := FALSE;
                                      
      end if;

   end Displayed_Exceeds_Actual;

   --============================================================================
   -- PROCESS_NEW_ENTITY_STATE_PDU
   --============================================================================
   -- 
   -- Purpose
   --
   --   Examine the new Entity State PDU position to determine if it is within an
   --   allowable tolerance to the next predicted position.
   --
   -- Implementation
   --
   --  Set the number of smoothing timeslices to the number of timeslices since 
   --  the receipt of the last Entity State PUD and reinitialize the timeslices
   --  counter.  
   --
   --  Calculate the next dead-reckoned position based on the last 
   --  output data (stored data).  If the new position is <= the dead-reckoned 
   --  position, then check to see if the new position exceeds the last output
   --  position (displayed position).  
   --
   --  If it is less than the displayed position, check to see if the orientation
   --  has changed.  If the orientation has changed, assume that the entity has 
   --  changed course and except the new data as good data.  If the orientation 
   --  has not changed, check the velocity to see if it has decreased.  If the 
   --  velocity has decreased, then except the new data as good data.  If the 
   --  neither the orientation has or the velocity decreased, then assume that 
   --  the dead-reckoning algorithm has overshot the actual position. Thhe goal
   --  then is to hold the output data to the dislayed position until the new
   --  data dead-reckons past the displayed.  Therefore, swap the values 
   --  of the new data and the displayed data so the displayed data will stay 
   --  the same (not jump backward) and the real data can be used to dead-reckon 
   --  the next timeslice.
   --
   --  If the new position exceeds the dead-reckoned position, then determine if 
   --  the difference between the dead-reckoned position and the new position 
   --  exceeds the tolerance.  If the tolerance is exceeded, check to see if the
   --  velocity changed.  If  the velocity did not change calculate the position
   --  offsets and dead-reckon with the offsets added.  If the velocity changed,
   --  call Velocity_Changed unit to dead-reckon with velocity offsets added.
   --
   --  If the new position lies between the last displayed position (stored) and
   --  the next predicted (dead-reckoned from stored) position, then data is good
   --  so exit.
   --
   --============================================================================
   procedure Process_New_Entity_State_PDU( 
      Entity_State_PDU     : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Stored_Location_Data : in out Hashing.ENTITY_STATE_INFO_PTR;
      Delta_Time           : in     INTEGER;
      Status               :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables
      -- 
      Dead_Reckoning_PDU          : DIS_Types.AN_ENTITY_STATE_PDU 
                                      := Entity_State_PDU;  

      New_Predicted_Difference    : Hashing.POSITION_OFFSETS;
      Predicted_Stored_Difference : Hashing.POSITION_OFFSETS;

      Temp_Location               : DIS_TYPES.A_WORLD_COORDINATE;
      Temp_Velocity               : DIS_TYPES.A_LINEAR_VELOCITY_VECTOR; 
 
      --=========================================================================
      -- VELOCITY_CHANGED
      --=========================================================================
      -- 
      -- Purpose
      --
      --   There is too big a jump to display, so limit the new position update.
      --
      -- Implementation
      --
      --   The velocity has changed so assume that this change has caused
      --   the difference in the new position update and the dead-reckoned 
      --   position.
      --
      --   Calculate the velocity offsets and then dead-reckon the position 
      --   using the old velocity with offsets added
      --     
      --=========================================================================
      procedure Velocity_Changed(
         Current_Position       : in out DIS_Types.AN_ENTITY_STATE_PDU;
         Stored_Location_Data   : in out Hashing.ENTITY_STATE_INFO_PTR;
         Dead_Reckoned_Position : in     DIS_Types.AN_ENTITY_STATE_PDU;
         Delta_Time             : in     INTEGER;
         Status                 :    out DL_Status.STATUS_TYPE) is

         --
         -- Declare local variables
         --  
         Velocity_Difference : Hashing.VELOCITY_OFFSETS;

      begin -- Velocity_Changed

         Status := DL_Status.SUCCESS;

         -- Get the total difference. 
         Vector_Math.Calculate_Vector_Difference(
           First         => Dead_Reckoning_PDU.Linear_Velocity,
           Second        => Current_Position.Linear_Velocity,
           Difference    => Velocity_Difference,
           Status        => Call_Status);

         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;
      
         -- Determine how much to adjust each timeslice.
         Vector_Math.Calculate_Vector_Offsets(
           Difference => Velocity_Difference,
           Timeslices => Stored_Location_Data.Timeslices,
           Offsets    => Stored_Location_Data.Offsets.Velocity,
           Status     => Call_Status);

           
         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;

         -- Set flag for next position update.
         Stored_Location_Data.Velocity_Changed := TRUE;
 
         Dead_Reckon_With_Offsets_Added( 
           Dead_Reckoning_PDU   => Current_Position,
           Stored_Location_Data => Stored_Location_Data,
           Status               => Call_Status);

      end Velocity_Changed;

   begin --Process_New_Entity_State_PDU
      
      Status := DL_Status.SUCCESS;

      -- Save timeslices since receipt of last Entity_State PDU in case
      -- smoothing offsets need to be calculated.
      Stored_Location_Data.Smooth_Timeslices := 
        Stored_Location_Data.Timeslices - 1; -- delete this timeslice
    
      -- Assign the currently stored data to dead-reckon.
      Dead_Reckoning_PDU.Location        := Stored_Location_Data.Position;
      Dead_Reckoning_PDU.Linear_Velocity := Stored_Location_Data.Velocity;
   
      -- Determine what the next display position would be if no 
      -- new Entity_State PDU was received.
      Dead_Reckoning.Update_Position(
        Entity_State_PDU => Dead_Reckoning_PDU,
        Delta_Time       => Delta_Time,
        Status           => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

        -- (First < Second)
      if Vector_Math.Less_Than(
           Entity_State_PDU.Location,
           Dead_Reckoning_PDU.Location) 
        or
         Entity_State_PDU.Location = Dead_Reckoning_PDU.Location       
      then

         -- New position does not exceed the dead-reckoned position. 
         -- Check to make sure that it DOES exceed or is equal to the 
         -- currently displayed position.

         -- (First < Second)
         if Vector_Math.Less_Than(             
                Entity_State_PDU.Location,
                Stored_Location_Data.Position)          
         then

           if Entity_State_PDU.Orientation = Stored_Location_Data.Orientation then

               -- The orientation has not changed.  
               -- Check to see if the velocity has decreased.

               -- (First < Second)
               if Vector_Math.Less_Than(
                    Entity_State_PDU.Linear_Velocity,
                    Stored_Location_Data.Velocity) 
               then
         
                  -- Velocity has decreased so allow the jump.
                 Stored_Location_Data.Position    := Entity_State_PDU.Location;
                 Stored_Location_Data.Velocity    := Entity_State_PDU.Linear_Velocity;
                 Stored_Location_Data.Orientation := Entity_State_PDU.Orientation;

               else
               
                  -- No change in orientation or velocity so swap the displayed data with 
                  -- the new data in order to keep the displayed position from jumping
                  -- backward.  The current data is saved for future dead-reckoning to
                  -- the displayed position.
            
                  Stored_Location_Data.Overshot := TRUE;

                  -- Save the new position and velocity data.
                  Temp_Location    := Entity_State_PDU.Location;
                  Temp_Velocity    := Entity_State_PDU.Linear_Velocity;

                  -- Store the currently displayed position
                  Last_Location_Data.Displayed_Position := 
                    Stored_Location_Data.Position;

                  -- Swap data
                  Entity_State_PDU.Location        := Stored_Location_Data.Position;
                  Entity_State_PDU.Linear_Velocity := Stored_Location_Data.Velocity;
                            
                  Stored_Location_Data.Position := Temp_Location;
                  Stored_Location_Data.Velocity := Temp_Velocity;             

               end if; -- Velocity Changed

            else
             
               -- Orientation changed (the entity could be turning around) so allow
               -- the jump.

               Stored_Location_Data.Position    := Entity_State_PDU.Location;
               Stored_Location_Data.Velocity    := Entity_State_PDU.Linear_Velocity;
               Stored_Location_Data.Orientation := Entity_State_PDU.Orientation;

            end if; -- Orientation changed

         else
     
            -- New position is either equal to or between the displayed 
            -- position and the dead-reckoned position, so store the data.
            Stored_Location_Data.Position    := Entity_State_PDU.Location;
            Stored_Location_Data.Velocity    := Entity_State_PDU.Linear_Velocity;
            Stored_Location_Data.Orientation := Entity_State_PDU.Orientation;

         end if; -- New position less than the displayed position

      else

         -- The new position exceeds the dead-reckoned position.
         -- Determine if the tolerance has been exceeded.

         -- Find the difference between the new and predicted positions (N -P).
         Vector_Math.Calculate_Vector_Difference(
           First      => Dead_Reckoning_PDU.Location,
           Second     => Entity_State_PDU.Location,
           Difference => New_Predicted_Difference,
           Status     => Call_Status);
  
         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;
       
         -- Find the difference between the predicted and stored positions (P - S).
         Vector_Math.Calculate_Vector_Difference(
           First      => Stored_Location_Data.Position,
           Second     => Dead_Reckoning_PDU.Location,
           Difference => Predicted_Stored_Difference,
           Status     => Call_Status);
  
         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;

         -- Determine if the difference between the new position and the 
         -- predicted position exceeds the tolerance calculated from the
         -- difference of the last position and the predicted position.
         Vector_Math.Check_Tolerance(
           Predicted_Last_Difference    => Predicted_Stored_Difference,
           Current_Predicted_Difference => New_Predicted_Difference,
           Tolerance                    => Tolerance,
           Exceeded                     => Tolerance_Exceeded,
           Status                       => Call_Status);

          if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
          end if;

          if Tolerance_Exceeded then
 
            if Entity_State_PDU.Linear_Velocity 
              = 
               Dead_Reckoning_PDU.Linear_Velocity
            then
                        
                -- The velocity has not changed so limit the new position update
                -- to the dead-reckoned position + position offsets. 

               Vector_Math.Calculate_Vector_Offsets(
                 Difference => New_Predicted_Difference,
                 Timeslices => Stored_Location_Data.Timeslices,
                 Offsets    => Stored_Location_Data.Offsets.Position,
                 Status     => Call_Status);

               Dead_Reckon_With_Offsets_Added( 
                 Dead_Reckoning_PDU   => Entity_State_PDU,
                 Stored_Location_Data => Stored_Location_Data,
                 Status               => Call_Status);
       
            else

               Velocity_Changed(
                 Current_Position       => Entity_State_PDU,
                 Stored_Location_Data   => Stored_Location_Data,
                 Dead_Reckoned_Position => Dead_Reckoning_PDU,
                 Delta_Time             => Delta_Time,
                 Status                 => Call_Status);
 
            end if; -- Velocity changed

         else

            -- Tolerance not exceeded so store the data.
            Stored_Location_Data.Position    := Entity_State_PDU.Location;
            Stored_Location_Data.Velocity    := Entity_State_PDU.Linear_Velocity;
            Stored_Location_Data.Orientation := Entity_State_PDU.Orientation;

         end if; -- Tolerance_Exceeded
  
      end if; -- New position does not exceed the dead-reckoned position

      -- Re-initialize the number of timeslices between receipt of
      -- Entity_State PDU.
      Stored_Location_Data.Timeslices := 0;

   end Process_New_Entity_State_PDU;
              
begin -- Rate_Change_Smoother

   Status := DL_Status.SUCCESS;
 
   -- Keep track of number of timeslices between receiving Entity_State PDU
   -- position updates.
   Last_Location_Data.Timeslices := Last_Location_Data.Timeslices + 1;

   if Entity_State_PDU.Location /= Last_Location_Data.Position then

      -- Either a new Entity_State PDU update has been received or the last
      -- dead-reckoned position overshot the actual position of the entity.
     
      -- If the last Entity_State PDU position was less than the displayed position,
      -- the Overshot flag was set to TRUE and the input data is the position 
      -- dislayed to the screen.
      --
  
      if Last_Location_Data.Overshot then 
   
         -- Check for new Entity_State PDU while still processing overshot.
         -- If new data is greater than the displayed data then its a new 
         -- Entity_State PDU.

         --  (First < Second)
         if Vector_Math.Less_Than(
              Last_Location_Data.Displayed_Position, 
              Entity_State_PDU.Location)
         then

            -- New Entity_State_PDU

            -- Initialize stored flags and offset values.
            Last_Location_Data.Offsets  := Hashing.Initialize_Vector_Offsets;     
            Last_Location_Data.Overshot := FALSE;
            Last_Location_Data.Smooth_Timeslices := 0;
            Last_Location_Data.Velocity_Changed  := FALSE; 


            Process_New_Entity_State_PDU(
              Entity_State_PDU     => Entity_State_PDU,
              Stored_Location_Data => Last_Location_Data,
              Delta_Time           => Delta_Time,
              Status               => Call_Status);

         else
 
            -- Continue to smoooth the data.
            Displayed_Exceeds_Actual( 
              Current_Position     => Entity_State_PDU,
              Stored_Location_Data => Last_Location_Data,
              Status               => Call_Status);

         end if; -- New Entity_State PUD received while smoothing overshot 
                 -- condition ?.

      else -- New Entity_State PDU received

         Process_New_Entity_State_PDU(
           Entity_State_PDU     => Entity_State_PDU,
           Stored_Location_Data => Last_Location_Data,
           Delta_Time           => Delta_Time,
           Status               => Call_Status);

      end if; -- Overshot

   else -- Same input as last output so in dead-reckoning mode
   
      -- Dead-reckon the input Entity_State_PDU position data
      Dead_Reckoning.Update_Position(
        Entity_State_PDU => Entity_State_PDU,
        Delta_Time       => Delta_Time,
        Status           => Call_Status);
  
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;
           
      if Last_Location_Data.Smooth_Timeslices > 0 then

         -- Still smoothing last Entity_State PDU update data.
         Dead_Reckon_With_Offsets_Added( 
           Dead_Reckoning_PDU   => Entity_State_PDU,
           Stored_Location_Data => Last_Location_Data,
           Status               => Call_Status);

      else

         -- No smoothing required so store the current data.
         Last_Location_Data.Position    := Entity_State_PDU.Location;
         Last_Location_Data.Velocity    := Entity_State_PDU.Linear_Velocity;
         Last_Location_Data.Orientation := Entity_State_PDU.Orientation;

      end if;
 
   end if; -- Input position data different

exception

      when CALL_FAILURE =>
        Status := Call_Status;

      when OTHERS       => 
        Status := DL_Status.RATE_CHANGE_FAILURE;

end Rate_Change_Smoother;


