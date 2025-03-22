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
-- PACKAGE NAME     : 
--
-- FILE NAME        : 
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June dd, 1994
--
-- PURPOSE:
--   - This package defines types and routines for defining and manipulating
--     a generic PDU.
--
-- EFFECTS:
--   - The expected usage is:
--     1. 
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

with DIS_PDU_Pointer_Types,
     DIS_Types,
     Numeric_Types,
     System,
     Unchecked_Conversion,
     Unchecked_Deallocation;

package DG_Generic_PDU is

   --
   -- Generic PDU type, access type, and deallocator
   --
   type GENERIC_PDU_TYPE is
     array (INTEGER range <>) of Numeric_Types.UNSIGNED_8_BIT;

   type GENERIC_PDU_POINTER_TYPE is
     access GENERIC_PDU_TYPE;

   procedure Free_Generic_PDU is
     new Unchecked_Deallocation(GENERIC_PDU_TYPE, GENERIC_PDU_POINTER_TYPE);

   --
   -- Define functions to check if a GENERIC_PDU_POINTER_TYPE is NULL or if
   -- it is valid (i.e., non-NULL).
   --
   function Null_Generic_PDU_Ptr(
      Ptr : in GENERIC_PDU_POINTER_TYPE)
     return BOOLEAN;

   function Valid_Generic_PDU_Ptr(
      Ptr : in GENERIC_PDU_POINTER_TYPE)
     return BOOLEAN;

   --
   -- Type and conversion function to access the PDU header of a generic PDU.
   --
   type PDU_HEADER_PTR is access DIS_Types.A_PDU_HEADER;

   function Generic_Ptr_To_PDU_Header_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       PDU_HEADER_PTR);

   --
   -- Address to generic PDU pointer conversion
   --
   function Address_To_Generic_Ptr is
     new Unchecked_Conversion(
       System.ADDRESS,
       GENERIC_PDU_POINTER_TYPE);

   --
   -- PDU access type conversions
   --
   function Generic_Ptr_To_Entity_State_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR);

   function Generic_Ptr_To_Fire_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.FIRE_PDU_PTR);

   function Generic_Ptr_To_Detonation_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.DETONATION_PDU_PTR);

   function Generic_Ptr_To_Service_Request_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.SERVICE_REQUEST_PDU_PTR);

   function Generic_Ptr_To_Resupply_Offer_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.RESUPPLY_OFFER_PDU_PTR);

   function Generic_Ptr_To_Resupply_Received_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.RESUPPLY_RECEIVED_PDU_PTR);

   function Generic_Ptr_To_Resupply_Cancel_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.RESUPPLY_CANCEL_PDU_PTR);

   function Generic_Ptr_To_Repair_Complete_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.REPAIR_COMPLETE_PDU_PTR);

   function Generic_Ptr_To_Repair_Response_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.REPAIR_RESPONSE_PDU_PTR);

   function Generic_Ptr_To_Collision_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.COLLISION_PDU_PTR);

   function Generic_Ptr_To_Create_Entity_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.CREATE_ENTITY_PDU_PTR);

   function Generic_Ptr_To_Remove_Entity_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.REMOVE_ENTITY_PDU_PTR);

   function Generic_Ptr_To_Start_Resume_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.START_RESUME_PDU_PTR);

   function Generic_Ptr_To_Stop_Freeze_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.STOP_FREEZE_PDU_PTR);

   function Generic_Ptr_To_Acknowledge_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.ACKNOWLEDGE_PDU_PTR);

   function Generic_Ptr_To_Emission_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.EMISSION_PDU_PTR);

   function Generic_Ptr_To_Laser_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.LASER_PDU_PTR);

   function Generic_Ptr_To_Transmitter_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR);

   function Generic_Ptr_To_Receiver_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.RECEIVER_PDU_PTR);

   function Generic_Ptr_To_Action_Request_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.ACTION_REQUEST_PDU_PTR);

   function Generic_Ptr_To_Action_Response_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.ACTION_RESPONSE_PDU_PTR);

   function Generic_Ptr_To_Data_Query_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.DATA_QUERY_PDU_PTR);

   function Generic_Ptr_To_Set_Data_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.SET_DATA_PDU_PTR);

   function Generic_Ptr_To_Data_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.DATA_PDU_PTR);

   function Generic_Ptr_To_Event_Report_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.EVENT_REPORT_PDU_PTR);

   function Generic_Ptr_To_Message_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.MESSAGE_PDU_PTR);

   function Generic_Ptr_To_Signal_PDU_Ptr is
     new Unchecked_Conversion(
       GENERIC_PDU_POINTER_TYPE,
       DIS_PDU_Pointer_Types.SIGNAL_PDU_PTR);

end DG_Generic_PDU;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
