--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Calculate_Firing_Orientation
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 October 94
--
-- PURPOSE :
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Errors, Math, Numeric_Types, OS_Data_Types,
--     OS_Hash_Table_Support, and OS_Status.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--   - This unit uses DL_Math_.ada to allow usage of the asin and atan2
--     functions which were omitted from the most recent (6.2.1) compiler
--     update.  When these functions are included in the Verdix compiler,
--     simply change DL_Math to just Math in the code and eliminate DL_Math
--     from the list of withed packages.
--   - If and when the orientation is added to the Fire PDU, the orientation
--     can simply be used rather than calculated.
--
------------------------------------------------------------------------------
with DL_Math,
     Errors,
     Math,
     Numeric_Types,
     OS_Hash_Table_Support;

separate (DCM_Calculations)

procedure Calculate_Firing_Orientation(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   EA_Trig               :  OS_Data_Types.TRIG_OF_EULER_ANGLES_RECORD;
   Returned_Status       :  OS_Status.STATUS_TYPE;
   Trig_of_Parent_Eulers :  OS_Data_Types.TRIG_OF_EULER_ANGLES_RECORD;

   -- Local exceptions
   CDCM_ERROR  :  exception;
   CIDCM_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT:  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Calculate_Firing_Orientation

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- This call may be replaced with the orientation from the Fire PDU
   -- once the Fire PDU is modified
   Calculate_Euler_Angles(
     Hashing_Index => Hashing_Index,
     Euler_Angles  => Flight_Parameters.Firing_Data.Orientation,
     Status        => Returned_Status);

   if Returned_Status = OS_Status.SUCCESS then

      -- Calculate trig components needed to solve for DCM
      EA_Trig.Cos_Psi   := Math.cos(
        Flight_Parameters.Firing_Data.Orientation.Psi);
      EA_Trig.Sin_Psi   := Math.sin(
        Flight_Parameters.Firing_Data.Orientation.Psi);
      EA_Trig.Cos_Theta := Math.cos(
        Flight_Parameters.Firing_Data.Orientation.Theta);
      EA_Trig.Sin_Theta := Math.sin(
        Flight_Parameters.Firing_Data.Orientation.Theta);
      EA_Trig.Cos_Phi   := 1.0;  -- cos(0)
      EA_Trig.Sin_Phi   := 0.0;  -- sin(0)

      -- Calculate DCM to convert from World to Entity
      Calculate_DCM(
        Trig_of_Eulers => EA_Trig,
        DCM_Values     => Flight_Parameters.DCM,
        Status         => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CDCM_ERROR;
      end if;

      -- Calculate Inverse DCM to convert from Entity to World
      Calculate_Inverse_DCM(
        DCM_Values         => Flight_Parameters.DCM,
        Inverse_DCM_Values => Flight_Parameters.Inverse_DCM,
        Status             => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CIDCM_ERROR;
      end if;

      Network_Parameters.Entity_Orientation := Flight_Parameters.
        Firing_Data.Orientation;

   else -- An error occurred in Calculate_Euler_Angles
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

      -- Use parent's orientation since an error occurred calculating
      -- firing orientation of munition (previously stored in Firing Data's
      -- Orientation field) 
      -- Calculate trig components of parent's Euler angles to solve for DCM
      Trig_of_Parent_Eulers.Cos_Psi   := Math.cos(Flight_Parameters.
        Firing_Data.Orientation.Psi);
      Trig_of_Parent_Eulers.Sin_Psi   := Math.sin(Flight_Parameters.
        Firing_Data.Orientation.Psi);
      Trig_of_Parent_Eulers.Cos_Theta := Math.cos(Flight_Parameters.
        Firing_Data.Orientation.Theta);
      Trig_of_Parent_Eulers.Sin_Theta := Math.sin(Flight_Parameters.
        Firing_Data.Orientation.Theta);
      Trig_of_Parent_Eulers.Cos_Phi   := Math.cos(Flight_Parameters.
        Firing_Data.Orientation.Phi);
      Trig_of_Parent_Eulers.Sin_Phi   := Math.sin(Flight_Parameters.
        Firing_Data.Orientation.Phi);

      -- Calculate DCM to convert from World to Entity
      Calculate_DCM(
        Trig_of_Eulers => Trig_of_Parent_Eulers,
        DCM_Values     => Flight_Parameters.DCM,
        Status         => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CDCM_ERROR;
      end if;

      -- Calculate Inverse DCM to convert from Entity to World
      Calculate_Inverse_DCM(
        DCM_Values         => Flight_Parameters.DCM,
        Inverse_DCM_Values => Flight_Parameters.Inverse_DCM,
        Status             => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CIDCM_ERROR;
      end if;

   end if;

exception
   when CDCM_ERROR | CIDCM_ERROR =>
      Status := Returned_Status;

   when OTHERS =>
      Status := OS_Status.CFO_ERROR;

end Calculate_Firing_Orientation;
