--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Terrain_Database_Interface (spec)
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 May 94
--
-- PURPOSE :
--   - The TDI CSC is responsible for determining height above terrain for a
--     specified position of an entity.  This implementation makes calls to
--     the CTDB library in ModSAF.
--
-- EFFECTS :
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with C_Strings,
     DIS_Types,
     Numeric_Types,
     OS_CTDB_Types,
     OS_Data_Types,
     OS_Simulation_Types,
     OS_Status;

package Terrain_Database_Interface is

   procedure CTDB_Read(
      Database_Filename :  in C_strings.C_string;
      CTDB              :  in OS_CTDB_Types.CTDB_STRUCTURE_PTR;
      Memory_Limit      :  in INTEGER);
   pragma interface(C, ctdb_read);

   function CTDB_Lookup_Elevation(
      CTDB :  in OS_CTDB_Types.CTDB_STRUCTURE_PTR;
      X    :  in Numeric_Types.FLOAT_64_BIT;
      Y    :  in Numeric_Types.FLOAT_64_BIT)
     return Numeric_Types.FLOAT_64_BIT;
   pragma interface(C, ctdb_lookup_elevation);

   CTDB_Pointer :  OS_CTDB_Types.CTDB_STRUCTURE_PTR;

   -- Procedure specs
   procedure Get_Height_Above_Terrain(
      Database_Origin      :  in     OS_Simulation_Types.
                                     GEODETIC_COORDINATE_RECORD;
      Location_in_WorldC   :  in     DIS_Types.A_WORLD_COORDINATE;
      Height_Above_Terrain :     out OS_Data_Types.METERS_DP;
      Status               :     out OS_Status.STATUS_TYPE);

end Terrain_Database_Interface;
