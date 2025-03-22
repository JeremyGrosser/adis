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
-- File Name:          Dead_Reckoning.ada
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
with Numeric_Types;
     

package body Dead_Reckoning is

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   --============================================================================
   -- ROTATE_ENTITY
   --============================================================================
   --
   -- Purpose:
   --
   --   Rotates an entity according to the angular velocity and the time that
   --   has elapsed since the last update.
   --
   -- Implementation:
   --
   --    Update entity orientation based upon the entity angular velocity using
   --    the equation defined in the DL SDD, section 4.2.5.2.9
   --
   --   Input/Output Parameters
   --
   --     Orientation - Orientation of the entity in Euler Angles.
   --
   --   Input Parameters:
   --
   --     Angular_Velocity   - Specifies the rate (in meters per second) at which
   --                          an entity's orientation is changing, in terms of 
   --                          the entity's own X, Y, Z coordinates.
   --   
   --    
   --     Delta_Time - The time (in seconds) that has elapsed since the 
   --                  location values were last assigned.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --                The following status values may be returned:
   --
   --                DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --                DL_Status.DR_ROTATE_FAILURE - Indicates an exception was 
   --                  raised in this unit.
   --
   --                Other - If an error occurs in a call to a sub-routine,
   --                  the procedure  will terminate and the status (error code)
   --                  for the failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --=============================================================================
   procedure Rotate_Entity(
      Orientation      : in out DIS_Types.AN_EULER_ANGLES_RECORD;  
      Angular_Velocity : in     DIS_Types.AN_ANGULAR_VELOCITY_VECTOR;
      Delta_Time       : in     NUMERIC_TYPES.FLOAT_32_BIT;                  
      Status           :    out DL_Status.STATUS_TYPE) is
 
   begin

      Status := DL_Status.SUCCESS;

      Orientation.Psi   := Orientation.Psi
                             + (Angular_Velocity.Psi_Rate * Delta_Time);

      Orientation.Theta := Orientation.Theta
                             + (Angular_Velocity.Theta_Rate * Delta_Time);

      Orientation.Phi   := Orientation.Phi 
                             + (Angular_Velocity.Phi_Rate * Delta_Time);

   exception

      when OTHERS => 
        Status := DL_Status.DR_ROTATE_FAILURE;

   end Rotate_Entity;

   --=============================================================================
   -- DRM_FPW
   --=============================================================================
   --
   -- Purpose:
   --
   --   Updates an entity's location using a dead-reckoning algorithm of the
   --   form DRM(F,P,W) where DRM indicates Dead-Reckon Model, F specifies
   --   fixed rotation, P specifies rate of position, and W specifies the 
   --   world coordinate system.
   --
   -- Implementation:
   --
   --   Uses the following equation:
   --     L = Lo + Vt
   --   where:
   --     L  = Current location
   --     Lo = Last location
   --     V  = Linear velocity
   --     t  = elapsed time from last position update (delta time)
   --
   --   Input/Output Parameters
   --
   --     Location - Specifies the position (in meters) of entity in terms of it's
   --                X, Y, Z geocentric coordinates.
   --
   --   Input Parameters:
   --
   --     Delta_Time - The time (in seconds) that has elapsed since the 
   --                  location values were last assigned.    
   --
   --     Linear_Velocity - Specifies the velocity (in meters per second) of an
   --                       entity in terms of it's X,Y,Z components.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --                The following status values may be returned:
   --
   --                DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --                DL_Status.DR_FPW_FAILURE - Indicates an exception was 
   --                  raised in this unit.
   --
   --                Other - If an error occurs in a call to a sub-routine,
   --                  the procedure  will terminate and the status (error code)
   --                  for the failed routine will be returned.
   --
   --
   -- Exceptions:
   --   None.
   --==============================================================================
   procedure DRM_FPW(
      Location        :  in out DIS_TYPES.A_WORLD_COORDINATE;
      Delta_Time      :  in     Numeric_Types.FLOAT_64_BIT;
      Linear_Velocity :  in     DIS_Types.A_LINEAR_VELOCITY_VECTOR; 
      Status          :     out DL_Status.STATUS_TYPE) is


   begin -- DRM_FPW

      Status     := DL_Status.SUCCESS;

      Location.X :=  Location.X + (Numeric_Types.FLOAT_64_BIT(
                       Linear_Velocity.X) * Delta_Time);

      Location.Y :=  Location.Y + (Numeric_Types.FLOAT_64_BIT(
                       Linear_Velocity.Y) * Delta_Time);

      Location.Z :=  Location.Z + (Numeric_Types.FLOAT_64_BIT(
                       Linear_Velocity.Z) * Delta_Time);

   exception

      when OTHERS => 
        Status := DL_Status.DR_FPW_FAILURE;

   end DRM_FPW;

   --===========================================================================
   -- DRM_FVW
   --===========================================================================
   --
   -- Purpose:
   --
   --   Updates an entity's location and velocity using a dead-reckoning 
   --   algorithm of the form DRM(F,V,W) where DRM indicates Dead-Reckon Model,
   --   F specifies fixed rotation, V specifies rate of velocity, and W 
   --   specifies the world coordinate system. 
   --
   -- Implementation:
   --
   --   Dead-reckons entity location based on rate of velocity using the 
   --   following equation:
   --
   --      L = Lo + Vt + 1/2(At**2)
   --
   --      where:
   --       L    = Current location
   --       Lo   = Last location
   --       V    = Linear velocity
   --       t    = Elapsed time from last location update (delta time)
   --       A    = Linear acceleration
   --       t**2 = Elapsed time squared
   --
   --    Then it updates the velocity vector using the following equation:
   --
   --      V = Vo + At
   --
   --      where:
   --       V   = Current velocity
   --       Vo  = Last location
   --       t   = Elapsed time from last location update (delta time)
   --       A   = Linear acceleration
   --
   --   Input/Output Parameters:
   --
   --     Linear_Velocity - Specifies the velocity (in meters per second) of an
   --                       entity in terms of it's X,Y,Z components.
   --
   --
   --     Location - Specifies the position (in meters) of entity in terms of it's
   --                X, Y, Z geocentric coordinates.
   --
   --   Input Parameters:
   --     
   --     Linear_Acceleration - The rate of linear acceleration (meters per
   --                           second squared) of the entity in geocentric 
   --                           coordinates.
   --
   --     Delta_Time - The time (in seconds) that has elapsed since the 
   --                  location values were last assigned.
   --
   --   Output Parameters:
   --     
   --     Status - Indicates whether this unit encountered an error condition.
   --                The following status values may be returned:
   --
   --                DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --                DL_Status.DR_FVW_FAILURE - Indicates an exception was 
   --                  raised in this unit.
   --
   --                Other - If an error occurs in a call to a sub-routine,
   --                  the procedure  will terminate and the status (error code)
   --                  for the failed routine will be returned.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -- PORTABILITY ISSUES:
   --   None.
   --  
   -- ANTICIPATED CHANGES:
   --   None.
   --
   --=============================================================================
   procedure DRM_FVW(
      Linear_Velocity     : in out DIS_Types.A_LINEAR_VELOCITY_VECTOR;   
      Location            : in out DIS_Types.A_WORLD_COORDINATE;
      Delta_Time          : in     Numeric_Types.FLOAT_64_BIT;
      Linear_Acceleration : in     DIS_Types.A_LINEAR_ACCELERATION_VECTOR;   
      Status              :    out DL_Status.STATUS_TYPE) is

      -- 
      -- Declare local variables
      --
      Delta_Time_32_Bit : Numeric_Types.FLOAT_32_BIT 
                            := Numeric_Types.FLOAT_32_BIT(Delta_Time);

      Delta_Time_Squared : Numeric_types.FLOAT_64_BIT 
                             := Delta_Time * Delta_Time;                   
   begin
       
      Status := DL_Status.SUCCESS;
        
      Location.X := Location.X + (Numeric_Types.FLOAT_64_BIT(Linear_Velocity.X)
                      * Delta_Time) +  (0.5 * (Numeric_Types.FLOAT_64_BIT(
                        Linear_Acceleration.X) * Delta_Time_Squared));

      Location.Y := Location.Y + (Numeric_Types.FLOAT_64_BIT(Linear_Velocity.Y)
                      * Delta_Time) +  (0.5 * (Numeric_Types.FLOAT_64_BIT(
                        Linear_Acceleration.Y) * Delta_Time_Squared));

      Location.Z := Location.Z + (Numeric_Types.FLOAT_64_BIT(Linear_Velocity.Z)
                      * Delta_Time) +  (0.5 * (Numeric_Types.FLOAT_64_BIT(
                        Linear_Acceleration.Z) * Delta_Time_Squared));

       -- Update entity velocity using equation V = Vo + At.
      Linear_Velocity.X := Linear_Velocity.X + (Linear_Acceleration.X 
                             * Delta_Time_32_Bit);

      Linear_Velocity.Y := Linear_Velocity.Y + (Linear_Acceleration.Y 
                             * Delta_Time_32_Bit);

      Linear_Velocity.Z := Linear_Velocity.Z + (Linear_Acceleration.Z
                             * Delta_Time_32_Bit);
        
   exception

      when OTHERS => 
           Status := DL_Status.DR_FVW_FAILURE;

   end DRM_FVW;

   --===========================================================================
   -- DRM_RPW
   --===========================================================================
   --
   -- Purpose:
   --
   --   Updates an entity's location and orientation using a dead-reckoning
   --   algorithm of the form DRM(R,P,W) where DRM indicates Dead-Reckon Model,
   --   R specifies rotation, P specifies rate of position, and W specifies the
   --   world coordinate system.
   --
   -- Implementation:
   -- 
   --   Input/Output Parameters:
   --
   --     Location - Specifies the position (in meters) of entity in terms of it's
   --                X, Y, Z geocentric coordinates.
   --
   --     Orientation - Orientation of the entity in Euler Angles.
   --  
   --
   --   Input Parameters:
   --
   --     Angular_Velocity   - Specifies the rate (in meters per second) at which
   --                          an entity's orientation is changing, in terms of 
   --                          the entity's own X, Y, Z coordinates.
   --     
   --
   --     Delta_Time - The time (in seconds) that has elapsed since the 
   --                  location values were last assigned.
   --
   --     Linear_Velocity - Specifies the velocity (in meters per second) of an 
   --                       entity in terms of it's X,Y,Z components. 
   --
   --   Output Parameters:
   --  
   --     Status - Indicates whether this unit encountered an error condition.
   --                The following status values may be returned:
   --
   --                DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --                DL_Status.DR_RPW_FAILURE - Indicates an exception was 
   --                  raised in this unit.
   --
   --                Other - If an error occurs in a call to a sub-routine,
   --                  the procedure  will terminate and the status (error code)
   --                  for the failed routine will be returned.
   --   
   --
   -- Exceptions:
   --   None. 
   --=============================================================================
   procedure DRM_RPW(
      Location         : in out DIS_Types.A_WORLD_COORDINATE;
      Orientation      : in out DIS_Types.AN_EULER_ANGLES_RECORD;
      Angular_Velocity : in     DIS_Types.AN_ANGULAR_VELOCITY_VECTOR;
      Delta_Time       : in     Numeric_Types.FLOAT_64_BIT;
      Linear_Velocity  : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;   
      Status           :    out DL_Status.STATUS_TYPE) is

      -- Define a status that can be read. 
      Call_Status  : DL_Status.STATUS_TYPE;

      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE : EXCEPTION;

   begin

       -- Update entity's orientation   
       Rotate_Entity(
         Orientation      => Orientation,
         Angular_Velocity => Angular_Velocity,
         Delta_Time       => Numeric_Types.FLOAT_32_BIT(Delta_Time),   
         Status           => Call_Status);

        if Call_Status /= DL_Status.SUCCESS then
           raise CALL_FAILURE;
        end if; 

       -- Update entity's location
       DRM_FPW(
         Location        => Location,
         Delta_Time      => Delta_Time,
         Linear_Velocity => Linear_Velocity, 
         Status          => Call_Status);

        if Call_Status /= DL_Status.SUCCESS then
           raise CALL_FAILURE;
        end if; 

   exception

      when CALL_FAILURE => 
        Status  := Call_Status;

      when OTHERS => 
           Status := DL_Status.DR_RPW_FAILURE;

   end DRM_RPW;

   --===========================================================================
   -- DRM_RVW
   --===========================================================================
   --
   -- Purpose:
   --
   --   Updates an entity location, orientation and velocity using a 
   --   dead-reckoning algorithm of the form DRM(R,V,W) where DRM indicates 
   --   Dead-Reckon Model, R specifies rotation, V specifies rate of velocity,
   --   and W specifies the world coordinate system. 
   -- 
   -- Implementation:
   --
   --   Input/Output Parameters:
   --
   --     Linear_Velocity - Specifies the velocity (in meters per second) of an
   --                       entity in terms of it's X,Y,Z components.
   --
   --     Location - Specifies the position (in meters) of entity in terms of it's
   --                X, Y, Z geocentric coordinates.
   --
   --     Orientation - Orientation of the entity in Euler Angles.
   --
   --   Input Parameters:
   --
   --     Angular_Velocity   - Specifies the rate (in meters per second) at which
   --                          an entity's orientation is changing, in terms of 
   --                          the entity's own X, Y, Z coordinates.
   --     
   --
   --     Delta_Time - The time (in seconds) that has elapsed since the 
   --                  location values were last assigned.
   --
    --     Linear_Acceleration - The rate of linear acceleration (meters per
   --                           second squared) of the entity in geocentric 
   --                           coordinates.
   --
   --   Output Parameters:
   --     
   --     Status - Indicates whether this unit encountered an error condition.
   --                The following status values may be returned:
   --
   --                DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --                DL_Status.DR_RVW_FAILURE - Indicates an exception was 
   --                  raised in this unit.
   --
   --                Other - If an error occurs in a call to a sub-routine,
   --                  the procedure  will terminate and the status (error code)
   --                  for the failed routine will be returned.
   --   
   --
   -- Exceptions:
   --   None. 
   --=============================================================================
   procedure DRM_RVW(
      Linear_Velocity     : in out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Location            : in out DIS_Types.A_WORLD_COORDINATE;
      Orientation         : in out DIS_Types.AN_EULER_ANGLES_RECORD;
      Angular_Velocity    : in     DIS_Types.AN_ANGULAR_VELOCITY_VECTOR; 
      Delta_Time          : in     Numeric_Types.FLOAT_64_BIT;
      Linear_Acceleration : in     DIS_Types.A_LINEAR_ACCELERATION_VECTOR;   
      Status              :    out DL_Status.STATUS_TYPE) is

      -- Define a status that can be read. 
      Call_Status  : DL_Status.STATUS_TYPE;

      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE : EXCEPTION;

   begin
     
       -- Update entity orientation   
       Rotate_Entity(                  
         Orientation      => Orientation,
         Angular_Velocity => Angular_Velocity,
         Delta_Time       => Numeric_Types.FLOAT_32_BIT(Delta_Time),  
         Status           => Call_Status);

       if Call_Status /= DL_Status.SUCCESS then
          raise CALL_FAILURE;
       end if; 

       -- Update entity's location and velocity
       DRM_FVW(
         Linear_Velocity     => Linear_Velocity,
         Location            => Location,        
         Delta_Time          => Delta_Time,
         Linear_Acceleration => Linear_Acceleration,
         Status              => Call_Status);

       if Call_Status /= DL_Status.SUCCESS then
          raise CALL_FAILURE;
       end if; 

   exception

     when CALL_FAILURE => 
        Status  := Call_Status;

      when OTHERS => 
           Status := DL_Status.DR_RVW_FAILURE;

   end DRM_RVW;

   --===========================================================================
   -- UPDATE_POSITION
   --===========================================================================
   --
   -- Purpose:
   --
   --   Calculates the entities next dead-reckoned position.
   --
   --
   -- IMPLEMENTATION NOTES:
   --
   --   Determines the dead-reckoning algorithm to use and then calls the 
   --   appropriate routine to dead-reckon the entity's position data.
   --
   --   Note:
   --   Only five of the ten dead-reckoning algorithms described in the DIS
   --   standard are implemented including the Static algorithm which does not
   --   move the entity.  All of the implemented algorithms are for world 
   --   coordinate systems.  Any other algorithm will result in the entity not
   --   being moved.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -- PORTABILITY ISSUES:
   --   None.
   --
   -- ANTICIPATED CHANGES:
   --   None.
   --
   --===========================================================================
   procedure Update_Position(
      Entity_State_PDU : in out DIS_Types.AN_ENTITY_STATE_PDU;
      Delta_Time       : in     INTEGER;
      Status           :    out DL_Status.STATUS_TYPE) is
  
      --
      -- Declare local variables
      --
      Convert_Microseconds_To_Seconds : constant 
                                          Numeric_Types.FLOAT_64_BIT
                                            := 1.0E6;

      Call_Status  : DL_Status.STATUS_TYPE;
    
      Elapsed_Time : Numeric_Types.FLOAT_64_BIT;

      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE : EXCEPTION;

   begin -- Update_Dead_Reckoned_Position
    
      Status := DL_Status.SUCCESS;

      Elapsed_Time := Numeric_Types.FLOAT_64_BIT(Delta_Time) 
                        / Convert_Microseconds_To_Seconds;

      -- Select the algorithm to dead-reckon entity.
      case Entity_State_PDU.Dead_Reckoning_Parms.Algorithm is

         when DIS_Types.FPW =>

            -- Calculate new entity location.
            DRM_FPW(
              Location        => Entity_State_PDU.Location,
              Delta_Time      => Elapsed_Time,
              Linear_Velocity => Entity_State_PDU.Linear_Velocity,       
              Status          => Call_Status);

            if Call_Status /= DL_Status.SUCCESS then
               raise CALL_FAILURE;
            end if; 

         when DIS_Types.FVW => 
                
            -- Calculate new entity location and velocity.
            DRM_FVW ( 
              Linear_Velocity     => Entity_State_PDU.Linear_Velocity,                 
              Location            => Entity_State_PDU.Location,
              Delta_Time          => Elapsed_Time,
              Linear_Acceleration => Entity_State_PDU.Dead_Reckoning_Parms.
                                       Linear_Accel,                 
              Status              => Call_Status);

            if Call_Status /= DL_Status.SUCCESS then
               raise CALL_FAILURE;
            end if; 

         when DIS_Types.RPW =>

            -- Calculate new entity location and orientation.
            DRM_RPW(    
              Location            => Entity_State_PDU.Location,
              Orientation         => Entity_State_PDU.Orientation,
              Angular_Velocity    => Entity_State_PDU.Dead_Reckoning_Parms.
                                       Angular_Velocity,
              Delta_Time          => Elapsed_Time,
              Linear_Velocity     => Entity_State_PDU.Linear_Velocity, 
              Status              => Call_Status);

            if Call_Status /= DL_Status.SUCCESS then
                raise CALL_FAILURE;
            end if; 

         when DIS_Types.RVW  =>

            -- Calculate new entity location, orientation and velocity.
            DRM_RVW(             
              Linear_Velocity     => Entity_State_PDU.Linear_Velocity,
              Location            => Entity_State_PDU.Location,
              Orientation         => Entity_State_PDU.Orientation,
              Angular_Velocity    => Entity_State_PDU.Dead_Reckoning_Parms.
                                       Angular_Velocity,
              Delta_Time          => Elapsed_Time,              
              Linear_Acceleration => Entity_State_PDU.Dead_Reckoning_Parms.
                                       Linear_Accel,        
              Status              => Call_Status);

              if Call_Status /= DL_Status.SUCCESS then
                 raise CALL_FAILURE;
              end if; 

          when DIS_Types.STATIC =>

            null;  -- Static entities do not move

          when OTHERS =>

            --
            -- Approximate other dead reckoning algorithms using the
            -- FPW method.
            --
            DRM_FPW(
              Location        => Entity_State_PDU.Location,
              Delta_Time      => Elapsed_Time,
              Linear_Velocity => Entity_State_PDU.Linear_Velocity,       
              Status          => Call_Status);

            if Call_Status /= DL_Status.SUCCESS then
               raise CALL_FAILURE;
            end if; 

      end case;
 
   exception

      when CALL_FAILURE => 
        Status  := Call_Status;

      when OTHERS       => 
        Status := DL_Status.DR_UDRP_FAILURE;

   end Update_Position;

end Dead_Reckoning;

------------------------------------------------------------------------------
-- MODIFICATION HISTORY
------------------------------------------------------------------------------
--
-- 27-Nov-94, B. Dufault
--    - In Update_Position, changed default handling of unimplemented DRMs
--      from Static to DRM(FPW) to create smoother position updates.
--
------------------------------------------------------------------------------
