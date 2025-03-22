--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Gateway_Interface
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 May 94
--
-- PURPOSE :
--   - The GI CSC is responsible for interacting with the DG CSCI to access
--     the network for the OS CSCI.  The GI CSC allows PDUs to be received
--     from and passed to the DG CSCI.
--
-- EFFECTS :
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES:
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
package body Gateway_Interface is

   procedure Get_Entity_State_Data(
      Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      ESPDU_Pointer :     out DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Get_Events(
      Events_List_Empty :   out BOOLEAN;
      Status            :   out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Collision_PDU(
      CPDU_Pointer :  in     DIS_PDU_Pointer_Types.COLLISION_PDU_PTR;
      Status       :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Detonation_PDU(
      DPDU_Pointer :  in     DIS_PDU_Pointer_Types.DETONATION_PDU_PTR;
      Status       :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Fire_PDU(
      FPDU_Pointer :  in     DIS_PDU_Pointer_Types.FIRE_PDU_PTR;
      Status       :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Sim_Mgmt_PDU(
      SMPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Start_Resume_Simulation_PDU(
      SRPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Stop_Freeze_Simulation_PDU(
      SFPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Start_Resume_Entity_PDU(
      SRPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Stop_Freeze_Entity_PDU(
      SFPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Process_Remove_Entity_PDU(
      REPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Issue_Acknowledge_PDU(
      Acknowledge_Flag      :  in     DIS_Types.AN_ACKNOWLEDGEMENT;
      Originating_Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Receiving_Entity_ID   :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Response_Flag         :  in     Numeric_Types.UNSIGNED_16_BIT;
      Status                :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Issue_Collision_PDU(
      Colliding_Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Collision_Location  :  in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
      Hashing_Index       :  in     INTEGER;
      Status              :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Issue_Detonation_PDU(
      Detonation_Location :  in     DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
      Detonation_Result   :  in     DIS_Types.A_DETONATION_RESULT;
      Hashing_Index       :  in     INTEGER;
      Status              :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Issue_Emission_PDU(
      Hashing_Index        :  in     INTEGER;
      Illuminated_Entities :  in     DL_Linked_List_Types.
                                     Entity_State_List.PTR;
      Status               :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Issue_Entity_State_PDU(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Initialize_Network_Parameters(
      Force_ID      :  in     DIS_Types.A_FORCE_ID;
      FPDU_Pointer  :  in     DIS_PDU_Pointer_Types.FIRE_PDU_PTR;
      Hashing_Index :     out INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

end Gateway_Interface;
