--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_Simulation_Types
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  31 May 94
--
-- PURPOSE :
--
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with DIS_Types,
     DL_Types,
     OS_Data_Types;

package OS_Simulation_Types is

   subtype GEODETIC_COORDINATE_RECORD is DL_Types.THE_GEODETIC_COORDINATES;

   type SIMULATION_STATE_TYPE is (
     RUN,
     FREEZE,
     HALT,
     RESET,
     SINGLE_STEP);

   type SIMULATION_PARAMETERS_RECORD is
     record
       Contact_Threshold            :  OS_Data_Types.METERS_DP;
       Cycle_Time                   :  OS_Data_Types.SECONDS
                                    := 0.0333; -- 33.3 milliseconds or at 30 Hz
       Database_Origin              :  GEODETIC_COORDINATE_RECORD;
       Database_Origin_in_WorldC    :  DIS_Types.A_WORLD_COORDINATE;
       Exercise_ID                  :  DIS_Types.AN_EXERCISE_IDENTIFIER;
       Hash_Table_Increment         :  INTEGER;
       Hash_Table_Size              :  INTEGER;
       ModSAF_Database_Filename     :  STRING(1..80);
       Memory_Limit_for_ModSAF_File :  INTEGER;
       Number_of_Loops_Until_Update :  INTEGER;
       Parent_Entity_ID             :  DIS_Types.AN_ENTITY_IDENTIFIER;
       Protocol_Version             :  DIS_Types.A_PROTOCOL_VERSION
                                    := 3; -- 2.0 Third Draft
       Simulation_State             :  SIMULATION_STATE_TYPE;
     end record;

   Simulation_Parameters :  SIMULATION_PARAMETERS_RECORD;

end OS_Simulation_Types;
