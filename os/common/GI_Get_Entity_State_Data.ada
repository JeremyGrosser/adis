--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Get_Entity_State_Data
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  16 May 94
--
-- PURPOSE :
--   - The GESD CSU requests a pointer to data about a specified entity.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_PDU_Pointer_Types,
--     DIS_Types, Errors and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with DG_Client,
     DG_Status,
     Errors;

separate (Gateway_Interface)

procedure Get_Entity_State_Data(
   Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   ESPDU_Pointer :     out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Returned_Status :  OS_Status.STATUS_TYPE;
   Status_DG       :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

   -- Local exceptions
   DG_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT : DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";

begin -- Get_Entity_State_Data

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Call DIS Gateway to get Entity State PDU by Entity ID
   DG_Client.Get_Entity_Info(
     Entity_ID   => Entity_ID,
     Entity_Info => ESPDU_Pointer,
     Status      => Status_DG);

   -- In case of error in DG
   if Status_DG /= DG_Status.SUCCESS then
      ESPDU_Pointer := null;
      Returned_Status := OS_Status.DG_ERROR;
      raise DG_ERROR;
   end if;

exception
   when DG_ERROR =>
      Status := Returned_Status;
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   when OTHERS =>
      Status := OS_Status.GESD_ERROR;

end Get_Entity_State_Data;
