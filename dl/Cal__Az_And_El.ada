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
-- File Name:          Cal__Az_And_El.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 24, 1994 
--
-- Purpose
-- 
--   Calculates the azimuth and elevation of an entity or event with respect
--   to an entity.    The results will be two angles.  The azimuth angle will
--   measure between 0.0 and 360.0 -(2 to the -23) and the elevation angle
--   will measure between -180.0 + (2 to the -23) and 180.0 degrees.
--
--
-- Implementation:
-- 
--   Calls Geocentric_To_Entity_Conversion to convert the position of 
--   interest to the input entity coordinate system then calls Calculate_
--   Azimuth to calculate the azimuth and Calculate_Elevation to calculate the
--   elevation.  
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
with Coordinate_Conversions;
   
separate (Calculate)

procedure Az_And_El (
   Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
   Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
   Azimuth              :    out Numeric_Types.FLOAT_32_BIT;
   Elevation            :    out Numeric_Types.FLOAT_32_BIT;
   Status               :    out DL_Status.STATUS_TYPE) is
   
   --
   -- Declare local variables
   --
   
   -- The Position_Of_Interest in entity coordinates. (meters)
   Position_Of_Interest_In_Entity_Coor : DIS_Types. 
                                           AN_ENTITY_COORDINATE_VECTOR;
   
   -- Define temporary variable for status that can be read.
   Call_Status                         : DL_Status.STATUS_TYPE;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE                        : EXCEPTION;
 
begin -- Az_And_El

   -- Convert the position of interest geocentric coordinates to
   -- the entity's coordinate system.
   Coordinate_Conversions.Geocentric_To_Entity_Conversion(
     Euler_Angles                    => Entity_State_PDU.Orientation,
     Entity_Coordinate_System_Center => Entity_State_PDU.Location,
     Geocentric_Coordinates          => Position_Of_Interest, 
     Entity_Coordinates              => Position_Of_Interest_In_Entity_Coor,
     Status                          => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if; 
     
   -- Calculate the azimuth 
   Calculate_Azimuth (
     Vector_Position => Position_Of_Interest_In_Entity_Coor,
     Azimuth         => Azimuth,
     Status          => Call_Status);

   if Call_Status /= DL_Status.SUCCESS then
      raise CALL_FAILURE;
   end if;
 
   -- Calculate the elevation
   Calculate_Elevation (
     Vector_Position => Position_Of_Interest_In_Entity_Coor,
     Elevation       => Elevation,
     Status          => Call_Status);
 
   Status := Call_Status;

exception
 
   when CALL_FAILURE => 
      Status := Call_Status;

   when OTHERS       => 
      Status := DL_Status.CALC_AZ_AND_EL_FAILURE; 

end Az_And_El;
