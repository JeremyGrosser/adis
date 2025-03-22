--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Modify_Entity_Hashing_Index
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  8 June 94
--
-- PURPOSE :
--   - The MEHI CSU adds an entity to, finds an entity on or removes an entity
--     from the munition hash table.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors, OS_GUI, and OS_Status.
--   - If Modify_Hash = ADD and a match is not found, then the first LINK entry
--     is allocated for the new entry.  This process keeps table entries as
--     close to the start of the search path as possible.
--   - If Modify_Hash = REMOVE, this procedure will search for the entity by
--     Entity ID in order to remove the entity from the hash table.  If the
--     Hashing Index of the entity is known, Remove_Entity_by_Hashing_Index
--     should be used instead of this procedure.
--   - This procedure is a modified version of a similar unit in the DIS
--     Gateway CSCI which was written by Brett Dufault.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Errors,
     OS_GUI;

separate (OS_Hash_Table_Support)

procedure Modify_Entity_Hashing_Index(
   Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Modify_Hash   :  in     HASHING_INDEX_ACTION;
   Hashing_Index :     out INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Error        :  OS_Status.STATUS_TYPE;  -- Avoids making Status in/out
   Final_Index  :  INTEGER := 0; -- Hashing index to be returned.
   First_Link   :  INTEGER := 0; -- Stores index of first LINK entry in the
                                 -- hash table.
   First_Index  :  INTEGER;      -- Used to detect infinite loops in a search.
   Test_Index   :  INTEGER;      -- Used to move through the hash table.

   -- Rename functions
   function "=" (LEFT, RIGHT :  DIS_Types.AN_ENTITY_IDENTIFIER)
     return BOOLEAN
     renames DIS_Types."=";

   -- Local exceptions
   ADD_ENTITY_ERROR    :  exception;
   INFINITE_LOOP_ERROR :  exception;

begin -- Modify_Entity_Hashing_Index

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Generate initial hash index from components of Entity ID
   First_Index := INTEGER(Entity_ID.Entity_ID) mod OS_GUI.Interface.
     Simulation_Parameters.Hash_Table_Size;
   Test_Index  := First_Index;

   Check_Index_Loop:
   loop
      --Check status of current hash table entry
      case (Munition_Hash_Table(Test_Index).Status) is
         when FREE =>
            if Modify_Hash = ADD then

               -- Add data into this entry unless a LINK entry was found
               -- previously
               if First_Link = 0 then
                  Final_Index := Test_Index;
               else
                  Final_Index := First_Index;
               end if;

               -- Add new hash entry for entity
               Munition_Hash_Table(Final_Index).Status := IN_USE;
               exit Check_Index_Loop;
            elsif Modify_Hash = FIND then
               if Munition_Hash_Table(Test_Index).Network_Parameters.Entity_ID
                 = Entity_ID
               then
                  -- This index corresponds to entry for this entity
                  exit Check_Index_Loop;
               end if;
            end if;

         when IN_USE =>
            -- Check for a match
            if Munition_Hash_Table(Test_Index).Network_Parameters.Entity_ID
              = Entity_ID then

               -- If only supposed to find hashing index, exit loop
               Final_Index := Test_Index;

               -- Remove if requested; if ADD requested, an error occurred
               if Modify_Hash = REMOVE then
                  -- Increment once to determine whether the entry should be
                  -- FREE or IN_USE
                  Test_Index := (
                    (Test_Index + OS_GUI.Interface.Simulation_Parameters.
                    Hash_Table_Increment - 1)
                    mod OS_GUI.Interface.Simulation_Parameters.Hash_Table_Size)
                    + 1;

                  if Munition_Hash_Table(Test_Index).Status = FREE then
                     Munition_Hash_Table(Final_Index).Status := FREE;
                  else -- Test_Index is LINK or IN_USE
                     Munition_Hash_Table(Final_Index).Status := LINK;
                  end if;
               elsif Modify_Hash = ADD then
                  raise ADD_ENTITY_ERROR;
               end if;

               exit Check_Index_Loop;
            end if;
         when LINK =>
            if First_Link = 0 then
               First_Link := Test_Index;
            end if;
      end case;

      -- Increment search index accounting for table wraparound
      Test_Index := ((Test_Index + OS_GUI.Interface.Simulation_Parameters.
        Hash_Table_Increment - 1)
        mod OS_GUI.Interface.Simulation_Parameters.Hash_Table_Size) + 1;
      -- Check for infinite loop in search (which can occur if the table size
      -- is an even multiple of the hash table increment value).
      if Test_Index = First_Index then
         raise INFINITE_LOOP_ERROR;
      end if;

   end loop Check_Index_Loop;
   Hashing_Index := Final_Index;

exception
   when ADD_ENTITY_ERROR =>
      Error := OS_Status.MEHI_ADD_ENTITY_ERROR;
      Status := Error;
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Error);

   when INFINITE_LOOP_ERROR =>
      Error := OS_Status.MEHI_INFINITE_LOOP_ERROR;
      Status := Error;
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Error);

   when OTHERS =>
      Status := OS_Status.MEHI_ERROR;

end Modify_Entity_Hashing_Index;
