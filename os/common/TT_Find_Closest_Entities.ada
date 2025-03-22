
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Find_Closest_Entities
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  9 August 94
--
-- PURPOSE :
--   - The FCE CSU finds the entities location in a sphere with a radius equal
--     to the current maximum range of the munition.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_PDU_Pointer_Types,
--     DIS_Types, DL_Linked_List_Types, DL_Status, Errors, Filter_List,
--     Gateway_Interface, Numeric_Types, OS_Data_Types, OS_GUI,
--     OS_Hash_Table_Support, OS_Simulation_Types, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with DG_Client,
     DG_Status,
     DIS_PDU_Pointer_Types,
     DIS_Types,
     DL_Linked_List_Types,
     DL_Status,
     Errors,
     Filter_List,
     Gateway_Interface,
     Numeric_Types,
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support,
     OS_Simulation_Types;
     

separate (Target_Tracking)

procedure Find_Closest_Entities(
   Hashing_Index   :  in     INTEGER;
   Status          :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Munition_ESPDU            :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Munition_Position_on_List :  POSITIVE;
   Parent_ESPDU              :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Parent_Position_on_List   :  POSITIVE;
   Possible_Targets_List     :  DL_Linked_List_Types.Entity_State_List.PTR;
   Returned_Status           :  OS_Status.STATUS_TYPE;
   Status_DG                 :  DG_Status.STATUS_TYPE; -- Status of DG calls
   Status_DL                 :  DL_Status.STATUS_TYPE; -- Status of DL calls

   -- Local exceptions
   DG_ERROR :  exception;
   DL_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters      :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Simulation_Parameters  :  OS_Simulation_Types.SIMULATION_PARAMETERS_RECORD
     renames OS_GUI.Interface.Simulation_Parameters;
   Termination_Parameters :  OS_Data_Types.TERMINATION_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Termination_Parameters;

begin -- Find_Closest_Entities

   -- Initialize status
   Status := OS_Status.SUCCESS;

   if (Flight_Parameters.Loop_Counter mod Simulation_Parameters.
     Number_of_Loops_Until_Update) = 0 then
      -- Increment Loop Counter
      Flight_Parameters.Loop_Counter := Flight_Parameters.Loop_Counter + 1;

      -- Acquire a list of ALL entities
      DG_Client.Get_Entity_List(
        Entity_List => Possible_Targets_List,
        Status      => Status_DG);
      if Status_DG /= DG_Status.SUCCESS then
         Returned_Status := OS_Status.DG_ERROR;
         raise DG_ERROR;
      end if;

      -- Use the DL's filtering routines to reduce the entity list to a short
      -- list of entities within the sphere of radius equal to the maximum
      -- range of the munition reduced by the distance travelled before this
      -- timeslice
      Filter_List.Entity_State_Distance.Filter_Distance(
        Reference_Position => OS_Hash_Table_Support.Munition_Hash_Table(
                              Hashing_Index).Network_Parameters.
                              Location_in_WorldC,
        Threshold          => (Termination_Parameters.Max_Range
                               - Termination_Parameters.Previous_Range),
        The_List           => Possible_Targets_List,
        Status             => Status_DL);
      if Status_DL /= DL_Status.SUCCESS then
         Returned_Status := OS_Status.DL_ERROR;
         raise DL_ERROR;
      end if;

      -- Request pointer to parent's entity state PDU
      Gateway_Interface.Get_Entity_State_Data(
        Entity_ID     => OS_Hash_Table_Support.Munition_Hash_Table(
                         Hashing_Index).Network_Parameters.Firing_Entity_ID,
        ESPDU_Pointer => Parent_ESPDU,
        Status        => Returned_Status);
      -- If parent is not found then it could not possibly become a target
      -- If parent is on the list, remove it so it won't be considered a target
      if Returned_Status = OS_Status.SUCCESS then
         -- Now remove parent from this shorter list
         DL_Linked_List_Types.Entity_State_List_Utilities.
           Find_Position_Of_Item(
           The_Item => Parent_ESPDU,
           The_List => Possible_Targets_List,
           Position => Parent_Position_on_List,
           Status   => Status_DL);
         if Status_DL = DL_Status.SUCCESS then
            -- Parent was found on list
            DL_Linked_List_Types.Entity_State_List_Utilities.
              Delete_Item_And_Free_Storage(
                The_List    => Possible_Targets_List,
                At_Position => Parent_Position_on_List,
                Status      => Status_DL);
            if Status_DL /= DL_Status.SUCCESS then
               -- Report error
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => OS_Status.DL_ERROR);
            end if;
         else
            -- Report error
            Errors.Report_Error(
              Detonated_Prematurely => FALSE,
              Error                 => OS_Status.DL_ERROR);
         end if;
      end if;

      -- Request pointer to munition's entity state PDU
      Gateway_Interface.Get_Entity_State_Data(
        Entity_ID     => OS_Hash_Table_Support.Munition_Hash_Table(
                         Hashing_Index).Network_Parameters.Entity_ID,
        ESPDU_Pointer => Munition_ESPDU,
        Status        => Returned_Status);
      -- Returned_Status would not be success and not an error during the
      -- first timeslice of a munition's fly-out because a munition will
      -- not exist in the DG's entity data table since it will not have
      -- issued an Entity State PDU yet; no other errors should occur in GESD
      if Returned_Status = OS_Status.SUCCESS then
         -- Now remove munition from this shorter list
         DL_Linked_List_Types.Entity_State_List_Utilities.
           Find_Position_Of_Item(
           The_Item => Munition_ESPDU,
           The_List => Possible_Targets_List,
           Position => Munition_Position_on_List,
           Status   => Status_DL);
         if Status_DL = DL_Status.SUCCESS then
            -- Munition was found on list
            DL_Linked_List_Types.Entity_State_List_Utilities.
              Delete_Item_And_Free_Storage(
                The_List    => Possible_Targets_List,
                At_Position => Munition_Position_on_List,
                Status      => Status_DL);
            if Status_DL /= DL_Status.SUCCESS then
               -- Report error
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => OS_Status.DL_ERROR);
            end if;
         else
            -- Report error
            Errors.Report_Error(
              Detonated_Prematurely => FALSE,
              Error                 => OS_Status.DL_ERROR);
         end if;
      end if;

      Flight_Parameters.Possible_Targets_List := Possible_Targets_List;

   else
      Flight_Parameters.Loop_Counter := Flight_Parameters.Loop_Counter + 1;
   end if;

exception
   when DG_ERROR | DL_ERROR =>
      Status := Returned_Status;

   when OTHERS =>
      Status := OS_Status.FCE_ERROR;

end Find_Closest_Entities;
