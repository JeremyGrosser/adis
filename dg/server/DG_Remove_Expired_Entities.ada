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
-- UNIT NAME        : DG_Remove_Expired_Entities
--
-- FILE NAME        : DG_Remove_Expired_Entities.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 05, 1994
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
     DG_Interface_Types,
     DG_Server_Error_Processing,
     DG_Server_GUI,
     DG_Status,
     Numeric_Types;

procedure DG_Remove_Expired_Entities (
   Simulation_Data : in out DG_Interface_Types.SIMULATION_DATA_TYPE;
   Status          :    out DG_Status.STATUS_TYPE) is

   Current_Time    : Calendar.TIME;
   Entity_Total    : INTEGER := 0;
   Local_Status    : DG_Status.STATUS_TYPE;
   Temp_Hash_Index : INTEGER;
   Update_Interval : Calendar.DAY_DURATION;

   K_IITSEC_Bit_23_Mask : constant Numeric_Types.UNSIGNED_16_BIT
                            := 2#0000000010000000#;

   function "="(Left, Right : DG_Hash_Table_Support.ENTRY_STATUS_TYPE)
     return BOOLEAN
       renames DG_Hash_Table_Support."=";

   function "-"(Left, Right : Calendar.TIME)
     return DURATION
       renames Calendar."-";

   function "and"(Left, Right : Numeric_Types.UNSIGNED_16_BIT)
     return Numeric_Types.UNSIGNED_16_BIT
       renames Numeric_Types."and";

   function "="(Left, Right : Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
       renames Numeric_Types."=";

begin  -- DG_Remove_Expired_Entities

   Status := DG_Status.SUCCESS;

   Current_Time := Calendar.Clock;

   Search_For_Entities:
   for Entity_Index in 1..Simulation_Data.Entity_Hash_Table.Number_Of_Entries
   loop

      if (Simulation_Data.Entity_Hash_Table.Entry_Data(Entity_Index).Status
        = DG_Hash_Table_Support.IN_USE) then

         --
         -- Calculate time elapsed since last PDU was received for this
         -- entity.
         --
         Update_Interval
           := Current_Time
                - Simulation_Data.Entity_Reception_Time(Entity_Index);

         --
         -- Remove the entity if the last update was received longer ago than
         -- the expiration threshold, or if I/ITSEC "Bit 23" is supported and
         -- the bit is set.
         --
         if ((INTEGER(Update_Interval)
           >= DG_Server_GUI.Interface.Threshold_Parameters.Entity_Expiration)
             or else ((DG_Server_GUI.Interface.Exercise_Parameters.
               IITSEC_Bit_23_Support) and then ((Simulation_Data.
                 Entity_Data_Table(Entity_Index).Appearance.Specific and
                   K_IITSEC_Bit_23_Mask) = K_IITSEC_Bit_23_Mask))) then

            DG_Hash_Table_Support.Entity_Hash_Index(
              Command    => DG_Hash_Table_Support.DELETE,
              Entity_ID  => Simulation_Data.Entity_Data_Table(Entity_Index).
                              Entity_ID,
              Hash_Table => Simulation_Data.Entity_Hash_Table,
              Hash_Index => Temp_Hash_Index,
              Status     => Local_Status);

            if (DG_Status.Failure(Local_Status)) then
               DG_Server_Error_Processing.Report_Error(Local_Status);
            end if;

         else

            Entity_Total := Entity_Total + 1;

         end if;

      end if;

   end loop Search_For_Entities;

   --
   -- Update the number of network entities
   --
   DG_Server_GUI.Interface.Server_Monitor.Number_Of_Network_Entities
     := Entity_Total
          - DG_Server_GUI.Interface.Server_Monitor.Number_Of_Client_Entities;

exception

   when OTHERS =>

      Status := DG_Status.REE_FAILURE;

end DG_Remove_Expired_Entities;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
