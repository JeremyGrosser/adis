--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Convert_Loc_Vel_to_WorldC
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  17 October 94
--
-- PURPOSE :
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Math, Numeric_Types, OS_Data_Types,
--     OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with Errors,
     Math,
     Numeric_Types,
     OS_Hash_Table_Support;

separate (DCM_Calculations)

procedure Convert_Loc_Vel_to_WorldC(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Status :  OS_Status.STATUS_TYPE;
   Returned_Status   :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   CEA_ERROR   :  exception;
   CELTW_ERROR :  exception;
   MMAV_ERROR  :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT:  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Convert_Loc_Vel_to_WorldC

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Calculate new location in world
   -- Location of the munition in world coordinates is the starting location of
   -- the munition in world coordinates plus the change in location due to
   -- flight (converted from entity coordinates to world coordinates)
   Convert_EntC_Location_to_WorldC(
     Offset_to_ECS      => Flight_Parameters.Firing_Data.Location_in_WorldC,
     EntC_to_WorldC_DCM => Flight_Parameters.Inverse_DCM,
     Location_in_EntC   => Flight_Parameters.Location_in_EntC,
     Location_in_WorldC => Network_Parameters.Location_in_WorldC,
     Status             => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise CELTW_ERROR;
   end if;

   -- Calculate new velocity in world
   Multiply_Matrix_and_Vector(
     Matrix           => Flight_Parameters.Inverse_DCM,
     Vector           => Flight_Parameters.Velocity_in_EntC,
     Resulting_Vector => Network_Parameters.Velocity_in_WorldC,
     Status           => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise MMAV_ERROR;
   end if;

   -- Determine new orientation
   Calculate_Euler_Angles(
     Hashing_Index => Hashing_Index,
     Euler_Angles  => Network_Parameters.Entity_Orientation,
     Status        => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise CEA_ERROR;
   end if;

exception
   when CEA_ERROR | CELTW_ERROR | MMAV_ERROR =>
     Errors.Detonate_Due_to_Error(
       Detonation_Result => DIS_Types.NONE,
       Hashing_Index     => Hashing_Index,
       Status            => Detonation_Status);

     if Detonation_Status = OS_Status.SUCCESS then
        -- Report original error
        Errors.Report_Error(
          Detonated_Prematurely => TRUE,
          Error                 => Returned_Status);
     else
        -- Report original error
        Errors.Report_Error(
          Detonated_Prematurely => FALSE,
          Error                 => Returned_Status);
        -- Report error from Detonate_Due_to_Error
        Errors.Report_Error(
          Detonated_Prematurely => FALSE,
          Error                 => Detonation_Status);
     end if;

   when OTHERS =>
      Status := OS_Status.CLVTW_ERROR;

end Convert_Loc_Vel_to_WorldC;
