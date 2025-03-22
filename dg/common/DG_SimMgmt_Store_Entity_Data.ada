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
-- UNIT NAME        : DG_Simulation_Management.Store_Entity_Data
--
-- FILE NAME        : DG_SimMgmt_Store_Entity_Data.ada
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

with Calendar,
     DG_Hash_Table_Support,
     System;

separate (DG_Simulation_Management)

procedure Store_Entity_Data(
   Entity_Info     : in     DIS_Types.AN_ENTITY_STATE_PDU;
   Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
   Status          :    out DG_Status.STATUS_TYPE) is

   Entity_Index : INTEGER;
   Local_Status : DG_Status.STATUS_TYPE;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

begin  -- Store_Entity_Data

   Status := DG_Status.SUCCESS;

   DG_Hash_Table_Support.Entity_Hash_Index(
     Command    => DG_Hash_Table_Support.ADD,
     Entity_ID  => Entity_Info.Entity_ID,
     Hash_Table => Simulation_Data.Entity_Hash_Table,
     Hash_Index => Entity_Index,
     Status     => Local_Status);

   if (Local_Status = DG_Status.ENTIDX_LOOP_FAILURE) then

      Status := DG_Status.SIMMGMT_STRENTITY_TABLE_FULL;

   elsif (DG_Status.Failure(Local_Status)) then

      Status := Local_Status;

   else

      Store_Entity_Info:
      declare

         Entity_Storage : DIS_Types.AN_ENTITY_STATE_PDU(
                            Number_Of_Parms => Entity_Info.Number_Of_Parms);
         for Entity_Storage use at
           Simulation_Data.Entity_Data_Table(Entity_Index)'ADDRESS;

      begin  -- Store_Entity_Info

         Entity_Storage := Entity_Info;

      end Store_Entity_Info;

      --
      -- Record the entity reception and update times.
      --
      Simulation_Data.Entity_Update_Time(Entity_Index)
        := Calendar.Clock;

      Simulation_Data.Entity_Reception_Time(Entity_Index)
        := Simulation_Data.Entity_Update_Time(Entity_Index);

   end if;

exception

   when OTHERS =>

      Status := DG_Status.SIMMGMT_STRENTITY_FAILURE;

end Store_Entity_Data;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
