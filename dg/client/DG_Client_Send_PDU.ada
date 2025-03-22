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
-- UNIT NAME        : Send_PDU
--
-- FILE NAME        : Send_PDU.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June dd, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - 
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

with DG_Generic_PDU,
     DG_Simulation_Management,
     Unchecked_Conversion;

separate (DG_Client)

procedure Send_PDU(
   PDU_Address : in     System.ADDRESS;
   Status      :    out DG_Status.STATUS_TYPE) is

   Generic_Size : INTEGER;
   PDU_Header   : DG_Generic_PDU.PDU_HEADER_PTR
                    := DG_Generic_PDU.Generic_Ptr_To_PDU_Header_Ptr(
                         DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address));

begin  -- Send_PDU

   Status := DG_Status.SUCCESS;

   --
   -- Check if any automatic fields are enabled
   --
   if (DG_Client_GUI.Interface.Exercise_Parameters.Set_Application_ID) then

      --
      -- See if the PDU contains an Application ID field
      --
      case (PDU_Header.PDU_Type) is

         when DIS_Types.ENTITY_STATE =>

            DG_Generic_PDU.Generic_Ptr_To_Entity_State_PDU_Ptr(
              DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).Entity_ID.
                Sim_Address.Application_ID
                  := DG_Client_GUI.Interface.Exercise_Parameters.
                       Application_ID;

         when OTHERS =>

            null;  -- All other PDUs lack an Application ID field

      end case;  -- (PDU_Header.PDU_Type)

   end if;  -- (...Set_Application_ID)

   case (PDU_Header.PDU_Type) is

      when DIS_Types.ENTITY_STATE |
           DIS_Types.EMISSION     |
           DIS_Types.LASER        |
           DIS_Types.TRANSMITTER  |
           DIS_Types.RECEIVER     =>

         DG_Simulation_Management.Store_Simulation_Data(
           Generic_PDU     => DG_Generic_PDU.Address_To_Generic_Ptr(
                                PDU_Address),
           Simulation_Data => DG_Client_Interface.Interface.Simulation_Data,
           Status          => Status);

      when OTHERS =>

         --
         -- Verdix Ada adds a "dope vector" to variant types, varying from
         -- 16 to 18 bytes in length.  Because of this dope vector, the Length
         -- field of the PDU Header cannot be trusted to accurately represent
         -- the number of bytes used by the variant record itself.  In order
         -- to determine the number of bytes in the PDU, it is safest to
         -- create a temporary pointer of the correct PDU type, using the
         -- 'SIZE attribute to determine the byte count.
         --
         case (PDU_Header.PDU_Type) is

            when DIS_Types.ENTITY_STATE |
                 DIS_Types.EMISSION     |
                 DIS_Types.LASER        |
                 DIS_Types.TRANSMITTER  |
                 DIS_Types.RECEIVER     =>

               null;  -- These PDUs are handled in the outer case statement,
                      -- and will not be encountered in this case statement.

            when DIS_Types.DETONATION =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Detonation_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.SERVICE_REQUEST =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Service_Request_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.RESUPPLY_OFFER =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Resupply_Offer_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.RESUPPLY_RECEIVED =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Resupply_Received_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.ACTION_REQUEST =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Action_Request_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.ACTION_RESPONSE =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Action_Response_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.DATA_QUERY =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Data_Query_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.SET_DATA =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Set_Data_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.DATA =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Data_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.EVENT_REPORT =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Event_Report_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.MESSAGE =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Message_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.SIGNAL =>

               Generic_Size
                 := (DG_Generic_PDU.Generic_Ptr_To_Signal_PDU_Ptr(
                      DG_Generic_PDU.Address_To_Generic_Ptr(PDU_Address)).
                        ALL'SIZE+7)/8;

            when DIS_Types.OTHER_PDU       |
                 DIS_Types.FIRE            |
                 DIS_Types.RESUPPLY_CANCEL |
                 DIS_Types.REPAIR_COMPLETE |
                 DIS_Types.REPAIR_RESPONSE |
                 DIS_Types.COLLISION       |
                 DIS_Types.CREATE_ENTITY   |
                 DIS_Types.REMOVE_ENTITY   |
                 DIS_Types.START_OR_RESUME |
                 DIS_Types.STOP_OR_FREEZE  |
                 DIS_Types.ACKNOWLEDGE     =>

               --
               -- The remaining PDUs are non-variant, and do not have the
               -- Verdix Ada "dope vector" problem.  For these PDUs, the
               -- Length field can be used.
               --

               Generic_Size := INTEGER(PDU_Header.Length);

         end case;

         Send_Generic_PDU:
         declare

            Generic_PDU : DG_Generic_PDU.GENERIC_PDU_TYPE(1..Generic_Size);
              for Generic_PDU use at PDU_Address;

         begin  -- Send_Generic_PDU

            DG_PDU_Buffer.Add(
              PDU             => Generic_PDU,
              PDU_Buffer      => DG_Client_Interface.Interface.PDU_Buffer,
              PDU_Write_Index => DG_Client_Interface.Interface.
                                   Buffer_Write_Index,
              Status          => Status);

         end Send_Generic_PDU;

   end case;

exception

   when OTHERS =>

      Status := DG_Status.CLI_SEND_FAILURE;

end Send_PDU;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
