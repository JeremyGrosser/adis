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
-- UNIT NAME        : DG_Network_Interface_Support.Create_IP_Address_String
--
-- FILE NAME        : DG_NIS_Create_IP_Address_String.ada
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

separate (DG_Network_Interface_Support)

procedure Create_IP_Address_String(
   IP_Address : in     DG_Server_GUI.IP_DOT_ADDRESS_TYPE;
   IP_String  :    out IP_STRING_TYPE;
   IP_Length  :    out INTEGER;
   Status     :    out DG_Status.STATUS_TYPE) is

   IP_Addr_1   : constant STRING := Numeric_Types.UNSIGNED_8_BIT'IMAGE(IP_Address(1));
   IP_Addr_2   : constant STRING := Numeric_Types.UNSIGNED_8_BIT'IMAGE(IP_Address(2));
   IP_Addr_3   : constant STRING := Numeric_Types.UNSIGNED_8_BIT'IMAGE(IP_Address(3));
   IP_Addr_4   : constant STRING := Numeric_Types.UNSIGNED_8_BIT'IMAGE(IP_Address(4));

   Addr_String : constant STRING
                   := IP_Addr_1(IP_Addr_1'FIRST+1..IP_Addr_1'LAST) & "."
                      & IP_Addr_2(IP_Addr_2'FIRST+1..IP_Addr_2'LAST) & "."
                      & IP_Addr_3(IP_Addr_3'FIRST+1..IP_Addr_3'LAST) & "."
                      & IP_Addr_4(IP_Addr_4'FIRST+1..IP_Addr_4'LAST);

begin  -- Create_IP_Address_String

   Status := DG_Status.SUCCESS;

   IP_Length := Addr_String'LENGTH;

   IP_String(1..Addr_String'LENGTH) := Addr_String;

exception

   when OTHERS =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

end Create_IP_Address_String;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
