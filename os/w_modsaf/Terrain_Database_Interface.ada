--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Terrain_Database_Interface
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
package body Terrain_Database_Interface is

   procedure Get_Height_Above_Terrain(
      Database_Origin      :  in     OS_Simulation_Types.
                                     GEODETIC_COORDINATE_RECORD;
      Location_in_WorldC   :  in     DIS_Types.A_WORLD_COORDINATE;
      Height_Above_Terrain :     out OS_Data_Types.METERS_DP;
      Status               :     out OS_Status.STATUS_TYPE)
     is separate;

end Terrain_Database_Interface;
