--=============================================================================
--                                UNCLASSIFIED
--
-- *==========================================================================*
-- |                                                                          |
-- |                       Manned Flight Simulator                            |
-- |               Naval Air Warfare Center Aircraft Division                 |
-- |                       Patuxent River, Maryland                           |
-- *==========================================================================*
--
--=============================================================================
--
-- Package Name:       Filter_List
--
-- File Name:          Filter_List_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 13, 1994
--
-- Purpose:
--
--   Instantiates the generic filter packages which contains routines to 
--   evaluate each PDU in a list and remove those PDUs which do not meet a 
--   specified criteria.
--   
--   Each instantiation requires a function to return the appropriate status
--   if an error is encountered and a function to get the geocentric location
--   or linear velocity from the PDU record which is referenced by a pointer
--   that is a private type (see Generic_List and DL_Linked_List_Types).
--
-- Effects:
--   None
--
-- Exceptions:
--   None
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--=============================================================================	
with DIS_PDU_Pointer_Types,
     DIS_Types,
     DL_Linked_List_Types,
     Filter,
     Generic_Filter_List_By_Az_And_El,
     Generic_Filter_List_By_Distance,
     Generic_Filter_List_By_Orientation,
     Generic_Filter_List_By_Velocity,
     Get_PDU_Data,
     Numeric_Types,
     Status_Functions;

