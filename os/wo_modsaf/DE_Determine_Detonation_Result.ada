--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Determine_Detonation_Result
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  25 May 94
--
-- PURPOSE :
--   - The DDR CSU determines the result of a detonation.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Active_Frozen_Lists, Coordinate_Conversions,
--     DCM_Calculations, DIS_PDU_Pointer_Types, DL_Types, Errors, 
--     Gateway_Interface, Math, Numeric_Types, OS_Data_Types, OS_GUI, 
--     OS_Hash_Table_Support, and OS_Status.
--   - After the result is determined, calls are made to issue the Detonation
--     PDU and deactivate the munition.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :
--   - This unit uses DL_Math_.ada to allow usage of the asin and atan2
--     functions which were omitted from the most recent (6.2.1) compiler
--     update.  When these functions are included in the Verdix compiler,
--     simply change DL_Math to just Math in the code and eliminate DL_Math
--     from the list of withed packages.
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     Coordinate_Conversions,
     DCM_Calculations,
     DIS_PDU_Pointer_Types,
     DL_Math,
     DL_Status,
     DL_Types,
     Errors,
     Gateway_Interface,
     Math,
     Numeric_Types,
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support;

separate (Detonation_Event)

procedure Determine_Detonation_Result(
   Hashing_Index    :  in     INTEGER;
   Target_Entity_ID :  in     DIS_Types.AN_ENTITY_IDENTIFIER;
   Status           :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Location    :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Detonation_Result      :  DIS_Types.A_DETONATION_RESULT;
   Detonation_Status      :  OS_Status.STATUS_TYPE;
   Entity_Impact_Occurred :  BOOLEAN;
   Geodetic_Position      :  DL_Types.THE_GEODETIC_COORDINATES;
   Relative_Location      :  DIS_Types.A_WORLD_COORDINATE;
   Returned_Status        :  OS_Status.STATUS_TYPE;
   Status_DL              :  DL_Status.STATUS_TYPE := DL_Status.SUCCESS;
   Target_DCM             :  OS_Data_Types.DIRECTION_COSINE_MATRIX_RECORD;
   Target_ESPDU           :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Trig_of_Target_Eulers  :  OS_Data_Types.TRIG_OF_EULER_ANGLES_RECORD;

   -- Local exceptions
   DL_ERROR   :  exception;
   DM_ERROR   :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_16_BIT)
     return BOOLEAN
     renames Numeric_Types."=";
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters      :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters     :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;
   Termination_Parameters :  OS_Data_Types.TERMINATION_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Termination_Parameters;

