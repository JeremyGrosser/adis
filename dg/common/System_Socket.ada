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
-- PACKAGE NAME     : System_Socket
--
-- FILE NAME        : System_Socket.ada
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

package body System_Socket is

   ---------------------------------------------------------------------------
   -- HToNL
   ---------------------------------------------------------------------------

   function HToNL(
      HostLong : in INTEGER)
     return INTEGER is
   begin
     return (HostLong);
   end HToNL;

   function HToNL(
      HostLong : in Numeric_Types.UNSIGNED_32_BIT)
     return Numeric_Types.UNSIGNED_32_BIT is
   begin
     return (HostLong);
   end HToNL;

   ---------------------------------------------------------------------------
   -- HToNS
   ---------------------------------------------------------------------------
   -- Note:  Based on BIGENDIAN definitions in <sys/endian.h>
   ---------------------------------------------------------------------------

   function HToNS(
      HostShort : in SHORT_INTEGER)
     return SHORT_INTEGER is
   begin
      return (HostShort);
   end HToNS;

   function HToNS(
      HostShort : in Numeric_Types.UNSIGNED_16_BIT)
     return Numeric_Types.UNSIGNED_16_BIT is
   begin
      return (HostShort);
   end HToNS;

   ---------------------------------------------------------------------------
   -- NToHL
   ---------------------------------------------------------------------------
   -- Note:  Based on BIGENDIAN definitions in <sys/endian.h>
   ---------------------------------------------------------------------------

   function NToHL(
      NetLong : in INTEGER)
     return INTEGER is
   begin
      return (NetLong);
   end NToHL;

   function NToHL(
      NetLong : in Numeric_Types.UNSIGNED_32_BIT)
     return Numeric_Types.UNSIGNED_32_BIT is
   begin
      return (NetLong);
   end NToHL;

   ---------------------------------------------------------------------------
   -- NToHS
   ---------------------------------------------------------------------------
   -- Note:  Based on BIGENDIAN definitions in <sys/endian.h>
   ---------------------------------------------------------------------------

   function NToHS(
      NetShort : in SHORT_INTEGER)
     return SHORT_INTEGER is
   begin
      return (NetShort);
   end NToHS;

   function NToHS(
      NetShort : in Numeric_Types.UNSIGNED_16_BIT)
     return Numeric_Types.UNSIGNED_16_BIT is
   begin
      return (NetShort);
   end NToHS;

end System_Socket;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
