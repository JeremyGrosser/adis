--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Issue_Detonation_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- MODIFIED BY:        Robert S. Kerr - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 May 94
--
-- PURPOSE :
--   - The IDPDU CSU generates a Detonation PDU which it then passes to the DG
--     CSCI.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_Types, Errors,
--     Numeric_Types, OS_Data_Types, OS_GUI, OS_Hash_Table_Support, and
--     OS_Status. 
--   - This procedure includes setting the 23rd bit in the Appearance.Specific
--     field as per the I/ITSEC expectations.  -- Modified 28 Oct 94 by KJN
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

procedure Issue_Detonation_PDU(
   Detonation_Location :  in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Detonation_Result   :  in     DIS_Types.A_DETONATION_RESULT;
   Hashing_Index       :  in     INTEGER;
   Status              :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   K_Destroyed : constant Numeric_Types.UNSIGNED_16_BIT := 16#0080#;
   -- For the Detonation PDU, the number of articulation parameters is
   -- determined by a function in order to ease defining Detonation_PDU here.
   Detonation_PDU  :  DIS_Types.A_DETONATION_PDU(Number_of_Parms => 0);
   Returned_Status :  OS_Status.STATUS_TYPE;
   Status_DG       :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

   -- Local exceptions
   DG_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
     renames Numeric_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Network_Parameters    :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Issue_Detonation_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Generate Detonation PDU
   Detonation_PDU.PDU_Header.Protocol_Version
     := OS_GUI.Interface.Simulation_Parameters.Protocol_Version;
   Detonation_PDU.PDU_Header.Exercise_ID
     := OS_GUI.Interface.Simulation_Parameters.Exercise_ID;
   Detonation_PDU.PDU_Header.PDU_Type := DIS_Types.DETONATION;
   Detonation_PDU.PDU_Header.Padding := (OTHERS => 0);
   Detonation_PDU.Firing_Entity_ID   := Network_Parameters.Firing_Entity_ID;
   Detonation_PDU.Target_Entity_ID   := Network_Parameters.Target_Entity_ID;
   Detonation_PDU.Munition_ID        := Network_Parameters.Entity_ID;
   Detonation_PDU.Event_ID           := Network_Parameters.Event_ID;
   Detonation_PDU.Velocity           := Network_Parameters.Velocity_in_WorldC;
   Detonation_PDU.World_Location     := Network_Parameters.Location_in_WorldC;
   Detonation_PDU.Burst_Descriptor   := Network_Parameters.Burst_Descriptor;
   Detonation_PDU.Entity_Location    := Detonation_Location;
   Detonation_PDU.Detonation_Result  := Detonation_Result;
   Detonation_PDU.Padding            := 0;
   Detonation_PDU.PDU_Header.Length
     := Numeric_Types.UNSIGNED_16_BIT((Detonation_PDU'SIZE + 7) / 8);

   -- Send PDU to DIS Gateway
   DG_Client.Send_PDU(
     PDU_Address => Detonation_PDU'ADDRESS,
     Status      => Status_DG);

   -- In case of error in DG, the error will be logged but no additional
   -- action will be taken
   if Status_DG /= DG_Status.SUCCESS then
      Returned_Status := OS_Status.DG_ERROR;
      raise DG_ERROR;
   end if;

   -- For tracked munitions, issue final Entity State PDU:
   if Network_Parameters.Entity_ID.Sim_Address.Site_ID /= 0
     and then Network_Parameters.Entity_ID.Sim_Address.Application_ID /= 0
     and then Network_Parameters.Entity_ID.Entity_ID /= 0
   then

      -- Set 23rd bit in Appearance Field to indicate detonation
      Network_Parameters.Entity_Appearance.Specific := K_Destroyed;
      -- Generate new Entity State PDU with new appearance field
      Gateway_Interface.Issue_Entity_State_PDU(
        Hashing_Index => Hashing_Index,
        Status        => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error but continue processing as normal
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;
   end if;

exception
   when DG_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.IDPDU_ERROR;

end Issue_Detonation_PDU;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 17 NOV 94 -- RSK:  Switched order of issuance to issue detonation PDU first
--           then final entity state PDU
--
