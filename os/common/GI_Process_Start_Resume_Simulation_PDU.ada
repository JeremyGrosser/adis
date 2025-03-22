--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Start_Resume_Simulation_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  18 May 94
--
-- PURPOSE :
--   - The PSRSPDU CSU sets the Simulation State to RUN in response to a
--     Simulation Management PDU.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_PDU_Pointer_Types, DIS_Types, OS_GUI,
--     OS_Simulation_Types, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--    - Incorporate enumerations for Response Flag
--
------------------------------------------------------------------------------
with DIS_PDU_Pointer_Types,
     DIS_Types,
     Errors,
     OS_GUI,
     OS_Simulation_Types,
     OS_Status;

separate (Gateway_Interface)

procedure Process_Start_Resume_Simulation_PDU(
   SRPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Returned_Status :  OS_Status.STATUS_TYPE;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Process_Start_Resume_Simulation_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Set Simulation State to Run
   OS_GUI.Interface.Simulation_Parameters.Simulation_State
     := OS_Simulation_Types.RUN;

   -- Call Issue Acknowledge PDU
   -- Response Flag is set to zero because enumeration is not defined in 2.0.3
   Issue_Acknowledge_PDU(
     Originating_Entity_ID => SRPDU_Pointer.Receiving_Entity_ID,
     Receiving_Entity_ID   => SRPDU_Pointer.Originating_Entity_ID,
     Acknowledge_Flag      => DIS_Types.START_RESUME,
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
      Status := OS_Status.PSRSPDU_ERROR;

end Process_Start_Resume_Simulation_PDU;
