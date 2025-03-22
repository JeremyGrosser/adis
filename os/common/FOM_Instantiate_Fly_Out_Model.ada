--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Instantiate_Fly_Out_Model
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- MODIFIED BY:        Robert S. Kerr - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 June 94
--
-- PURPOSE :
--   - The IFOM CSU applies the Fly-Out Model ID of the corresponding munition
--     type to the particular munition being instantiated and initializes data
--     needed for the fly-out of the munition.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Calendar, DCM_Calculations, DIS_Types, Errors, 
--     Math, OS_Hash_Table_Support, OS_Data_Types, OS_Simulation_Types and 
--     OS_Status.
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
with Calendar,
     DCM_Calculations,
     DL_Math,
     Errors,
     Math,
     OS_Hash_Table_Support,
     OS_Simulation_Types;

separate (Fly_Out_Model)

procedure Instantiate_Fly_Out_Model(
   Entity_Type      :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
   Fly_Out_Model_ID :  in     OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER;
   Hashing_Index    :  in     INTEGER;
   Status           :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Status     :  OS_Status.STATUS_TYPE;
   Ground_Track_Velocity :  OS_Data_Types.METERS_PER_SECOND;
   Returned_Status       :  OS_Status.STATUS_TYPE;
   Velocity_Magnitude    :  OS_Data_Types.METERS_PER_SECOND;

   -- Local exceptions
   CFO_ERROR  :  exception;
   MMAV_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Instantiate_Fly_Out_Model

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Begin to initialize Flight Parameters
   Flight_Parameters.Cycle_Time                 := 0.0;
   Flight_Parameters.Greq                       := 0.0;
   Flight_Parameters.Location_in_EntC           := (OTHERS => 0.0);
   Flight_Parameters.Loop_Counter               := 0;
   Flight_Parameters.Max_Turn                   := 0.0;
   Flight_Parameters.Munition_Azimuth_Heading   := 0.0;
   Flight_Parameters.Munition_Elevation_Heading := 0.0;
   Flight_Parameters.Range_to_Target            := 0.0;
   Flight_Parameters.Target.Azimuth_Heading     := 0.0;
   Flight_Parameters.Target.Elevation_Heading   := 0.0;
   Flight_Parameters.Target.Location_in_WorldC  := (OTHERS => 0.0);
   Flight_Parameters.Target.Location_in_EntC    := (OTHERS => 0.0);
   Flight_Parameters.Target.Velocity_in_WorldC  := (OTHERS => 0.0);
   Flight_Parameters.Target.Velocity_Magnitude  := 0.0;
   Flight_Parameters.Time_in_Flight             := 0.0;
   Flight_Parameters.Velocity_in_EntC           := (OTHERS => 0.0);
   Flight_Parameters.Velocity_Magnitude         := 0.0;
   Flight_Parameters.Fly_Out_Model_ID           := Fly_Out_Model_ID;
   Flight_Parameters.Previous_Update_Time       := Calendar.Clock;

   Flight_Parameters.Firing_Data.Location_in_WorldC
     := Network_Parameters.Location_in_WorldC;
   Flight_Parameters.Firing_Data.Orientation
     := Network_Parameters.Entity_Orientation;
   Flight_Parameters.Current_Mass := OS_Hash_Table_Support.
     Munition_Hash_Table(Hashing_Index).Aerodynamic_Parameters.Initial_Mass;

   -- Calculate Euler angles and direction cosine matrices to convert
   -- the munition at the moment of firing from the world coordinate
   -- system to the entity coordinate system
   DCM_Calculations.Calculate_Firing_Orientation(
     Hashing_Index => Hashing_Index,
     Status        => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      -- If the orientation cannot be found, fly-out cannot be performed
      raise CFO_ERROR;
   end if;

   case Flight_Parameters.Fly_Out_Model_ID is

      -- For munitions which require firing and entity coordinate system data
      when OS_Data_Types.FOM_AAM | OS_Data_Types.FOM_ASM |
        OS_Data_Types.FOM_SAM =>

         -- Set location in entity coordinate system upon firing
         Flight_Parameters.Location_in_EntC.X := 0.0;
         Flight_Parameters.Location_in_EntC.Y := 0.0;
         Flight_Parameters.Location_in_EntC.Z := 0.0;

         -- Convert velocity from world coordinates to entity coordinates
         DCM_Calculations.Multiply_Matrix_and_Vector(
           Matrix           => Flight_Parameters.DCM,
           Vector           => Network_Parameters.Velocity_in_WorldC,
           Resulting_Vector => Flight_Parameters.Velocity_in_EntC,
           Status           => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            raise MMAV_ERROR;
         end if;

         -- Calculate the velocity magnitude for the munition in entity
         -- coordinates
         Ground_Track_Velocity := Math.sqrt(
             Flight_Parameters.Velocity_in_EntC.X
           * Flight_Parameters.Velocity_in_EntC.X
           + Flight_Parameters.Velocity_in_EntC.Y
           * Flight_Parameters.Velocity_in_EntC.Y);

         Flight_Parameters.Velocity_Magnitude := Math.sqrt(
             Ground_Track_Velocity * Ground_Track_Velocity
           + Flight_Parameters.Velocity_in_EntC.Z
           * Flight_Parameters.Velocity_in_EntC.Z);

         -- Calculate the azimuth and elevation of the munition's total
         -- velocity vector
         -- Azimuth is measured clockwise from North and Elevation is positive
         -- up from the horizon
         if (abs(Flight_Parameters.Velocity_in_EntC.Z) >= 0.0001)
           or else (abs(Ground_Track_Velocity) >= 0.0001)
         then
            Flight_Parameters.Munition_Azimuth_Heading := DL_Math.atan2(
              Flight_Parameters.Velocity_in_EntC.Y,
              Flight_Parameters.Velocity_in_EntC.X);
         else
            Flight_Parameters.Munition_Azimuth_Heading := 0.0;
         end if;

         if (abs(Flight_Parameters.Velocity_in_EntC.X) >= 0.0001)
           or else (abs(Flight_Parameters.Velocity_in_EntC.Y) >= 0.0001)
         then
            Flight_Parameters.Munition_Elevation_Heading := DL_Math.atan2(
              Flight_Parameters.Velocity_in_EntC.Z, Ground_Track_Velocity);
         else
            Flight_Parameters.Munition_Elevation_Heading := 0.0;
         end if;

      -- For munitions which do not require firing and entity coordinate
      -- system data
      when OS_Data_Types.FOM_Kinematic | OS_Data_Types.FOM_DRA_FPW =>
         -- Set velocity magnitude in Flight_Parameters to the velocity
         -- magnitude in world coordinates so the range can be calculated
         -- (primarily for determining when to detonate)
         Flight_Parameters.Velocity_Magnitude := Math.sqrt(
             Network_Parameters.Velocity_in_WorldC.X
           * Network_Parameters.Velocity_in_WorldC.X
           + Network_Parameters.Velocity_in_WorldC.Y
           * Network_Parameters.Velocity_in_WorldC.Y
           + Network_Parameters.Velocity_in_WorldC.Z
           * Network_Parameters.Velocity_in_WorldC.Z);

   end case;

exception
   when CFO_ERROR | MMAV_ERROR =>
      Status := Returned_Status;
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
      Status := OS_Status.IFOM_ERROR;

end Instantiate_Fly_Out_Model;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 11 NOV 94 -- KJN:  Incorporated initialization of all Flight_Parameters
--           fields to zero if they are not otherwise initialized in this unit
--
-- 16 NOV 94 -- RSK:  Corrected equations for calculation of Munition Azimuth 
--           Heading and Munition Elevation Headings
--
-- 17 NOV 94 -- RSK:  Corrected equation for calculation of the Munition
--           Azimuth Heading:  Reversed X and Y in call to Math.atan2
