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
-- PACKAGE NAME     : DG_Network_Interface_Support
--
-- FILE NAME        : DG_Network_Interface_Support.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 17, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Generic_PDU,
     DIS_Types,
     Generic_Linked_List,
     System_Socket;

package body DG_Network_Interface_Support is

   --
   -- Network Socket ID
   --
   Socket_ID : INTEGER;

   --
   -- Network broadcast address
   --
   Broadcast_SockAddr : System_Socket.SOCKADDR(System_Socket.AF_INET);

   --
   -- Parameters and equality rename for Receive_PDU.  These are declared here
   -- to avoid spending time allocating local variables in the Receive_PDU
   -- routine.
   --

   From_Addr     : System_Socket.SOCKADDR(System_Socket.AF_INET);
   From_Addr_Len : INTEGER;
   Keep_PDU      : BOOLEAN;
   Local_PDU_Ptr : DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Local_Status  : DG_Status.STATUS_TYPE;
   PDU_Data      : DG_Generic_PDU.GENERIC_PDU_TYPE(1..48*1024);
   PDU_Length    : INTEGER;
   PDU_Header    : DIS_Types.A_PDU_HEADER;
                     for PDU_Header use at PDU_Data'ADDRESS;

   function "="(Left, Right : System_Socket.SOCKADDR)
     return BOOLEAN
       renames System_Socket."=";

   ---------------------------------------------------------------------------
   -- Create_IP_Address_String
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Create_IP_Address_String(
      IP_Address : in     DG_Server_GUI.IP_DOT_ADDRESS_TYPE;
      IP_String  :    out IP_STRING_TYPE;
      IP_Length  :    out INTEGER;
      Status     :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Establish_Network_Interface
   ---------------------------------------------------------------------------

   procedure Establish_Network_Interface(
      UDP_Port          : in     Numeric_Types.UNSIGNED_16_BIT;
      Broadcast_Address : in     STRING;
      Status            :    out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Terminate_Network_Interface
   ---------------------------------------------------------------------------

   procedure Terminate_Network_Interface(
      Status : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Receive_PDU
   ---------------------------------------------------------------------------

   procedure Receive_PDU(
      PDU_Ptr : out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Status  : out DG_Status.STATUS_TYPE)
     is separate;

   ---------------------------------------------------------------------------
   -- Transmit_PDU
   ---------------------------------------------------------------------------

   procedure Transmit_PDU(
      PDU    : in     System.ADDRESS;
      Status :    out DG_Status.STATUS_TYPE)
     is separate;

end DG_Network_Interface_Support;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
