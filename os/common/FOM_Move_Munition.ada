--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Move_Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  16 June 94
--
-- PURPOSE :
--   - The MM CSU invokes the assigned fly-out model to advance the munition's
--     position.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Calendar, DIS_Types, DL_Linked_List_Types,
--     Errors, Numeric_Types, OS_Data_Types, OS_Hash_Table_Support, and
--     OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Calendar,
     Errors,
     Numeric_Types,
     OS_Hash_Table_Support;

separate (Fly_Out_Model)

procedure Move_Munition(
   Hashing_Index        :  in     INTEGER;
   Illuminated_Entities :  in     DL_Linked_List_Types.Entity_State_List.PTR;
   Status               :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Current_Time      :  Calendar.TIME; -- Seconds
   Detonation_Status :  OS_Status.STATUS_TYPE;
   Returned_Status   :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   DFFOM_ERROR :  exception;
   KFOM_ERROR  :  exception;
   GFOM_ERROR  :  exception;

   -- Rename functions
   function "-" (LEFT, RIGHT :  Calendar.TIME)
     return DURATION
     renames Calendar."-";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;

begin -- Move_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Calculate cycle time
   -- For first update, since no previous time, use user selected cycle time
   Current_Time := Calendar.Clock;
   Flight_Parameters.Cycle_Time := Numeric_Types.FLOAT_32_BIT(Current_Time
     - Flight_Parameters.Previous_Update_Time);
   Flight_Parameters.Previous_Update_Time := Current_Time;

   -- Correlate fly-out model to the specific munition
   case Flight_Parameters.Fly_Out_Model_ID is

      when OS_Data_Types.FOM_AAM | OS_Data_Types.FOM_ASM |
        OS_Data_Types.FOM_SAM =>

         Generic_Fly_Out_Model(
           Hashing_Index        => Hashing_Index,
           Status               => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            raise GFOM_ERROR;
         end if;

      when OS_Data_Types.FOM_KINEMATIC =>
         Kinematic_Fly_Out_Model(
           Hashing_Index => Hashing_Index,
           Status        => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            raise KFOM_ERROR;
         end if;

      when OS_Data_Types.FOM_DRA_FPW =>
         DRA_FPW_Fly_Out_Model(
           Hashing_Index => Hashing_Index,
           Status        => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            raise DFFOM_ERROR;
         end if;

      when OTHERS =>
         Kinematic_Fly_Out_Model(
           Hashing_Index => Hashing_Index,
           Status        => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            raise KFOM_ERROR;
         end if;
   end case;

exception
   when DFFOM_ERROR | GFOM_ERROR | KFOM_ERROR =>
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
      Status := OS_Status.MM_ERROR;

end Move_Munition;
