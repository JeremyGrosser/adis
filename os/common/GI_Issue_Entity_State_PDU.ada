--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Issue_Entity_State_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  16 May 94
--
-- PURPOSE :
--   - The IESPDU CSU generates an Entity State PDU which it then passes to the
--     DG CSCI.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_Types, Errors,
--     Number_of_Articulation_Parameters, Numeric_Types, OS_Data_Types, OS_GUI,
--     OS_Hash_Table_Support, and OS_Status.
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
     Number_of_Articulation_Parameters,
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support;

separate (Gateway_Interface)

procedure Issue_Entity_State_PDU(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Entity_State_PDU :  DIS_Types.AN_ENTITY_STATE_PDU(
     Number_of_Parms => Number_of_Articulation_Parameters(
       Hashing_Index => Hashing_Index));
   Returned_Status  :  OS_Status.STATUS_TYPE;
   Status_DG        :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

   -- Local exceptions
   DG_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function ">" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
     return BOOLEAN
     renames Numeric_Types.">";

   -- Rename variables
   Network_Parameters    :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Issue_Entity_State_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Generate PDU
   Entity_State_PDU.PDU_Header.Protocol_Version
     := OS_GUI.Interface.Simulation_Parameters.Protocol_Version;
   Entity_State_PDU.PDU_Header.Exercise_ID
     := OS_GUI.Interface.Simulation_Parameters.Exercise_ID;
   Entity_State_PDU.PDU_Header.PDU_Type := DIS_Types.ENTITY_STATE;
   Entity_State_PDU.PDU_Header.Length
     := Numeric_Types.UNSIGNED_16_BIT((Entity_State_PDU'SIZE + 7) / 8);
   Entity_State_PDU.PDU_Header.Padding := (OTHERS => 0);
   Entity_State_PDU.Entity_ID          := Network_Parameters.Entity_ID;
   Entity_State_PDU.Force_ID           := Network_Parameters.Force_ID;
   Entity_State_PDU.Entity_Type
     := Network_Parameters.Burst_Descriptor.Munition;
   Entity_State_PDU.Alternative_Type
     := Network_Parameters.Alternate_Entity_Type;
   Entity_State_PDU.Location
     := Network_Parameters.Location_in_WorldC;
   Entity_State_PDU.Linear_Velocity
     := Network_Parameters.Velocity_in_WorldC;
   Entity_State_PDU.Orientation
     := Network_Parameters.Entity_Orientation;
   Entity_State_PDU.Appearance
     := Network_Parameters.Entity_Appearance;
   Entity_State_PDU.Dead_Reckoning_Parms
     := Network_Parameters.Dead_Reckoning_Parameters;
   Entity_State_PDU.Marking             := Network_Parameters.Entity_Marking;
   Entity_State_PDU.Capabilities        := Network_Parameters.Capabilities;

   -- Assign Articulated Parameters if there are any known.
   if Number_of_Articulation_Parameters(Hashing_Index => Hashing_Index) > 0
   then
      Entity_State_PDU.Articulation_Parms  := Network_Parameters.
                                              Articulation_Parameters.All;
   end if;

   -- Send PDU to DIS Gateway
   DG_Client.Send_PDU(
     PDU_Address => Entity_State_PDU'ADDRESS,
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
      Status := OS_Status.IESPDU_ERROR;

end Issue_Entity_State_PDU;
