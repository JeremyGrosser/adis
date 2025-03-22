--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Issue_Acknowledge_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 May 94
--
-- PURPOSE :
--   - The IAPDU CSU generates an Acknowledge PDU which it then passes to
--     the DG CSCI.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_Types, Errors,
--     Numeric_Types, OS_GUI, and OS_Status.
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
     Errors,
     Numeric_Types,
     OS_GUI;

separate (Gateway_Interface)

procedure Issue_Acknowledge_PDU(
   Acknowledge_Flag      :  in     DIS_Types.AN_ACKNOWLEDGEMENT;
   Originating_Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Receiving_Entity_ID   :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Response_Flag         :  in     Numeric_Types.UNSIGNED_16_BIT;
   Status                :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Acknowledge_PDU :  DIS_Types.AN_ACKNOWLEDGE_PDU;
   Returned_Status :  OS_Status.STATUS_TYPE;
   Status_DG       :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

   -- Local exceptions
   DG_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";

begin -- Issue_Acknowledge_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Generate PDU
   Acknowledge_PDU.PDU_Header.Protocol_Version := OS_GUI.Interface.
     Simulation_Parameters.Protocol_Version;
   Acknowledge_PDU.PDU_Header.Exercise_ID      := OS_GUI.Interface.
     Simulation_Parameters.Exercise_ID;
   Acknowledge_PDU.PDU_Header.PDU_Type         := DIS_Types.ACKNOWLEDGE;
   Acknowledge_PDU.PDU_Header.Length           := Numeric_Types.
     UNSIGNED_16_BIT((DIS_Types.AN_ACKNOWLEDGE_PDU'SIZE + 7) / 8);
   Acknowledge_PDU.PDU_Header.Padding          := (OTHERS => 0);
   Acknowledge_PDU.Originating_Entity_ID := Originating_Entity_ID;
   Acknowledge_PDU.Originating_Group     := 0;
   Acknowledge_PDU.Receiving_Entity_ID   := Receiving_Entity_ID;
   Acknowledge_PDU.Receiving_Group       := 0;
   Acknowledge_PDU.Acknowledge_Flag      := Acknowledge_Flag;
   Acknowledge_PDU.Response_Flag         := Response_Flag;
 
   -- Send PDU to DIS Gateway
   DG_Client.Send_PDU(
     PDU_Address => Acknowledge_PDU'ADDRESS,
     Status      => Status_DG);

   -- In case of error in DG, the error will be logged but no additional
   -- action will be taken
   if Status_DG /= DG_Status.SUCCESS then
      Returned_Status := OS_Status.DG_ERROR;
      raise DG_ERROR;
   end if;

exception
   when DG_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.IAPDU_ERROR;

end Issue_Acknowledge_PDU;
