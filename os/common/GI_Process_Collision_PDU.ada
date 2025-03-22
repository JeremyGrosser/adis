--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Collision_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  17 May 94
--
-- PURPOSE :
--   - The PCPDU CSU processes incoming Collision PDUs to incorporate the
--     effects of the collisions.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Active_Frozen_Lists, DCM_Calculations, 
--     Detonation_Event, DIS_PDU_Pointer_Types, DIS_Types, Errors, Math,
--     OS_Data_Types, OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--   - This unit uses DL_Math_.ada to allow usage of the atan2 and asin
--     functions which were omitted from the most recent (6.2.1) compiler
--     update.  When these functions are included in the Verdix compiler,
--     simply change DL_Math to just Math in the code and eliminate DL_Math
--     from the list of withed packages.
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     DCM_Calculations,
     Detonation_Event,
     DL_Math,
     Errors,
     Math,
     OS_Data_Types,
     OS_Hash_Table_Support;

separate (Gateway_Interface)

procedure Process_Collision_PDU(
   CPDU_Pointer :  in     DIS_PDU_Pointer_Types.COLLISION_PDU_PTR;
   Status       :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Collision_Location_in_WorldC   :  DIS_Types.A_WORLD_COORDINATE;
   Detonation_Location            :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Detonation_Result              :  DIS_Types.A_DETONATION_RESULT;
   Detonation_Status              :  OS_Status.STATUS_TYPE;
   Geocentric_Location            :  DIS_Types.A_WORLD_COORDINATE;
   Issuing_Entity_DCM             :  OS_Data_Types.
                                     DIRECTION_COSINE_MATRIX_RECORD;
   Issuing_Entity_ESPDU           :  DIS_PDU_Pointer_Types.
                                     ENTITY_STATE_PDU_PTR;
   Location_Rel_to_Issuing_Entity :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Node_Pointer                   :  Active_Frozen_Lists.
                                     LINKED_LIST_ENTRY_RECORD_PTR;
   Returned_Status                :  OS_Status.STATUS_TYPE;
   Trig_of_Issuing_Eulers         :  OS_Data_Types.TRIG_OF_EULER_ANGLES_RECORD;

   -- Local exceptions
   CDCM_ERROR   :  exception;
   CELTW_ERROR  :  exception;
   CWLTE_ERROR  :  exception;
   FEDBID_ERROR :  exception;
   GESD_ERROR   :  exception;

   -- Rename functions
   function "=" (
     LEFT, RIGHT :  Active_Frozen_Lists.LINKED_LIST_ENTRY_RECORD_PTR)
     return BOOLEAN
     renames Active_Frozen_Lists."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Process_Collision_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Determine whether the collision involves an active munition
   Active_Frozen_Lists.Find_Entity_Data_By_ID(
     Entity_ID           => CPDU_Pointer.Colliding_Entity_ID,
     Top_of_List_Pointer => Active_Frozen_Lists.Top_of_Active_List_Pointer,
     Node_Pointer        => Node_Pointer,
     Status              => Returned_Status);

   if Returned_Status /= OS_Status.SUCCESS then
      -- Will appear as if no match was found
      raise FEDBID_ERROR;
   end if;

   if Node_Pointer /= null then

      -- Get entity information about the issuing entity
      Get_Entity_State_Data(
        Entity_ID     => CPDU_Pointer.Issuing_Entity_ID,
        ESPDU_Pointer => Issuing_Entity_ESPDU,
        Status        => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise GESD_ERROR; 
      end if;

      -- Convert collision location from munition's coordinate system to the
      -- world coordinate system
      DCM_Calculations.Convert_EntC_Location_to_WorldC(
        Offset_to_ECS      => OS_Hash_Table_Support.Munition_Hash_Table(
                              Node_Pointer.Munition_Data_Pointer.Hashing_Index)
                              .Flight_Parameters.Firing_Data.Location_in_WorldC,
        EntC_to_WorldC_DCM => OS_Hash_Table_Support.Munition_Hash_Table(
                              Node_Pointer.Munition_Data_Pointer.Hashing_Index)
                              .Flight_Parameters.Inverse_DCM,
        Location_in_EntC   => CPDU_Pointer.Entity_Location,
        Location_in_WorldC => Collision_Location_in_WorldC,
        Status             => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CELTW_ERROR;
      end if;

      -- Calculate the direction cosine matrix which converts from the world
      -- coordinate system to the issuing entity's coordinate system
      Trig_of_Issuing_Eulers.Cos_Psi   := Math.cos(Issuing_Entity_ESPDU.
        Orientation.Psi);
      Trig_of_Issuing_Eulers.Sin_Psi   := Math.sin(Issuing_Entity_ESPDU.
        Orientation.Psi);
      Trig_of_Issuing_Eulers.Cos_Theta := Math.cos(Issuing_Entity_ESPDU.
        Orientation.Theta);
      Trig_of_Issuing_Eulers.Sin_Theta := Math.sin(Issuing_Entity_ESPDU.
        Orientation.Theta);
      Trig_of_Issuing_Eulers.Cos_Phi   := Math.cos(Issuing_Entity_ESPDU.
        Orientation.Phi);
      Trig_of_Issuing_Eulers.Sin_Phi   := Math.sin(Issuing_Entity_ESPDU.
        Orientation.Phi);

      DCM_Calculations.Calculate_DCM(
        Trig_of_Eulers => Trig_of_Issuing_Eulers,
        DCM_Values     => Issuing_Entity_DCM,
        Status         => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CDCM_ERROR;
      end if;

      -- To have the resulting vector in the proper direction, multiply
      -- Collision_Location_in_WorldC by negative one.
      Collision_Location_in_WorldC.X := - Collision_Location_in_WorldC.X;
      Collision_Location_in_WorldC.Y := - Collision_Location_in_WorldC.Y;
      Collision_Location_in_WorldC.Z := - Collision_Location_in_WorldC.Z;

      -- Now convert the collision location into the issuing entity's
      -- coordinate system
      DCM_Calculations.Convert_WorldC_Location_to_EntC(
        Offset_to_ECS      => Issuing_Entity_ESPDU.Location,
        WorldC_to_EntC_DCM => Issuing_Entity_DCM,
        Location_in_WorldC => Collision_Location_in_WorldC,
        Location_in_EntC   => Location_Rel_to_Issuing_Entity,
        Status             => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CWLTE_ERROR;
      end if;

      -- Issue Collision PDU in response to collision
      Issue_Collision_PDU(
        Colliding_Entity_ID => CPDU_Pointer.Issuing_Entity_ID,
        Collision_Location  => Location_Rel_to_Issuing_Entity,
        Hashing_Index       => Node_Pointer.Munition_Data_Pointer.
                               Hashing_Index,
        Status              => Returned_Status);

      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error and continue
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

      -- Prepare to detonate munition (regardless of whether an error occurred
      -- when attempting to issue the response Collision PDU)
      case OS_Hash_Table_Support.Munition_Hash_Table(
        Node_Pointer.Munition_Data_Pointer.Hashing_Index).
        Termination_Parameters.Fuze is

         when DIS_Types.CONTACT | DIS_Types.CONTACT_INSTANT |
           DIS_Types.CONTACT_DELAYED | DIS_Types.PROXIMITY =>
            -- Determine detonation result to be issued
            -- This unit will automatically issue a Detonation PDU
            Detonation_Event.Determine_Detonation_Result(
              Hashing_Index    => Node_Pointer.Munition_Data_Pointer.
                                  Hashing_Index,
              Target_Entity_ID => CPDU_Pointer.Issuing_Entity_ID,
              Status           => Returned_Status);

           if Returned_Status /= OS_Status.SUCCESS then
              -- Since no idea what caused error, report error and make attempt
              -- to Deactivate Munition
              Errors.Report_Error(
                Detonated_Prematurely => FALSE,
                Error                 => Returned_Status);
              Active_Frozen_Lists.Deactivate_Munition(
                Entity_ID => Node_Pointer.Munition_Data_Pointer.Entity_ID,
                Status    => Returned_Status);
              if Returned_Status /= OS_Status.SUCCESS then
                 -- Report error
                 Errors.Report_Error(
                   Detonated_Prematurely => FALSE,
                   Error                 => Returned_Status);
              end if;
           end if;

         when OTHERS =>
            -- Detonate regardless of fuse with a result of NONE
            Detonation_Result     := DIS_Types.NONE;
            Detonation_Location.X := 0.0;
            Detonation_Location.Y := 0.0;
            Detonation_Location.Z := 0.0;
            Issue_Detonation_PDU(
              Detonation_Location => Detonation_Location,
              Detonation_Result   => Detonation_Result,
              Hashing_Index       => Node_Pointer.Munition_Data_Pointer.
                                     Hashing_Index,
              Status              => Returned_Status);
           if Returned_Status /= OS_Status.SUCCESS then
              -- Report error
              Errors.Report_Error(
                Detonated_Prematurely => FALSE,
                Error                 => Returned_Status);
           end if;

           Active_Frozen_Lists.Deactivate_Munition(
             Entity_ID => Node_Pointer.Munition_Data_Pointer.Entity_ID,
             Status    => Returned_Status);
           if Returned_Status /= OS_Status.SUCCESS then
              -- Report error
              Errors.Report_Error(
                Detonated_Prematurely => FALSE,
                Error                 => Returned_Status);
           end if;
      end case;
   end if;

exception
   when FEDBID_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when CDCM_ERROR | CELTW_ERROR | CWLTE_ERROR | GESD_ERROR =>
      Errors.Detonate_Due_to_Error(
        Detonation_Result => DIS_Types.ENTITY_IMPACT,
        Hashing_Index     => Node_Pointer.Munition_Data_Pointer.Hashing_Index,
        Status            => Detonation_Status);
      -- Detonation should not be considered premature since a detonation was
      -- required
      -- Report original error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Detonation_Status);

   when OTHERS =>
      Status := OS_Status.PCPDU_ERROR;

end Process_Collision_PDU;
