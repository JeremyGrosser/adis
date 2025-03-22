--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Kinematic_Fly_Out_Model
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  30 June 94
--
-- PURPOSE :
--   - The KFOM CSU provides a fly-out model based on the standard rectlinear
--     equations of motion.  This model is best suited for dropped bombs and
--     rockets (unguided munitions).
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires G_Utilities, Math, Numeric_Types, OS_Data_Types, 
--     OS_Hash_Table_Support, OS_Simulation_Types, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with G_Utilities,
     Math,
     Numeric_Types,
     OS_Hash_Table_Support,
     OS_Simulation_Types;

separate (Fly_Out_Model)

procedure Kinematic_Fly_Out_Model(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   G_Vector        :  G_Utilities.G_VECTOR_TYPE;
   Returned_Status :  OS_Status.STATUS_TYPE;

   -- Rename variables
   Flight_Parameters  :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Kinematic_Fly_Out_Model

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   G_Utilities.Find_G(
     Entity_Position => Network_Parameters.Location_in_WorldC,
     G_Vector        => G_Vector,
     Status          => Returned_Status);

   -- Find new location
   Network_Parameters.Location_in_WorldC.X
     := Network_Parameters.Location_in_WorldC.X
      + Numeric_Types.FLOAT_64_BIT(Network_Parameters.Velocity_in_WorldC.X
      * Flight_Parameters.Cycle_Time)
      + 0.5 * G_Vector.X_Accel * Numeric_Types.FLOAT_64_BIT(
        Flight_Parameters.Cycle_Time * Flight_Parameters.Cycle_Time);
   Network_Parameters.Location_in_WorldC.Y
     := Network_Parameters.Location_in_WorldC.Y
      + Numeric_Types.FLOAT_64_BIT(Network_Parameters.Velocity_in_WorldC.Y
      * Flight_Parameters.Cycle_Time)
      + 0.5 * G_Vector.Y_Accel * Numeric_Types.FLOAT_64_BIT(
        Flight_Parameters.Cycle_Time * Flight_Parameters.Cycle_Time);
   Network_Parameters.Location_in_WorldC.Z
     := Network_Parameters.Location_in_WorldC.Z
      + Numeric_Types.FLOAT_64_BIT(Network_Parameters.Velocity_in_WorldC.Z
      * Flight_Parameters.Cycle_Time)
      + 0.5 * G_Vector.Z_Accel * Numeric_Types.FLOAT_64_BIT(
        Flight_Parameters.Cycle_Time * Flight_Parameters.Cycle_Time);

   -- Find new velocity
   Network_Parameters.Velocity_in_WorldC.X
     := Network_Parameters.Velocity_in_WorldC.X + Flight_Parameters.Cycle_Time
      * Numeric_Types.FLOAT_32_BIT(G_Vector.X_Accel);
   Network_Parameters.Velocity_in_WorldC.Y
     := Network_Parameters.Velocity_in_WorldC.Y + Flight_Parameters.Cycle_Time
      * Numeric_Types.FLOAT_32_BIT(G_Vector.Y_Accel);
   Network_Parameters.Velocity_in_WorldC.Z
     := Network_Parameters.Velocity_in_WorldC.Z + Flight_Parameters.Cycle_Time
      * Numeric_Types.FLOAT_32_BIT(G_Vector.Z_Accel);

   -- Find new velocity magnitude and store in flight parameters
   Flight_Parameters.Velocity_Magnitude := Math.sqrt(
       Network_Parameters.Velocity_in_WorldC.X
     * Network_Parameters.Velocity_in_WorldC.X
     + Network_Parameters.Velocity_in_WorldC.Y
     * Network_Parameters.Velocity_in_WorldC.Y
     + Network_Parameters.Velocity_in_WorldC.Z
     * Network_Parameters.Velocity_in_WorldC.Z);

   -- Update time in flight
   Flight_Parameters.Time_in_Flight := Flight_Parameters.Time_in_Flight
     + Flight_Parameters.Cycle_Time;
   
exception
   when OTHERS =>
      Status := OS_Status.KFOM_ERROR;

end Kinematic_Fly_Out_Model;
