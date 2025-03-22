--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Beam_Rider_Guidance
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  17 June 94
--
-- PURPOSE :
--   - The BRG CSU provides a guidance method where the munition proceeds
--     toward the target based on information about the parent's and the
--     munition's position and velocity.  This method is best suited for
--     munition's depending on the radar of a parent.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DCM_Calculations, DIS_PDU_Pointer_Types,
--     Gateway_Interface, Math, Numeric_Types, OS_Data_Types,
--     OS_Hash_Table_Support, and OS_Status.
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
with DCM_Calculations,
     DIS_PDU_Pointer_Types,
     DL_Math,
     Gateway_Interface,
     Math,
     Numeric_Types,
     OS_Hash_Table_Support;

separate (Fly_Out_Model)

procedure Beam_Rider_Guidance(
   Hashing_Index      :  in     INTEGER;
   Required_Azimuth   :     out OS_Data_Types.RADIANS;
   Required_Elevation :     out OS_Data_Types.RADIANS; 
   Status             :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Munition_Azimuth_from_Parent     :  OS_Data_Types.RADIANS;
   Munition_Elevation_from_Parent   :  OS_Data_Types.RADIANS;
   Munition_to_Parent_Range         :  OS_Data_Types.METERS;
   Parent_ESPDU                     :  DIS_PDU_Pointer_Types.
                                       ENTITY_STATE_PDU_PTR;
   Parent_Location_in_EntC          :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Parent_to_Munition               :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Parent_to_Munition_Grd_Trk_Range :  OS_Data_Types.METERS;
   Parent_to_Target                 :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Parent_to_Target_Grd_Trk_Range   :  OS_Data_Types.METERS;
   Returned_Status                  :  OS_Status.STATUS_TYPE;
   Target_Azimuth_from_Parent       :  OS_Data_Types.RADIANS;
   Target_Elevation_from_Parent     :  OS_Data_Types.RADIANS;
   Target_Location_in_EntC          :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;

   -- Local exceptions
   CWLTE_ERROR :  exception;
   GESD_ERROR  :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

   -- Rename variables
   Flight_Parameters  :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Beam_Rider_Guidance

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Get entity data for parent entity
   Gateway_Interface.Get_Entity_State_Data(
     Entity_ID     => Network_Parameters.Firing_Entity_ID,
     ESPDU_Pointer => Parent_ESPDU,
     Status        => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise GESD_ERROR;
   end if;

   -- Convert the parent's location into the entity coordinate system centered
   -- about the munition
   DCM_Calculations.Convert_WorldC_Location_to_EntC(
     Offset_to_ECS      => Flight_Parameters.Firing_Data.Location_in_WorldC,
     WorldC_to_EntC_DCM => Flight_Parameters.DCM,
     Location_in_WorldC => Parent_ESPDU.Location,
     Location_in_EntC   => Parent_Location_in_EntC,
     Status             => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise CWLTE_ERROR;
   end if;

   -- Calculate relative distances between target and parent, and munition
   -- and parent and the corresponding ground track ranges
   Parent_to_Munition.X := Parent_Location_in_EntC.X
     - Flight_Parameters.Location_in_EntC.X;
   Parent_to_Munition.Y := Parent_Location_in_EntC.Y
     - Flight_Parameters.Location_in_EntC.Y;
   Parent_to_Munition.Z := Parent_Location_in_EntC.Z
     - Flight_Parameters.Location_in_EntC.Z;
   Parent_to_Munition_Grd_Trk_Range := Math.sqrt(Parent_to_Munition.X
     * Parent_to_Munition.X + Parent_to_Munition.Y * Parent_to_Munition.Y);

   Parent_to_Target.X := Parent_Location_in_EntC.X
     - Flight_Parameters.Target.Location_in_EntC.X;
   Parent_to_Target.Y := Parent_Location_in_EntC.Y
     - Flight_Parameters.Target.Location_in_EntC.Y;
   Parent_to_Target.Z := Parent_Location_in_EntC.Z
     - Flight_Parameters.Target.Location_in_EntC.Z;
   Parent_to_Target_Grd_Trk_Range := Math.sqrt(Parent_to_Target.X
     * Parent_to_Target.X + Parent_to_Target.Y * Parent_to_Target.Y);

   -- Determine the azimuth and elevation angles between parent's radar
   -- and target
   Target_Azimuth_from_Parent     := DL_Math.atan2(
     Parent_to_Target.Y, Parent_to_Target.X);
   Target_Elevation_from_Parent   := DL_Math.atan2(
     Parent_to_Target.Z, Parent_to_Target_Grd_Trk_Range);

   -- Determine the azimuth and elevation angles between parent's radar
   -- and munition
   Munition_Azimuth_from_Parent   := DL_Math.atan2(
     Parent_to_Munition.Y, Parent_to_Munition.X);
   Munition_Elevation_from_Parent := DL_Math.atan2(
     Parent_to_Munition.Z, Parent_to_Munition_Grd_Trk_Range);

   -- Determine the slant range of the munition from the parent's radar
   Munition_to_Parent_Range       := Math.sqrt(
       Parent_to_Munition_Grd_Trk_Range * Parent_to_Munition_Grd_Trk_Range
     + Parent_to_Munition.Z * Parent_to_Munition.Z);

   -- Calculate azimuth required to ride beam toward target
   -- RA = TargAzfrPar + arcsin(MunParRange * sin(TargAzfrPar - MunAzfrPar)
   --                           / VelMag * cos(MunElv) * CycleTime)
   Required_Azimuth :=  Target_Azimuth_from_Parent
     + DL_Math.asin(Munition_to_Parent_Range
       * Math.sin(Target_Azimuth_from_Parent - Munition_Azimuth_from_Parent)
       / (Flight_Parameters.Velocity_Magnitude
         * Math.cos(Flight_Parameters.Munition_Elevation_Heading)
         * Flight_Parameters.Cycle_Time));

   -- Calculate elevation required to ride beam toward target
   -- RE = TargElvfrPar + arcsin(MunParRange * sin(TargElvfrPar - MunElvfrPar)
   --                           / VelMag * cos(MunAz - MunAzfrPar) * CycleTime)
   Required_Elevation :=  Target_Elevation_from_Parent
     + DL_Math.asin(Munition_to_Parent_Range
       * Math.sin(Target_Elevation_from_Parent
         - Munition_Elevation_from_Parent)
       / (Flight_Parameters.Velocity_Magnitude
         * Math.cos(Flight_Parameters.Munition_Azimuth_Heading
           - Munition_Azimuth_from_Parent)
         * Flight_Parameters.Cycle_Time));

exception
   when CWLTE_ERROR | GESD_ERROR =>
      Status := Returned_Status;

   when OTHERS =>
      Status := OS_Status.BRG_ERROR;

end Beam_Rider_Guidance;
