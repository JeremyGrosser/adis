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
-- UNIT NAME        : DG_Client.Get_Laser_By_Code
--
-- FILE NAME        : DG_Client_Get_Laser_By_Code.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : November 3, 1994
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

procedure Get_Laser_By_Code(
   Laser_Code : in     Numeric_Types.UNSIGNED_8_BIT;
   Laser_Info :    out DIS_PDU_Pointer_Types.LASER_PDU_PTR;
   Status     :    out DG_Status.STATUS_TYPE) is

   Local_Status : DG_Status.STATUS_TYPE;

   function Addr_To_Ptr is
     new Unchecked_Conversion(
           System.ADDRESS,
           DIS_PDU_Pointer_Types.LASER_PDU_PTR);

   function "="(Left, Right : Numeric_Types.UNSIGNED_8_BIT)
     return BOOLEAN
       renames Numeric_Types."=";

begin  -- Get_Laser_By_Code

   Laser_Info := NULL;
   Status     := DG_Status.SUCCESS;

   Search_For_Matching_Laser:
   for Search_Index in 1..DG_Server_Interface.Interface.Simulation_Data.
     Laser_Hash_Table.Entry_Data'LAST loop

      if ((DG_Server_Interface.Interface.Simulation_Data.Laser_Hash_Table.
        Entry_Data(Search_Index).Status = DG_Hash_Table_Support.IN_USE)
          and then (DG_Server_Interface.Interface.Simulation_Data.
            Laser_Data_Table(Search_Index).Laser_Code = Laser_Code)) then

         Laser_Info
           := Addr_To_Ptr(DG_Server_Interface.Interface.Simulation_Data.
                Laser_Data_Table(Search_Index)'ADDRESS);

         exit Search_For_Matching_Laser;

      end if;

   end loop Search_For_Matching_Laser;

exception

   when OTHERS =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

end Get_Laser_By_Code;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
