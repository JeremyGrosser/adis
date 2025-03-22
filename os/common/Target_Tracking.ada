--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Target_Tracking
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
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
package body Target_Tracking is

   procedure Check_for_Parent_Illumination(
      Hashing_Index      :  in     INTEGER;
      Target_Illuminated :     out BOOLEAN;
      Status             :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Find_Closest_Entities(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Update_Target(
      Hashing_Index        :  in     INTEGER;
      Illuminated_Entities :  in out DL_Linked_List_Types.
                                     Entity_State_List.PTR;
      Status               :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Search_for_Target(
      Hashing_Index        :  in     INTEGER;
      Illuminated_Entities :  in out DL_Linked_List_Types.
                                     Entity_State_List.PTR;
      Status               :     out OS_Status.STATUS_TYPE)
     is separate;

end Target_Tracking;