package Filter_List is

   --
   -- FILTER AZ_AND_EL
   --
   --===========================================================================
   -- Instantiate package to filter list of Entity State PDUs by Azimuth and
   -- Elevation.
   --===========================================================================
   -- Filter_Az_And_El is overloaded. 
   -- The following are the procedure calls for this instantiation:
   --
   --   Filter_List.Entity_State_Az_And_El.Filter_Az_And_El(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Entity_State_List.PTR;
   --     First_Az_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
   --     Second_Az_Threshold        : in     Numeric_Types.FLOAT_32_BIT;   
   --     First_El_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
   --     Second_El_Threshold        : in     Numeric_Types.FLOAT_32_BIT;  
   --     Reference_Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --  or
   --
   --   Filter_List.Entity_State_Az_And_El.Filter_Az_And_El(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Entity_State_List.PTR;
   --     First_Az_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
   --     Second_Az_Threshold        : in     Numeric_Types.FLOAT_32_BIT;   
   --     First_El_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
   --     Second_El_Threshold        : in     Numeric_Types.FLOAT_32_BIT;  
   --     Location                   : in     DIS_Types.A_WORLD_COORDINATE;
   --     Orientation                : in     DIS_Types.AN_EULER_ANGLES_RECORD; 
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Entity_State_Az_And_El is new Generic_Filter_List_By_Az_And_El(
      ITEM                         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Entity_State_List.PTR,
      Get_Status                   => Status_Functions.
                                        Filt_Entity_State_Az_And_El_Status,
      PDU_Location                 => Get_PDU_Data.Entity_State_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Entity_State_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Entity_State_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Entity_State_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Entity_State_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Entity_State_List.Value_Of);
   --
   -- FILTER AZIMUTH
   -- 
   --===========================================================================
   -- Instantiate package to filter a list of Detonation PDUs by azimuth
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Detonation_Azimuth.Filter_Orientation(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Detonation_List.PTR;
   --     Threshold_1                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Threshold_2                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Reference_Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Detonation_Azimuth is new Generic_Filter_List_By_Orientation(
      ITEM                         => DIS_PDU_Pointer_Types.DETONATION_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Detonation_List.PTR,
      Orientation                  => Filter.Azimuth,
      Get_Status                   => Status_Functions.
                                        Filt_Detonation_AZ_Status,
      PDU_Location                 => Get_PDU_Data.Detonation_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Detonation_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Detonation_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Detonation_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Detonation_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Detonation_List.Value_Of);

   --===========================================================================
   -- Instantiate package to filter a list of Entity_State PDUs by azimuth
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Entity_State_Azimuth.Filter_Orientation(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Entity_State_List.PTR;
   --     Threshold_1                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Threshold_2                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Reference_Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Entity_State_Azimuth is new Generic_Filter_List_By_Orientation(
      ITEM                         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Entity_State_List.PTR,
      Orientation                  => Filter.Azimuth,
      Get_Status                   => Status_Functions.
                                        Filt_Entity_State_Az_Status,
      PDU_Location                 => Get_PDU_Data.Entity_State_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Entity_State_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Entity_State_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Entity_State_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Entity_State_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Entity_State_List.Value_Of);

  --===========================================================================
   -- Instantiate package to filter a list of Fire PDUs by azimuth
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Fire_Azimuth.Filter_Orientation(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Fire_List.PTR;
   --     Threshold_1                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Threshold_2                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Reference_Fire_PDU         : in     DIS_Types.AN_ENTITY_STATE_PDU;
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Fire_Azimuth is new Generic_Filter_List_By_Orientation(
      ITEM                         => DIS_PDU_Pointer_Types.FIRE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Fire_List.PTR,
      Orientation                  => Filter.Azimuth,
      Get_Status                   => Status_Functions.Filt_Fire_Az_Status,
      PDU_Location                 => Get_PDU_Data.Fire_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Fire_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Fire_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Fire_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Fire_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Fire_List.Value_Of);    
   --
   -- FILTER DISTANCE
   -- 
   --===========================================================================
   -- Instantiate package to filter a list of Detonation PDUs by distance
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Detonation_Distance.Filter_Distance(
   --     The_List           : in out DL_Linked_List_Types.Detonation_List.PTR;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Threshold          : in     Numeric_Types.FLOAT_64_BIT;
   --     Status             :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Detonation_Distance is new Generic_Filter_List_By_Distance(
      ITEM                         => DIS_PDU_Pointer_Types.DETONATION_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Detonation_List.PTR,
      Get_Status                   => Status_Functions.
                                        Filt_Detonation_Distance_Status,
      PDU_Location                 => Get_PDU_Data.Detonation_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Detonation_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Detonation_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Detonation_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Detonation_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Detonation_List.Value_Of);

   --===========================================================================
   -- Instantiate package to filter a list of Entity State PDUs by distance
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Entity_State_Distance.Filter_Distance(
   --     The_List           : in out DL_Linked_List_Types.Entity_State_List.PTR;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Threshold          : in     Numeric_Types.FLOAT_64_BIT;
   --     Status             :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Entity_State_Distance is new Generic_Filter_List_By_Distance(
      ITEM                         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Entity_State_List.PTR,
      Get_Status                   => Status_Functions.
                                        Filt_Entity_State_Distance_Status,
      PDU_Location                 => Get_PDU_Data.Entity_State_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Entity_State_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Entity_State_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Entity_State_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Entity_State_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Entity_State_List.Value_Of);

   --===========================================================================
   -- Instantiate package to filter list of Fire PDUs by distance
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Fire_Distance.Filter_Distance(
   --     The_List           : in out DL_Linked_List_Types.Fire_List.PTR;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Threshold          : in     Numeric_Types.FLOAT_64_BIT;
   --     Status             :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Fire_Distance is new Generic_Filter_List_By_Distance(
      ITEM                         => DIS_PDU_Pointer_Types.FIRE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Fire_List.PTR,
      Get_Status                   => Status_Functions.
                                        Filt_Fire_Distance_Status,
      PDU_Location                 => Get_PDU_Data.Fire_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Fire_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Fire_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Fire_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Fire_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Fire_List.Value_Of);

   --===========================================================================
   -- Instantiate a package to filter a list of Laser PDUs by distance
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Laser_Distance.Filter_Distance(
   --     The_List           : in out DL_Linked_List_Types.Laser_List.PTR;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Threshold          : in     Numeric_Types.FLOAT_64_BIT;
   --     Status             :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Laser_Distance is new Generic_Filter_List_By_Distance(
      ITEM                         => DIS_PDU_Pointer_Types.LASER_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Laser_List.PTR,
      Get_Status                   => Status_Functions.
                                        Filt_Laser_Distance_Status,
      PDU_Location                 => Get_PDU_Data.Laser_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Laser_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Laser_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Laser_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Laser_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Laser_List.Value_Of);

   --===========================================================================
   -- Instantiate a package to filter a list of Transmitter PDUs by distance
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Transmitter_Distance.Filter_Distance(
   --     The_List           : in out DL_Linked_List_Types.Transmitter_List.PTR;
   --     Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
   --     Threshold          : in     Numeric_Types.FLOAT_64_BIT;
   --     Status             :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Transmitter_Distance is new Generic_Filter_List_By_Distance(
      ITEM                         => DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Transmitter_List.PTR,
      Get_Status                   => Status_Functions.
                                        Filt_Transmitter_Distance_Status,
      PDU_Location                 => Get_PDU_Data.Transmitter_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Transmitter_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Transmitter_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Transmitter_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Transmitter_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Transmitter_List.Value_Of);

   
   --
   -- FILTER ELEVATION
   -- 
   --===========================================================================
   -- Instantiate package to filter a list of Detonation PDUs by elevation
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Detonation_Elevation.Filter_Orientation(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Detonation_List.PTR;
   --     Threshold_1                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Threshold_2                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Reference_Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Detonation_Elevation is new Generic_Filter_List_By_Orientation(
      ITEM                         => DIS_PDU_Pointer_Types.DETONATION_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Detonation_List.PTR,
      Orientation                  => Filter.Elevation,
      Get_Status                   => Status_Functions.
                                        Filt_Detonation_El_Status,
      PDU_Location                 => Get_PDU_Data.Detonation_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Detonation_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Detonation_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Detonation_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Detonation_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Detonation_List.Value_Of);

   --===========================================================================
   -- Instantiate package to filter a list of Entity_State PDUs by elevation
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Entity_State_Elevation.Filter_Orientation(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Entity_State_List.PTR;
   --     Threshold_1                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Threshold_2                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Reference_Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Entity_State_Elevation is new Generic_Filter_List_By_Orientation(
      ITEM                         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Entity_State_List.PTR,
      Orientation                  => Filter.Elevation,
      Get_Status                   => Status_Functions.
                                        Filt_Entity_State_El_Status,
      PDU_Location                 => Get_PDU_Data.Entity_State_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Entity_State_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Entity_State_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Entity_State_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Entity_State_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Entity_State_List.Value_Of);

  --===========================================================================
   -- Instantiate package to filter a list of Fire PDUs by elevation
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Fire_Elevation.Filter_Orientation(
   --     The_List                   : in out DL_Linked_List_Types.
   --                                           Fire_List.PTR;
   --     Threshold_1                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Threshold_2                : in     Numeric_Types.FLOAT_32_BIT;   
   --     Reference_Fire_PDU         : in     DIS_Types.AN_ENTITY_STATE_PDU;
   --     Status                     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Fire_Elevation is new Generic_Filter_List_By_Orientation(
      ITEM                         => DIS_PDU_Pointer_Types.FIRE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Fire_List.PTR,
      Orientation                  => Filter.Elevation,
      Get_Status                   => Status_Functions.Filt_Fire_El_Status,
      PDU_Location                 => Get_PDU_Data.Fire_Location,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Fire_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Fire_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Fire_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Fire_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Fire_List.Value_Of); 

   --
   -- VELOCITY
   --
   --===========================================================================
   -- Instantiate package to filter a list of Entity_State PDUs by maximum
   -- velocity
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Entity_State_Max_Velocity.Filter_Velocity(
   --     The_List   : in out DL_Linked_List_Types.Entity_State_List.PTR;
   --     Threshold  : in     Numeric_Types.FLOAT_32_BIT;
   --     Status     :    out DL_Status.STATUS_TYPE);
   --
   --============================================================================
   package Entity_State_Max_Velocity is new Generic_Filter_List_By_Velocity(
      ITEM                         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Entity_State_List.PTR,
      Velocity                     => Filter.Maximum_Velocity,
      Get_Status                   => Status_Functions.
                                        Filt_Entity_State_Max_Vel_Status,
      PDU_Velocity                 => Get_PDU_Data.Entity_State_Velocity,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Entity_State_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Entity_State_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Entity_State_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Entity_State_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Entity_State_List.Value_Of);

   --===========================================================================
   -- Instantiate package to filter a list of Entity_State PDUs by minimum
   -- velocity
   --===========================================================================
   -- procedure call for the following instantiation is:
   --
   --   Filter_List.Entity_State_Min_Velocity.Filter_Velocity(
   --     The_List   : in out DL_Linked_List_Types.Entity_State_List.PTR;
   --     Threshold  : in     Numeric_Types.FLOAT_32_BIT;
   --     Status     :    out DL_Status.STATUS_TYPE);
   
   --============================================================================
   package Entity_State_Min_Velocity is new Generic_Filter_List_By_Velocity(
      ITEM                         => DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR,
      PTR                          => DL_Linked_List_Types.Entity_State_List.PTR,
      Velocity                     => Filter.Minimum_Velocity,
      Get_Status                   => Status_Functions.
                                        Filt_Entity_State_Min_Vel_Status,
      PDU_Velocity                 => Get_PDU_Data.Entity_State_Velocity,
      Delete_Item_and_Free_Storage => DL_Linked_List_Types.
                                        Entity_State_List_Utilities.
                                        Delete_Item_and_Free_Storage,
      Position_Of                  =>  DL_Linked_List_Types.
                                        Entity_State_List_Utilities.Position_Of,                                       
      Is_Null                      => DL_Linked_List_Types.
                                        Entity_State_List.Is_Null,
      Tail_Of                      => DL_Linked_List_Types.
                                        Entity_State_List.Tail_Of,
      Value_Of                     => DL_Linked_List_Types.
                                        Entity_State_List.Value_Of);
   
   
end Filter_List;

--===============================================================================
-- MODIFICATIONS
--
-- Sept. 2, 1994 / Charlotte Mildren / Created a new package call Status_Functions
--                                     and moved all the functions that returned
--                                     status to it.  Also, created a new package
--                                     call Get_PDU_Data and moved all the 
--                                     functions that returned location and 
--                                     velocity to it (these were duplicated
--                                     in Sort_List package).  In the future, any
--                                     functions required for generics which 
--                                     require status or PDU information will be 
--                                     added to these new packages.
--
--==============================================================================
