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
-- UNIT NAME        : DG_Network_Interface_Support.Receive_PDU
--
-- FILE NAME        : DG_NIS_Receive_PDU.ada
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

with DG_Filter_PDU,
     DG_Host_Specific,
     DG_Server_Error_Processing,
     DG_Server_GUI,
     System_Errno;

separate (DG_Network_Interface_Support)

procedure Receive_PDU(
   PDU_Ptr : out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Status  : out DG_Status.STATUS_TYPE) is

   IP_Broadcast : IP_STRING_TYPE;
   IP_Length    : INTEGER;
   Local_Status : DG_Status.STATUS_TYPE;

   function "="(Left, Right : Numeric_Types.UNSIGNED_32_BIT)
     return BOOLEAN
       renames Numeric_Types."=";

begin  -- Receive_PDU

   PDU_Ptr := NULL;
   Status  := DG_Status.SUCCESS;

   Get_Next_PDU:
   loop

      From_Addr_Len := (From_Addr'SIZE+7)/8;

      PDU_Length
        := System_Socket.RecvFrom(
             S       => Socket_ID,
             Buf     => PDU_Data'ADDRESS,
             Len     => PDU_Data'SIZE/8,
             From    => From_Addr'ADDRESS,
             FromLen => From_Addr_Len'ADDRESS);

      if (PDU_Length = -1) then

         --
         -- If PDU_Length = -1 but Errno is set to EWOULDBLOCK, then no
         -- error has actually occurred.  This combination indicates that
         -- there is simply no data available to read from the socket.
         --
         if (System_Errno.Errno /= System_Socket.EWOULDBLOCK) then

            Status := DG_Status.NIS_RCVPDU_RECVFROM_FAILURE;

            Terminate_Network_Interface(
              Status => Local_Status);

            if (DG_Status.Failure(Local_Status)) then
               DG_Server_Error_Processing.Report_Error(
                 DG_Status.DG_PLACEHOLDER_ERROR);
            end if;

            Create_IP_Address_String(
               IP_Address => DG_Server_GUI.Interface.Network_Parameters.
                               Broadcast_IP_Address,
               IP_String  => IP_Broadcast,
               IP_Length  => IP_Length,
               Status     => Local_Status);

            if (DG_Status.Failure(Local_Status)) then
               DG_Server_Error_Processing.Report_Error(
                 DG_Status.DG_PLACEHOLDER_ERROR);
            end if;

            Establish_Network_Interface(
              UDP_Port          => DG_Server_GUI.Interface.Network_Parameters.
                                     UDP_Port,
              Broadcast_Address => IP_Broadcast(1..IP_Length),
              Status            => Local_Status);

            if (DG_Status.Failure(Local_Status)) then
               DG_Server_Error_Processing.Report_Error(
                 DG_Status.DG_PLACEHOLDER_ERROR);
            end if;

         end if;

         --
         -- Either the socket queue is empty, or an error was encountered.
         -- In either case, exit the loop.
         --
         exit Get_Next_PDU;

      elsif (not DG_Server_GUI.Interface.Network_Parameters.
        Data_Reception_Enabled) then

         null;  -- Discard the PDU and continue processing

      else

         --
         -- Create a pointer-based copy of the PDU
         --

         Local_PDU_Ptr
           := new DG_Generic_PDU.GENERIC_PDU_TYPE(
                    1..INTEGER(PDU_Header.Length));

         Local_PDU_Ptr.ALL := PDU_Data(1..INTEGER(PDU_Header.Length));

         --
         -- Perform any required network/host data conversions
         --

         DG_Host_Specific.Translate_Net_To_Host(
           PDU    => Local_PDU_Ptr,
           Status => Local_Status);

         if (DG_Status.Failure(Local_Status)) then
            Status := Local_Status;
            exit Get_Next_PDU;
         end if;

         --
         -- Check if the received PDU is desired
         --

         DG_Filter_PDU(
           PDU_Ptr => Local_PDU_Ptr,
           Keep    => Keep_PDU,
           Status  => Local_Status);

         if (DG_Status.Failure(Local_Status)) then

            Status := Local_Status;

            exit Get_Next_PDU;

         elsif (Keep_PDU) then

            PDU_Ptr := Local_PDU_Ptr;

            exit Get_Next_PDU;

         end if;

      end if;

   end loop Get_Next_PDU;

exception

   when STORAGE_ERROR =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

   when OTHERS =>

      Status := DG_Status.NIS_RCVPDU_FAILURE;

end Receive_PDU;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
