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
-- Unit Name:          Az_And_El
--
-- File Name:          Filter__Az_And_El.ada
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
--   Determines whether the azimuth and elevation of an entity or event with 
--   respect to a reference entity is within the specified threshold ranges.
--
-- Implementation:
--
--   Calls Calculate.Azimuth to calculate the azimuth of the input entity or
--   event then compares this value to the input threshold values.  Then calls
--   Calculate.Elevation to calculate the elevation of the input entity or event
--   and compares this value to the input threshold values.
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
with Calculate,
     Coordinate_Conversions;
 
separate (Filter)
  
procedure Az_And_El(
   Az_Angle_1           : in     Numeric_Types.FLOAT_32_BIT;
   Az_Angle_2           : in     Numeric_Types.FLOAT_32_BIT;   
   El_Angle_1           : in     Numeric_Types.FLOAT_32_BIT;
   El_Angle_2           : in     Numeric_Types.FLOAT_32_BIT;
   Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
   Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;  
   Status               :    out DL_Status.STATUS_TYPE;
   Within_Threshold     :    out BOOLEAN) is


   --
   -- Declare local variables
   --

   Azimuth                             : Numeric_Types.FLOAT_32_BIT;
   Elevation                           : Numeric_Types.FLOAT_32_BIT;

   -- The Position_Of_Interest in entity coordinates. (meters)
   Position_Of_Interest_In_Entity_Coor : DIS_Types. 
                                           AN_ENTITY_COORDINATE_VECTOR;
   
   Within_Bounds                       : BOOLEAN; 

   -- Define a status that can be read. 
   Call_Status                         : DL_Status.STATUS_TYPE;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE                       : exception;

begin  -- Az_And_El

   Status := DL_Status.SUCCESS;

   -- Convert the position of interest geocentric coordinates to
   -- the reference entity's coordinate system.
   Coordinate_Conversions.Geocentric_To_Entity_Conversion(
     Euler_Angles                    => Entity_State_PDU.Orientation,
     Entity_Coordinate_System_Center => Entity_State_PDU.Location,
     Geocentric_Coordinates          => Position_Of_Interest, 
     Entity_Coordinates              => Position_Of_Interest_In_Entity_Coor,
     Status                          => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 

   -- Calculate the Azimuth of the input entity or event.
   Calculate.Calculate_Azimuth (
     Vector_Position => Position_Of_Interest_In_Entity_Coor,
     Azimuth         => Azimuth,
     Status          => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 

   -- Determine whether the azimuth is within the input threshold.
   if Az_Angle_1 <= Az_Angle_2 then

      if (Azimuth >= Az_Angle_1) and (Azimuth <= Az_Angle_2) then
         Within_Bounds := TRUE;
      else
         Within_Bounds := FALSE;
      end if;
   
   else --(Az_Angle_1 > Az_Angle_2)

      if (Azimuth >= Az_Angle_1) or (Azimuth <= Az_Angle_2) then
         Within_Bounds := TRUE;
      else
         Within_Bounds := FALSE;
      end if;
   
   end if; -- Az_Angle_1 <= Az_Angle_2

   if Within_Bounds then

      -- Calculate the elevation of the input entity or event.
     Calculate.Calculate_Elevation (
       Vector_Position => Position_Of_Interest_In_Entity_Coor,
       Elevation       => Elevation,
       Status          => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;  
  
      -- Determine whether the elevation is within the input threshold.
      if El_Angle_1 <= EL_Angle_2 then

         if (Elevation >= El_Angle_1) and (Elevation <= El_Angle_2) then
            Within_Threshold := TRUE;
         else
            Within_Threshold := FALSE;
         end if;
   
      else --(El_Angle_1 > El_Angle_2)

         if (Elevation >= El_Angle_1) or (Elevation <= El_Angle_2) then
            Within_Threshold := TRUE;
         else
            Within_Threshold := FALSE;
         end if;
   
      end if; -- El_Angle_1 <= El_Angle_2

   else

      Within_Threshold := FALSE;  

   end if; -- Within_Bounds
 
exception
 
   when CALL_FAILURE => 
      Status  := Call_Status;
 
   when OTHERS       => 
      Status  := DL_Status.FILT_AZ_AND_EL_FAILURE; 

end Az_And_El;

