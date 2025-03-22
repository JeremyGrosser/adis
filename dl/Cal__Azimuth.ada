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
-- Unit Name:          Azimuth
--
-- File Name:          Cal__Azimuth.ada 
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc
--
-- Origination Date:   May 5, 1994
--
-- Purpose
-- 
--   Calculates the azimuth of an entity or event with respect to an
--   entity.  The result will be an angle measuring between 0.0 and
--   360 - (2 to the -23) degrees. 
--
-- Implementation:
--
--   Calls Geocentric_To_Entity_Conversion to convert the position of
--   interest to the input entity's coordinate system and then calls
--   Calculate_Azimuth to calculate the azimuth (relative angle of the
--   reference position to the heading of the input entity defined in the 
--   Entity_State_PDU). 
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

procedure Azimuth (
   Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
   Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;
   Azimuth              :    out Numeric_Types.FLOAT_32_BIT;
   Status               :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables
   --

   -- The Position_Of_Interest in entity coordinates (meters).
   Position_Of_Interest_In_Entity_Coor : DIS_Types. 
                                           AN_ENTITY_COORDINATE_VECTOR;

   -- Define a status that can be read. 
   Call_Status                         : DL_Status.STATUS_TYPE;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE                        : EXCEPTION;

begin  -- Azimuth

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

   -- Calculate the Azimuth value.
   Calculate_Azimuth (
     Vector_Position => Position_Of_Interest_In_Entity_Coor,
     Azimuth         => Azimuth,
     Status          => Call_Status);

   Status := Call_Status;
      
exception
 
   when CALL_FAILURE => 
      Status  := Call_Status;
 
   when OTHERS       => 
      Status  := DL_Status.CALC_AZIMUTH_FAILURE; 

end Azimuth;
