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
-- FILE NAME        : System_Socket_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 17, 1994
--
-- PURPOSE:
--   - This package defines the data types and provides an interface to the
--     system routines for performing socket I/O operations.
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

with C_Strings,
     Numeric_Types,
     System;

package System_Socket is

   --
   -- Define address family values.
   --
   -- Note:  Based on constants in <sys/socket.h>
   --
   AF_INET : constant := 2;

   --
   -- Define socket type values.
   --
   -- Note:  Based on constants in <sys/socket.h>
   --
   SOCK_DGRAM : constant := 1;

   --
   -- Define socket option level numbers
   --
   -- Note:  Based on constants in <sys/socket.h>
   --
   SOL_SOCKET : constant := 16#FFFF#;

   --
   -- Define socket option flags
   --
   -- Note:  Based on constants in <sys/socket.h>
   --
   SO_BROADCAST : constant := 16#0020#;
   SO_RCVBUF    : constant := 16#1002#;

   --
   -- Define type IN_ADDR.
   --
   -- Note:  Based on struct in_addr in <netinet/in.h>
   --
   type IN_ADDR is
     record
        S_Addr : Numeric_Types.UNSIGNED_32_BIT;
     end record;

   --
   -- Define the constant INADDR_ANY.
   --
   -- Note:  Based on constant in <netinet/in.h>
   --
   INADDR_ANY : constant := 0;

   --
   -- Define the constant INADDR_BROADCAST.
   --
   -- Note:  Based on constant in <netinet/in.h>
   --
   INADDR_BROADCAST : constant := 16#FFFFFFFF#;

   --
   -- Define type SOCKADDR.
   --
   -- Note:  Based on several different header files.  These are listed
   --        next to the corresponding record section.
   --
   type SOCKADDR(SA_Family : Numeric_Types.UNSIGNED_16_BIT) is
     record

        case SA_Family is

           when AF_INET =>  -- based on struct sockaddr_in in <netinet/in.h>

              SIN_Port : Numeric_Types.UNSIGNED_16_BIT := 0;
              SIN_Addr : IN_ADDR      := (S_Addr => 0);
              SIN_Zero : STRING(1..8) := (OTHERS => ASCII.NUL);

           when OTHERS =>   -- based on struct sockaddr in <sys/socket.h>

              SA_Data : STRING(1..14) := (OTHERS => ASCII.NUL);

        end case;

     end record;

   for SOCKADDR use
     record
       SA_Family at 0 range 0..15;
     end record;

   --
   -- Define constants for file control.
   --
   -- Note:  Based on constant in <sys/fcntl.h>
   --
   F_SETOWN   : constant := 24;
   F_SETFL    : constant := 4;
   FASYNC     : constant := 16#1000#;
   FNDELAY    : constant := 4;
   O_NONBLOCK : constant := 16#0080#;

   --
   -- Define constant for EWOULDBLOCK
   --
   -- Note:  Based on constant in <sys/errno.h>
   --
   EWOULDBLOCK : constant := 11;

   ---------------------------------------------------------------------------
   -- HToNL
   ---------------------------------------------------------------------------
   -- Purpose: Converts long (four-byte) values from host byte order to
   --          network byte order.
   --
   -- Note   : This is implemented as a macro, not a library/system routine
   --          under IRIX.
   ---------------------------------------------------------------------------

   function HToNL(
      HostLong : in INTEGER)
     return INTEGER;

   function HToNL(
      HostLong : in Numeric_Types.UNSIGNED_32_BIT)
     return Numeric_Types.UNSIGNED_32_BIT;

   ---------------------------------------------------------------------------
   -- HToNS
   ---------------------------------------------------------------------------
   -- Purpose: Converts short (two-byte) values from host byte order to
   --          network byte order.
   --
   -- Note   : This is implemented as a macro, not a library/system routine
   --          under IRIX.
   ---------------------------------------------------------------------------

   function HToNS(
      HostShort : in SHORT_INTEGER)
     return SHORT_INTEGER;

   function HToNS(
      HostShort : in Numeric_Types.UNSIGNED_16_BIT)
     return Numeric_Types.UNSIGNED_16_BIT;

   ---------------------------------------------------------------------------
   -- NToHL
   ---------------------------------------------------------------------------
   -- Purpose: Converts long (four-byte) values from network byte order to
   --          host byte order.
   --
   -- Note   : This is implemented as a macro, not a library/system routine
   --          under IRIX.
   ---------------------------------------------------------------------------

   function NToHL(
      NetLong : in INTEGER)
     return INTEGER;

   function NToHL(
      NetLong : in Numeric_Types.UNSIGNED_32_BIT)
     return Numeric_Types.UNSIGNED_32_BIT;

   ---------------------------------------------------------------------------
   -- NToHS
   ---------------------------------------------------------------------------
   -- Purpose: Converts short (two-byte) values from network byte order to
   --          host byte order.
   --
   -- Note   : This is implemented as a macro, not a library/system routine
   --          under IRIX.
   ---------------------------------------------------------------------------

   function NToHS(
      NetShort : in SHORT_INTEGER)
     return SHORT_INTEGER;

   function NToHS(
      NetShort : in Numeric_Types.UNSIGNED_16_BIT)
     return Numeric_Types.UNSIGNED_16_BIT;

   ---------------------------------------------------------------------------
   -- Socket
   ---------------------------------------------------------------------------
   -- Purpose: Create an endpoint for communication
   ---------------------------------------------------------------------------

   function Socket(
      Domain      : in INTEGER;
      Socket_Type : in INTEGER;
      Protocol    : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, Socket);

   ---------------------------------------------------------------------------
   -- SetSockOpt
   ---------------------------------------------------------------------------
   -- Purpose: Set options on sockets
   ---------------------------------------------------------------------------

   function SetSockOpt(
      S       : in INTEGER;
      Level   : in INTEGER;
      OptName : in INTEGER;
      OptVal  : in System.ADDRESS;
      OptLen  : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, SetSockOpt);

   ---------------------------------------------------------------------------
   -- GetSockOpt
   ---------------------------------------------------------------------------
   -- Purpose: Get options from sockets
   ---------------------------------------------------------------------------

   function GetSockOpt(
      S       : in INTEGER;
      Level   : in INTEGER;
      OptName : in INTEGER;
      OptVal  : in System.ADDRESS;
      OptLen  : in System.ADDRESS)  -- INTEGER'ADDRESS
     return INTEGER;

   pragma INTERFACE(C, GetSockOpt);

   ---------------------------------------------------------------------------
   -- Bind
   ---------------------------------------------------------------------------
   -- Purpose: Bind a name to a socket
   ---------------------------------------------------------------------------

   function Bind(
      S       : in INTEGER;
      Name    : in System.ADDRESS;  -- SOCKADDR'ADDR
      NameLen : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, Bind);

   ---------------------------------------------------------------------------
   -- Send
   ---------------------------------------------------------------------------
   -- Purpose: Send a message from a connected socket
   ---------------------------------------------------------------------------

   function Send(
      S     : in INTEGER;
      Msg   : in System.ADDRESS;
      Len   : in INTEGER;
      Flags : in INTEGER := 0)
     return INTEGER;

   pragma INTERFACE(C, Send);

   ---------------------------------------------------------------------------
   -- SendTo
   ---------------------------------------------------------------------------
   -- Purpose: Send a message from an unconnected socket
   ---------------------------------------------------------------------------

   function SendTo(
      S     : in INTEGER;
      Msg   : in System.ADDRESS;
      Len   : in INTEGER;
      Flags : in INTEGER := 0;
      To    : in System.ADDRESS;  -- SOCKADDR'ADDRESS
      ToLen : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, SendTo);

   ---------------------------------------------------------------------------
   -- Recv
   ---------------------------------------------------------------------------
   -- Purpose: Receive a message from a connected socket
   ---------------------------------------------------------------------------

   function Recv(
      S        : in INTEGER;
      Buf      : in System.ADDRESS;
      Len      : in INTEGER;
      Flags    : in INTEGER := 0)
     return INTEGER;

   pragma INTERFACE(C, Recv);

   ---------------------------------------------------------------------------
   -- RecvFrom
   ---------------------------------------------------------------------------
   -- Purpose: Receive a message from a socket
   ---------------------------------------------------------------------------

   function RecvFrom(
      S        : in INTEGER;
      Buf      : in System.ADDRESS;
      Len      : in INTEGER;
      Flags    : in INTEGER := 0;
      From     : in System.ADDRESS := System.NO_ADDR;  -- SOCKADDR'ADDRESS
      FromLen  : in System.ADDRESS := System.NO_ADDR)  -- INTEGER'ADDRESS
     return INTEGER;

   pragma INTERFACE(C, RecvFrom);

   ---------------------------------------------------------------------------
   -- IOCtl
   ---------------------------------------------------------------------------
   -- Purpose: Control device
   ---------------------------------------------------------------------------

   function IOCtl(
      FilDes  : in INTEGER;
      Request : in INTEGER;
      Arg     : in System.ADDRESS)
     return INTEGER;

   pragma INTERFACE(C, IOCtl);

   ---------------------------------------------------------------------------
   -- FCntl
   ---------------------------------------------------------------------------
   -- Purpose: File and descriptor control
   ---------------------------------------------------------------------------

   function FCntl(
      FilDes : in INTEGER;
      Cmd    : in INTEGER;
      Arg    : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, FCntl);

   ---------------------------------------------------------------------------
   -- Connect
   ---------------------------------------------------------------------------
   -- Purpose: Initiate a connection on a socket
   ---------------------------------------------------------------------------

   function Connect(
      S       : in INTEGER;
      Name    : in System.ADDRESS; -- SOCKADDR'ADDRESS
      NameLen : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, Connect);

   ---------------------------------------------------------------------------
   -- Close
   ---------------------------------------------------------------------------
   -- Purpose: Closes a file descriptor
   ---------------------------------------------------------------------------

   function Close(
      FilDes : in INTEGER)
     return INTEGER;

   pragma INTERFACE(C, Close);

   ---------------------------------------------------------------------------
   -- INet_Addr
   ---------------------------------------------------------------------------
   -- Purpose: Changes a "dot-notation" address to an Internet address.
   ---------------------------------------------------------------------------

   function INet_Addr(
      CP : in C_Strings.C_STRING)
     return Numeric_Types.UNSIGNED_32_BIT;

   pragma INTERFACE(C, Inet_Addr);

   function Convert_String_To_C(
      S : STRING)
     return C_Strings.C_STRING
       renames C_Strings.Convert_String_To_C;

end System_Socket;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
