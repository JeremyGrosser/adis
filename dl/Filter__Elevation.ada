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
-- Unit Name:          Elevation
--
-- File Name:          Filter__Elevation.ada
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
--   Determines whether the elevation of an entity or event with respect to a 
--   reference entity is within the specified threshold ranges.
--
-- Implementation:
--
--   Calls Calculate.Elevation to calculates the elevation of the input entity or
--   event then compares this value to the input threshold values. 
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
  
procedure Elevation(
   Angle_1              : in     Numeric_Types.FLOAT_32_BIT;
   Angle_2              : in     Numeric_Types.FLOAT_32_BIT;
   Entity_State_PDU     : in     DIS_Types.AN_ENTITY_STATE_PDU;
   Position_Of_Interest : in     DIS_Types.A_WORLD_COORDINATE;   
   Status               :    out DL_Status.STATUS_TYPE;
   Within_Threshold     :    out BOOLEAN) is

   --
   -- Declare local variables
   --

   Elevation    : Numeric_Types.FLOAT_32_BIT;

   -- Define a status that can be read. 
   Call_Status  : DL_Status.STATUS_TYPE;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE : exception;

begin  -- Elevation

   Status := DL_Status.SUCCESS;

   -- Calculate the elevation of the input entity or event with respect to 
   -- the reference point.
   Calculate.Elevation (
     Entity_State_PDU     => Entity_State_PDU,
     Position_Of_Interest => Position_Of_Interest,
     Elevation            => Elevation,
     Status               => Call_Status);

     if Call_Status /= DL_Status.SUCCESS then
        raise CALL_FAILURE;
     end if;  
  
     -- Determine whether the elevation is within the input threshold.
     if Angle_1 <= Angle_2 then

        if (Elevation >= Angle_1) and (Elevation <= Angle_2) then
           Within_Threshold := TRUE;
        else
           Within_Threshold := FALSE;
        end if;
   
     else --(Angle_1 > Angle_2)

        if (Elevation >= Angle_1) or (Elevation <= Angle_2) then
           Within_Threshold := TRUE;
        else
           Within_Threshold := FALSE;
        end if;
   
    end if; -- Angle_1 <= Angle_2

exception
 
   when CALL_FAILURE => 
      Status  := Call_Status;
 
   when OTHERS       => 
      Status  := DL_Status.FILT_EL_FAILURE; 

end Elevation;

