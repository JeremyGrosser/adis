--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Calculate_Euler_Angles
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- MODIFIED BY:        Robert S. Kerr - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  23 October 94
--
-- PURPOSE :
--   - The CEA unit calculates the Euler angles (in radians) of the munition
--     based on the velocity of the munition in world coordinates.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Math, OS_Hash_Table_Support, and
--     OS_Status.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--   - This unit uses DL_Math_.ada to allow usage of the atan2 function which
--     was omitted from the most recent (6.2.1) compiler update.  When this
--     function is included in the Verdix compiler, simply change DL_Math to
--     just Math in the code and eliminate DL_Math from the list of withed
--     packages.
--
------------------------------------------------------------------------------
with DL_Math,
     Math,
     OS_Hash_Table_Support;

separate (DCM_Calculations)

procedure Calculate_Euler_Angles(
   Hashing_Index :  in     INTEGER;
   Euler_Angles  :     out DIS_Types.AN_EULER_ANGLES_RECORD;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Ground_Track_Velocity   :  OS_Data_Types.METERS_PER_SECOND;
   Velocity_Magnitude      :  OS_Data_Types.METERS_PER_SECOND;

   -- Local exceptions
   VEL_MAG_EQUAL_ZERO_ERROR :  exception;

   -- Rename variables
   Flight_Parameters :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Calculate_Euler_Angles

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Calculate velocity magnitude and unit velocities
   Ground_Track_Velocity := Math.sqrt(
       Network_Parameters.Velocity_in_WorldC.X
     * Network_Parameters.Velocity_in_WorldC.X
     + Network_Parameters.Velocity_in_WorldC.Y
     * Network_Parameters.Velocity_in_WorldC.Y);
   Velocity_Magnitude := Math.sqrt(
       Ground_Track_Velocity * Ground_Track_Velocity
     + Network_Parameters.Velocity_in_WorldC.Z
     * Network_Parameters.Velocity_in_WorldC.Z);

   if abs(Velocity_Magnitude) >= 0.001
   then
      if abs(Ground_Track_Velocity) >= 0.001 then
         -- Calculate Euler angles (Roll = 0.0) in radians
         Euler_Angles.Psi   := DL_Math.atan2(
           Network_Parameters.Velocity_in_WorldC.Y,
           Network_Parameters.Velocity_in_WorldC.X );
         Euler_Angles.Theta := - DL_Math.atan2(
	   Network_Parameters.Velocity_in_WorldC.Z,
           Ground_Track_Velocity );
         Euler_Angles.Phi   := 0.0;
      else
         Euler_Angles.Psi   := 0.0;
         Euler_Angles.Phi   := 0.0;
         if Network_Parameters.Velocity_in_WorldC.Z > 0.0 then
            Euler_Angles.Theta := -90.0;
         else
            Euler_Angles.Theta := 90.0;
         end if;
      end if;
   else
      -- Velocity magnitude is approximately zero and a divide by zero error
      -- would occur
      raise VEL_MAG_EQUAL_ZERO_ERROR;
   end if;

exception
   when VEL_MAG_EQUAL_ZERO_ERROR =>
      Status := OS_Status.CEA_VEL_MAG_EQUAL_ZERO_ERROR;

   when OTHERS =>
      Status := OS_Status.CEA_ERROR;

end Calculate_Euler_Angles;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 21 NOV 94 -- RSK:  Changed calculation for Euler_Angles.Phi to use atan2
--           instead of acos to allow for orientations in all four quadrants
--
-- 23 NOV 94 -- RSK:  Changed calculation for Euler_Angles.Theta to use atan2
--           instead of acos to allow for negative theta angles; the previous
--           equation used acos( Ground_Track_Velocity / Velocity_Magnitude )
--           and always returned results between 0 and 90 degrees since both
--           of the used values must be positive

