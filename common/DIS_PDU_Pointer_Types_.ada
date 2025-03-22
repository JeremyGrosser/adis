------------------------------------------------------------------------------
--
-- PACKAGE NAME     : DIS_PDU_Pointer_Types
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 20, 1994
--
-- PURPOSE:
--   - Define access types for the DIS PDU types in DIS_Types_.ada
--
-- EFFECTS:
--   - None.
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - Change spelling of AN_ACTION_RESPONCE_PDU to AN_ACTION_RESPONSE_PDU
--     both here and in DIS_Types_.ada
--
------------------------------------------------------------------------------

with DIS_Types;

package DIS_PDU_Pointer_Types is

   type ENTITY_STATE_PDU_PTR is
     access DIS_Types.AN_ENTITY_STATE_PDU;

   type FIRE_PDU_PTR is
     access DIS_Types.A_FIRE_PDU;

   type DETONATION_PDU_PTR is
     access DIS_Types.A_DETONATION_PDU;

   type SERVICE_REQUEST_PDU_PTR is
     access DIS_Types.A_SERVICE_REQUEST_PDU;

   type RESUPPLY_OFFER_PDU_PTR is
     access DIS_Types.A_RESUPPLY_OFFER_PDU;

   type RESUPPLY_RECEIVED_PDU_PTR is
     access DIS_Types.A_RESUPPLY_RECEIVED_PDU;

   type RESUPPLY_CANCEL_PDU_PTR is
     access DIS_Types.A_RESUPPLY_CANCEL_PDU;

   type REPAIR_COMPLETE_PDU_PTR is
     access DIS_Types.A_REPAIR_COMPLETE_PDU;

   type REPAIR_RESPONSE_PDU_PTR is
     access DIS_Types.A_REPAIR_RESPONSE_PDU;

   type COLLISION_PDU_PTR is
     access DIS_Types.A_COLLISION_PDU;

   type CREATE_ENTITY_PDU_PTR is
     access DIS_Types.A_CREATE_ENTITY_PDU;

   type REMOVE_ENTITY_PDU_PTR is
     access DIS_Types.A_REMOVE_ENTITY_PDU;

   type START_RESUME_PDU_PTR is
     access DIS_Types.A_START_RESUME_PDU;

   type STOP_FREEZE_PDU_PTR is
     access DIS_Types.A_STOP_FREEZE_PDU;

   type ACKNOWLEDGE_PDU_PTR is
     access DIS_Types.AN_ACKNOWLEDGE_PDU;

   type ACTION_REQUEST_PDU_PTR is
     access DIS_Types.AN_ACTION_REQUEST_PDU;

   type ACTION_RESPONSE_PDU_PTR is
     access DIS_Types.AN_ACTION_RESPONCE_PDU;

   type DATA_QUERY_PDU_PTR is
     access DIS_Types.A_DATA_QUERY_PDU;

   type SET_DATA_PDU_PTR is
     access DIS_Types.A_SET_DATA_PDU;

   type DATA_PDU_PTR is
     access DIS_Types.A_DATA_PDU;

   type EVENT_REPORT_PDU_PTR is
     access DIS_Types.AN_EVENT_REPORT_PDU;

   type MESSAGE_PDU_PTR is
     access DIS_Types.A_MESSAGE_PDU;

   type EMISSION_PDU_PTR is
     access DIS_Types.AN_EMISSION_PDU;

   type LASER_PDU_PTR is
     access DIS_Types.A_LASER_PDU;

   type TRANSMITTER_PDU_PTR is
     access DIS_Types.A_TRANSMITTER_PDU;

   type RECEIVER_PDU_PTR is
     access DIS_Types.A_RECEIVER_PDU;

   type SIGNAL_PDU_PTR is
     access DIS_Types.A_SIGNAL_PDU;

end DIS_PDU_Pointer_Types;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
