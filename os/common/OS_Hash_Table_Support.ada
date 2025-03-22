--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_Hash_Table_Support
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
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
package body OS_Hash_Table_Support is

   procedure Modify_Entity_Hashing_Index(
      Entity_ID     :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Modify_Hash   :  in     HASHING_INDEX_ACTION;
      Hashing_Index :     out INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Remove_Entity_by_Hashing_Index(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

end OS_Hash_Table_Support;
