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
-- Unit Name:          Minimum_Velocity
--
-- File Name:          Filter__Minimum_Velocity.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   June 28, 1994
--
-- Purpose:
--
--   Determines whether the velocity magnitude of an entity or event is greater
--   than or equal to a specificed minimum velocity magnitude.
--
-- Implementation:
--
--   Calls Calculate.Velocity to calculate the velocity of the input entity or
--   or event and then compares this value to the input threshold value.
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
with Calculate;
 
separate (Filter)
  
 procedure Minimum_Velocity(
      Threshold        : in     Numeric_Types.FLOAT_32_BIT;
      Velocity         : in     DIS_Types.A_VECTOR;
      Status           :    out DL_Status.STATUS_TYPE;
      Within_Threshold :    out BOOLEAN) is

   --
   -- Declare local variables
   --

   Velocity_Magnitude : Numeric_Types.FLOAT_32_BIT;

   -- Define a status that can be read. 
   Call_Status        : DL_Status.STATUS_TYPE;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE       : exception;

begin  -- Velocity

   Status := DL_Status.SUCCESS;

   -- Calculate the velocity of the input entity or event.
   Calculate.Velocity(
     Linear_Velocity    => Velocity,
     Velocity_Magnitude => Velocity_Magnitude,
     Status             => Call_Status); 

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 

   -- Determine whether the distance is within the input threshold.
   if Velocity_Magnitude >= Threshold then
      Within_Threshold := TRUE;
   else 
      Within_Threshold := FALSE;
   end if;

exception
 
   when CALL_FAILURE => 
      Status  := Call_Status;
 
   when OTHERS       => 
      Status  := DL_Status. FILT_MIN_VEL_FAILURE; 

end Minimum_Velocity;

