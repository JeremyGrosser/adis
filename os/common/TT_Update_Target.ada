--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Update_Target
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  22 June 94
--
-- PURPOSE :
--   - The UT CSU makes a call for the most recent position and velocity
--     of the target and then determines whether this entity is still a
--     reasonable target.  If not, a call is made to find a new target.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DCM_Calculations, DG_Client, DG_Status, 
--     DIS_PDU_Pointer_Types, DIS_Types, DL_Linked_List_Types, DL_Status, 
--     Errors, Gateway_Interface, Math, Numeric_Types, OS_Data_Types, OS_GUI,
--     OS_Hash_Table_Support, and OS_Status.
--   - Errors from calling units are reported as handled successfully even
--     though no action is taken because the target ID has a value regardless
--     of processing in Search_for_Target.
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
     Gateway_Interface,
     Math,
     Numeric_Types,
     OS_Data_Types, OS_GUI,
     OS_Hash_Table_Support;


separate (Target_Tracking)

procedure Update_Target(
   Hashing_Index        :  in     INTEGER;
   Illuminated_Entities :  in out DL_Linked_List_Types.Entity_State_List.PTR;
   Status               :     out OS_Status.STATUS_TYPE)
  is
  
   -- Local variables
   First_ESPDU                 :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Ground_Track_Range          :  OS_Data_Types.METERS;
   Laser_PDU                   :  DIS_PDU_Pointer_Types.LASER_PDU_PTR;
   Relative_Location           :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Relative_Azimuth            :  OS_Data_Types.RADIANS;
   Relative_Elevation          :  OS_Data_Types.RADIANS;
   Returned_Status             :  OS_Status.STATUS_TYPE;
   Size                        :  NATURAL;
   Status_DG                   :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;
   Status_DL                   :  DL_Status.STATUS_TYPE := DL_Status.SUCCESS;
   Target_ESPDU                :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
   Target_Illuminated          :  BOOLEAN;
   Target_List                 :  DL_Linked_List_Types.Entity_State_List.PTR;
   Target_Location             :  DIS_Types.A_WORLD_COORDINATE;
   Target_Point                :  BOOLEAN;
   Target_Velocity             :  DIS_Types.A_LINEAR_VELOCITY_VECTOR;

   -- Local exceptions
   CWLTE_ERROR :  exception;
   DG_ERROR    :  exception;
   DL_ERROR    :  exception;
   GESD_ERROR  :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DIS_PDU_Pointer_Types.LASER_PDU_PTR)
     return BOOLEAN
     renames DIS_PDU_Pointer_Types."=";
   function "=" (LEFT, RIGHT :  DIS_Types.AN_ENTITY_IDENTIFIER)
     return BOOLEAN
     renames DIS_Types."=";
   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
     return BOOLEAN
     renames Numeric_Types."=";
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_16_BIT)
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

