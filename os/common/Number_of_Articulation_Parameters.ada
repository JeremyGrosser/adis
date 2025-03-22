--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- FUNCTION NAME :     Number_of_Articulation_Parameters
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  6 June 94
--
-- PURPOSE :
--
-- IMPLEMENTATION NOTES :
--   - This function requires Numeric_Types, OS_Data_Types and
--     OS_Hash_Table_Support.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with Numeric_Types,
     OS_Data_Types,
     OS_Hash_Table_Support;

function Number_of_Articulation_Parameters(
   Hashing_Index :  in     INTEGER)
  return Numeric_Types.UNSIGNED_8_BIT
  is

   -- Local variables
   Number_of_Articulation_Parameters :  Numeric_Types.UNSIGNED_8_BIT;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Data_Types.ARTICULATION_PARAMS_PTR)
     return BOOLEAN
     renames OS_Data_Types."=";

begin -- Number_of_Articulation_Parameters

   if OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
      Network_Parameters.Articulation_Parameters = null
   then
      Number_of_Articulation_Parameters := 0;
   else
      Number_of_Articulation_Parameters := Numeric_Types.UNSIGNED_8_BIT(
        OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
        Network_Parameters.Articulation_Parameters.All'LENGTH);
   end if;

   return Number_of_Articulation_Parameters;

end Number_of_Articulation_Parameters;
