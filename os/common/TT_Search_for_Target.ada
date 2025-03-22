--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Search_for_Target
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  22 June 94
--
-- PURPOSE :
--   - The SFT CSU looks for a new target.  The target must be within the cone
--     of detection for the munition and within line of sight.  The azimuth and
--     the elevation headings are also updated.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DCM_Calculations, DG_Client, DG_Status,
--     DIS_PDU_Pointer_Types, DIS_Types, DL_Linked_List_Types, DL_Status,
--     Errors, Filter_List, Gateway_Interface, Math, Numeric_Types, 
--     OS_Data_Types, OS_GUI, OS_Hash_Table_Support, OS_Status,
--     PDU_Operators, and Sort_List.
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
     DG_Client,
     DG_Status,
     DIS_PDU_Pointer_Types,
     DIS_Types,
     DL_Math,
     DL_Status,
     Errors,
     Filter_List,
     Gateway_Interface,
     Math,
     Numeric_Types,
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support,
     PDU_Operators,
     Sort_List;

separate (Target_Tracking)

procedure Search_for_Target(
   Hashing_Index        :  in     INTEGER;
   Illuminated_Entities :  in out DL_Linked_List_Types.Entity_State_List.PTR;
   Status               :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Beam_Data                   :  PDU_Operators.A_BEAM_DATA_POINTER;
   Emission_PDU                :  DIS_PDU_Pointer_Types.EMISSION_PDU_PTR;
   First_ESPDU                 :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Ground_Track_Range          :  OS_Data_Types.METERS;
   Number_of_Beams             :  NATURAL;
   Relative_Location           :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Returned_Status             :  OS_Status.STATUS_TYPE;
   Status_DG                   :  DG_Status.STATUS_TYPE;
   Status_DL                   :  DL_Status.STATUS_TYPE := DL_Status.SUCCESS;
   System                      :  PDU_Operators.AN_EMITTER_POINTER;
   Target_Illuminated          :  BOOLEAN;
   Target_List                 :  DL_Linked_List_Types.Entity_State_List.PTR;
   Tracked_Entity_Info         :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;

   -- Local exceptions
   CWLTE_ERROR :  exception;
   DG_ERROR    :  exception;
   DL_ERROR    :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function "=" (LEFT, RIGHT :  DIS_PDU_Pointer_Types.EMISSION_PDU_PTR)
     return BOOLEAN
     renames DIS_PDU_Pointer_Types."=";
   function "=" (LEFT, RIGHT :  DL_Linked_List_Types.Entity_State_List.PTR)
     return BOOLEAN
     renames DL_Linked_List_Types.Entity_State_List."=";
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
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
   Flight_Parameters      :  OS_Data_Types.FLIGHT_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Flight_Parameters;
   Network_Parameters     :  OS_Data_Types.NETWORK_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Network_Parameters;

begin -- Search_for_Target

   -- Initialize Status
   Status := OS_Status.SUCCESS;
   Target_Illuminated := FALSE;

   -- For parent illuminated entities, find an appropriate target
   if Aerodynamic_Parameters.Illumination_Flag = OS_Data_Types.PARENT
     and then Emission_PDU /= null
   then

      -- Create list of illuminated entities
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

            -- Determine if this is a tracking beam (Emitter and Beam IDs both
            -- equal to zero) or a jamming beam.
            if Beam_Data.Track_Jam(1).Emitter_ID = 0
              and then Beam_Data.Track_Jam(1).Beam_ID = 0 then

               Process_Tracked_Targets:
               for Target_Index in 1..Beam_Data.Number_Of_Targets loop

                  -- Get pointer to entity information from the DG
                  DG_Client.Get_Entity_Info(
                    Entity_ID   => Beam_Data.Track_Jam(Target_Index).
                                     Entity_ID,
                    Entity_Info => Tracked_Entity_Info,
                    Status      => Status_DG);

                  if Status_DG /= DG_Status.SUCCESS then
                     Returned_Status := OS_Status.DG_ERROR;
                     raise DG_ERROR;
                  end if;

                  -- Add the entity to the list of illuminated targets
                  DL_Linked_List_Types.Entity_State_List_Utilities.
                    Insert_Item_Top(
                      The_Item => Tracked_Entity_Info,
                      The_List => Illuminated_Entities,
                      Status   => Status_DL);

                  if Status_DL /= DL_Status.SUCCESS then
                     Returned_Status := OS_Status.DL_ERROR;
                     raise DL_ERROR;
                  end if;
               end loop Process_Tracked_Targets;

            end if;  -- Emitter_ID = 0 and Beam_ID = 0

         end loop;
      end loop Search_Parent_Emission_for_Target;

      -- Filter out all entities outside the cone of detection of the munition.
      -- As currently implemented, the filtering procedure accepts
      -- the azimuth angle in the range 0 - 360 and the elevation
      -- angle in the range (-180) - 180.  Therefore, the lower side of
      -- the azimuth detection angle has been biased by adding
      -- two PI to provide the correct range.
      Filter_List.Entity_State_Az_And_El.Filter_Az_And_El(
        First_Az_Threshold         => (-Aerodynamic_Parameters.
                                        Azimuth_Detection_Angle 
                                      + OS_Data_Types.K_Degrees_in_Circle),
        Second_Az_Threshold        => Aerodynamic_Parameters.
                                      Azimuth_Detection_Angle,
        First_El_Threshold         => - Aerodynamic_Parameters.
                                      Elevation_Detection_Angle,
        Second_El_Threshold        => Aerodynamic_Parameters.
                                      Elevation_Detection_Angle,
        Location                   => Network_Parameters.
                                      Location_in_WorldC,
        Orientation                => Network_Parameters.
                                      Entity_Orientation,
        The_List                   => Illuminated_Entities,
        Status                     => Status_DL);

      if Status_DL /= DL_Status.SUCCESS then
         Returned_Status := OS_Status.DL_ERROR;
         raise DL_ERROR;
      end if;

      -- Prioritize illuminated entities by distance
      -- Send list of illuminated entities to DIS Library to be prioritized by
      -- distance with closest entities first
      Sort_List.Entity_State_Distance.Sort_Distance(
        Ascending          => TRUE,
        Reference_Position => Network_Parameters.Location_in_WorldC,
        The_List           => Illuminated_Entities,
        Status             => Status_DL);
      if Status_DL /= DL_Status.SUCCESS then
         Returned_Status := OS_Status.DL_ERROR;
         raise DL_ERROR;
      end if;

      -- Access the first item on the list
      DL_Linked_List_Types.Entity_State_List_Utilities.Get_Item(
        The_List => Target_List,
        The_Item => First_ESPDU,
        Status   => Status_DL);
      if Status_DL /= DL_Status.SUCCESS then
         Target_Illuminated := FALSE;
         Returned_Status    := OS_Status.DL_ERROR;
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      else
         -- Target is first entity illuminated by parent within munition's cone
         -- of detection
         Target_Illuminated := TRUE;
      end if;

   -- For munition illuminated entities, find an appropriate target
   elsif Aerodynamic_Parameters.Illumination_Flag = OS_Data_Types.MUNITION
     and then Illuminated_Entities
      /= DL_Linked_List_Types.Entity_State_List.K_Null_List
   then
      -- Prioritize illuminated entities by distance
      -- Send list of illuminated entities to DIS Library to be prioritized by
      -- distance with closest entities first
      Sort_List.Entity_State_Distance.Sort_Distance(
        Ascending          => TRUE,
        Reference_Position => Network_Parameters.Location_in_WorldC,
        The_List           => Illuminated_Entities,
        Status             => Status_DL);
      if Status_DL /= DL_Status.SUCCESS then
         Returned_Status := OS_Status.DL_ERROR;
         raise DL_ERROR;
      end if;

      -- Since illuminated by the munition, the target is detectable so let the
      -- closest entity be the target
      DL_Linked_List_Types.Entity_State_List_Utilities.Get_Item(
        The_List => Illuminated_Entities,
        The_Item => First_ESPDU,
        Status   => Status_DL);
      if Status_DL /= DL_Status.SUCCESS then
         Returned_Status := OS_Status.DL_ERROR;
         raise DL_ERROR;
      end if;

      Target_Illuminated := TRUE;

   -- In the event the munition is illuminating its own targets but doesn't
   -- have any entities within its field or if the parent does not have any
   -- Emission PDUs, the munition should continue along its current path.
   -- Also true for laser guided munitions since they can only follow the laserG
   else
      -- Set heading of the target to heading of the munition
      -- Munition will continue to fly in its current direction
      Flight_Parameters.Target.Azimuth_Heading
        := Flight_Parameters.Munition_Azimuth_Heading;
      Flight_Parameters.Target.Elevation_Heading
        := Flight_Parameters.Munition_Elevation_Heading;
   end if;

   if Target_Illuminated then
      -- Target data is in the First ESPDU
      -- Convert the location vector into the munition's coordinate system
      DCM_Calculations.Convert_WorldC_Location_to_EntC(
        Offset_to_ECS      => Flight_Parameters.Firing_Data.Location_in_WorldC,
        WorldC_to_EntC_DCM => Flight_Parameters.DCM,
        Location_in_WorldC => First_ESPDU.Location,
        Location_in_EntC   => Flight_Parameters.Target.Location_in_EntC,
        Status             => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CWLTE_ERROR;
      end if;

      -- Set target ID to represent new target
      Network_Parameters.Target_Entity_ID         := First_ESPDU.Entity_ID;
      Flight_Parameters.Target.Location_in_WorldC := First_ESPDU.Location;
      Flight_Parameters.Target.Velocity_in_WorldC
        := First_ESPDU.Linear_Velocity;
      Flight_Parameters.Target.Velocity_Magnitude := Math.sqrt(
          First_ESPDU.Linear_Velocity.X * First_ESPDU.Linear_Velocity.X
        + First_ESPDU.Linear_Velocity.Y * First_ESPDU.Linear_Velocity.Y
        + First_ESPDU.Linear_Velocity.Z * First_ESPDU.Linear_Velocity.Z);

      -- Calculate components of distance from munition to target, ground
      -- track range and range to target
      Relative_Location.X := Flight_Parameters.Target.Location_in_EntC.X
        - Flight_Parameters.Location_in_EntC.X;
      Relative_Location.Y := Flight_Parameters.Target.Location_in_EntC.Y
        - Flight_Parameters.Location_in_EntC.Y;
      Relative_Location.Z := Flight_Parameters.Target.Location_in_EntC.Z
        - Flight_Parameters.Location_in_EntC.Z;

      Ground_Track_Range := Math.sqrt(Relative_Location.X
        * Relative_Location.X + Relative_Location.Y * Relative_Location.Y);
      Flight_Parameters.Range_to_Target := Numeric_Types.FLOAT_64_BIT(
        Math.sqrt(Ground_Track_Range * Ground_Track_Range
        + Relative_Location.Z * Relative_Location.Z));

      -- Calculate target's azimuth and elevation heading
      Flight_Parameters.Target.Azimuth_Heading   := DL_Math.atan2(
        Relative_Location.Y, Relative_Location.X);
      Flight_Parameters.Target.Elevation_Heading := DL_Math.atan2(
        Relative_Location.Z, Ground_Track_Range);

   else
      -- Set heading of the target to the heading of the munition
      -- Munition will continue to fly in its current direction
      Flight_Parameters.Target.Azimuth_Heading
        := Flight_Parameters.Munition_Azimuth_Heading;
      Flight_Parameters.Target.Elevation_Heading
        := Flight_Parameters.Munition_Elevation_Heading;

   end if;

exception
   when CWLTE_ERROR | DG_ERROR | DL_ERROR =>
      -- Set heading of the target to heading of the munition
      -- Munition will continue to fly in its current direction
      Flight_Parameters.Target.Azimuth_Heading
        := Flight_Parameters.Munition_Azimuth_Heading;
      Flight_Parameters.Target.Elevation_Heading
        := Flight_Parameters.Munition_Elevation_Heading;
      -- Report error and target remains as previous
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.SFT_ERROR;
      -- Set heading of the target to heading of the munition
      -- Munition will continue to fly in its current direction
      Flight_Parameters.Target.Azimuth_Heading
        := Flight_Parameters.Munition_Azimuth_Heading;
      Flight_Parameters.Target.Elevation_Heading
        := Flight_Parameters.Munition_Elevation_Heading;

end Search_for_Target;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 11 NOV 94 -- KJN:  Switched direction of Relative_Location calculations
-- 14 NOV 94 -- KJN:  Added check for munition illumination to if
--           Illuminated_Entites = null then statement
