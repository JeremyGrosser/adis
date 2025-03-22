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
-- UNIT NAME        : DG_PDU_Buffer.Add
--
-- FILE NAME        : DG_PB_Add.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 22, 1994
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

with DIS_Types,
     System;

separate (DG_PDU_Buffer)

procedure Add(
   PDU             : in     DG_Generic_PDU.GENERIC_PDU_TYPE;
   PDU_Buffer      : in out PDU_BUFFER_TYPE;
   PDU_Write_Index : in out INTEGER;
   Status          :    out DG_Status.STATUS_TYPE) is

   PDU_Header : DIS_Types.A_PDU_HEADER;
     for PDU_Header use at PDU'ADDRESS;

   Wrap_Index : INTEGER;

   LOCAL_FAILURE : EXCEPTION;

begin  -- Add

   Status := DG_Status.SUCCESS;

   --
   -- Ensure that the buffer can actually hold the PDU.
   --
   if (PDU_Buffer'LENGTH <= PDU'LENGTH) then
      Status := DG_Status.PB_ADD_PDU_TOO_BIG_FAILURE;
      raise LOCAL_FAILURE;
   end if;

   --
   -- Determine if the PDU will fit in the buffer without wrapping
   --

   if (PDU_Buffer'LAST >= PDU_Write_Index + PDU'LENGTH - 1) then

      PDU_Buffer(PDU_Write_Index..(PDU_Write_Index+PDU'LENGTH-1)) := PDU;

   else

      --
      -- Copy as much of the PDU as will fit into the end of the buffer
      --

      -- Calculate index at which PDU divides when wrapping

      Wrap_Index := PDU_Buffer'LAST - PDU_Write_Index + 1;

      PDU_Buffer(PDU_Write_Index..PDU_Buffer'LAST) := PDU(1..Wrap_Index);

      PDU_Buffer(1..PDU'LENGTH-Wrap_Index) := PDU(Wrap_Index+1..PDU'LENGTH);

   end if;

   PDU_Write_Index
     := ((PDU_Write_Index + PDU'LENGTH - 1) mod PDU_Buffer'LENGTH) + 1;

exception

   when LOCAL_FAILURE =>

      null;  -- Status has been set at the point of the failure

   when OTHERS =>

      Status := DG_Status.PB_ADD_FAILURE;

end Add;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
