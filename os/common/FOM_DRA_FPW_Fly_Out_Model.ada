--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         DRA_FPW_Fly_Out_Model
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  1 July 94
--
-- PURPOSE :
--   - The DFFOM CSU provides a fly-out model based on the FPW Dead Reckoning
--     Algorithm defined in the DIS Standard.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Numeric_Types, OS_Data_Types,
--     OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Numeric_Types,
     OS_Hash_Table_Support;

separate (Fly_Out_Model)

procedure DRA_FPW_Fly_Out_Model(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Rename variables
   Flight_Parameters  :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- DRA_FPW_Fly_Out_Model

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Velocity does not vary and, therefore, does not need to be updated

   -- Find new location
   Network_Parameters.Location_in_WorldC.X
     := Network_Parameters.Location_in_WorldC.X
      + Numeric_Types.FLOAT_64_BIT(Network_Parameters.Velocity_in_WorldC.X
      * Flight_Parameters.Cycle_Time);
   Network_Parameters.Location_in_WorldC.Y
     := Network_Parameters.Location_in_WorldC.Y
      + Numeric_Types.FLOAT_64_BIT(Network_Parameters.Velocity_in_WorldC.Y
      * Flight_Parameters.Cycle_Time);
   Network_Parameters.Location_in_WorldC.Z
     := Network_Parameters.Location_in_WorldC.Z
      + Numeric_Types.FLOAT_64_BIT(Network_Parameters.Velocity_in_WorldC.Z
      * Flight_Parameters.Cycle_Time);

   -- Update time in flight
   Flight_Parameters.Time_in_Flight := Flight_Parameters.Time_in_Flight
     + Flight_Parameters.Cycle_Time;

exception
   when OTHERS =>
      Status := OS_Status.SUCCESS;

end DRA_FPW_Fly_Out_Model;
