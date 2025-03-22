--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Issue_Collision_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  16 May 94
--
-- PURPOSE :
--   - The ICPDU CSU generates a Collision PDU which it then passes to the DG
--     CSCI.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_Types, Errors,
--     Numeric_Types, OS_Data_Types, OS_GUI, OS_Hash_Table_Support, and
--     OS_Status.
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
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support;

separate (Gateway_Interface)

procedure Issue_Collision_PDU(
   Colliding_Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Collision_Location  :  in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Hashing_Index       :  in     INTEGER;
   Status              :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Collision_PDU   :  DIS_Types.A_COLLISION_PDU;
   Returned_Status :  OS_Status.STATUS_TYPE;
   Status_DG       :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

   -- Local exceptions
   DG_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";

   -- Rename variables
   Network_Parameters    :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Issue_Collision_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Generate PDU
   Collision_PDU.PDU_Header.Protocol_Version := OS_GUI.Interface.
     Simulation_Parameters.Protocol_Version;
   Collision_PDU.PDU_Header.Exercise_ID      := OS_GUI.Interface.
     Simulation_Parameters.Exercise_ID;
   Collision_PDU.PDU_Header.PDU_Type         := DIS_Types.COLLISION;
   Collision_PDU.PDU_Header.Length           := Numeric_Types.
     UNSIGNED_16_BIT((DIS_Types.A_COLLISION_PDU'SIZE + 7) / 8);
   Collision_PDU.PDU_Header.Padding          := (OTHERS => 0);
   Collision_PDU.Issuing_Entity_ID           := Network_Parameters.Entity_ID;
   Collision_PDU.Colliding_Entity_ID         := Colliding_Entity_ID;
   Collision_PDU.Event_ID                    := Network_Parameters.Event_ID;
   Collision_PDU.Padding                     := (OTHERS => 0);
   Collision_PDU.Velocity                    := Network_Parameters.
                                                Velocity_in_WorldC;
   Collision_PDU.Mass := OS_Hash_Table_Support.Munition_Hash_Table(
     Hashing_Index).Flight_Parameters.Current_Mass;
   Collision_PDU.Entity_Location             := Collision_Location;

   -- Send PDU to DIS Gateway
   DG_Client.Send_PDU(
     PDU_Address => Collision_PDU'ADDRESS,
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
      Status := OS_Status.ICPDU_ERROR;

end Issue_Collision_PDU;
