--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Stop_Freeze_Simulation_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  18 May 94
--
-- PURPOSE :
--   - The PSFSPDU CSU sets the simulation state to FREEZE in response to a
--     Simulation Management PDU.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_PDU_Pointer_Types, DIS_Types, Errors,
--     OS_GUI, OS_Simulation_Types, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--    - Incorporate enumerations for Response Flag
--
------------------------------------------------------------------------------
with Errors,
     OS_GUI,
     OS_Simulation_Types;

separate (Gateway_Interface)

procedure Process_Stop_Freeze_Simulation_PDU(
   SFPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Returned_Status :  OS_Status.STATUS_TYPE;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Process_Stop_Freeze_Simulation_PDU(

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Set Simulation State to FREEZE
   OS_GUI.Interface.Simulation_Parameters.Simulation_State
     := OS_Simulation_Types.FREEZE;

   -- Call Issue Acknowledge PDU
   -- Response Flag is set to zero because enumeration is not defined in 2.0.3
   Issue_Acknowledge_PDU(
     Originating_Entity_ID => SFPDU_Pointer.Receiving_Entity_ID,
     Receiving_Entity_ID   => SFPDU_Pointer.Originating_Entity_ID,
     Acknowledge_Flag      => DIS_Types.STOP_FREEZE,
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
      Status := OS_Status.PSFSPDU_ERROR;

end Process_Stop_Freeze_Simulation_PDU;
