--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Get_Events
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  17 May 94
--
-- PURPOSE :
--   - The GE CSU allows incoming events to be processed by calling the
--     appropriate unit for the incoming event.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Generic_PDU,
--     DG_Status, DIS_Types, Errors, OS_GUI, OS_Simulation_Types and
--     OS_Status.
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
     Errors,
     OS_GUI,
     OS_Simulation_Types;

separate (Gateway_Interface)

procedure Get_Events(
   Events_List_Empty :  out BOOLEAN;
   Status            :  out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Event_PDU_Pointer :  DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Returned_Status   :  OS_Status.STATUS_TYPE;
   Simulation_State  :  OS_Simulation_Types.SIMULATION_STATE_TYPE;
   Status_DG         :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;
   Time_Remaining    :  BOOLEAN;

   -- Local exception
   DG_ERROR     :  exception;
   PCPDU_ERROR  :  exception;
   PDPDU_ERROR  :  exception;
   PFPDU_ERROR  :  exception;
   PSMPDU_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE)
     return BOOLEAN
     renames DG_Generic_PDU."=";
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function "=" (LEFT, RIGHT :  OS_Simulation_Types.SIMULATION_STATE_TYPE)
     return BOOLEAN
     renames OS_Simulation_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Get_Events

   -- Initialize status and list empty flag
   Status := OS_Status.SUCCESS;
   Events_List_Empty := FALSE;

   -- Call DIS Gateway for next PDU
   DG_Client.Get_Next_PDU(
     PDU_Pointer => Event_PDU_Pointer,
     Status      => Status_DG);

   -- In case of error in DG
   if Status_DG /= DG_Status.SUCCESS then
      Event_PDU_Pointer := null;
      Events_List_Empty := TRUE;
      Returned_Status := OS_Status.DG_ERROR;
      raise DG_ERROR;
   end if; 

   -- Check for null pointer
   if Event_PDU_Pointer /= null then

      -- Process PDU based on Simulation State
      Simulation_State
        := OS_GUI.Interface.Simulation_Parameters.Simulation_State;
      case DG_Generic_PDU.Generic_Ptr_to_PDU_Header_Ptr(Event_PDU_Pointer).
        PDU_Type is

         when DIS_Types.COLLISION => 
            if Simulation_State /= OS_Simulation_Types.FREEZE then
               Process_Collision_PDU(
                 CPDU_Pointer => DG_Generic_PDU.
                                 Generic_Ptr_to_Collision_PDU_Ptr(
                                 Event_PDU_Pointer),
                 Status       => Returned_Status);
               if Returned_Status /= OS_Status.SUCCESS then
                  raise PCPDU_ERROR;
               end if;
            end if;

         when DIS_Types.DETONATION =>
            if Simulation_State /= OS_Simulation_Types.FREEZE then
               Process_Detonation_PDU(
                 DPDU_Pointer => DG_Generic_PDU.
                                 Generic_Ptr_to_Detonation_PDU_Ptr(
                                 Event_PDU_Pointer),
                 Status       => Returned_Status);
               if Returned_Status /= OS_Status.SUCCESS then
                   raise PDPDU_ERROR;
               end if;
            end if;

         when DIS_Types.FIRE =>
            if Simulation_State /= OS_Simulation_Types.FREEZE then
               Process_Fire_PDU(
                 FPDU_Pointer => DG_Generic_PDU.Generic_Ptr_to_Fire_PDU_Ptr(
                                 Event_PDU_Pointer),
                 Status       => Returned_Status);
               if Returned_Status /= OS_Status.SUCCESS then
                  raise PFPDU_ERROR;
               end if;
            end if;

         when DIS_Types.CREATE_ENTITY | DIS_Types.REMOVE_ENTITY |
           DIS_Types.START_OR_RESUME | DIS_Types.STOP_OR_FREEZE =>
             Process_Sim_Mgmt_PDU(
               SMPDU_Pointer => Generic_Ptr_to_SMPDU_Header_Ptr(
                                Event_PDU_Pointer),
               Status        => Returned_Status);
             if Returned_Status /= OS_Status.SUCCESS then
                raise PSMPDU_ERROR;
             end if;

         when OTHERS =>
            null;

      end case;

      DG_Generic_PDU.Free_Generic_PDU(Event_PDU_Pointer);

   else

      -- No more events to process
      Events_List_Empty := TRUE;

   end if;

exception
   when DG_ERROR =>
      Status := Returned_Status;
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when PCPDU_ERROR | PDPDU_ERROR | PFPDU_ERROR | PSMPDU_ERROR =>
      DG_Generic_PDU.Free_Generic_PDU(Event_PDU_Pointer);

   when OTHERS =>
      Status := OS_Status.GE_ERROR;

end Get_Events;
