--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Check_for_Detonation
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
-- 
-- MODIFIED BY:        Robert S. Kerr - J.F.Taylor, Inc.
--
-- ORIGINATION DATE :  24 May 94
--
-- PURPOSE :
--   - The CFD CSU performs tests to determine whether a detonation should
--     occur and then initiates the detonation if one is required.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Active_Frozen_Lists, Calculate,
--     Coordinate_Conversions, DIS_Types, DL_Linked_List_Types, DL_Status,
--     DL_Types, Errors, Gateway_Interface, Numeric_Types, OS_Data_Types,
--     OS_GUI, OS_Hash_Table_Support, OS_Simulation_Types, OS_Status,
--     Sort_List and Terrain_Database_Interface.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Active_Frozen_Lists,
     Calculate,
     Coordinate_Conversions,
     DL_Linked_List_Types,
     DL_Status,
     DL_Types,
     Errors,
     Gateway_Interface,
     Numeric_Types,
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support,
     OS_Simulation_Types,
     Sort_List,
     Terrain_Database_Interface;

separate (Detonation_Event)

procedure Check_for_Detonation(
   Hashing_Index :  in     INTEGER;
   Status        :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Detonation_Location          :  DIS_Types.AN_ENTITY_COORDINATE_VECTOR;
   Detonation_Result            :  DIS_Types.A_DETONATION_RESULT;
   Detonation_Status            :  OS_Status.STATUS_TYPE;
   Distance_to_Entity           :  OS_Data_Types.METERS_DP;
   Entity_Location              :  DIS_Types.A_WORLD_COORDINATE;
   Geodetic_Position            :  DL_Types.THE_GEODETIC_COORDINATES;
   Ground_Impact_Occurred       :  BOOLEAN;
   Height_Above_Terrain         :  OS_Data_Types.METERS_DP;
   Returned_Status              :  OS_Status.STATUS_TYPE; -- Status of OS calls
   Status_DL                    :  DL_Status.STATUS_TYPE; -- Status of DL calls
   Target_Entity                :  DIS_Types.AN_ENTITY_IDENTIFIER;   
   Temp_Range                   :  OS_Data_Types.METERS_DP;

   -- Local exceptions
   DDR_ERROR  :  exception;
   DL_ERROR   :  exception;
   GHAT_ERROR :  exception;
   NO_TARGET  :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DIS_Types.A_FUZE_TYPE)
     return BOOLEAN
     renames DIS_Types."=";
   function "=" (LEFT, RIGHT :  DL_Linked_List_Types.Entity_State_List.PTR)
     return BOOLEAN
     renames DL_Linked_List_Types.Entity_State_List."=";
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
   Simulation_Parameters  :  OS_Simulation_Types.SIMULATION_PARAMETERS_RECORD
     renames OS_GUI.Interface.Simulation_Parameters;
   Termination_Parameters :  OS_Data_Types.TERMINATION_PARAMETERS_RECORD
     renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
     Termination_Parameters;

