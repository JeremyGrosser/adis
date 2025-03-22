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
-- UNIT NAME        : DG_Filter_PDU
--
-- FILE NAME        : DG_Filter_PDU.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June dd, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - 
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Generic_PDU,
     DG_Server_GUI,
     DG_Status,
     DIS_Types,
     Numeric_Types;

procedure DG_Filter_PDU(
   PDU_Ptr : in     DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Keep    :    out BOOLEAN;
   Status  :    out DG_Status.STATUS_TYPE) is

   Local_Keep : BOOLEAN;

   PDU_Header : DIS_Types.A_PDU_HEADER;

   DISCARD_PDU : EXCEPTION;

   function "="(Left, Right : DIS_Types.AN_EXERCISE_IDENTIFIER)
     return BOOLEAN
       renames Numeric_Types."=";

begin  -- DG_Filter_PDU

   Status := DG_Status.SUCCESS;
   Keep   := TRUE;

   --
   -- Check PDU type first
   --

   PDU_Header := DG_Generic_PDU.Generic_Ptr_To_PDU_Header_Ptr(PDU_Ptr).ALL;

   --
   -- Check if this type of PDU should be kept
   --
   if (not DG_Server_GUI.Interface.Filter_Parameters.Keep_PDU(
     PDU_Header.PDU_Type)) then

      raise DISCARD_PDU;

   end if;

   --
   -- Check specific PDU filters
   --

   if ((DG_Server_GUI.Interface.Filter_Parameters.Keep_Exercise_ID)
     and then (PDU_Header.Exercise_ID /= DG_Server_GUI.Interface.
       Filter_Parameters.Exercise_ID)) then

      raise DISCARD_PDU;

   end if;

exception

   when DISCARD_PDU =>

      Keep := FALSE;

   when OTHERS =>

      Status := DG_Status.FILTER_FAILURE;

end DG_Filter_PDU;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
