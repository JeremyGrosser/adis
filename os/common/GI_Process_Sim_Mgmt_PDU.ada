--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Sim_Mgmt_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  17 May 94
--
-- PURPOSE :
--    - The PSMPDU CSU processes Simulation Management PDUs allowing the state
--      of the entity in a simulation, the state of a simulation to change, or
--      an entity to be removed from the simulation.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Errors, Numeric_Types, OS_GUI, and
--     OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--    - Incorporate enumerations for Response Flag
--
------------------------------------------------------------------------------
with Errors,
     OS_GUI;

separate (Gateway_Interface)

procedure Process_Sim_Mgmt_PDU(
   SMPDU_Pointer :  in     SMPDU_HEADER_TYPE_PTR;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Returned_Status :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   PSREPDU_ERROR :  exception;
   PSFEPDU_ERROR :  exception;
   PREPDU_ERROR  :  exception;
   IAPDU_ERROR   :  exception;
   PSRSPDU_ERROR :  exception;
   PSFSPDU_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
     renames Numeric_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Process_Sim_Mgmt_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Determine whether the PDU was sent to a specific entity under
   -- OS CSCI control
   if SMPDU_Pointer.Receiving_Entity_ID.Sim_Address.Site_ID
      = OS_GUI.Interface.Simulation_Parameters.Parent_Entity_ID.Sim_Address.
      Site_ID
     and then SMPDU_Pointer.Receiving_Entity_ID.Sim_Address.Application_ID
      = OS_GUI.Interface.Simulation_Parameters.Parent_Entity_ID.Sim_Address.
      Application_ID
   then

      case SMPDU_Pointer.PDU_Header.PDU_Type is

         when DIS_Types.START_OR_RESUME =>
            Process_Start_Resume_Entity_PDU(
              SRPDU_Pointer => SMPDU_Pointer,
              Status        => Returned_Status);
            if Returned_Status /= OS_Status.SUCCESS then
               raise PSREPDU_ERROR;
            end if;

         when DIS_Types.STOP_OR_FREEZE =>
            Process_Stop_Freeze_Entity_PDU(
              SFPDU_Pointer => SMPDU_Pointer,
              Status        => Returned_Status);
            if Returned_Status /= OS_Status.SUCCESS then
               raise PSFEPDU_ERROR;
            end if;

         when DIS_Types.REMOVE_ENTITY => 
            Process_Remove_Entity_PDU(
              REPDU_Pointer => SMPDU_Pointer,
              Status        => Returned_Status);
            if Returned_Status /= OS_Status.SUCCESS then
               raise PREPDU_ERROR;
            end if;

         when DIS_Types.CREATE_ENTITY =>
            -- Entities are not created based on Sim Mgmt PDUs so the only
            -- action is to issue an Acknowledge PDU
            -- Ordinarily, the response flag would be set to indicate no
            -- action was taken, but the enumerations for the response flag
            -- are not defined for DIS Version 2.0.3.
            Issue_Acknowledge_PDU(
              Acknowledge_Flag      => DIS_Types.CREATE_ENTITY,
              Originating_Entity_ID => SMPDU_Pointer.Receiving_Entity_ID,
              Receiving_Entity_ID   => SMPDU_Pointer.Originating_Entity_ID,
              Response_Flag         => 0,
              Status                => Returned_Status);
            if Returned_Status /= OS_Status.SUCCESS then
               raise IAPDU_ERROR;
            end if;

         when OTHERS =>
            null;

      end case;

   -- Determine whether the PDU was sent as a general message to all sites
   -- (represented by all ones in binary)
   elsif SMPDU_Pointer.Receiving_Entity_ID.Sim_Address.Site_ID = 16#FFFF#
     or else SMPDU_Pointer.Receiving_Entity_ID.Sim_Address.Application_ID
       = 16#FFFF#
   then

      case SMPDU_Pointer.PDU_Header.PDU_Type is

         when DIS_Types.START_OR_RESUME =>
            Process_Start_Resume_Simulation_PDU(
              SRPDU_Pointer => SMPDU_Pointer,
              Status        => Returned_Status);
            if Returned_Status /= OS_Status.SUCCESS then
               raise PSRSPDU_ERROR;
            end if;

         when DIS_Types.STOP_OR_FREEZE =>
            Process_Stop_Freeze_Simulation_PDU(
              SFPDU_Pointer => SMPDU_Pointer,
              Status        => Returned_Status);
            if Returned_Status /= OS_Status.SUCCESS then
               raise PSFSPDU_ERROR;
            end if;

         when OTHERS =>
            null;

      end case;
   end if;

exception
   when PSREPDU_ERROR | PSFEPDU_ERROR | PREPDU_ERROR | IAPDU_ERROR |
     PSRSPDU_ERROR | PSFSPDU_ERROR =>
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.PSMPDU_ERROR;

end Process_Sim_Mgmt_PDU;
