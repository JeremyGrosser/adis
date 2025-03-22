--
--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--
------------------------------------------------------------------------------
--
-- PACKAGE NAME     : DG_Verdix_Dope_Vector
--
-- FILE NAME        : DG_Verdix_Dope_Vector_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 30, 1994
--
-- PURPOSE:
--   - This package defines the information needed to handle the conversion
--     between DIS network PDU formats and the corresponding Verdix Ada
--     internal data representation formats.  Verdix Ada inserts a 16-18 byte
--     "dope vector" between the static and variant sections of a variant
--     record.  This "dope vector" must be inserted into data received from
--     the net, and removed from data prior to transmission on the net.
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
--   - None.
--
------------------------------------------------------------------------------

with DIS_Types,
     System;

package DG_Verdix_Dope_Vector is

   --
   -- Import the "-" function for addresses.
   --
   function "-"(Left, Right : System.ADDRESS)
     return INTEGER
       renames System."-";

   --
   -- Declare some simple record objects to enable retrieval of dope
   -- vector location information
   --

   Dope_Entity_State      : DIS_Types.AN_ENTITY_STATE_PDU(
                              Number_Of_Parms => 1);
   Dope_Detonation        : DIS_Types.A_DETONATION_PDU(
                              Number_Of_Parms => 1);
   Dope_Service_Request   : DIS_Types.A_SERVICE_REQUEST_PDU(
                              Number_Of_Supply_Types => 1);
   Dope_Resupply_Offer    : DIS_Types.A_RESUPPLY_OFFER_PDU(
                              Number_Of_Supply_Types => 1);
   Dope_Action_Request    : DIS_Types.AN_ACTION_REQUEST_PDU(
                              Number_Of_Fixed_Datums    => 1,
                              Number_Of_Variable_Datums => 1);
   Dope_Action_Response   : DIS_Types.AN_ACTION_RESPONCE_PDU(
                              Number_Of_Fixed_Datums    => 1,
                              Number_Of_Variable_Datums => 1);
   Dope_Data_Query        : DIS_Types.A_DATA_QUERY_PDU(
                              Number_Of_Fixed_Datums    => 1,
                              Number_Of_Variable_Datums => 1);
   Dope_Set_Data          : DIS_Types.A_SET_DATA_PDU(
                              Number_Of_Fixed_Datums    => 1,
                              Number_Of_Variable_Datums => 1);
   Dope_Data              : DIS_Types.A_DATA_PDU(
                              Number_Of_Fixed_Datums    => 1,
                              Number_Of_Variable_Datums => 1);
   Dope_Event_Report      : DIS_Types.AN_EVENT_REPORT_PDU(
                              Number_Of_Fixed_Datums    => 1,
                              Number_Of_Variable_Datums => 1);
   Dope_Message           : DIS_Types.A_MESSAGE_PDU(
                              Number_Of_Variable_Datums => 1);
   Dope_Emission          : DIS_Types.AN_EMISSION_PDU(
                              Total_System_Length => 1);
   Dope_Transmitter       : DIS_Types.A_TRANSMITTER_PDU(
                              Antenna_Pattern_Length     => 1,
                              Length_Of_Modulation_Parms => 1);
   Dope_Signal            : DIS_Types.A_SIGNAL_PDU(
                              Length => 1);
   Dope_Resupply_Received : DIS_Types.A_RESUPPLY_RECEIVED_PDU(
                              Number_Of_Supply_Types => 1);

   --
   --
   --

   type DOPE_VECTOR_INFO_TYPE is
     record
       Static_Start  : INTEGER;
       Dope_Start    : INTEGER;
       Variant_Start : INTEGER;
     end record;

   type DOPE_VECTOR_ARRAY_TYPE is
     array (DIS_Types.A_PDU_KIND) of DOPE_VECTOR_INFO_TYPE;

   Offset : DOPE_VECTOR_ARRAY_TYPE := (
              DIS_Types.OTHER_PDU => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.ENTITY_STATE => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Entity_State.Capabilities'ADDRESS
                                   - Dope_Entity_State'ADDRESS)
                                   + ((Dope_Entity_State.Capabilities'SIZE
                                       + 7) / 8),
                Variant_Start => (Dope_Entity_State.Articulation_Parms'ADDRESS
                                   - Dope_Entity_State'ADDRESS)),
              DIS_Types.FIRE => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.DETONATION => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Detonation.Padding'ADDRESS
                                   - Dope_Detonation'ADDRESS)
                                     + ((Dope_Detonation.Padding'SIZE
                                       + 7) / 8),
                Variant_Start => (Dope_Detonation.Articulation_Parms'ADDRESS
                                   - Dope_Detonation'ADDRESS)),
              DIS_Types.COLLISION => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.SERVICE_REQUEST => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Service_Request.Padding'ADDRESS
                                   - Dope_Service_Request'ADDRESS)
                                     + ((Dope_Service_Request.Padding'SIZE
                                       + 7) / 8),
                Variant_Start => (Dope_Service_Request.Supplies'ADDRESS
                                   - Dope_Service_Request'ADDRESS)),
              DIS_Types.RESUPPLY_OFFER => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Resupply_Offer.Padding'ADDRESS
                                   - Dope_Resupply_Offer'ADDRESS)
                                     + ((Dope_Resupply_Offer.Padding'SIZE
                                       + 7) / 8),
                Variant_Start => (Dope_Resupply_Offer.Supplies'ADDRESS
                                   - Dope_Resupply_Offer'ADDRESS)),
              DIS_Types.RESUPPLY_RECEIVED => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Resupply_Received.Padding'ADDRESS
                                   - Dope_Resupply_Received'ADDRESS)
                                     + ((Dope_Resupply_Received.Padding'SIZE
                                       + 7) / 8),
                Variant_Start => (Dope_Resupply_Received.Supplies'ADDRESS
                                   - Dope_Resupply_Received'ADDRESS)),
              DIS_Types.RESUPPLY_CANCEL => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.REPAIR_COMPLETE => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.REPAIR_RESPONSE => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.CREATE_ENTITY => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.REMOVE_ENTITY => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.START_OR_RESUME => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.STOP_OR_FREEZE => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.ACKNOWLEDGE => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.ACTION_REQUEST => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Action_Request.
                                   Number_Of_Variable_Datums'ADDRESS
                                     - Dope_Action_Request'ADDRESS)
                                       + ((Dope_Action_Request.
                                         Number_Of_Variable_Datums'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Action_Request.Fixed_Datum'ADDRESS
                                   - Dope_Action_Request'ADDRESS)),
              DIS_Types.ACTION_RESPONSE => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Action_Response.
                                   Number_Of_Variable_Datums'ADDRESS
                                     - Dope_Action_Response'ADDRESS)
                                       + ((Dope_Action_Response.
                                         Number_Of_Variable_Datums'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Action_Response.Fixed_Datum'ADDRESS
                                   - Dope_Action_Response'ADDRESS)),
              DIS_Types.DATA_QUERY => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Data_Query.
                                   Number_Of_Variable_Datums'ADDRESS
                                     - Dope_Data_Query'ADDRESS)
                                       + ((Dope_Data_Query.
                                         Number_Of_Variable_Datums'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Data_Query.Fixed_Datum'ADDRESS
                                   - Dope_Data_Query'ADDRESS)),
              DIS_Types.SET_DATA => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Set_Data.
                                   Number_Of_Variable_Datums'ADDRESS
                                     - Dope_Set_Data'ADDRESS)
                                       + ((Dope_Set_Data.
                                         Number_Of_Variable_Datums'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Set_Data.Fixed_Datum'ADDRESS
                                   - Dope_Set_Data'ADDRESS)),
              DIS_Types.DATA => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Data.
                                   Number_Of_Variable_Datums'ADDRESS
                                     - Dope_Data'ADDRESS)
                                       + ((Dope_Data.
                                         Number_Of_Variable_Datums'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Data.Fixed_Datum'ADDRESS
                                   - Dope_Data'ADDRESS)),
              DIS_Types.EVENT_REPORT => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Event_Report.
                                   Number_Of_Variable_Datums'ADDRESS
                                     - Dope_Event_Report'ADDRESS)
                                       + ((Dope_Event_Report.
                                         Number_Of_Variable_Datums'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Event_Report.Fixed_Datum'ADDRESS
                                   - Dope_Event_Report'ADDRESS)),
              DIS_Types.MESSAGE => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Message.
                                   Number_Of_Variable_Datums'ADDRESS
                                     - Dope_Message'ADDRESS)
                                       + ((Dope_Message.
                                         Number_Of_Variable_Datums'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Message.Variable_Datum'ADDRESS
                                   - Dope_Message'ADDRESS)),
              DIS_Types.EMISSION => (
                Static_Start  => (Dope_Emission.Total_System_Length'ADDRESS
                                   - Dope_Emission'ADDRESS)
                                     + ((Dope_Emission.
                                       Total_System_Length'SIZE + 7) / 8),
                Dope_Start    => (Dope_Emission.Padding'ADDRESS
                                   - Dope_Emission'ADDRESS)
                                     + ((Dope_Emission.Padding'SIZE + 7) / 8),
                Variant_Start => (Dope_Emission.System_Data'ADDRESS
                                   - Dope_Emission'ADDRESS)),
              DIS_Types.LASER => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0),
              DIS_Types.TRANSMITTER => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Transmitter.Padding'ADDRESS
                                     - Dope_Transmitter'ADDRESS)
                                       + ((Dope_Transmitter.Padding'SIZE
                                           + 7) / 8),
                Variant_Start => (Dope_Transmitter.
                                   Modulation_Parameters'ADDRESS
                                   - Dope_Transmitter'ADDRESS)),
              DIS_Types.SIGNAL => (
                Static_Start  => 0,
                Dope_Start    => (Dope_Signal.Length'ADDRESS
                                     - Dope_Signal'ADDRESS)
                                       + ((Dope_Signal.Length'SIZE + 7) / 8),
                Variant_Start => (Dope_Signal.Samples'ADDRESS
                                   - Dope_Signal'ADDRESS)),
              DIS_Types.RECEIVER => (
                Static_Start  => 0,
                Dope_Start    => 0,
                Variant_Start => 0));

end DG_Verdix_Dope_Vector;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
