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
-- FILE NAME        : DG_Network_Interface_Support_.ada
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

with DG_Generic_PDU,
     DG_Server_GUI,
     DG_Status,
     Numeric_Types,
     System;

package DG_Network_Interface_Support is

   --
   -- String to hold addresses of the general form aaa.bbb.ccc.ddd
   --
   subtype IP_STRING_TYPE is STRING(1..15);

   ---------------------------------------------------------------------------
   -- Create_IP_Address_String
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Create_IP_Address_String(
      IP_Address : in     DG_Server_GUI.IP_DOT_ADDRESS_TYPE;
      IP_String  :    out IP_STRING_TYPE;
      IP_Length  :    out INTEGER;
      Status     :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Establish_Network_Interface
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Establish_Network_Interface(
      UDP_Port          : in     Numeric_Types.UNSIGNED_16_BIT;
      Broadcast_Address : in     STRING;
      Status            :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Terminate_Network_Interface
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Terminate_Network_Interface(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Receive_PDU
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Receive_PDU(
      PDU_Ptr : out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
      Status  : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Transmit_PDU
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Transmit_PDU(
      PDU    : in     System.ADDRESS;
      Status :    out DG_Status.STATUS_TYPE);

end DG_Network_Interface_Support;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
