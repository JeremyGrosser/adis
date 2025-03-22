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
-- UNIT NAME        : DG_Hash_Table_Support.Entity_Hash_Index
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 13, 1994
--
-- PURPOSE:
--   - This routine calculates a unique identifier for an entity based upon
--     a hashing algorithm.
--
-- IMPLEMENTATION NOTES:
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

with Numeric_Types;

separate (DG_Hash_Table_Support)

procedure Entity_Hash_Index(
   Command    : in     HASH_COMMAND_TYPE;
   Entity_ID  : in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Hash_Table : in out ENTITY_HASH_TABLE_TYPE;
   Hash_Index :    out INTEGER;
   Status     :    out DG_Status.STATUS_TYPE) is

   First_Link  : INTEGER;  -- Stores index of first "link" entry in the hash
                           -- table.  If Command is ADD and the requested
                           -- entry is not found in the table, then the first
                           -- link entry is allocated for the new entry.  This
                           -- keeps table entries as close to the start of the
                           -- search path as possible.
   First_Index : INTEGER;  -- Used to detect infinite loops in table searches
   Test_Index  : INTEGER;  -- Used to move through the hash table
   Final_Index : INTEGER;  -- Hash table entry value to be returned in
                           -- Hash_Index.

   --
   -- Declare local exceptions
   --
   HASH_TABLE_LOOP_ERROR : EXCEPTION;

   --
   -- Import standard math functions to improve code readability
   --
   function "+"(Left, Right : Numeric_Types.UNSIGNED_16_BIT)
     return Numeric_Types.UNSIGNED_16_BIT renames Numeric_Types."+";
   function "="(Left, Right : DIS_Types.AN_ENTITY_IDENTIFIER)
     return BOOLEAN renames DIS_Types."=";

begin  -- Entity_Hash_Index

   Status      := DG_Status.SUCCESS;
   Final_Index := 0;
   First_Link  := 0;

   --
   -- Merge components of Entity_ID together to form the initial hash index
   --
   First_Index
     :=  (INTEGER(Entity_ID.Sim_Address.Site_ID)
              * Hash_Table.Site_Multiplier
          + INTEGER(Entity_ID.Sim_Address.Application_ID)
              * Hash_Table.Application_Multiplier
          + INTEGER(Entity_ID.Entity_ID)
              * Hash_Table.Entity_Multiplier)
     mod Hash_Table.Number_Of_Entries + 1;

   Test_Index := First_Index;

   Check_Index_Loop:
   loop

      --
      -- Check status of current hash table entry
      --
      case (Hash_Table.Entry_Data(Test_Index).Status) is

         when FREE =>

            if (Command = ADD) then

               --
               -- If none of the searched entries had a "link" status, then
               -- use the current "free" entry.  If a "link" entry has been
               -- found, then reuse the entry, since this will put the new
               -- entry as close to the start of the search path as is
               -- possible.
               --
               if (First_Link = 0) then
                  Final_Index := Test_Index;
               else
                  Final_Index := First_Link;
               end if;

               --
               -- Add new hash entry for entity
               --
               Hash_Table.Entry_Data(Final_Index) := (
                 Status    => IN_USE,
                 Entity_ID => Entity_ID);

            end if;

            exit Check_Index_Loop;

         when IN_USE =>

            --
            -- Check for match between table entry and Entity_ID values
            --
            if (Hash_Table.Entry_Data(Test_Index).Entity_ID = Entity_ID) then

               Final_Index := Test_Index;

               if (Command = DELETE) then
                  Hash_Table.Entry_Data(Test_Index).Status := LINK;
               end if;

               exit Check_Index_Loop;

            end if;

         when LINK =>

            if (First_Link = 0) then
               First_Link := Test_Index;
            end if;

      end case;

      --
      -- Increment the search index, accounting for table wraparound
      --
      Test_Index := ((Test_Index
        + (Hash_Table.Secondary_Hash_Increment - 1))
        mod Hash_Table.Number_Of_Entries) + 1;

      --
      -- Check for infinite loop in search.  This can occur if the table
      -- size is an even multiple of the hash index increment value.
      --
      if (Test_Index = First_Index) then
         raise HASH_TABLE_LOOP_ERROR;
      end if;

   end loop Check_Index_Loop;

   Hash_Index := Final_Index;

exception

   when HASH_TABLE_LOOP_ERROR =>

      case (Command) is

         when ADD =>
            Status := DG_Status.ENTIDX_LOOP_FAILURE;

         when OTHERS =>
            Status := DG_Status.SUCCESS;

      end case;

      Hash_Index := 0;

   when OTHERS =>

      Status     := DG_Status.ENTIDX_FAILURE;
      Hash_Index := 0;

end Entity_Hash_Index;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
