--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_Hash_Table_Support (spec)
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  27 May 94
--
-- PURPOSE :
--
-- EFFECTS :
--   - Munition_Hash_Table must have the bounds defined before being used.
--     This definition is provided in Initialize_Simulation.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with DIS_Types,
     OS_Data_Types,
     OS_Simulation_Types,
     OS_Status;

package OS_Hash_Table_Support is

   -- Define hash table related types
   type ENTRY_STATUS_TYPE is (
     FREE,
     IN_USE,
     LINK);

   type HASH_TABLE_ENTRY_TYPE is
     record
       Status :  ENTRY_STATUS_TYPE;
       Network_Parameters     :  OS_Data_Types.NETWORK_PARAMETERS_RECORD; 
       Aerodynamic_Parameters :  OS_Data_Types.AERODYNAMIC_PARAMETERS_RECORD;
       Flight_Parameters      :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD;
       Emitter_Parameters     :  OS_Data_Types.EMITTER_PARAMETERS_RECORD;
       Termination_Parameters :  OS_Data_Types.TERMINATION_PARAMETERS_RECORD;
     end record;

   type HASH_TABLE_ARRAY_TYPE is array (INTEGER range <>)
     of HASH_TABLE_ENTRY_TYPE;

   type HASH_TABLE_PTR is access HASH_TABLE_ARRAY_TYPE;

   -- Must have bounds defined, as in Initialize_Simulation, before being used.
   Munition_Hash_Table :  HASH_TABLE_PTR;

   type HASHING_INDEX_ACTION is (ADD, FIND, REMOVE);

   -- Procedure specs
   procedure Modify_Entity_Hashing_Index(
      Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Modify_Hash   :  in     HASHING_INDEX_ACTION;
      Hashing_Index :     out INTEGER;
      Status        :     out OS_Status.STATUS_TYPE);

   procedure Remove_Entity_by_Hashing_Index(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE);

end OS_Hash_Table_Support;
