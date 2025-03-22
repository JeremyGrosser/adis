--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- FUNCTION NAME :     Is_Parent
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  20 June 94
--
-- PURPOSE :
--   - The Is_Parent function determines whether the entity is the parent of a
--     specified munition.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Numeric_Types and
--     OS_Simulation_Types.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with DIS_Types,
     Numeric_Types,
     OS_GUI,
     OS_Simulation_Types;

function Is_Parent(
   Entity_ID :  in DIS_Types.AN_ENTITY_IDENTIFIER)
  return BOOLEAN
  is

   -- Local variables
   Is_Parent :  BOOLEAN;

   -- Rename functions
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
     renames Numeric_Types."=";

   -- Rename variables
   Simulation_Parameters :  OS_Simulation_Types.SIMULATION_PARAMETERS_RECORD
     renames OS_GUI.Interface.Simulation_Parameters;

begin -- Is_Parent

   -- Initialize Is_Parent (return parameter)
   Is_Parent := FALSE;

   -- Perform check for parent entity
   if Entity_ID.Sim_Address.Site_ID = Simulation_Parameters.
     Parent_Entity_ID.Sim_Address.Site_ID
   then
      if Entity_ID.Sim_Address.Application_ID = Simulation_Parameters.
        Parent_Entity_ID.Sim_Address.Application_ID
      then
         -- At this point, the entity id must match or be zero because zero
         -- indicates a wild card:  any entity from this site and application
         -- is a parent
         if Entity_ID.Entity_ID = Simulation_Parameters.Parent_Entity_ID.
            Entity_ID
           or else OS_Simulation_Types.Simulation_Parameters.Parent_Entity_ID.
            Entity_ID = 0
         then

            Is_Parent := TRUE; -- The entity is a parent entity

         end if;
      end if;
   end if;

   return Is_Parent;

end Is_Parent;
