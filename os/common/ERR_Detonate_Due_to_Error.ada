--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Detonate_Due_to_Error
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  25 May 94
--
-- PURPOSE :
--   - The DDTE CSU attempts to detonate and deactivate a munition in the event
--     of an error in order to satisfy the DIS requirement that every fire
--     event have a corresponding detonation event.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Active_Frozen_Lists, DIS_Types,
--     Gateway_Interface, OS_Data_Types, OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     Gateway_Interface,
     OS_Data_Types,
     OS_Hash_Table_Support;

separate (Errors)

procedure Detonate_Due_to_Error(
   Detonation_Result :  in     DIS_Types.A_DETONATION_RESULT;
   Hashing_Index     :  in     INTEGER;
   Status            :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Location :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Returned_Status     :  OS_Status.STATUS_TYPE;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Network_Parameters    :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;


begin -- Detonate_Due_to_Error

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Set parameters required to detonate munition
   Detonation_Location.X := 0.0;
   Detonation_Location.Y := 0.0;
   Detonation_Location.Z := 0.0;

   Gateway_Interface.Issue_Detonation_PDU(
     Detonation_Location => Detonation_Location,
     Detonation_Result   => Detonation_Result,
     Hashing_Index       => Hashing_Index,
     Status              => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      -- Set status so calling routines will know the detonation was
      -- unsuccessful
      Status := Returned_Status;
   end if;

   -- Attempt to remove munition from simulation regardless of status returned
   -- returned from Issue_Detonation_PDU
   Active_Frozen_Lists.Deactivate_Munition(
     Entity_ID     => Network_Parameters.Entity_ID,
     Status        => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      -- Report error and don't set status so calling routines will know the
      -- detonation was successful
      Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if;

exception
   when OTHERS =>
      Status := OS_Status.DDTE_ERROR;

end Detonate_Due_to_Error;
