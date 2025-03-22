--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Remove_Entity_by_Hashing_Index
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  8 June 94
--
-- PURPOSE :
--   - The REBHI CSU removes an entity from the munition hash table using the
--     munition's Hashing_Index.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires OS_GUI and OS_Status.
--   - This procedure will remove the entity from the munition hash table only
--     if the Hashing Index is known.  If the Hashing Index is not known, the
--     Modify_Entity_Hashing_Index procedure should be used instead of this
--     procedure.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with OS_GUI;

separate (OS_Hash_Table_Support)

procedure Remove_Entity_by_Hashing_Index(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Next_Index  :  INTEGER; 

begin -- Remove_Entity_by_Hashing_Index

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Increment once to determine whether the entry should be FREE or IN_USE
   Next_Index := ((Hashing_Index
     + OS_GUI.Interface.Simulation_Parameters.Hash_Table_Increment - 1)
     mod OS_GUI.Interface.Simulation_Parameters.Hash_Table_Size) + 1;

   if Munition_Hash_Table(Next_Index).Status = FREE then
      Munition_Hash_Table(Hashing_Index).Status := FREE;
   else -- Next_Index is LINK or IN_USE
      Munition_Hash_Table(Hashing_Index).Status := LINK;
   end if;

exception
   when OTHERS =>
      Status := OS_Status.REBHI_ERROR;

end Remove_Entity_by_Hashing_Index;
