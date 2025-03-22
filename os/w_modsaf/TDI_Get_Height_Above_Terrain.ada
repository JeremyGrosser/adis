--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Get_Height_Above_Terrain
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  12 July 94
--
-- PURPOSE :
--   - The GHAT CSU determines a height above terrain by interfacing with a
--     terrain database to acquire height of the terrain and then calculating
--     the difference between height of the terrain and height of the munition.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Coordinate_Conversions, DIS_Types, DL_Status,
--     Errors, OS_Data_Types, OS_Simulation_Types and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Coordinate_Conversions,
     DL_Status,
     Errors;

separate (Terrain_Database_Interface)

procedure Get_Height_Above_Terrain(
   Database_Origin      :  in     OS_Simulation_Types.
                                  GEODETIC_COORDINATE_RECORD;
   Location_in_WorldC   :  in     DIS_Types.A_WORLD_COORDINATE;
   Height_Above_Terrain :     out OS_Data_Types.METERS_DP;
   Status               :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Location_in_DatabaseC :  DIS_Types.A_WORLD_COORDINATE; -- A 64 bit vector
   Returned_Status       :  OS_Status.STATUS_TYPE;
   Status_DL             :  DL_Status.STATUS_TYPE;

   -- Local exceptions
   DL_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";

begin -- Get_Height_Above_Terrain

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Convert world location to a database location
   Coordinate_Conversions.Geocentric_To_Local_In_Meters_Conversion(
     Geocentric_Coordinates => Location_in_WorldC,
     Local_Origin           => Database_Origin,
     Local_Coordinates      => Location_in_DatabaseC,
     Status                 => Status_DL);

   if Status_DL /= DL_Status.SUCCESS then
      Returned_Status := OS_Status.DL_ERROR;
      raise DL_ERROR;
   end if;

   -- Find difference between actual height and terrain's height
   -- Make a call to ModSAF to lookup elevation at the new X and Y
   Height_Above_Terrain := Location_in_DatabaseC.Z
     - CTDB_Lookup_Elevation(
         CTDB => OS_CTDB_Types.CTDB_Pointer,
         X    => Location_in_DatabaseC.X,
         Y    => Location_in_DatabaseC.Y);

exception
   when DL_ERROR =>
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.GHAT_ERROR;

end Get_Height_Above_Terrain;
