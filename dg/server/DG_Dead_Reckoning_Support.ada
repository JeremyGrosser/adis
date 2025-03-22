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
-- PACKAGE NAME     : DG_Dead_Reckoning_Support
--
-- FILE NAME        : DG_Dead_Reckoning_Support.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 19, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with Calendar,
     Dead_Reckoning,
     DG_Hash_Table_Support,
     DG_Server_Error_Processing,
     DG_Server_Interface,
     DL_Status;

package body DG_Dead_Reckoning_Support is

   ---------------------------------------------------------------------------
   -- Update_Entity_Positions
   ---------------------------------------------------------------------------

   procedure Update_Entity_Positions(
      Status : out DG_Status.STATUS_TYPE) is

      Current_Time : Calendar.TIME := Calendar.Clock;
      Delta_Time   : INTEGER;
      Local_Status : DL_Status.STATUS_TYPE;

      function "="(Left, Right : DL_Status.STATUS_TYPE)
        return BOOLEAN
          renames DL_Status."=";

      function "="(Left, Right : DG_Hash_Table_Support.ENTRY_STATUS_TYPE)
        return BOOLEAN
          renames DG_Hash_Table_Support."=";

      function "-"(Left, Right : Calendar.TIME)
        return DURATION
          renames Calendar."-";

   begin  -- Update_Entity_Positions

      Status := DG_Status.SUCCESS;

      Check_Each_Entity:
      for Entity_Index in 1..DG_Server_Interface.Interface.Maximum_Entities
      loop

         --
         -- Check if valid entity data is stored in this entry.
         --
         if (DG_Server_Interface.Interface.Simulation_Data.Entity_Hash_Table.
           Entry_Data(Entity_Index).Status = DG_Hash_Table_Support.IN_USE)
         then

            --
            -- Calculate the number of microseconds elapsed since the last
            -- position update was performed.
            --
            Delta_Time
              := INTEGER(Current_Time
                   - DG_Server_Interface.Interface.Simulation_Data.
                       Entity_Update_Time(Entity_Index)) * 1_000_000;

            --
            -- Set the entity's position update time.
            --
            DG_Server_Interface.Interface.Simulation_Data.Entity_Update_Time(
              Entity_Index) := Current_Time;

            --
            -- Call DIS Library routine to update the dead reckoned position.
            --
            Dead_Reckoning.Update_Position(
              Entity_State_PDU => DG_Server_Interface.Interface.
                                    Simulation_Data.Entity_Data_Table(
                                      Entity_Index),
              Delta_Time       => Delta_Time,
              Status           => Local_Status);

         end if;  -- (Status = IN_USE)

      end loop Check_Each_Entity;

   exception

      when OTHERS =>

         Status := DG_Status.DRS_EEP_FAILURE;

   end Update_Entity_Positions;

end DG_Dead_Reckoning_Support;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
