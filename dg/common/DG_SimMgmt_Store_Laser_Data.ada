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
-- UNIT NAME        : DG_Simulation_Management.Store_Laser_Data
--
-- FILE NAME        : DG_SimMgmt_Store_Laser_Data.ada
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

procedure Store_Laser_Data(
   Laser_Info      : in     DIS_Types.A_LASER_PDU;
   Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
   Status          :    out DG_Status.STATUS_TYPE) is

   Entity_Index       : INTEGER;
   Lased_Entity_Index : INTEGER;
   Laser_Index        : INTEGER;
   Local_Status       : DG_Status.STATUS_TYPE;

   LOCAL_FAILURE : EXCEPTION;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

begin  -- Store_Laser_Data

   Status := DG_Status.SUCCESS;

   DG_Hash_Table_Support.Entity_Hash_Index(
     Command    => DG_Hash_Table_Support.FIND,
     Entity_ID  => Laser_Info.Lasing_Entity_ID,
     Hash_Table => Simulation_Data.Entity_Hash_Table,
     Hash_Index => Entity_Index,
     Status     => Local_Status);

   if (Local_Status = DG_Status.ENTIDX_LOOP_FAILURE) then

      Status := DG_Status.SIMMGMT_STRLAS_NO_ENTITY_FAILURE;

   elsif (DG_Status.Failure(Local_Status)) then

      raise LOCAL_FAILURE;

   else

      DG_Hash_Table_Support.Entity_Hash_Index(
        Command    => DG_Hash_Table_Support.ADD,
        Entity_ID  => Laser_Info.Lasing_Entity_ID,
        Hash_Table => Simulation_Data.Laser_Hash_Table,
        Hash_Index => Laser_Index,
        Status     => Local_Status);

      if (Local_Status = DG_Status.ENTIDX_LOOP_FAILURE) then

         Status := DG_Status.SIMMGMT_STRLAS_TABLE_FULL;

      elsif (DG_Status.Failure(Local_Status)) then

         raise LOCAL_FAILURE;

      else

         --
         -- Store the laser information
         --
         Simulation_Data.Laser_Data_Table(Laser_Index) := Laser_Info;

         --
         -- If possible, cross-reference the laser with its host entity
         --
         if (Entity_Index /= 0) then
            Simulation_Data.Entity_XRef_Table(Entity_Index).Laser_Index
              := Laser_Index;
         end if;

         --
         -- If possible, cross-reference the laser with the lased entity
         --
         DG_Hash_Table_Support.Entity_Hash_Index(
           Command    => DG_Hash_Table_Support.FIND,
           Entity_ID  => Laser_Info.Lased_Entity_ID,
           Hash_Table => Simulation_Data.Entity_Hash_Table,
           Hash_Index => Lased_Entity_Index,
           Status     => Local_Status);

         if (DG_Status.Success(Local_Status)) then
            if (Lased_Entity_Index /= 0) then
               Simulation_Data.Entity_XRef_Table(Lased_Entity_Index).
                 Lased_Index := Laser_Index;
            end if;
         else
            Status := Local_Status;
         end if;

      end if;

   end if;

exception

   when LOCAL_FAILURE =>

      Status := Local_Status;

   when OTHERS =>

      Status := DG_Status.SIMMGMT_STRLAS_FAILURE;

end Store_Laser_Data;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
