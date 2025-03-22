--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Update_Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 June 94
--
-- PURPOSE :
--   - The UPM CSU manages all activity of each munition for the current
--     timeslice.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Detonation_Event, DL_Linked_List_Types,
--     DL_Status, Errors, Filter_List, Fly_Out_Model, Gateway_Interface,
--     Numeric_Types, OS_Data_Types, OS_Hash_Table_Support,
--     OS_Simulation_Types, OS_Status, and Target_Tracking.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Detonation_Event,
     DL_Linked_List_Types,
     DL_Status,
     Errors,
     Filter_List,
     Fly_Out_Model,
     Gateway_Interface,
     Numeric_Types,
     OS_Hash_Table_Support,
     OS_Simulation_Types,
     Target_Tracking;


separate (Munition)

procedure Update_Munition(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Status    :  OS_Status.STATUS_TYPE;
   Illuminated_Entities :  DL_Linked_List_Types.Entity_State_List.PTR;
   Returned_Status      :  OS_Status.STATUS_TYPE;
   Status_DL            :  DL_Status.STATUS_TYPE := DL_Status.SUCCESS;

   -- Local exceptions
   CFD_ERROR    :  exception;
   DL_ERROR     :  exception;
   FCE_ERROR    :  exception;
   IESPDU_ERROR :  exception;
   MM_ERROR     :  exception;
   UT_ERROR     :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
     renames Numeric_Types."=";
   function "=" (LEFT, RIGHT :  OS_Data_Types.ILLUMINATION_IDENTIFIER)
     return BOOLEAN
     renames OS_Data_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Aerodynamic_Parameters :  OS_Data_Types.AERODYNAMIC_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Aerodynamic_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Update_Munition

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Generate short list of entities close to munition (for emission and
   -- detonation purposes)
   Target_Tracking.Find_Closest_Entities(
     Hashing_Index => Hashing_Index,
     Status        => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      raise FCE_ERROR;
   end if;

   -- Only update the munition's target if target data is required for the
   -- fly-out model
   case OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters.Fly_Out_Model_ID is

      -- Fly-out models which require target data
      when OS_Data_Types.FOM_AAM | OS_Data_Types.FOM_ASM |
        OS_Data_Types.FOM_SAM =>
         Illuminated_Entities := OS_Hash_Table_Support.Munition_Hash_Table(
           Hashing_Index).Flight_Parameters.Possible_Targets_List;

         -- If targets are illuminated by the munition, send an Emission PDU
         if Aerodynamic_Parameters.Illumination_Flag = OS_Data_Types.MUNITION
         then
            -- As currently implemented, the filtering procedure accepts
	    -- the azimuth angle in the range 0 - 360 and the elevation
	    -- angle in the range (-180) - 180.  Therefore, the lower side of
	    -- the azimuth detection angle has been biased by adding
	    -- two PI to provide the correct range
            Filter_List.Entity_State_Az_And_El.Filter_Az_And_El(
              First_Az_Threshold    => (-Aerodynamic_Parameters.
                                         Azimuth_Detection_Angle 
				       + OS_Data_Types.K_Degrees_in_Circle),
              Second_Az_Threshold   => Aerodynamic_Parameters.
                                       Azimuth_Detection_Angle,
              First_El_Threshold    => - Aerodynamic_Parameters.
                                       Elevation_Detection_Angle,
              Second_El_Threshold   => Aerodynamic_Parameters.
                                       Elevation_Detection_Angle,
              Location              => Network_Parameters.
                                       Location_in_WorldC,
              Orientation           => Network_Parameters.
                                       Entity_Orientation,
              The_List              => Illuminated_Entities,
              Status                => Status_DL);

            if Status_DL /= DL_Status.SUCCESS then
               Returned_Status := OS_Status.DL_ERROR;
               raise DL_ERROR;
            end if;

            --
	    -- Issue_Emission_PDU commented out until Emission PDUs can be
	    -- handled by the gateway
	    -- 
	    -- Gateway_Interface.Issue_Emission_PDU(
            --  Hashing_Index        => Hashing_Index,
            --  Illuminated_Entities => Illuminated_Entities,
            --  Status               => Returned_Status);
            -- if Returned_Status /= OS_Status.SUCCESS then
            --   -- Report error and continue processing
            --   Errors.Report_Error(
            --     Detonated_Prematurely => FALSE,
            --     Error                 => Returned_Status);
            -- end if;
         end if;

         Target_Tracking.Update_Target(
           Hashing_Index        => Hashing_Index,
           Illuminated_Entities => Illuminated_Entities,
           Status               => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            raise UT_ERROR;
         end if;

      -- Fly-out models which do not require target data
      when OS_Data_Types.FOM_Kinematic | OS_Data_Types.FOM_DRA_FPW =>
        null;

   end case;

   Fly_Out_Model.Move_Munition(
     Hashing_Index        => Hashing_Index,
     Illuminated_Entities => Illuminated_Entities,
     Status               => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise MM_ERROR;
   end if;

   if Network_Parameters.Entity_ID.Sim_Address.Site_ID /= 0
     and then Network_Parameters.Entity_ID.Sim_Address.Application_ID /= 0
     and then Network_Parameters.Entity_ID.Entity_ID /= 0
   then

      Gateway_Interface.Issue_Entity_State_PDU(
        Hashing_Index => Hashing_Index,
        Status        => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error but continue processing as normal
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

   end if;

   Detonation_Event.Check_for_Detonation(
     Hashing_Index => Hashing_Index,
     Status        => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise CFD_ERROR;
   end if;

exception
   when CFD_ERROR | DL_ERROR | FCE_ERROR | MM_ERROR | UT_ERROR =>
      Errors.Detonate_Due_to_Error(
        Detonation_Result => DIS_Types.NONE,
        Hashing_Index     => Hashing_Index,
        Status            => Detonation_Status);

      if Detonation_Status = OS_Status.SUCCESS then
         -- Report original error
         Errors.Report_Error(
           Detonated_Prematurely => TRUE,
           Error                 => Returned_Status);
      else
         -- Report original error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
         -- Report error from Detonate_Due_to_Error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;
 
   when OTHERS =>
      Status := OS_Status.UPM_ERROR;

end Update_Munition;
