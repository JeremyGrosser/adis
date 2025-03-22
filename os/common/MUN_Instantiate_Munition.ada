--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Instantiate_Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 June 94
--
-- PURPOSE :
--   - The IM CSU initiates processes to define all parameters for the
--     specified munition based on user-selected data and firing data.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors, Fly_Out_Model, OS_Data_Types,
--     OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Errors,
     Fly_Out_Model,
     OS_Hash_Table_Support;

separate (Munition)

procedure Instantiate_Munition(
   Entity_Type   :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Status  :  OS_Status.STATUS_TYPE;
   General_Parameters :  OS_Data_Types.GENERAL_PARAMETERS_RECORD_PTR;
   Returned_Status    :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   FRED_ERROR :  exception;
   IFOM_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Data_Types.GENERAL_PARAMETERS_RECORD_PTR)
     return BOOLEAN
     renames OS_Data_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Instantiate_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   Find_Related_Entity_Data(
     Entity_Type        => Entity_Type,
     General_Parameters => General_Parameters,
     Status             => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      if General_Parameters = null then
         raise FRED_ERROR;
      else
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;
   end if;

   OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Aerodynamic_Parameters := General_Parameters.Aerodynamic_Parameters;
   OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).Emitter_Parameters
     := General_Parameters.Emitter_Parameters;
   OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Termination_Parameters := General_Parameters.Termination_Parameters; 
   Network_Parameters.Dead_Reckoning_Parameters.Algorithm
     := General_Parameters.Dead_Reckoning_Algorithm;
   Network_Parameters.Dead_Reckoning_Parameters.Other_Parms := (OTHERS => 0);
   Network_Parameters.Dead_Reckoning_Parameters.Linear_Accel
     := (OTHERS => 0.0);
   Network_Parameters.Dead_Reckoning_Parameters.Angular_Velocity
     := (OTHERS => 0.0);
   Network_Parameters.Alternate_Entity_Type
     := General_Parameters.Alternate_Entity_Type;
   Network_Parameters.Articulation_Parameters
     := General_Parameters.Articulation_Parameters;
   Network_Parameters.Capabilities   := General_Parameters.Capabilities;
   Network_Parameters.Entity_Appearance
     := General_Parameters.Entity_Appearance;
   Network_Parameters.Entity_Marking := General_Parameters.Entity_Marking;

   Fly_Out_Model.Instantiate_Fly_Out_Model(
     Entity_Type      => Entity_Type,
     Fly_Out_Model_ID => General_Parameters.Fly_Out_Model_ID,
     Hashing_Index    => Hashing_Index,
     Status           => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      raise IFOM_ERROR;
   end if;

exception
   when FRED_ERROR =>
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
           Error                 => Returned_Status);
      end if;

   when IFOM_ERROR =>
      Status := Returned_Status;
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.IM_ERROR;

end Instantiate_Munition;
-- MODIFICATION HISTORY:
--
-- 12 NOV 94 -- KJN:  Added initialization of additional dead reckoning
--           parameters