begin -- Determine_Detonation_Result

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Initialize flag for entity impact
   Entity_Impact_Occurred := FALSE;

   if not (Target_Entity_ID.Sim_Address.Site_ID = 0
     and then Target_Entity_ID.Sim_Address.Application_ID = 0
     and then Target_Entity_ID.Entity_ID = 0)
   then

      -- Set target entity id for issuing Detonation PDU
      Network_Parameters.Target_Entity_ID := Target_Entity_ID;

      -- Get data about target from DG
      Gateway_Interface.Get_Entity_State_Data(
        Entity_ID     => Target_Entity_ID,
        ESPDU_Pointer => Target_ESPDU, 
        Status        => Returned_Status);

      if Returned_Status /= OS_Status.SUCCESS then
         -- Since this is an if block all target-related checks are avoided
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      else
         -- Calculate range to target
         Relative_Location.X := Network_Parameters.Location_in_WorldC.X
           - Target_ESPDU.Location.X;
         Relative_Location.Y := Network_Parameters.Location_in_WorldC.Y
           - Target_ESPDU.Location.Y;
         Relative_Location.Z := Network_Parameters.Location_in_WorldC.Z
           - Target_ESPDU.Location.Z;

         Flight_Parameters.Range_to_Target := Math.sqrt(
             Relative_Location.X * Relative_Location.X
           + Relative_Location.Y * Relative_Location.Y
           + Relative_Location.Z * Relative_Location.Z);

         -- Now check for detonations related to target
         -- Check for Hard Kill first
         if Flight_Parameters.Range_to_Target <=
           Termination_Parameters.Hard_Kill
         then
            Detonation_Result := DIS_Types.ENTITY_IMPACT;
            -- Determine the direction cosine matrix to convert from the world
            -- coordinate system to the target's coordinate system
            Trig_of_Target_Eulers.Cos_Psi   := Math.cos(
              Target_ESPDU.Orientation.Psi);
            Trig_of_Target_Eulers.Sin_Psi   := Math.sin(
              Target_ESPDU.Orientation.Psi);
            Trig_of_Target_Eulers.Cos_Theta := Math.cos(
              Target_ESPDU.Orientation.Theta);
            Trig_of_Target_Eulers.Sin_Theta := Math.sin(
              Target_ESPDU.Orientation.Theta);
            Trig_of_Target_Eulers.Cos_Phi   := Math.cos(
              Target_ESPDU.Orientation.Phi);
            Trig_of_Target_Eulers.Sin_Phi   := Math.sin(
              Target_ESPDU.Orientation.Phi);

            DCM_Calculations.Calculate_DCM(
              Trig_of_Eulers => Trig_of_Target_Eulers,
              DCM_Values     => Target_DCM,
              Status         => Returned_Status);
            if Returned_Status = OS_Status.SUCCESS then
               -- Convert the munition's location into the target's coordinate
               -- system
               DCM_Calculations.Convert_WorldC_Location_to_EntC(
                 Offset_to_ECS      => Target_ESPDU.Location,
                 WorldC_to_EntC_DCM => Target_DCM,
                 Location_in_WorldC => Network_Parameters.Location_in_WorldC,
                 Location_in_EntC   => Detonation_Location,
                 Status             => Returned_Status);
               if Returned_Status /= OS_Status.SUCCESS then
                  -- Report error
                  Errors.Report_Error(
                    Detonated_Prematurely => FALSE,
                    Error                 => Returned_Status);
                  -- Set detonation location
                  Detonation_Location.X := 0.0;
                  Detonation_Location.Y := 0.0;
                  Detonation_Location.Z := 0.0;
               end if;
            else
               -- Report error
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => Returned_Status);
               -- Set detonation location
               Detonation_Location.X := 0.0;
               Detonation_Location.Y := 0.0;
               Detonation_Location.Z := 0.0;
            end if;

            Entity_Impact_Occurred := TRUE;

         -- Then check for proximity damage
         elsif Flight_Parameters.Range_to_Target
           <= Termination_Parameters.Range_to_Damage
         then
            Detonation_Result := DIS_Types.ENTITY_PROXIMATE_DETONATION;
            -- Determine the direction cosine matrix to convert from the world
            -- coordinate system to the target's coordinate system
            Trig_of_Target_Eulers.Cos_Psi   := Math.cos(
              Target_ESPDU.Orientation.Psi);
            Trig_of_Target_Eulers.Sin_Psi   := Math.sin(
              Target_ESPDU.Orientation.Psi);
            Trig_of_Target_Eulers.Cos_Theta := Math.cos(
              Target_ESPDU.Orientation.Theta);
            Trig_of_Target_Eulers.Sin_Theta := Math.sin(
              Target_ESPDU.Orientation.Theta);
            Trig_of_Target_Eulers.Cos_Phi   := Math.cos(
              Target_ESPDU.Orientation.Phi);
            Trig_of_Target_Eulers.Sin_Phi   := Math.sin(
              Target_ESPDU.Orientation.Phi);

            DCM_Calculations.Calculate_DCM(
              Trig_of_Eulers => Trig_of_Target_Eulers,
              DCM_Values     => Target_DCM,
              Status         => Returned_Status);
            if Returned_Status = OS_Status.SUCCESS then
               -- Convert the munition's location into the target's coordinate
               -- system
               DCM_Calculations.Convert_WorldC_Location_to_EntC(
                 Offset_to_ECS      => Target_ESPDU.Location,
                 WorldC_to_EntC_DCM => Target_DCM,
                 Location_in_WorldC => Network_Parameters.Location_in_WorldC,
                 Location_in_EntC   => Detonation_Location,
                 Status             => Returned_Status);
               if Returned_Status /= OS_Status.SUCCESS then
                  Entity_Impact_Occurred := TRUE;
                  -- Report error
                  Errors.Report_Error(
                    Detonated_Prematurely => FALSE,
                    Error                 => Returned_Status);
                  -- Set detonation location
                  Detonation_Location.X := 0.0;
                  Detonation_Location.Y := 0.0;
                  Detonation_Location.Z := 0.0;
               end if;
            else
               -- Report error
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => Returned_Status);
               -- Set detonation location
               Detonation_Location.X := 0.0;
               Detonation_Location.Y := 0.0;
               Detonation_Location.Z := 0.0;
            end if;

            Entity_Impact_Occurred := TRUE;

         end if;
      end if;
   end if;

   -- If there was no entity impact, look for a ground impact
   if not Entity_Impact_Occurred then
      -- Get height above terrain through conversion to Lat/Lon/Alt using WGS84
      Coordinate_Conversions.Geocentric_To_Geodetic_Conversion(
	Geocentric_Coordinates => Network_Parameters.Location_in_WorldC,
	Geodetic_Coordinates   => Geodetic_Position,
	Status                 => Status_DL);
      if Status_DL /= DL_Status.SUCCESS then
         raise DL_ERROR;
      end if;

      -- Add database offset
      Geodetic_Position.Altitude := Geodetic_Position.Altitude 
	+ K_Database_Offset;

      if Geodetic_Position.Altitude <= 0.0 then
         Detonation_Result     := DIS_Types.GROUND_IMPACT;
         Detonation_Location.X := 0.0;
         Detonation_Location.Y := 0.0;
         Detonation_Location.Z := 0.0;
         Network_Parameters.Target_Entity_ID.Sim_Address.Site_ID := 0;
         Network_Parameters.Target_Entity_ID.Sim_Address.Application_ID := 0;
         Network_Parameters.Target_Entity_ID.Entity_ID := 0;

      elsif Geodetic_Position.Altitude <= OS_Hash_Table_Support.
        Munition_Hash_Table(Hashing_Index).Termination_Parameters.
        Range_to_Damage
      then
         Detonation_Result     := DIS_Types.GROUND_PROXIMATE_DETONATION;
         Detonation_Location.X := 0.0;
         Detonation_Location.Y := 0.0;
         Detonation_Location.Z := 0.0;
         Network_Parameters.Target_Entity_ID.Sim_Address.Site_ID := 0;
         Network_Parameters.Target_Entity_ID.Sim_Address.Application_ID := 0;
         Network_Parameters.Target_Entity_ID.Entity_ID := 0;

      else -- Provide for a general detonation since no impacts detected
         Detonation_Result     := DIS_Types.DETONATION;
         Detonation_Location.X := 0.0;
         Detonation_Location.Y := 0.0;
         Detonation_Location.Z := 0.0;
         Network_Parameters.Target_Entity_ID.Sim_Address.Site_ID := 0;
         Network_Parameters.Target_Entity_ID.Sim_Address.Application_ID := 0;
         Network_Parameters.Target_Entity_ID.Entity_ID := 0;
      end if;

   end if;

   -- Generate and send Detonation PDU
   Gateway_Interface.Issue_Detonation_PDU(
     Detonation_Location => Detonation_Location,
     Detonation_Result   => Detonation_Result,
     Hashing_Index       => Hashing_Index,
     Status              => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if; 

   -- Remove munition from simulation
   Active_Frozen_Lists.Deactivate_Munition(
     Entity_ID => Network_Parameters.Entity_ID,
     Status    => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise DM_ERROR;
   end if;

exception
   when DL_ERROR =>
      Network_Parameters.Target_Entity_ID.Sim_Address.Site_ID := 0;
      Network_Parameters.Target_Entity_ID.Sim_Address.Application_ID := 0;
      Network_Parameters.Target_Entity_ID.Entity_ID := 0;
      Errors.Detonate_Due_to_Error(
        Detonation_Result => DIS_Types.DETONATION,
        Hashing_Index     => Hashing_Index,
        Status            => Detonation_Status);
      -- Detonation was not premature!
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
      if Detonation_Status /= OS_Status.SUCCESS then
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Detonation_Status);
      end if;

   when DM_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.DDR_ERROR;

end Determine_Detonation_Result;
