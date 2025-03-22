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
-- UNIT NAME        : DG_Client.Get_Next_Simulation_Laser
--
-- FILE NAME        : DG_Client_Get_Next_Simulation_Laser.ada
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

procedure Get_Next_Simulation_Laser(
   Laser_Info : out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
   Status     : out DG_Status.STATUS_TYPE) is

   function Addr_To_Ptr is
     new Unchecked_Conversion(
           System.ADDRESS,
           DIS_PDU_Pointer_Types.LASER_PDU_PTR);

begin  -- Get_Next_Simulation_Laser

   Status          := DG_Status.SUCCESS;
   Laser_Info      := NULL;
   Sim_Laser_Index := Sim_Laser_Index + 1;

   Search_For_Next_Laser:
   for Search_Index in Sim_Laser_Index..DG_Server_Interface.Interface.
     Simulation_Data.Laser_Hash_Table.Entry_Data'LAST loop

      if (DG_Server_Interface.Interface.Simulation_Data.Laser_Hash_Table.
        Entry_Data(Search_Index).Status = DG_Hash_Table_Support.IN_USE) then

         Sim_Laser_Index := Search_Index;

         Laser_Info
           := Addr_To_Ptr(DG_Server_Interface.Interface.Simulation_Data.
                Laser_Data_Table(Search_Index)'ADDRESS);

         exit Search_For_Next_Laser;

      end if;

   end loop Search_For_Next_Laser;

exception

   when OTHERS =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

end Get_Next_Simulation_Laser;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
