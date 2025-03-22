--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Pursuit_Guidance
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  28 June 94
--
-- PURPOSE :
--   - The PG CSU provides a pursuit guidance model in which the munition
--     attempts to fly to where the target currently is.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires OS_Data_Types, OS_Hash_Table_Support, and
--     OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with OS_Hash_Table_Support;

separate (Fly_Out_Model)

procedure Pursuit_Guidance(
   Hashing_Index      :  in     INTEGER;
   Required_Azimuth   :     out OS_Data_Types.RADIANS;
   Required_Elevation :     out OS_Data_Types.RADIANS;
   Status             :     out OS_Status.STATUS_TYPE)
  is

begin -- Pursuit_Guidance

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Set the required munition azimuth and elevation to that of the target
   -- (to fly toward the current target location)
   Required_Azimuth   := OS_Hash_Table_Support.Munition_Hash_Table(
     Hashing_Index).Flight_Parameters.Target.Azimuth_Heading;
   Required_Elevation := OS_Hash_Table_Support.Munition_Hash_Table(
     Hashing_Index).Flight_Parameters.Target.Elevation_Heading;

exception
   when OTHERS =>
      Status := OS_Status.PG_ERROR;

end Pursuit_Guidance;
