--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Generic_Fly_Out_Model
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  21 June 94
--
-- PURPOSE :
--   - The GFOM CSU provides a generic fly-out model for all types of guided
--     munitions.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Coordinate_Conversions, DCM_Calculations, 
--     DIS_Types, DL_Status, DL_Types, Errors, Math, Numeric_Types, 
--     OS_Data_Types,OS_Hash_Table_Support, OS_Simulation_Types, and OS_Status.
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
with Coordinate_Conversions,
     DCM_Calculations,
     DL_Math,
     DL_Types,
     DL_Status,
     Errors,
     Math,
     Numeric_Types,
     OS_Hash_Table_Support,
     OS_Simulation_Types;

separate (Fly_Out_Model)

procedure Generic_Fly_Out_Model(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Altitude           :  OS_Data_Types.METERS_DP;
   Cd                 :  OS_Data_Types.DRAG_COEFFICIENT_TYPE;
   Cdg                :  OS_Data_Types.DRAG_COEFFICIENT_TYPE;
   Cdo                :  OS_Data_Types.DRAG_COEFFICIENT_TYPE;
   Cos_Elev           :  Numeric_Types.FLOAT_32_BIT;
   Delta_Heading      :  OS_Data_Types.RADIANS;
   Delta_Velocity     :  Numeric_Types.FLOAT_32_BIT;
   Desired_Munition_Azimuth_Heading   :  OS_Data_Types.RADIANS;
   Desired_Munition_Elevation_Heading :  OS_Data_Types.RADIANS;
   Detonation_Status  :  OS_Status.STATUS_TYPE;
   Drag               :  OS_Data_Types.NEWTONS;
   Drag_Coefficients  :  OS_Data_Types.DRAG_COEFFICIENTS_ARRAY;
   Geodetic_Position  :  DL_Types.THE_GEODETIC_COORDINATES;
   Mach               :  OS_Data_Types.METERS_PER_SECOND; -- actually
                      -- dimensionless, but this avoids a type conversion
   Net_Force          :  OS_Data_Types.NEWTONS;
   New_Heading_Factor :  OS_Data_Types.RADIANS;
   Q                  :  Numeric_Types.FLOAT_32_BIT;
   Returned_Status    :  OS_Status.STATUS_TYPE;
   Rho                :  Numeric_Types.FLOAT_32_BIT
                      := 0.06246; -- kg*sec^2/m**4
   Sin_Elev           :  Numeric_Types.FLOAT_32_BIT;
   Sonic_Velocity     :  OS_Data_Types.METERS_PER_SECOND;
   Status_DL          :  DL_Status.STATUS_TYPE := DL_Status.SUCCESS;
   Thrust             :  OS_Data_Types.NEWTONS;
   Turn_Factor        :  Numeric_Types.FLOAT_32_BIT;
   Vel_Factor1        :  OS_Data_Types.METERS_PER_SECOND;
   Vel_Factor2        :  OS_Data_Types.METERS_PER_SECOND;

   -- Local exceptions
   CLVTW_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Aerodynamic_Parameters :  OS_Data_Types.AERODYNAMIC_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Aerodynamic_Parameters;
   Flight_Parameters      :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters     :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Generic_Fly_Out_Model

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Determine guidance model (to calculate required munition heading)
   case Aerodynamic_Parameters.Guidance is
      when OS_Data_Types.BEAM_RIDER =>
         Beam_Rider_Guidance(
           Hashing_Index      => Hashing_Index,
           Required_Azimuth   => Flight_Parameters.Target.Azimuth_Heading,
           Required_Elevation => Flight_Parameters.Target.Elevation_Heading,
           Status             => Returned_Status);

         if Returned_Status /= OS_Status.SUCCESS then
           -- Report error
           Errors.Report_Error(
             Detonated_Prematurely => FALSE,
             Error                 => Returned_Status);

           -- Assign values to required azimuth and elevation
           Flight_Parameters.Target.Azimuth_Heading
             := Flight_Parameters.Munition_Azimuth_Heading;
           Flight_Parameters.Target.Elevation_Heading
             := Flight_Parameters.Munition_Elevation_Heading;
         end if;
 
      when OS_Data_Types.COLLISION  =>
         Collision_Guidance(
           Hashing_Index      => Hashing_Index,
           Required_Azimuth   => Flight_Parameters.Target.Azimuth_Heading,
           Required_Elevation => Flight_Parameters.Target.Elevation_Heading,
           Status             => Returned_Status);

         if Returned_Status /= OS_Status.SUCCESS then
           -- Report error
           Errors.Report_Error(
             Detonated_Prematurely => FALSE,
             Error                 => Returned_Status);

           -- Assign values to required azimuth and elevation
           Flight_Parameters.Target.Azimuth_Heading
             := Flight_Parameters.Munition_Azimuth_Heading;
           Flight_Parameters.Target.Elevation_Heading
             := Flight_Parameters.Munition_Elevation_Heading;
         end if;

      when OS_Data_Types.PURSUIT    =>
         Pursuit_Guidance(
           Hashing_Index      => Hashing_Index,
           Required_Azimuth   => Flight_Parameters.Target.Azimuth_Heading,
           Required_Elevation => Flight_Parameters.Target.Elevation_Heading,
           Status             => Returned_Status);

         if Returned_Status /= OS_Status.SUCCESS then
           -- Report error
           Errors.Report_Error(
             Detonated_Prematurely => FALSE,
             Error                 => Returned_Status);

           -- Assign values to required azimuth and elevation
           Flight_Parameters.Target.Azimuth_Heading
             := Flight_Parameters.Munition_Azimuth_Heading;
           Flight_Parameters.Target.Elevation_Heading
             := Flight_Parameters.Munition_Elevation_Heading;
         end if;

   end case;

   -- Calculate desired munition heading change
   Desired_Munition_Azimuth_Heading   := Flight_Parameters.
     Target.Azimuth_Heading - Flight_Parameters.Munition_Azimuth_Heading;
   Desired_Munition_Elevation_Heading := Flight_Parameters.
     Target.Elevation_Heading - Flight_Parameters.Munition_Elevation_Heading;

   -- Check azimuth heading change to ensure turn towards the target heading
   if Desired_Munition_Azimuth_Heading   > OS_Data_Types.K_PI then
      Desired_Munition_Azimuth_Heading := Desired_Munition_Azimuth_Heading
	- (OS_Data_Types.K_2PI);
   elsif Desired_Munition_Azimuth_Heading   <= (-OS_Data_Types.K_PI) then
      Desired_Munition_Azimuth_Heading := Desired_Munition_Azimuth_Heading
	+ (OS_Data_Types.K_2PI);
   end if;

   -- Check elevation heading change to ensure turn towards the target heading
   if Desired_Munition_Azimuth_Heading   > OS_Data_Types.K_PI then
      Desired_Munition_Azimuth_Heading := Desired_Munition_Azimuth_Heading
	- (OS_Data_Types.K_2PI);
   elsif Desired_Munition_Azimuth_Heading   <= (-OS_Data_Types.K_PI) then
      Desired_Munition_Azimuth_Heading := Desired_Munition_Azimuth_Heading
	+ (OS_Data_Types.K_2PI);
   end if;

   -- Calculate the change in heading required to intercept target
   Cos_Elev := Math.cos(Desired_Munition_Elevation_Heading);
   Delta_Heading := Math.sqrt(
       (Desired_Munition_Azimuth_Heading * Cos_Elev)
     * (Desired_Munition_Azimuth_Heading * Cos_Elev)
     + Desired_Munition_Elevation_Heading
     * Desired_Munition_Elevation_Heading);

   -- If angle required exceeds maximum allowed, limit the angle
   Flight_Parameters.Max_Turn := OS_Data_Types.K_g
     * Aerodynamic_Parameters.Max_Gs * Flight_Parameters.Cycle_Time
     / Flight_Parameters.Velocity_Magnitude;

   if Delta_Heading >= Flight_Parameters.Max_Turn then
      Turn_Factor := Flight_Parameters.Max_Turn / Delta_Heading;
      Flight_Parameters.Target.Azimuth_Heading
        := Flight_Parameters.Munition_Azimuth_Heading
         + Desired_Munition_Azimuth_Heading * Turn_Factor;
      Flight_Parameters.Target.Elevation_Heading
        := Flight_Parameters.Munition_Elevation_Heading
         + Desired_Munition_Elevation_Heading * Turn_Factor;
   end if;

   -- Calculate the g-loading, given the new angle
   Flight_Parameters.Greq := (Flight_Parameters.Velocity_Magnitude
     / (Flight_Parameters.Cycle_Time * OS_Data_Types.K_g)) * Delta_Heading;

   -- Set the munition's new azimuth and elevation
   Flight_Parameters.Munition_Azimuth_Heading
     := Flight_Parameters.Target.Azimuth_Heading;
   Flight_Parameters.Munition_Elevation_Heading
     := Flight_Parameters.Target.Elevation_Heading;

   -- Find altitude (meters) to approximate sonic velocity
   Coordinate_Conversions.Geocentric_To_Geodetic_Conversion(
     Geocentric_Coordinates => Network_Parameters.Location_in_WorldC,
     Geodetic_Coordinates   => Geodetic_Position,
     Status                 => Status_DL);

   -- In case of an error in Get_Height_Relative_to_Sea_Level, the fly-out
   -- should continue; therefore, an average is used for Sonic_Velocity

   -- Sonic velocity approximation is based on relationship determined from
   -- a table of sonic velocities for various altitudes for various units
   -- These values are appropriate up to 20000 meters
   if Status_DL = DL_Status.SUCCESS then

      if Geodetic_Position.Altitude < 11000.0 then
         Sonic_Velocity :=  340.0 - (Numeric_Types.FLOAT_32_BIT(
           Geodetic_Position.Altitude / 500.0) * 2.0);
      else
         Sonic_Velocity := 295.1;
      end if;

   else  -- An error occurred

     Sonic_Velocity := 320.0;

      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   end if;

   -- Calculate Mach number
   Mach := Flight_Parameters.Velocity_Magnitude / Sonic_Velocity;

   -- Determine drag coefficient (based on a sample typical drag profile
   -- from Mechanics and Thermodynamics of Propulsion by Hill and Peterson
   if Mach < 0.5 then
      Cdo := Aerodynamic_Parameters.Drag_Coefficients(1);
   elsif 0.5 <= Mach and Mach <= 1.0 then
      Cdo := Aerodynamic_Parameters.Drag_Coefficients(2);
   elsif 1.0 < Mach and Mach < 1.3 then
      Cdo := Aerodynamic_Parameters.Drag_Coefficients(3);
   elsif 1.3 <= Mach and Mach <= 2.0 then
      Cdo := Aerodynamic_Parameters.Drag_Coefficients(4);
   elsif 2.0 < Mach and Mach < 3.0 then
      Cdo := Aerodynamic_Parameters.Drag_Coefficients(5);
   else -- 3.0 < Mach
      Cdo := Aerodynamic_Parameters.Drag_Coefficients(6);
   end if;

   Cdg := Flight_Parameters.Greq * Flight_Parameters.Greq
     * Aerodynamic_Parameters.G_Gain * Cdo;

   -- Calculate drag
   Cd   := Cdg + Cdo;
   Q    := 0.5 * Rho * Flight_Parameters.Velocity_Magnitude
     * Flight_Parameters.Velocity_Magnitude;
   Drag := Cd * Q * Aerodynamic_Parameters.Frontal_Area;

   -- Calculate time the munition has been in flight
   Flight_Parameters.Time_in_Flight := Flight_Parameters.Time_in_Flight
     + Flight_Parameters.Cycle_Time;

   -- Calculate thrust
   if Flight_Parameters.Time_in_Flight <= Aerodynamic_Parameters.Burn_Time
   then
      Thrust := Aerodynamic_Parameters.Thrust;
      -- Calculate change in mass
      Flight_Parameters.Current_Mass := Flight_Parameters.Current_Mass
        - Aerodynamic_Parameters.Burn_Rate * Flight_Parameters.Cycle_Time;
   else
      Thrust := 0.0;
   end if;

   -- Net propulsive force calculation
   Net_Force := Thrust - Drag;

   -- Calculate sin of elevation to facilitate calculations
   Sin_Elev := Math.sin(Flight_Parameters.Munition_Elevation_Heading);

   -- Calculate new velocity of missile due to net propulsive force
   Delta_Velocity := Net_Force / Flight_Parameters.Current_Mass
     * Flight_Parameters.Cycle_Time;
   Vel_Factor1 := Flight_Parameters.Velocity_Magnitude + Delta_Velocity
     - Sin_Elev * OS_Data_Types.K_g * Flight_Parameters.Cycle_Time;
   Vel_Factor2 := OS_Data_Types.K_g * Flight_Parameters.Cycle_Time
     * Math.cos(Flight_Parameters.Munition_Elevation_Heading);
   Flight_Parameters.Velocity_Magnitude := Math.sqrt(
     Vel_Factor1 * Vel_Factor1 + Vel_Factor2 * Vel_Factor2);

   -- Calculate velocity components (in inertial coordinates -- entity
   -- coordinates with the database origin as the center of the system)
   -- Z => Down, X => North, Y => East
   Flight_Parameters.Velocity_in_EntC.Z := Sin_Elev
     * Flight_Parameters.Velocity_Magnitude;
   Flight_Parameters.Velocity_in_EntC.X :=
       Math.cos(Flight_Parameters.Munition_Azimuth_Heading)
     * Math.sqrt(
       Flight_Parameters.Velocity_Magnitude
     * Flight_Parameters.Velocity_Magnitude
     - Flight_Parameters.Velocity_in_EntC.Z
     * Flight_Parameters.Velocity_in_EntC.Z);
   Flight_Parameters.Velocity_in_EntC.Y := 
       Math.sin(Flight_Parameters.Munition_Azimuth_Heading)
     * Math.sqrt(
       Flight_Parameters.Velocity_Magnitude
     * Flight_Parameters.Velocity_Magnitude
     - Flight_Parameters.Velocity_in_EntC.Z
     * Flight_Parameters.Velocity_in_EntC.Z);

   -- Update munition position
   Flight_Parameters.Location_in_EntC.X := Flight_Parameters.Location_in_EntC.X
     + Flight_Parameters.Velocity_in_EntC.X * Flight_Parameters.Cycle_Time;
   Flight_Parameters.Location_in_EntC.Y := Flight_Parameters.Location_in_EntC.Y
     + Flight_Parameters.Velocity_in_EntC.Y * Flight_Parameters.Cycle_Time;
   Flight_Parameters.Location_in_EntC.Z := Flight_Parameters.Location_in_EntC.Z
     + Flight_Parameters.Velocity_in_EntC.Z * Flight_Parameters.Cycle_Time;

   -- Convert new location and velocity from the entity coordinate system to
   -- the world coordinate system
   DCM_Calculations.Convert_Loc_Vel_to_WorldC(
     Hashing_Index => Hashing_Index,
     Status        => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise CLVTW_ERROR;
   end if;

exception
   when CLVTW_ERROR =>
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
      Status := OS_Status.GFOM_ERROR;

end Generic_Fly_Out_Model;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 11 NOV 94 -- KJN:  Removed extraneous calculations (New_Heading_Factor)
--           and cosine and sine of azimuth angle
-- 12 NOV 94 -- KJN:  Moved change in mass calculation inside if Time_in_Flight
--           < Burn_Time block
-- 28 NOV 94 -- RSK:  Added Desired Munition Azimuth and Elevation range
--           checks to ensure turn towards the target heading
-- 
