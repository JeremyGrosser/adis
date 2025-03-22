--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Detonation_Event (spec)
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- MODIFIED BY :       Robert S. Kerr - J. F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 May 94
--
-- PURPOSE :
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
with DIS_Types,
     OS_Data_Types,
     OS_Status;

package Detonation_Event is

   --
   -- Define Constants
   --
   -- Ground Z offset to account for terrain database & modsaf database
   -- differences
   K_Database_Offset :  constant OS_Data_Types.METERS_DP := 500.0;

   procedure Check_for_Detonation(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE);

   procedure Determine_Detonation_Result(
      Hashing_Index    :  in     INTEGER;
      Target_Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Status           :     out OS_Status.STATUS_TYPE);

end Detonation_Event;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 27 NOV 94 -- RSK:  Added offset to terrain database constant
