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
-- UNIT NAME        : DG_Network_Interface_Support.Establish_Network_Interface
--
-- FILE NAME        : DG_NIS_Establish_Network_Interface.ada
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

with Unix;

separate (DG_Network_Interface_Support)

procedure Establish_Network_Interface(
   UDP_Port          : in     Numeric_Types.UNSIGNED_16_BIT;
   Broadcast_Address : in     STRING;
   Status            :    out DG_Status.STATUS_TYPE) is

   Broadcast_Val   : INTEGER;
   Socket_Status   : INTEGER;
   Source_SockAddr : System_Socket.SOCKADDR(System_Socket.AF_INET);

   LOCAL_FAILURE : EXCEPTION;

begin  -- Establish_Network_Interface

   Status := DG_Status.SUCCESS;

   --
   -- Set up socket source address information
   --

   Source_SockAddr.SIN_Addr.S_Addr
     := System_Socket.HToNL(System_Socket.INADDR_ANY);

   Source_SockAddr.SIN_Port := UDP_Port;

   --
   -- Obtain a socket ID
   --

   Socket_ID
     := System_Socket.Socket(
          Domain      => System_Socket.AF_INET,
          Socket_Type => System_Socket.SOCK_DGRAM,
          Protocol    => 0);

   if (Socket_ID = -1) then
      Status := DG_Status.NIS_ENI_SOCKET_FAILURE;
      raise LOCAL_FAILURE;
   end if;

   --
   -- Enable broadcasting on the socket
   --

   Broadcast_Val := 1;

   Socket_Status
     := System_Socket.SetSockOpt(
          S       => Socket_ID,
          Level   => System_Socket.SOL_SOCKET,
          OptName => System_Socket.SO_BROADCAST,
          OptVal  => Broadcast_Val'ADDRESS,
          OptLen  => Broadcast_Val'SIZE/8);

   if (Socket_Status = -1) then
      Status := DG_Status.NIS_ENI_SETSOCKOPT_FAILURE;
      raise LOCAL_FAILURE;
   end if;

   --
   -- Enable non-blocking I/O on the socket
   --
   Socket_Status
     := System_Socket.FCntl(
          FilDes  => Socket_ID,
          Cmd     => System_Socket.F_SETFL,
          Arg     => System_Socket.FNDELAY);

   if (Socket_Status = -1) then
      Status := DG_Status.NIS_ENI_FCNTL_SETFL_FAILURE;
      raise LOCAL_FAILURE;
   end if;

   --
   -- Bind the socket to the source address and port
   --

   Socket_Status
     := System_Socket.Bind(
          S       => Socket_ID,
          Name    => Source_SockAddr'ADDRESS,
          NameLen => Source_SockAddr'SIZE/8);

   if (Socket_Status = -1) then
      Status := DG_Status.NIS_ENI_BIND_FAILURE;
      raise LOCAL_FAILURE;
   end if;

   --
   -- Set up broadcast address for use in Transmit_PDU
   --

   Broadcast_SockAddr.SIN_Addr.S_Addr
     := System_Socket.HToNL(
          System_Socket.INet_Addr(
            System_Socket.Convert_String_To_C(
              Broadcast_Address)));

   Broadcast_SockAddr.SIN_Port := UDP_Port;

exception

   when LOCAL_FAILURE =>

      null;  -- Status was set at the point of the failure

   when OTHERS =>

      Status := DG_Status.NIS_ENI_FAILURE;

end Establish_Network_Interface;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
