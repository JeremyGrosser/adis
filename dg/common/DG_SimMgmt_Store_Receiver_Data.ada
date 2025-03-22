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
-- UNIT NAME        : DG_Simulation_Management.Store_Receiver_Data
--
-- FILE NAME        : DG_SimMgmt_Store_Receiver_Data.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 08, 1994
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

with DG_Hash_Table_Support,
     System;

separate (DG_Simulation_Management)

procedure Store_Receiver_Data(
   Receiver_Info   : in     DIS_Types.A_RECEIVER_PDU;
   Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
   Status          :    out DG_Status.STATUS_TYPE) is

   Entity_Index   : INTEGER;
   Local_Status   : DG_Status.STATUS_TYPE;
   Receiver_Index : INTEGER;

   LOCAL_FAILURE : EXCEPTION;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

begin  -- Store_Receiver_Data

   Status := DG_Status.SUCCESS;

   DG_Hash_Table_Support.Entity_Hash_Index(
     Command    => DG_Hash_Table_Support.FIND,
     Entity_ID  => Receiver_Info.Entity_ID,
     Hash_Table => Simulation_Data.Entity_Hash_Table,
     Hash_Index => Entity_Index,
     Status     => Local_Status);

   if (Local_Status = DG_Status.ENTIDX_LOOP_FAILURE) then

      Status := DG_Status.SIMMGMT_STRREC_NO_ENTITY_FAILURE;

   elsif (DG_Status.Failure(Local_Status)) then

      raise LOCAL_FAILURE;

   else

      DG_Hash_Table_Support.Entity_Hash_Index(
        Command    => DG_Hash_Table_Support.ADD,
        Entity_ID  => Receiver_Info.Entity_ID,
        Hash_Table => Simulation_Data.Receiver_Hash_Table,
        Hash_Index => Receiver_Index,
        Status     => Local_Status);

      if (Local_Status = DG_Status.ENTIDX_LOOP_FAILURE) then

         Status := DG_Status.SIMMGMT_STRREC_TABLE_FULL;

      elsif (DG_Status.Failure(Local_Status)) then

         raise LOCAL_FAILURE;

      else

         Simulation_Data.Receiver_Data_Table(Receiver_Index) := Receiver_Info;

         Simulation_Data.Entity_XRef_Table(Entity_Index).Receiver_Index
           := Receiver_Index;

      end if;

   end if;

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.SIMMGMT_STRREC_FAILURE;

end Store_Receiver_Data;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
