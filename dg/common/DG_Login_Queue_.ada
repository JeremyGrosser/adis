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
-- PACKAGE NAME     : DG_Login_Queue
--
-- FILE NAME        : DG_Login_Queue_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 26, 1994
--
-- PURPOSE:
--   - Defines types and routines to permit DG Clients to log into the DG
--     Server.
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

with DG_GUI_Interface_Types,
     DG_Status,
     Numeric_Types;

package DG_Login_Queue is

   ---------------------------------------------------------------------------
   -- Define types for exchanging Client and Server information.
   ---------------------------------------------------------------------------

   type INTERFACE_INFORMATION_TYPE is
     record
       Maximum_Entities      : INTEGER;
       Maximum_Articulations : Numeric_Types.UNSIGNED_8_BIT;
       PDU_Buffer_Size       : INTEGER;
     end record;

   type CLIENT_INFO_TYPE is
     record
       Client_ID            : INTEGER;
       Client_Interface_Key : INTEGER;
       Client_Semaphore_Key : INTEGER;
       Login_Flag           : BOOLEAN;  -- TRUE for logins, FALSE for logouts
       Interface_Info       : DG_GUI_Interface_Types.
                                SIMULATION_DATA_PARAMETERS_TYPE;
     end record;

   type SERVER_INFO_TYPE is
     record
       Server_ID      : INTEGER;
       Permit_Login   : BOOLEAN;
       Interface_Info : DG_GUI_Interface_Types.
                          SIMULATION_DATA_PARAMETERS_TYPE;
     end record;

   ---------------------------------------------------------------------------
   -- Create_Login_Queue
   ---------------------------------------------------------------------------
   -- Purpose:     Establishes the DG Server's login message queue.
   -- Exceptions:  None.
   ---------------------------------------------------------------------------
   procedure Create_Login_Queue(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Client_Login
   ---------------------------------------------------------------------------
   -- Purpose:     Returns a flag (Login_Present), indicating if a client is
   --              attempting to log into the server.  If Login_Present is
   --              TRUE, then Client_Info will contain information for the
   --              new client.
   -- Exceptions:  None.
   ---------------------------------------------------------------------------
   procedure Get_Client_Login(
      Login_Present : out BOOLEAN;
      Client_Info   : out CLIENT_INFO_TYPE;
      Status        : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Send_Server_Info
   ---------------------------------------------------------------------------
   -- Purpose:     Sends information from the DG Server to the DG Client with
   --              the identifier of Client_ID.  This identifier is contained
   --              in the Client_Info record returned by the Get_Client_Login
   --              procedure.
   -- Exceptions:  None.
   ---------------------------------------------------------------------------
   procedure Send_Server_Info(
      Server_Info : in     SERVER_INFO_TYPE;
      Client_ID   : in     INTEGER;
      Status      :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Remove_Login_Queue
   ---------------------------------------------------------------------------
   -- Purpose:     Removes the DG Server's login message queue.  Any pending
   --              requests are discarded.
   -- Exceptions:  None.
   ---------------------------------------------------------------------------
   procedure Remove_Login_Queue(
      Status : out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Client_Login
   ---------------------------------------------------------------------------
   -- Purpose:     Informs server of client's presence, and obtains
   --              information from the server.
   -- Exceptions:  None.
   ---------------------------------------------------------------------------
   procedure Client_Login(
      Client_Info : in     CLIENT_INFO_TYPE;
      Server_Info :    out SERVER_INFO_TYPE;
      Status      :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Client_Logout
   ---------------------------------------------------------------------------
   -- Purpose:     Informs server that the client is logging out.
   -- Exceptions:  None.
   ---------------------------------------------------------------------------
   procedure Client_Logout(
      Status : out DG_Status.STATUS_TYPE);

end DG_Login_Queue;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
