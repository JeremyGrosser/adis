--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Initialize_Network_Parameters
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  9 June 94
--
-- PURPOSE :
--   - The INP CSU places data related to PDUs in a hash table by copying the
--     relevant data from the Fire PDU when a Fire PDU from a parent entity is
--     received.  Additional PDU data will be available from the user through
--     the GUI.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_PDU_Pointer_Types, DIS_Types,
--     OS_Data_Types, OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with OS_Data_Types,
     OS_Hash_Table_Support;

separate (Gateway_Interface)

procedure Initialize_Network_Parameters(
   Force_ID      :  in     DIS_Types.A_FORCE_ID;
   FPDU_Pointer  :  in     DIS_PDU_Pointer_Types.FIRE_PDU_PTR;
   Hashing_Index :     out INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   New_Hashing_Index :  INTEGER; 
   Returned_Status   :  OS_Status.STATUS_TYPE;  -- Status returned from call

   -- Local exceptions
   MEHI_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Initialize_Network_Parameters

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   OS_Hash_Table_Support.Modify_Entity_Hashing_Index(
     Entity_ID     =>  FPDU_Pointer.Munition_ID,
     Modify_Hash   =>  OS_Hash_Table_Support.ADD,
     Hashing_Index =>  New_Hashing_Index,
     Status        =>  Returned_Status);

   if Returned_Status = OS_Status.SUCCESS then

      Assign_Network_Parameters_Block:
      declare
         -- Rename variables
         Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
           renames OS_Hash_Table_Support.Munition_Hash_Table(
           New_Hashing_Index).Network_Parameters;

      begin --Assign_Network_Parameters_Block

         Hashing_Index := New_Hashing_Index;

         Network_Parameters.Burst_Descriptor   := FPDU_Pointer.
           Burst_Descriptor;

         Network_Parameters.Entity_ID          := FPDU_Pointer.Munition_ID;
         Network_Parameters.Event_ID           := FPDU_Pointer.Event_ID;
         Network_Parameters.Firing_Entity_ID   := FPDU_Pointer.
           Firing_Entity_ID;
         Network_Parameters.Force_ID           := Force_ID;
         Network_Parameters.Location_in_WorldC := FPDU_Pointer.World_Location;
         Network_Parameters.Target_Entity_ID   := FPDU_Pointer.
           Target_Entity_ID;
         Network_Parameters.Velocity_in_WorldC := FPDU_Pointer.Velocity;

      end Assign_Network_Parameters_Block;

   else -- Returned_Status is not success
      raise MEHI_ERROR;
   end if;

exception
   when MEHI_ERROR =>
      Status := Returned_Status;
   when OTHERS =>
      Status := OS_Status.INP_ERROR;

end Initialize_Network_Parameters;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 12 NOV 94 -- KJN:  Added initialization of Force_ID
