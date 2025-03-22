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
-- PACKAGE NAME     : DG_Client_Interface
--
-- FILE NAME        : DG_Client_Interface_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 25, 1994
--
-- PURPOSE:
--   - This package provides data types and routines to allocate, access, and
--     deallocate the DG Client shared memory inteface.
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
     DG_Interface_Types,
     DG_Status;

package DG_Client_Interface is
   --
   -- Define a type for the DG Server Interface.
   --

   type CLIENT_INTERFACE_TYPE(

     Maximum_Entities     : INTEGER;
     Maximum_Emitters     : INTEGER;
     Maximum_Lasers       : INTEGER;
     Maximum_Transmitters : INTEGER;
     Maximum_Receivers    : INTEGER;
     PDU_Buffer_Size      : INTEGER) is

   record

      Client_Online      : BOOLEAN;

      Client_Name        : DG_Interface_Types.CLIENT_NAME_TYPE;

      PDU_Buffer         : DG_Interface_Types.
                             PDU_BUFFER_TYPE(1..PDU_Buffer_Size);

      Buffer_Write_Index : INTEGER;

      Buffer_Read_Index  : INTEGER;

      Simulation_Data    : DG_Interface_Types.SIMULATION_DATA_TYPE(
                             Maximum_Entities     => Maximum_Entities,
                             Maximum_Emitters     => Maximum_Emitters,
                             Maximum_Lasers       => Maximum_Lasers,
                             Maximum_Transmitters => Maximum_Transmitters,
                             Maximum_Receivers    => Maximum_Receivers);

   end record;

   for CLIENT_INTERFACE_TYPE use
     record
       Maximum_Entities     at 0 range   0 ..  31;
       Maximum_Emitters     at 0 range  32 ..  63;
       Maximum_Lasers       at 0 range  64 ..  95;
       Maximum_Transmitters at 0 range  96 .. 127;
       Maximum_Receivers    at 0 range 128 .. 159;
       PDU_Buffer_Size      at 0 range 160 .. 191;
     end record;

   type CLIENT_INTERFACE_PTR_TYPE is access CLIENT_INTERFACE_TYPE;

   --
   -- Declare memory pointer variable.  This is only used by the DG Client --
   -- the DG Server must track multiple clients and therefore maintains its
   -- own set of client interface pointers.
   --
   Interface : CLIENT_INTERFACE_PTR_TYPE;

   ---------------------------------------------------------------------------
   -- Map_Interface
   ---------------------------------------------------------------------------
   --
   -- Purpose : Initializes access to the DG Client/Server shared memory
   --           interface.  If Create_Interface is TRUE, then a new shared
   --           memory area is created.  This should only be done once, and
   --           should only be done by the DG Client.  An unsuccessful status
   --           is returned if Create_Interface is FALSE and the shared memory
   --           area does not exist.
   --
   ---------------------------------------------------------------------------

   procedure Map_Interface(
      Create_Interface      : in     BOOLEAN;
      Simulation_Parameters : in     DG_GUI_Interface_Types.
                                       SIMULATION_DATA_PARAMETERS_TYPE;
      Memory_Key            : in     INTEGER;
      Interface             :    out CLIENT_INTERFACE_PTR_TYPE;
      Status                :    out DG_Status.STATUS_TYPE);

   ---------------------------------------------------------------------------
   -- Unmap_Interface
   ---------------------------------------------------------------------------
   --
   -- Purpose : Terminates access to the DG Client/Server shared memory
   --           interface.  If Destroy_Interface is FALSE, then the shared
   --           memory area for the interface will still exist.  This is
   --           the proper method for the Server to terminate access to the
   --           interface.  If Destroy_Interface is TRUE, then the shared
   --           memory area will be removed from the system.  Any subsequent
   --           references to the interface by any program will result in an
   --           error.  This termination method should only be used by the
   --           DG Client.
   --
   ---------------------------------------------------------------------------

   procedure Unmap_Interface(
      Destroy_Interface : in     BOOLEAN;
      Memory_Key        : in     INTEGER;
      Interface         : in out CLIENT_INTERFACE_PTR_TYPE;
      Status            :    out DG_Status.STATUS_TYPE);

end DG_Client_Interface;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