begin -- Check_for_Detonation

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Calculate new range and set previous range
   Temp_Range := Termination_Parameters.Current_Range;
   Termination_Parameters.Current_Range
     := Termination_Parameters.Previous_Range
      + Numeric_Types.FLOAT_64_BIT(Flight_Parameters.Velocity_Magnitude
      * Flight_Parameters.Cycle_Time);
   Termination_Parameters.Previous_Range := Temp_Range;

   -- When the munition has not exceeded max range, check for other reasons
   -- for detonation; otherwise, detonate with result of NONE due to max range
   if Termination_Parameters.Current_Range <= Termination_Parameters.Max_Range
   then

      -- Set height above ground and ground impact occurred flag for 
      -- ground impact checks

      Ground_Impact_Occurred := FALSE;

      Terrain_Database_Interface.Get_Height_Above_Terrain(
        Database_Origin      => OS_GUI.Interface.Simulation_Parameters.
                                Database_Origin,
        Location_in_WorldC   => Network_Parameters.Location_in_WorldC,
        Height_Above_Terrain => Height_Above_Terrain,
        Status               => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         raise GHAT_ERROR;
      end if;

      -- Add in database offset
      Height_Above_Terrain := Height_Above_Terrain + K_Database_Offset;

      if Height_Above_Terrain <= 0.0 then
         Ground_Impact_Occurred := TRUE;
      end if;


      -- If the munition has a proximity fuze, delay possible ignition (and
      -- therefore, possible detonation) of the fuse until time to detonation
      -- input by the user to avoid blowing up the parent entity
      if not (Termination_Parameters.Fuze = DIS_Types.PROXIMITY
        and then Termination_Parameters.Time_to_Detonation > Flight_Parameters.
         Time_in_Flight)
      then
         if Flight_Parameters.Possible_Targets_List
           /= DL_Linked_List_Types.Entity_State_List.K_Null_List
         then
            -- Use DL's sorting routines to determine the closest entity
            Sort_List.Entity_State_Distance.Sort_Distance(
              Ascending          => TRUE,
              Reference_Position => Network_Parameters.Location_in_WorldC,
              The_List           => Flight_Parameters.Possible_Targets_List,
              Status             => Status_DL);
            if Status_DL /= DL_Status.SUCCESS then
               Returned_Status := OS_Status.DL_ERROR;
               -- Report error
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => Returned_Status);

               if (Network_Parameters.Target_Entity_ID.Sim_Address.Site_ID = 0
                 and then Network_Parameters.Target_Entity_ID.Sim_Address.
                  Application_ID = 0
                 and then Network_Parameters.Target_Entity_ID.Entity_ID = 0)
               then
                  raise NO_TARGET;
               else
                  Target_Entity := Network_Parameters.Target_Entity_ID;
                  Entity_Location := Flight_Parameters.Target.
                    Location_in_WorldC;
               end if;

            else
               -- Determine closest entity's location and distance to munition
               Target_Entity   := DL_Linked_List_Types.Entity_State_List.
                 Value_Of(Flight_Parameters.Possible_Targets_List).Entity_ID;
               Entity_Location := DL_Linked_List_Types.Entity_State_List.
                 Value_Of(Flight_Parameters.Possible_Targets_List).Location;

               Calculate.Distance(
                 Position_1 => Network_Parameters.Location_in_WorldC,
                 Position_2 => Entity_Location,
                 Distance   => Distance_to_Entity,
                 Status     => Status_DL);

               if Status_DL /= DL_Status.SUCCESS then
                  Returned_Status := OS_Status.DL_ERROR;
                  -- Report error
                  Errors.Report_Error(
                    Detonated_Prematurely => FALSE,
                    Error                 => Returned_Status);
                  -- If there is an error, set Distance to Entity to be greater
                  -- than Range to Target so Target Entity can be used
                  Distance_to_Entity := Flight_Parameters.Range_to_Target
                    + 5.0;
               end if;
            end if;
         else
            -- Possible Targets List is null; null target and location
            Target_Entity.Sim_Address.Site_ID        := 0;
            Target_Entity.Sim_Address.Application_ID := 0;
            Target_Entity.Entity_ID                  := 0;
            Entity_Location.X := 0.0;
            Entity_Location.Y := 0.0;
            Entity_Location.Z := 0.0;

         end if;

         -- Check for detonation based on the type of fuse
         case Termination_Parameters.Fuze is

            when DIS_Types.CONTACT | DIS_Types.CONTACT_INSTANT |
              DIS_Types.CONTACT_DELAYED =>

               if ((Network_Parameters.Location_in_WorldC.X
                 - Simulation_Parameters.Contact_Threshold) < Entity_Location.X
               and then Entity_Location.X
                 < (Network_Parameters.Location_in_WorldC.X
                 + Simulation_Parameters.Contact_Threshold)
               and then
                 (Network_Parameters.Location_in_WorldC.Y
                 - Simulation_Parameters.Contact_Threshold) < Entity_Location.Y
               and then Entity_Location.Y
                 < (Network_Parameters.Location_in_WorldC.Y
                 + Simulation_Parameters.Contact_Threshold)
               and then
                 (Network_Parameters.Location_in_WorldC.Z
                 - Simulation_Parameters.Contact_Threshold) < Entity_Location.Z
               and then Entity_Location.Z
                 < (Network_Parameters.Location_in_WorldC.Z
                 + Simulation_Parameters.Contact_Threshold))
               or Ground_Impact_Occurred
               then
                  Determine_Detonation_Result(
                    Hashing_Index    => Hashing_Index,
                    Target_Entity_ID => Target_Entity,
                    Status           => Returned_Status);

                  -- If an error occurred in Determine_Detonation_Result, then
                  -- attempt to force a detonation
                  if Returned_Status /= OS_Status.SUCCESS then
                     raise DDR_ERROR;
                  end if;
               end if;
 
            when DIS_Types.TIMED =>

               if Flight_Parameters.Time_in_Flight
                 > Termination_Parameters.Time_to_Detonation
               then

                  Determine_Detonation_Result(
                    Hashing_Index    => Hashing_Index,
                    Target_Entity_ID => Target_Entity,
                    Status           => Returned_Status);

                  -- If an error occurred in Determine_Detonation_Result, then
                  -- attempt to force a detonation 
                  if Returned_Status /= OS_Status.SUCCESS then
                     raise DDR_ERROR;
                  end if;
               end if;
 
            when DIS_Types.PROXIMITY =>

               if Distance_to_Entity
                 < Termination_Parameters.Detonation_Proximity_Distance
               or Height_Above_Terrain
                 < Termination_Parameters.Detonation_Proximity_Distance
               then
                  Determine_Detonation_Result(
                    Hashing_Index    => Hashing_Index,
                    Target_Entity_ID => Target_Entity,
                    Status           => Returned_Status);

                  -- If an error occurred in Determine_Detonation_Result, then
                  -- attempt to force a detonation
                  if Returned_Status /= OS_Status.SUCCESS then
                     raise DDR_ERROR;
                  end if;
               end if; 
 
            when DIS_Types.ALTITUDE | DIS_Types.DEPTH =>

               -- Get height relative to sea level by simply converting into
               -- geodetic coordinates and using the altitude
               Coordinate_Conversions.Geocentric_To_Geodetic_Conversion(
                 Geocentric_Coordinates => Network_Parameters.
                                           Location_in_WorldC,
                 Geodetic_Coordinates   => Geodetic_Position,
                 Status                 => Status_DL);
               if Status_DL /= DL_Status.SUCCESS then
                  Returned_Status := OS_Status.DL_ERROR;
                  raise DL_ERROR;
               end if;

               if Termination_Parameters.Fuze = DIS_Types.DEPTH then

                  -- Change sign on termination parameters for Depth fuse so
                  -- the altitude algorithm will suit both cases
                  Termination_Parameters.
                    Height_Relative_to_Sea_Level_to_Detonate
                      := - (Termination_Parameters.
                        Height_Relative_to_Sea_Level_to_Detonate);
                  Geodetic_Position.Altitude := - (Geodetic_Position.Altitude);
               end if;

               if Geodetic_Position.Altitude > Termination_Parameters.
                 Height_Relative_to_Sea_Level_to_Detonate
               then
                  Determine_Detonation_Result(
                    Hashing_Index    => Hashing_Index,
                    Target_Entity_ID => Target_Entity,
                    Status           => Returned_Status);

                  -- If an error occurred in Determine_Detonation_Result, then
                  -- attempt to force a detonation
                  if Returned_Status /= OS_Status.SUCCESS then
                     raise DDR_ERROR;
                  end if;
               end if;

               -- If ground impact, then detonate harmlessly
               if Ground_Impact_Occurred then
                  Detonation_Location.X := 0.0;
                  Detonation_Location.Y := 0.0;
                  Detonation_Location.X := 0.0;

                  Gateway_Interface.Issue_Detonation_PDU(
                    Detonation_Location => Detonation_Location,
                    Detonation_Result   => DIS_Types.NONE,
                    Hashing_Index       => Hashing_Index,
                    Status              => Returned_Status);
                  if Returned_Status /= OS_Status.SUCCESS then
                     -- Report error
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;

                  Active_Frozen_Lists.Deactivate_Munition(
                    Entity_ID     => Network_Parameters.Entity_ID,
                    Status        => Returned_Status);
                  if Returned_Status /= OS_Status.SUCCESS then
                     -- Report error
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error                 => Returned_Status);
                  end if;
               end if;

            when OTHERS =>
               null;

         end case; 
      end if;

   else

      -- Max range is exceeded
      Detonation_Location.X := 0.0;
      Detonation_Location.Y := 0.0;
      Detonation_Location.X := 0.0;

      Gateway_Interface.Issue_Detonation_PDU(
        Detonation_Location => Detonation_Location,
        Detonation_Result   => DIS_Types.NONE,
        Hashing_Index       => Hashing_Index,
        Status              => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

      Active_Frozen_Lists.Deactivate_Munition(
        Entity_ID     => Network_Parameters.Entity_ID,
        Status        => Returned_Status);
      if Returned_Status /= OS_Status.SUCCESS then
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

   end if;

exception
   when DDR_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
      Errors.Detonate_Due_to_Error(
        Detonation_Result => DIS_Types.DETONATION,
        Hashing_Index     => Hashing_Index,
        Status            => Detonation_Status);

      -- Detonation was not premature
      if Detonation_Status /= OS_Status.SUCCESS then
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Detonation_Status);
      end if;

   when DL_ERROR =>
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when GHAT_ERROR =>
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

   when NO_TARGET =>
      null; -- will only detonate when max range is reached

   when OTHERS =>
      Status := OS_Status.CFD_ERROR;

end Check_for_Detonation;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
--  9 NOV 94 -- KJN:  Added code to handle null Possible_Targets_List
--
-- 25 NOV 94 -- RSK:  Added code to handle ground impacts and subsequent
--              detonations.  As currently implemented, not all ground
--              impacts cause detonation ( e.g. Timed fused munitions that
--              impact the ground will not detonate because they impacted
--              the ground ) and this leaves the possibility of munitions
--              that are not moving but lying on the ground.  After a long
--              scenario these muntions could overload the server.
--               
