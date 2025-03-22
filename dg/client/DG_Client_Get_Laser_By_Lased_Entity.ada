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
-- UNIT NAME        : DG_Client.Get_Laser_By_Lased_Entity
--
-- FILE NAME        : DG_Client_Get_Laser_By_Lased_Entity.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : October 13, 1994
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

separate (DG_Client)

procedure Get_Laser_By_Lased_Entity(
   Lased_Entity_ID : in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Laser_Info      :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
   Status          :    out DG_Status.STATUS_TYPE) is

   Entity_Index : INTEGER;
   Laser_Index  : INTEGER;
   Local_Status : DG_Status.STATUS_TYPE;

   function "="(Left, Right : DG_Status.STATUS_TYPE)
     return BOOLEAN
       renames DG_Status."=";

   function Addr_To_Ptr is
     new Unchecked_Conversion(
           System.ADDRESS,
           DIS_PDU_Pointer_Types.LASER_PDU_PTR);

begin  -- Get_Laser_By_Lased_Entity

   Laser_Info := NULL;
   Status     := DG_Status.SUCCESS;

   --
   -- Locate entity in hash table
   --

   DG_Hash_Table_Support.Entity_Hash_Index(
     Command    => DG_Hash_Table_Support.FIND,
     Entity_ID  => Lased_Entity_ID,
     Hash_Table => DG_Server_Interface.Interface.Simulation_Data.
                     Entity_Hash_Table,
     Hash_Index => Entity_Index,
     Status     => Local_Status);

   if (Local_Status = DG_Status.ENTIDX_LOOP_FAILURE) then

      null;  -- Entity does not exist

   elsif (DG_Status.Failure(Local_Status)) then

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

   else

      Laser_Index
        := DG_Server_Interface.Interface.Simulation_Data.Entity_XRef_Table(
             Entity_Index).Lased_Index;

      if (Laser_Index /= 0) then

         Laser_Info
           := Addr_To_Ptr(DG_Server_Interface.Interface.Simulation_Data.
                Laser_Data_Table(Laser_Index)'ADDRESS);

      end if;

   end if;

exception

   when OTHERS =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

end Get_Laser_By_Lased_Entity;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
