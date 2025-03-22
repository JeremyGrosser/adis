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
-- PACKAGE NAME     : DG_Interface_Types
--
-- FILE NAME        : DG_Interface_Types_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 08, 1994
--
-- PURPOSE:
--   - 
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

with Calendar,
     DIS_Types,
     DG_Generic_PDU,
     DG_Hash_Table_Support,
     DG_PDU_Buffer,
     Numeric_Types;

package DG_Interface_Types is

   --
   -- Define a type for a circular buffer to hold PDUs
   --
   subtype PDU_BUFFER_TYPE is DG_PDU_Buffer.PDU_BUFFER_TYPE;

   --
   -- Define a type for the Client application name
   --
   K_Maximum_Client_Name : constant INTEGER := 20;

   subtype CLIENT_NAME_TYPE is STRING(1..K_Maximum_Client_Name);

   ---------------------------------------------------------------------------
   -- Define types to hold arrays of various PDUs.
   ---------------------------------------------------------------------------

   --
   -- These constant control the storage allocated for PDUs based on variant
   -- types.  Ideally, these will be replaced by some other storage mechanism
   -- in which the user can control the storage allocation, rather than having
   -- hard-coded constants.
   --
   K_Maximum_Articulated_Parts : constant := 78;
   K_Maximum_Emitter_Size      : constant := 500;
   K_Maximum_Receiver_Size     : constant := 500;

   type ENTITY_DATA_TABLE_TYPE is
     array (INTEGER range <>) of
       DIS_Types.AN_ENTITY_STATE_PDU(K_Maximum_Articulated_Parts);

   type EMITTER_DATA_TABLE_TYPE is
     array (INTEGER range <>) of
       DG_Generic_PDU.GENERIC_PDU_TYPE(1..K_Maximum_Emitter_Size);

   type LASER_DATA_TABLE_TYPE is
     array (INTEGER range <>) of DIS_Types.A_LASER_PDU;

   type TRANSMITTER_DATA_TABLE_TYPE is
     array (INTEGER range <>) of
       DG_Generic_PDU.GENERIC_PDU_TYPE(1..K_Maximum_Receiver_Size);

   type RECEIVER_DATA_TABLE_TYPE is
     array (INTEGER range <>) of DIS_Types.A_RECEIVER_PDU;

   --
   -- Define types to track relationships between persistent simulation
   -- objects.
   --

   type ENTITY_CROSS_REFERENCE_ENTRY_TYPE is
     record
       Emitter_Index     : INTEGER;  -- Emitter controlled by this entity
       Laser_Index       : INTEGER;  -- Laser controlled by this entity
       Lased_Index       : INTEGER;  -- Most recent laser to illuminate this
                                     --   entity
       Transmitter_Index : INTEGER;  -- Transmitter controlled by this entity
       Receiver_Index    : INTEGER;  -- Receiver controlled by this entity
     end record;

   type ENTITY_CROSS_REFERENCE_ARRAY_TYPE is
     array (INTEGER range <>) of ENTITY_CROSS_REFERENCE_ENTRY_TYPE;

   --
   -- Define a type to track data update times.
   --

   type DATA_UPDATE_TIME_TYPE is
     array (INTEGER range <>) of Calendar.TIME;

   --
   -- Define a type for the DG Server Interface.
   --

   type SIMULATION_DATA_TYPE(

     Maximum_Entities     : INTEGER;
     Maximum_Emitters     : INTEGER;
     Maximum_Lasers       : INTEGER;
     Maximum_Transmitters : INTEGER;
     Maximum_Receivers    : INTEGER) is

   record

      --
      -- Entity information
      --
      Entity_Hash_Table     : DG_Hash_Table_Support.
                                ENTITY_HASH_TABLE_TYPE(Maximum_Entities);
      Entity_Data_Table     : ENTITY_DATA_TABLE_TYPE(1..Maximum_Entities);
      Entity_XRef_Table     : ENTITY_CROSS_REFERENCE_ARRAY_TYPE(
                                1..Maximum_Entities);
      Entity_Update_Time    : DATA_UPDATE_TIME_TYPE(1..Maximum_Entities);
      Entity_Reception_Time : DATA_UPDATE_TIME_TYPE(1..Maximum_Entities);

      --
      -- Emitter Information
      --
      Emitter_Hash_Table     : DG_Hash_Table_Support.
                                 ENTITY_HASH_TABLE_TYPE(Maximum_Emitters);
      Emitter_Data_Table     : EMITTER_DATA_TABLE_TYPE(1..Maximum_Emitters);
      Emitter_Update_Time    : DATA_UPDATE_TIME_TYPE(1..Maximum_Emitters);
      Emitter_Reception_Time : DATA_UPDATE_TIME_TYPE(1..Maximum_Emitters);

      --
      -- Laser Information
      --
      Laser_Hash_Table : DG_Hash_Table_Support.
                           ENTITY_HASH_TABLE_TYPE(Maximum_Lasers);
      Laser_Data_Table : LASER_DATA_TABLE_TYPE(1..Maximum_Lasers);
      Laser_Update_Time     : DATA_UPDATE_TIME_TYPE(1..Maximum_Lasers);
      Laser_Reception_Time  : DATA_UPDATE_TIME_TYPE(1..Maximum_Lasers);

      --
      -- Transmitter Information
      --
      Transmitter_Hash_Table     : DG_Hash_Table_Support.
                                     ENTITY_HASH_TABLE_TYPE(
                                       Maximum_Transmitters);
      Transmitter_Data_Table     : TRANSMITTER_DATA_TABLE_TYPE(
                                     1..Maximum_Transmitters);
      Transmitter_Update_Time    : DATA_UPDATE_TIME_TYPE(
                                     1..Maximum_Transmitters);
      Transmitter_Reception_Time : DATA_UPDATE_TIME_TYPE(
                                     1..Maximum_Transmitters);

      --
      -- Receiver Information
      --
      Receiver_Hash_Table     : DG_Hash_Table_Support.
                                  ENTITY_HASH_TABLE_TYPE(Maximum_Receivers);
      Receiver_Data_Table     : RECEIVER_DATA_TABLE_TYPE(1..Maximum_Receivers);
      Receiver_Update_Time    : DATA_UPDATE_TIME_TYPE(1..Maximum_Receivers);
      Receiver_Reception_Time : DATA_UPDATE_TIME_TYPE(1..Maximum_Receivers);

   end record;

   for SIMULATION_DATA_TYPE use
     record
       Maximum_Entities     at 0 range   0 ..  31;
       Maximum_Emitters     at 0 range  32 ..  63;
       Maximum_Lasers       at 0 range  64 ..  95;
       Maximum_Transmitters at 0 range  96 .. 127;
       Maximum_Receivers    at 0 range 128 .. 159;
     end record;

end DG_Interface_Types;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
