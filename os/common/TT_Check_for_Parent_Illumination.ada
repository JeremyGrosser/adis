--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Check_for_Parent_Illumination
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  18 August 94
--
-- PURPOSE :
--   - The CFPI CSU searches through the parent's Emission PDU to determine if
--     the target entity is being illumination.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_PDU_Pointer_Types,
--     DIS_Types, DL_Status, Errors, OS_Hash_Table_Support, OS_Status, and
--     PDU_Operators.
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
     DL_Status,
     Errors,
     OS_Hash_Table_Support,
     PDU_Operators;

separate (Target_Tracking)

procedure Check_for_Parent_Illumination(
   Hashing_Index      :  in     INTEGER;
   Target_Illuminated :     out BOOLEAN;
   Status             :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Beam_Data       :  PDU_Operators.A_BEAM_DATA_POINTER;
   Emission_PDU    :  DIS_PDU_Pointer_Types.EMISSION_PDU_PTR;
   Number_of_Beams :  NATURAL;
   Returned_Status :  OS_Status.STATUS_TYPE;
   Status_DG       :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;
   Status_DL       :  DL_Status.STATUS_TYPE := DL_Status.SUCCESS;
   System          :  PDU_Operators.AN_EMITTER_POINTER;

   -- Local exceptions
   DG_ERROR :  exception;
   DL_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function "=" (LEFT, RIGHT :  DIS_PDU_Pointer_Types.EMISSION_PDU_PTR)
     return BOOLEAN
     renames DIS_PDU_Pointer_Types."=";
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";
   function "=" (LEFT, RIGHT :  DIS_Types.AN_ENTITY_IDENTIFIER)
     return BOOLEAN
     renames DIS_Types."=";

begin -- Check_for_Parent_Illuminated

   -- Initialize status and illumination flag
   Status := OS_Status.SUCCESS;
   Target_Illuminated := FALSE;

   -- Get Emission PDU of parent
   DG_Client.Get_Entity_Emission(
     Entity_ID     => OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
                      Network_Parameters.Firing_Entity_ID,
     Emission_Info => Emission_PDU,
     Status        => Status_DG);
   if Status_DG /= DG_Status.SUCCESS then
      Returned_Status := OS_Status.DG_ERROR;
      raise DG_ERROR;
   end if;

   if Emission_PDU /= null then
      Search_Parent_Emission_for_Target:
      for System_Index in 1..Emission_PDU.Number_of_Systems loop
         PDU_Operators.Get_Emitter(
           Emission      => Emission_PDU.All,
           System_Number => NATURAL(System_Index),
           System        => System,
           Status        => Status_DL);
         if Status_DL /= DL_Status.SUCCESS then
            Returned_Status := OS_Status.DL_ERROR;
            raise DL_ERROR;
         end if;

         PDU_Operators.Get_Number_Of_Beams(
           Emission => Emission_PDU.All,
           System   => System.Emitter_System,
           Beams    => Number_of_Beams,
           Status   => Status_DL);
         if Status_DL /= DL_Status.SUCCESS then
            Returned_Status := OS_Status.DL_ERROR;
            raise DL_ERROR;
         end if;

         for Beam_Index in 1..Number_of_Beams loop
            PDU_Operators.Get_Beam(
              Beam_Number => Beam_Index,
              Emission    => System.All,
              Beam        => Beam_Data,
              Status      => Status_DL);
            if Status_DL /= DL_Status.SUCCESS then
               Returned_Status := OS_Status.DL_ERROR;
               raise DL_ERROR;
            end if;

            for Target_Index in 1..Beam_Data.Number_Of_Targets loop
               if OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
                  Network_Parameters.Target_Entity_ID
                 = Beam_Data.Track_Jam(Target_Index).Entity_ID
               then
                  Target_Illuminated := TRUE;
                  exit Search_Parent_Emission_for_Target;
               end if;
            end loop;
         end loop;
      end loop Search_Parent_Emission_for_Target;
   end if;

exception
   when DL_ERROR =>
      -- Report error here because calling routines will look at
      -- Target_Illuminated flag in addition to status
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   when OTHERS =>
      Status := OS_Status.CFPI_ERROR;
end Check_for_Parent_Illumination;

