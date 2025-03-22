--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Process_Fire_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  23 May 94
--
-- PURPOSE :
--   - The PFPDU CSU processes incoming Fire PDUs to determine whether a
--     munition should be activated.
--
-- IMPLEMENTATION NOTES :
--   -  This procedure requires Active_Frozen_Lists, DIS_PDU_Pointer_Types,
--      DIS_Types, Errors, Is_Parent, Numeric_Types, OS_GUI, and OS_Status.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--   - Until we can solve the Direction Cosine Matrices required to determine
--     the munition's orientation at firing or have orientation incorporated
--     into the Fire PDU, we assume the munition has the same orientation as
--     the parent.  This assumption is actually only reasonable for parents in
--     the air domain.  The orientation is stored in network parameters after
--     Initialize_Network_Parameters is called.  This assignment shoudld be
--     removed when the direction cosine matrice method or when orientation is
--     included in the Fire PDU to avoid overwriting the value.
--     OS_Hash_Table_Support should then be removed from the with list.
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     Errors,
     Is_Parent,
     OS_GUI,
     OS_Hash_Table_Support;

separate (Gateway_Interface)

procedure Process_Fire_PDU(
   FPDU_Pointer :  in     DIS_PDU_Pointer_Types.FIRE_PDU_PTR;
   Status       :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Status :  OS_Status.STATUS_TYPE;
   ESPDU_Pointer     :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Force_ID          :  DIS_Types.A_FORCE_ID;
   Hashing_Index     :  INTEGER;
   Orientation       :  DIS_Types.AN_EULER_ANGLES_RECORD;
   Returned_Status   :  OS_Status.STATUS_TYPE := OS_Status.SUCCESS;

   -- Local exception
   AM_ERROR   :  exception;
   GESD_ERROR :  exception;
   INP_ERROR  :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
     renames Numeric_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Process_Fire_PDU

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Determine if the firing entity is a parent
   if Is_Parent(Entity_ID => FPDU_Pointer.Firing_Entity_ID) then

      -- Get Force ID of munition from the parent
      Get_Entity_State_Data(
        Entity_ID     => FPDU_Pointer.Firing_Entity_ID,
        ESPDU_Pointer => ESPDU_Pointer,
        Status        => Returned_Status);

      if Returned_Status = OS_Status.SUCCESS then
         Force_ID    := ESPDU_Pointer.Force_ID;
         Orientation := ESPDU_Pointer.Orientation;
      else
         -- When direction cosine matrix solution is implemented, this branch
         -- should simply report an error and set Force_ID = OTHER_FORCE
         raise GESD_ERROR;
      end if;

      -- Set up network parameters entry for new munition
      Initialize_Network_Parameters(
        FPDU_Pointer  => FPDU_Pointer,
        Force_ID      => Force_ID,
        Hashing_Index => Hashing_Index,
        Status        => Returned_Status);

      if Returned_Status /= OS_Status.SUCCESS then
         raise INP_ERROR;
      end if;

      -- If and when the Fire PDU contains the orientation, this section of
      -- code should be removed to prevent overwriting the orientation
      -- Also remove OS_Hash_Table_Support from the with list.
      OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
        Network_Parameters.Entity_Orientation := Orientation;

      -- Place new munition on active list
      Active_Frozen_Lists.Activate_Munition(
        Entity_ID     => FPDU_Pointer.Munition_ID,
        Entity_Type   => FPDU_Pointer.Burst_Descriptor.Munition,
        Hashing_Index => Hashing_Index,
        Status        => Returned_Status);

      if Returned_Status /= OS_Status.SUCCESS then
         raise AM_ERROR;
      end if;

   end if;

exception
   when AM_ERROR =>
      -- Attempt to detonate munition
      Issue_Detonation_PDU(
        Detonation_Location => (OTHERS => 0.0),
        Detonation_Result   => DIS_Types.NONE,
        Hashing_Index       => Hashing_Index,
        Status              => Detonation_Status);
      if Detonation_Status /= OS_Status.SUCCESS then
         -- Report original error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
         -- Report detonation error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Detonation_Status);
      else
         -- Report original error
         Errors.Report_Error(
           Detonated_Prematurely => TRUE,
           Error                 => Returned_Status);
      end if;

   when GESD_ERROR | INP_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.PFPDU_ERROR;

end Process_Fire_PDU; 
