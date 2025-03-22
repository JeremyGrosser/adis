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
-- Unit Name:          Distance
--
-- File Name:          Filter__Distance.ada
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
--   Determines whether the distance between two entities/events is 
--   within a specified maximum distance threshold value.
--
-- Implementation:
--
--   Calls Calculate.Distance to calculate the distance between the two input
--   positions and then compares this value to the input threshold value.
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
  
procedure Distance(
   Position_1       : in     DIS_Types.A_WORLD_COORDINATE;
   Position_2       : in     DIS_Types.A_WORLD_COORDINATE;
   Threshold        : in     Numeric_Types.FLOAT_64_BIT;  
   Status           :    out DL_Status.STATUS_TYPE;
   Within_Threshold :    out BOOLEAN) is

   --
   -- Declare local variables
   --

   Distance     : Numeric_Types.FLOAT_64_BIT;

   -- Define a status that can be read. 
   Call_Status  : DL_Status.STATUS_TYPE;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE : EXCEPTION;

begin  -- Distance

   Status := DL_Status.SUCCESS;

   -- Calculate the distance between the two input positions.
   Calculate.Distance(
     Position_1 => Position_1,
     Position_2 => Position_2,
     Distance   => Distance,
     Status     => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 

   -- Determine whether the distance is within the input threshold.
   if Distance <= Threshold then
      Within_Threshold := TRUE;
   else 
      Within_Threshold := FALSE;
   end if;

exception
 
   when CALL_FAILURE => 
      Status  := Call_Status;
 
   when OTHERS       => 
      Status  := DL_Status.FILT_DIST_FAILURE; 

end Distance;

