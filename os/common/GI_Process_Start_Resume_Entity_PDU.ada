--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Start_Resume_Entity_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  19 May 94
--
-- PURPOSE :
--   - The PSREPDU CSU restores a munition to the active munition list in
--     response to a Simulation Management PDU.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Active_Frozen_Lists, DIS_PDU_Pointer_Types,
--     DIS_Types, Errors and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--    - Incorporate enumerations for Response Flag
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     Errors;

separate (Gateway_Interface)

procedure Process_Start_Resume_Entity_PDU(
   SRPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Returned_Status :  OS_Status.STATUS_TYPE;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Process_Start_Resume_Entity_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Resume Munition
   Active_Frozen_Lists.Resume_Munition(
     Entity_ID => SRPDU_Pointer.Receiving_Entity_ID, 
     Status    => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      -- When response flag enumeration is known, set to non-compliance if
      -- an error occurs
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if;

   -- Acknowledge that the munition was resumed
   Issue_Acknowledge_PDU(
     Acknowledge_Flag      => DIS_Types.START_RESUME,
     Originating_Entity_ID => SRPDU_Pointer.Receiving_Entity_ID,
     Receiving_Entity_ID   => SRPDU_Pointer.Originating_Entity_ID,
     Response_Flag         => 0,
     Status                => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if;

exception
   when OTHERS =>
      Status := OS_Status.PSREPDU_ERROR;

end Process_Start_Resume_Entity_PDU;
