--
--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--
------------------------------------------------------------------------------
--
-- PACKAGE NAME     : DG_Hash_Table_Support
--
-- FILE NAME        : DG_Hash_Table_Support.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : May 13, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

package body DG_Hash_Table_Support is

   ---------------------------------------------------------------------------
   -- Entity_Hash_Index
   ---------------------------------------------------------------------------

   procedure Entity_Hash_Index(
      Command    : in     HASH_COMMAND_TYPE;
      Entity_ID  : in     DIS_Types.AN_ENTITY_IDENTIFIER;
      Hash_Table : in out ENTITY_HASH_TABLE_TYPE;
      Hash_Index :    out INTEGER;
      Status     :    out DG_Status.STATUS_TYPE) is separate;

end DG_Hash_Table_Support;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
