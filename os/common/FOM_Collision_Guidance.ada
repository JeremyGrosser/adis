--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Collision_Guidance
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  28 June 94
--
-- PURPOSE :
--   - The CG CSU provides a guidance method where the munition proceeds toward
--     the position the target is expected to occupy.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DCM_Calculations, Math, OS_Data_Types, OS_GUI,
--     OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--   - This unit uses DL_Math_.ada to allow usage of the asin and atan2
--     functions which were omitted from the most recent (6.2.1) compiler
--     update.  When these functions are included in the Verdix compiler,
--     simply change DL_Math to just Math in the code and eliminate DL_Math
--     from the list of withed packages.
--
------------------------------------------------------------------------------
with DCM_Calculations,
     DL_Math,
     Math,
     OS_GUI,
     OS_Hash_Table_Support;

separate (Fly_Out_Model)

procedure Collision_Guidance(
   Hashing_Index      :  in     INTEGER;
   Required_Azimuth   :     out OS_Data_Types.RADIANS;
   Required_Elevation :     out OS_Data_Types.RADIANS;
   Status             :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Delta_Target_Azimuth         :  OS_Data_Types.RADIANS;
   Returned_Status              :  OS_Status.STATUS_TYPE;
   Target_Azimuth_Heading       :  OS_Data_Types.RADIANS;
   Target_Elevation_Heading     :  OS_Data_Types.RADIANS;
   Target_Ground_Track_Velocity :  OS_Data_Types.METERS_PER_SECOND;
   Target_Velocity_in_EntC      :  DIS_Types.A_LINEAR_VELOCITY_VECTOR;
   Target_Velocity_Magnitude    :  OS_Data_Types.METERS_PER_SECOND;

   -- Local exceptions
   MMAV_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT:  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters  :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;

begin -- Collision_Guidance

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Convert target's velocity into the entity coordinate system centered
   -- about the munition
   DCM_Calculations.Multiply_Matrix_and_Vector(
     Matrix           => Flight_Parameters.DCM,
     Vector           => Flight_Parameters.Target.Velocity_in_WorldC,
     Resulting_Vector => Target_Velocity_in_EntC,
     Status           => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise MMAV_ERROR;
   end if;

   -- Perform preliminary calculation of target's ground track velocity and
   -- velocity magnitude
   Target_Ground_Track_Velocity := Math.sqrt(Target_Velocity_in_EntC.X
     * Target_Velocity_in_EntC.X + Target_Velocity_in_EntC.Y
     * Target_Velocity_in_EntC.Y);
   Target_Velocity_Magnitude := Math.sqrt(
       Target_Ground_Track_Velocity * Target_Ground_Track_Velocity
     + Target_Velocity_in_EntC.Z * Target_Velocity_in_EntC.Z);

   -- Perform preliminary calculation of target's azimuth and elevation and the
   -- difference between the target's azimuth and the target's azimuth from the
   -- munition
   Target_Azimuth_Heading   := DL_Math.atan2(
     Target_Velocity_in_EntC.Y, Target_Velocity_in_EntC.X);
   Target_Elevation_Heading := DL_Math.atan2(
     Target_Velocity_in_EntC.Z, Target_Ground_Track_Velocity);
   Delta_Target_Azimuth     := Target_Azimuth_Heading
     - Flight_Parameters.Target.Azimuth_Heading; 

   -- Calculate required azimuth and elevation to collide with target at its
   -- projected position
   Required_Azimuth   := Flight_Parameters.Target.Azimuth_Heading
     + DL_Math.asin((Target_Velocity_Magnitude
       * Math.cos(Target_Elevation_Heading) * Math.sin(Delta_Target_Azimuth))
     / (Flight_Parameters.Velocity_Magnitude
       * Math.cos(Flight_Parameters.Munition_Elevation_Heading)));
   Required_Elevation := Flight_Parameters.Target.Elevation_Heading
     + DL_Math.asin((Target_Velocity_Magnitude * Math.cos(Delta_Target_Azimuth)
       * Math.sin(Target_Elevation_Heading
       - Flight_Parameters.Target.Elevation_Heading))
     / (Flight_Parameters.Velocity_Magnitude
       * Math.cos(Flight_Parameters.Munition_Azimuth_Heading
       - Flight_Parameters.Target.Azimuth_Heading)));

exception
   when MMAV_ERROR =>
      Status := Returned_Status;

   when OTHERS =>
      Status := OS_Status.CG_ERROR;

end Collision_Guidance;
