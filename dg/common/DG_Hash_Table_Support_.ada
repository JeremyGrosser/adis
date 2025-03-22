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
-- PACKAGE NAME     : DG_Hash_Table_Support
--
-- FILE NAME        : DG_Hash_Table_Support_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 13, 1994
--
-- PURPOSE:
--   - This package defines types and routines for establishing and
--     maintaining various hash tables.
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

with DG_Status,
     DIS_Types;

package DG_Hash_Table_Support is

   ---------------------------------------------------------------------------
   -- Type ENTRY_STATUS_TYPE is used to track the status of a hash table
   -- entry.  The meanings of these status values are:
   --   FREE   - The entry does not contain useful data, and secondary
   --            hashing calculations will not lead to further IN_USE entries.
   --   IN_USE - The entry is contains useful data.
   --   LINK   - The entry does not contain useful data, but secondary
   --            hashing calculations will lead to further IN_USE entries.
   ---------------------------------------------------------------------------

   type ENTRY_STATUS_TYPE is (
      FREE,
      IN_USE,
      LINK);

   ---------------------------------------------------------------------------
   -- Type HASH_COMMAND_TYPE is used to specify the operation performed by
   -- the hash routines.  The meanings of these commands are:
   --   ADD    - Return the hash index if an entry already exists in the
   --            table.  If no entry exists for the data, locate an unused
   --            entry, store the data, and return that entry's index.
   --   FIND   - Return the hash index if an entry already exists in the
   --            table.  If no entry exists for the data, then return 0.
   --   DELETE - Remove the data's entry from the table.
   ---------------------------------------------------------------------------

   type HASH_COMMAND_TYPE is (
     ADD,
     FIND,
     DELETE);

   ---------------------------------------------------------------------------
   -- Define types for creating an entity hash table.
   ---------------------------------------------------------------------------

   type ENTITY_HASH_TABLE_ENTRY_TYPE is
   record
      Status    : ENTRY_STATUS_TYPE;
      Entity_ID : DIS_Types.AN_ENTITY_IDENTIFIER;
   end record;

   type ENTITY_HASH_TABLE_ARRAY_TYPE is array (INTEGER range <>)
     of ENTITY_HASH_TABLE_ENTRY_TYPE;

   --
   -- The variants of this ENTITY_HASH_TABLE_TYPE record are used for the
   -- following purposes:
   --
   --   - Number_Of_Entries determines the size of the table.
   --   - Secondary_Hash_Increment determines the interval between secondary
   --       hash table probes if the initial probe results in a collision.
   --   - Site_Multiplier, Application_Multiplier, and Entity_Multiplier are
   --       used to create a wider dispersion of the initial probe location
   --       in exercises where the site, application, and entity IDs are
   --       close together.
   --
   type ENTITY_HASH_TABLE_TYPE(
      Number_Of_Entries : INTEGER) is
     record
       Secondary_Hash_Increment : INTEGER;
       Site_Multiplier          : INTEGER;
       Application_Multiplier   : INTEGER;
       Entity_Multiplier        : INTEGER;
       Entry_Data               : ENTITY_HASH_TABLE_ARRAY_TYPE(
                                    1..Number_Of_Entries);
     end record;

   for ENTITY_HASH_TABLE_TYPE use
     record
       Number_Of_Entries        at 0 range   0..31;
       Secondary_Hash_Increment at 0 range  32..63;
       Site_Multiplier          at 0 range  64..95;
       Application_Multiplier   at 0 range  96..127;
       Entity_Multiplier        at 0 range 128..159;
     end record;

   ---------------------------------------------------------------------------
   -- Entity_Hash_Index
   ---------------------------------------------------------------------------
   --
   -- Purpose: Performs hashing functions on an entity hash table.
   --
   ---------------------------------------------------------------------------

   procedure Entity_Hash_Index(
      Command    : in     HASH_COMMAND_TYPE;
      Entity_ID  : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Hash_Table : in out ENTITY_HASH_TABLE_TYPE;
      Hash_Index :    out INTEGER;
      Status     :    out DG_Status.STATUS_TYPE);

end DG_Hash_Table_Support;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
