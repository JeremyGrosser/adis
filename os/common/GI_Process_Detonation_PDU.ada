--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Detonation_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  19 May 94
--
-- PURPOSE :
--   - The PDPDU CSU processes incoming Detonation PDUs to incorporate the
--     effects of the detonations.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Active_Frozen_Lists, Detonation_Event,
--     DIS_PDU_Pointer_Types, DIS_Types, Errors, Math, Numeric_Types,
--     OS_Data_Types, OS_GUI, OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     Detonation_Event,
     Errors,
     Math,
     Numeric_Types,
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support;

separate (Gateway_Interface)

procedure Process_Detonation_PDU(
   DPDU_Pointer :  in     DIS_PDU_Pointer_Types.DETONATION_PDU_PTR;
   Status       :     out OS_Status.STATUS_TYPE) 
  is

   -- Local variables
   Detonation_Location    :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Detonation_Result      :  DIS_Types.A_DETONATION_RESULT;
   Detonation_Status      :  OS_Status.STATUS_TYPE;
   Distance_to_Detonation :  OS_Data_Types.METERS_DP;
   Node_Pointer           :  Active_Frozen_Lists.LINKED_LIST_ENTRY_RECORD_PTR;
   Returned_Status        :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   DDR_ERROR :  exception;

   -- Rename functions
   function "=" (
     LEFT, RIGHT :  Active_Frozen_Lists.LINKED_LIST_ENTRY_RECORD_PTR)
     return BOOLEAN
     renames Active_Frozen_Lists."=";
   function "=" (LEFT, RIGHT :  DIS_Types.A_DETONATION_RESULT)
     return BOOLEAN
     renames DIS_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Process_Detonation_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- If the incoming detonation does not have a general detonation result,
   -- then determine type of detonation required for munition 
   if DPDU_Pointer.Detonation_Result /= DIS_Types.DETONATION
     and then DPDU_Pointer.Detonation_Result /= DIS_Types.NONE
   then

      Active_Frozen_Lists.Find_Entity_Data_By_ID(
        Entity_ID           => DPDU_Pointer.Target_Entity_ID,
        Top_of_List_Pointer => Active_Frozen_Lists.Top_of_Active_List_Pointer,
        Node_Pointer        => Node_Pointer, 
        Status              => Returned_Status);

      if Returned_Status /= OS_Status.SUCCESS then
         -- Since Node_Pointer isn't set until the last step of FEDBID and is
         -- initialized null, report error and allow if-block to handle the
         -- rest.
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

     if Node_Pointer /= null then

        -- Calculate distance to detonation location
        Distance_to_Detonation := Numeric_Types.FLOAT_64_BIT(Math.sqrt(
            DPDU_Pointer.Entity_Location.X * DPDU_Pointer.Entity_Location.X
          + DPDU_Pointer.Entity_Location.Y * DPDU_Pointer.Entity_Location.Y
          + DPDU_Pointer.Entity_Location.Z * DPDU_Pointer.Entity_Location.Z));

        case DPDU_Pointer.Burst_Descriptor.Fuze is

           when DIS_Types.CONTACT | DIS_Types.CONTACT_INSTANT |
             DIS_Types.CONTACT_DELAYED =>
              -- If conditions of contact fuse are met, then determine
              -- detonation result
              if Distance_to_Detonation
                <= OS_GUI.Interface.Simulation_Parameters.Contact_Threshold
              then
                 Detonation_Event.Determine_Detonation_Result(
                   Hashing_Index    => Node_Pointer.Munition_Data_Pointer.
                                       Hashing_Index,
                   Target_Entity_ID => DPDU_Pointer.Munition_ID,
                   Status           => Returned_Status);

                 -- In case of an error, attempt a general detonation
                 if Returned_Status /= OS_Status.SUCCESS then
                    raise DDR_ERROR;
                 end if;

              else
                 -- Due to inconsistency between incoming network traffic and
                 -- OS model, detonate with NONE result
                 Errors.Detonate_Due_to_Error(
                   Detonation_Result => DIS_Types.NONE,
                   Hashing_Index     => Node_Pointer.Munition_Data_Pointer.
                                        Hashing_Index,
                   Status            => Returned_Status);

                 if Returned_Status /= OS_Status.SUCCESS then
                    -- Report error
                    Errors.Report_Error(
                      Detonated_Prematurely => FALSE,
                      Error                 => Returned_Status);
                 end if;
              end if;
 
           when DIS_Types.PROXIMITY =>
              -- If conditions of proximity fuse are met, then determine
              -- detonation result
              if Distance_to_Detonation
                <= OS_Hash_Table_Support.Munition_Hash_Table(Node_Pointer.
                Munition_Data_Pointer.Hashing_Index).Termination_Parameters.
                Detonation_Proximity_Distance
              then
                 Detonation_Event.Determine_Detonation_Result(
                   Hashing_Index    => Node_Pointer.Munition_Data_Pointer.
                                       Hashing_Index,
                   Target_Entity_ID => DPDU_Pointer.Munition_ID,
                   Status           => Returned_Status);

                 if Returned_Status /= OS_Status.SUCCESS then
                    raise DDR_ERROR;
                 end if;

              else
                 -- Due to inconsistency between incoming network traffic and
                 -- OS model, detonate with NONE result
                 Errors.Detonate_Due_to_Error(
                   Detonation_Result => DIS_Types.NONE,
                   Hashing_Index     => Node_Pointer.Munition_Data_Pointer.
                                        Hashing_Index,
                   Status            => Returned_Status);

                 if Returned_Status /= OS_Status.SUCCESS then
                    -- Report error
                    Errors.Report_Error(
                      Detonated_Prematurely => FALSE,
                      Error                 => Returned_Status);
                 end if;
              end if;

           when OTHERS =>
              -- Due to inconsistency between incoming network traffic and
              -- OS model, detonate with NONE result
              Errors.Detonate_Due_to_Error(
                Detonation_Result => DIS_Types.NONE,
                Hashing_Index     => Node_Pointer.Munition_Data_Pointer.
                                     Hashing_Index,
                Status            => Returned_Status);

              if Returned_Status /= OS_Status.SUCCESS then
                 -- Report error
                 Errors.Report_Error(
                   Detonated_Prematurely => FALSE,
                   Error                 => Returned_Status);
              end if;

        end case;

      end if;

   end if;

exception
   when DDR_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

      Errors.Detonate_Due_to_Error(
        Detonation_Result => DIS_Types.DETONATION,
        Hashing_Index     => Node_Pointer.Munition_Data_Pointer.
                             Hashing_Index,
        Status            => Detonation_Status);

      -- Detonation was not premature
      if Detonation_Status /= OS_Status.SUCCESS then
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Detonation_Status);
      end if;
 
   when OTHERS =>
      Status := OS_Status.PDPDU_ERROR;

end Process_Detonation_PDU;
