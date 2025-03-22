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
-- UNIT NAME        : DG_Network_Interface_Support.Transmit_PDU
--
-- FILE NAME        : DG_NIS_Transmit_PDU.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 17, 1994
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
     DG_Host_Specific,
     DG_Server_GUI,
     DIS_Types,
     Get_Time_Stamp,
     System_Errno;

separate (DG_Network_Interface_Support)

procedure Transmit_PDU(
   PDU    : in     System.ADDRESS;
   Status :    out DG_Status.STATUS_TYPE) is

   Local_Status : DG_Status.STATUS_TYPE;
   PDU_Header   : DIS_Types.A_PDU_HEADER;
     for PDU_Header use at PDU;

   Generic_PDU  : DG_Generic_PDU.GENERIC_PDU_TYPE(
                    1..INTEGER(PDU_Header.Length));
     for Generic_PDU use at PDU;
   Generic_Ptr  : DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Send_Status  : INTEGER;

   LOCAL_FAILURE : EXCEPTION;

begin  -- Transmit_PDU

   Status := DG_Status.SUCCESS;

   --
   -- Only transmit if permitted
   --
   if (DG_Server_GUI.Interface.Network_Parameters.Data_Transmission_Enabled)
   then

      --
      -- Set timetag if this is enabled
      --
      if (DG_Server_GUI.Interface.Exercise_Parameters.Automatic_Timestamp)
      then

         PDU_Header.Time_Stamp := Get_Time_Stamp;

      end if;

      --
      -- Set exercise ID if this is enabled
      --
      if (DG_Server_GUI.Interface.Exercise_Parameters.Set_Exercise_ID) then

         PDU_Header.Exercise_ID
           := DG_Server_GUI.Interface.Exercise_Parameters.Exercise_ID;

      end if;

      --
      -- Set Site ID if this is enabled, and if the PDU contains a Site ID
      -- field.
      --
      if (DG_Server_GUI.Interface.Exercise_Parameters.Set_Site_ID) then

         case (PDU_Header.PDU_Type) is

            when DIS_Types.ENTITY_STATE =>

               DG_Generic_PDU.Generic_Ptr_To_Entity_State_PDU_Ptr(
                 DG_Generic_PDU.Address_To_Generic_Ptr(PDU)).Entity_ID.
                   Sim_Address.Site_ID
                     := DG_Server_GUI.Interface.Exercise_Parameters.Site_ID;

            when OTHERS =>

               null;

         end case;

      end if;

      --
      -- Perform any host/network conversions necessary
      --

      Generic_Ptr
        := new DG_Generic_PDU.GENERIC_PDU_TYPE(1..INTEGER(PDU_Header.Length));

      Generic_Ptr.ALL := Generic_PDU;

      DG_Host_Specific.Translate_Host_To_Net(
        PDU    => Generic_Ptr,
        Status => Local_Status);

      if (DG_Status.Failure(Local_Status)) then
         raise LOCAL_FAILURE;
      end if;

      --
      -- Set PDU length to size of translated data
      --
      DG_Generic_PDU.Generic_Ptr_To_PDU_Header_Ptr(Generic_Ptr).
        Length := Numeric_Types.UNSIGNED_16_BIT(Generic_Ptr.ALL'LENGTH);

      Send_Status
        := System_Socket.SendTo(
             S     => Socket_ID,
             Msg   => Generic_Ptr.ALL'ADDRESS,
             Len   => Generic_Ptr.ALL'LENGTH,
             To    => Broadcast_SockAddr'ADDRESS,
             ToLen => Broadcast_SockAddr'SIZE/8);

      if (Send_Status = -1) then

         --
         -- If Send_Status = -1 but Errno is set to EWOULDBLOCK, then no
         -- error has actually occurred.  This combination indicates that
         -- there is simply no data available to read from the socket.
         --

         if (System_Errno.Errno /= System_Socket.EWOULDBLOCK) then

            Status := DG_Status.NIS_TXPDU_SENDTO_FAILURE;

         end if;

      end if;  -- (Send_Status = -1)

      DG_Generic_PDU.Free_Generic_PDU(Generic_Ptr);

   end if;  -- ( ...Data_Transmission_Enabled)

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.NIS_TXPDU_FAILURE;

end Transmit_PDU;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