begin -- Update_Target

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Initialize Target Illuminated flag and Target Point flag
   Target_Illuminated := FALSE;
   Target_Point       := FALSE;

   -- Check whether a target entity has been identified
   if Network_Parameters.Target_Entity_ID.Sim_Address.Site_ID /= 0
     and then Network_Parameters.Target_Entity_ID.Sim_Address.Application_ID
      /= 0
     and then Network_Parameters.Target_Entity_ID.Entity_ID /= 0
   then

      -- Check whether the illuminating entity is illuminating the target
      if Aerodynamic_Parameters.Illumination_Flag = OS_Data_Types.PARENT then
         Check_for_Parent_Illumination(
           Hashing_Index      => Hashing_Index,
           Target_Illuminated => Target_Illuminated,
           Status             => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            -- Report error
            Errors.Report_Error(
              Detonated_Prematurely => FALSE,
              Error                 => Returned_Status);
         end if;

      elsif Aerodynamic_Parameters.Illumination_Flag = OS_Data_Types.MUNITION
      then
         -- When the munition is illuminating, loop through all the entities
         -- in the Illuminated Entities list until the target is found or the
         -- list is empty

         -- Determine number of illuminated entities
         DL_Linked_List_Types.Entity_State_List_Utilities.Get_Size(
           The_List => Illuminated_Entities,
           Size     => Size,
           Status   => Status_DL);
         if Status_DL /= DL_Status.SUCCESS then
            Returned_Status    := OS_Status.DL_ERROR;
            -- Report error
            Errors.Report_Error(
              Detonated_Prematurely => FALSE,
              Error                 => Returned_Status);
         elsif Size /= 0 then

            Target_List := Illuminated_Entities;

            Search_for_Illuminated_Target:
            for Target_Index in 1..Size loop
               -- Access the first item on the list
               DL_Linked_List_Types.Entity_State_List_Utilities.Get_Item(
                 The_List => Target_List,
                 The_Item => First_ESPDU,
                 Status   => Status_DL);
               if Status_DL /= DL_Status.SUCCESS then
                  -- Target is still not illuminated
                  Returned_Status    := OS_Status.DL_ERROR;
                  -- Report error
                  Errors.Report_Error(
                    Detonated_Prematurely => FALSE,
                    Error                 => Returned_Status);
               elsif First_ESPDU.Entity_ID
                 = Network_Parameters.Target_Entity_ID
               then
                  Target_Illuminated := TRUE;
                  exit Search_for_Illuminated_Target;
               else
                  -- Move to the next item on the list (this procedure
                  -- eliminates preceding items)
                  DL_Linked_List_Types.Entity_State_List_Utilities.Get_Next(
                    The_List => Target_List,
                    Next     => Target_List,
                    Status   => Status_DL);
                  if Status_DL /= DL_Status.SUCCESS then
                     -- Target is still not illuminated
                     Returned_Status    := OS_Status.DL_ERROR;
                     -- Report error
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;
               end if;
            end loop Search_for_Illuminated_Target;
         end if;
      end if;
   end if;

   if Aerodynamic_Parameters.Illumination_Flag = OS_Data_Types.LASER then
      -- Request Laser PDU designating the target entity
      DG_Client.Get_Laser_By_Code(
        Laser_Code => Aerodynamic_Parameters.Laser_Code,
        Laser_Info => Laser_PDU,
        Status     => Status_DG);

      if Status_DG /= DG_Status.SUCCESS then
         Returned_Status := OS_Status.DG_ERROR;
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      elsif Laser_PDU /= null then
         Network_Parameters.Target_Entity_ID := Laser_PDU.Lased_Entity_ID;
         Target_Illuminated := TRUE;
         -- Check whether a target point has been identified
         if Network_Parameters.Target_Entity_ID.Sim_Address.Site_ID = 0
           and then Network_Parameters.Target_Entity_ID.Sim_Address.
            Application_ID = 0
           and then Network_Parameters.Target_Entity_ID.Entity_ID = 0
         then
            Target_Point := TRUE;
         end if;
      end if;
   end if;

   if Target_Illuminated then
      if not Target_Point then
         -- Access target data
         Gateway_Interface.Get_Entity_State_Data(
           Entity_ID     => Network_Parameters.Target_Entity_ID,
           ESPDU_Pointer => Target_ESPDU,
           Status        => Returned_Status);
         if Returned_Status = OS_Status.SUCCESS then
            Target_Location := Target_ESPDU.Location;
            Target_Velocity := Target_ESPDU.Linear_Velocity;
         else
            raise GESD_ERROR;
         end if;
      else
         -- A laser is illuminating a point, not an entity
         Target_Location   := Laser_PDU.Laser_Spot_Location;
         Target_Velocity.X := 0.0;
         Target_Velocity.Y := 0.0;
         Target_Velocity.Z := 0.0;
      end if;

      -- Convert the location vector into the munition's coordinate system
      DCM_Calculations.Convert_WorldC_Location_to_EntC(
        Offset_to_ECS      => Flight_Parameters.Firing_Data.Location_in_WorldC,
        WorldC_to_EntC_DCM => Flight_Parameters.DCM,
        Location_in_WorldC => Target_Location,
        Location_in_EntC   => Flight_Parameters.Target.Location_in_EntC,
        Status             => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise CWLTE_ERROR;
      end if;

      -- Calculate components of distance from target to munition, ground 
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

      -- Calculate target's Relative_Azimuth and Relative_Elevation heading
      -- to facilitate cone of detection calculations
      Relative_Azimuth   := Flight_Parameters.Target.Azimuth_Heading 
			  - Flight_Parameters.Munition_Elevation_Heading;
      Relative_Elevation := Flight_Parameters.Target.Elevation_Heading
			  - Flight_Parameters.Munition_Elevation_Heading;
      if Relative_Azimuth > OS_Data_Types.K_PI then
	 Relative_Azimuth := Relative_Azimuth - (OS_Data_Types.K_2PI);
      elsif Relative_Azimuth <= ( -OS_Data_Types.K_PI) then
	 Relative_Azimuth := Relative_Azimuth + (OS_Data_Types.K_2PI);
      end if;

      if Relative_Elevation > OS_Data_Types.K_PI then
	 Relative_Elevation := Relative_Elevation - (OS_Data_Types.K_2PI);
      elsif Relative_Elevation <= (-OS_Data_Types.K_PI) then
	 Relative_Elevation := Relative_Elevation + (OS_Data_Types.K_2PI);
      end if;

      -- Check whether the target is outside the cone of detection
      -- (If target is inside cone of detection, the target remains
      -- the same)
      if abs(Relative_Azimuth) <= (Aerodynamic_Parameters.
	 Azimuth_Detection_Angle * OS_Data_Types.K_Degrees_to_Radians)
        and then abs(Relative_Elevation) <= (Aerodynamic_Parameters.
	 Elevation_Detection_Angle * OS_Data_Types.K_Degrees_to_Radians)
      then -- Target is inside cone of detection
         Flight_Parameters.Target.Location_in_WorldC := Target_Location;
         Flight_Parameters.Target.Velocity_in_WorldC
           := Target_Velocity;
         Flight_Parameters.Target.Velocity_Magnitude := Math.sqrt(
             Target_Velocity.X * Target_Velocity.X
           + Target_Velocity.Y * Target_Velocity.Y
           + Target_Velocity.Z * Target_Velocity.Z);

      else -- Target is outside cone of detection
         Search_for_Target(
           Hashing_Index        => Hashing_Index,
           Illuminated_Entities => Illuminated_Entities,
           Status               => Returned_Status);
         if Returned_Status /= OS_Status.SUCCESS then
            -- Report error
            Errors.Report_Error(
              Detonated_Prematurely => FALSE,
              Error                 => Returned_Status);
         end if;
      end if;
      
   else -- Target is not illuminated
      Search_for_Target(
        Hashing_Index        => Hashing_Index,
        Illuminated_Entities => Illuminated_Entities,
        Status               => Status);
      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

   end if;

exception
   when CWLTE_ERROR | DL_ERROR | GESD_ERROR =>
      -- Set heading of the target to heading of the munition
      -- Munition will continue flying in its current direction
      Flight_Parameters.Target.Azimuth_Heading
        := Flight_Parameters.Munition_Azimuth_Heading;
      Flight_Parameters.Target.Elevation_Heading
        := Flight_Parameters.Munition_Elevation_Heading;
      -- Report error and target remains as previous
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.UT_ERROR;
      -- Set heading of the target to heading of the munition
      -- Munition will continue flying in its current direction
      Flight_Parameters.Target.Azimuth_Heading
        := Flight_Parameters.Munition_Azimuth_Heading;
      Flight_Parameters.Target.Elevation_Heading
        := Flight_Parameters.Munition_Elevation_Heading;

end Update_Target;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
--  4 NOV 94 -- KJN:  Added laser guided munitions branch and renamed
--           Target_ESPDU location and velocity components to local variables
--           to agree with laser branch variable names to ease processing and
--           added Target_Point to allow for Target_ID of all zeros (for
--           laser-guided munitions.
--           -- Consolidated separate Illumination_Flag if-then blocks into one
--           if-then-else block
--           -- Removed excess assignments of FALSE to Target_Illuminated
-- 11 NOV 94 -- KJN:  Switched direction of Relative_Location calculation
-- 28 NOV 94 -- RSK:  Added Relative_Azimuth and Relative_Elevation variables 
--           into the cone of detection calculations to properly account for 
--           muntition orientation during the check.
