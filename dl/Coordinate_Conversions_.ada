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
-- Package Name:       Coordinate_Conversions
--
-- File Name:          Coordinate_Conversions_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 5, 1994
--
-- Purpose:
--
--   Contains routines that convert between geocentric (DIS world) coordinate
--   systems and entity, local, geodetic and UTM coordinate systems and 
--   vice-versa.
--
--   The geocentric coordinate system is a right-handed system which has
--   its origin at the center of the earth and the following axis with 
--   position values defined in meters:
--
--     Positive X axis - passing through Prime Meridian at the equator.
--     Positive Y axis - passing trough 90 degrees East longitude at
--                       the equator.
--     Positive Z axis - passing through the North Pole (earth's
--                       spin axis).
--
--  The entity coordinate system is a right handed system which has its origin
--  at the center of the entity's bounded volume and the following axis with
--  position values defined in meters:
--
--    Positive X axis - pointing to the front of the entity.
--    Positive Y axis - pointing to the right side of the entity.
--    Positive Z axis - pointing down.
--
--  (For example, an airplane would have the following positive axes:
--
--    X through the nose,
--    Y through the right wing
--    Z from the center of the body and down.)
--
--   The geodetic coordinate system is defined in terms of latitude,
--   longitude and altitude with the following boundaries: 
--        Latitude  - -90.0..90.0 degrees
--        Longitude - -180.0..180.0 degrees
--        Altitude  - meters
--
--   Local coordinates are defined based on a local database.
--
--     The local origin is defined in terms of latitude (degrees),
--     longitude (degrees), and altitude (meters).
--
--     The local coordinates for an Entity location is defined in terms of the 
--     X,Y,Z axis in the local coordinate system in feet.
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
with DL_Status,
     DL_Types,
     DIS_Types;

package Coordinate_Conversions is

   --==========================================================================
   -- ENTITY_TO_GEOCENTRIC_CONVERSION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from the entity of interest coordinate system to a geocentric
   --   coordinate system.
   --
   --    Input Parameters:
   --
   --      Euler_Angles - Defines the reference entity's location in the 
   --                     geocentric coordinate system in terms of pitch
   --                     (rotation about the lateral or X axis), roll 
   --                     (rotation about the longitudinal or Y axis), and
   --                     yaw (rotation about the altitude or Z axis).
   --                     Angles are defined in degrees.
   --
   --      Entity_Coordinate_System_Center - The origin of the entity of 
   --                                        interest coordinate system defined
   --                                        in terms of the X,Y,Z axis in the
   --                                        geocentric coordinate system in
   --                                        meters.
   --
   --      Entity_Coordinates - The location of the point of interest defined
   --                           in terms of the X,Y,Z axis in the reference
   --                           entity's coordinate system in meters.
   -- 
   --    Output Parameters:
   --
   --      Geocentric_Coordinates - The entity of interest location defined in 
   --                               terms of the X,Y,Z axis in the geocentric
   --                               coordinate system in meters.
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.ENT_GCC_FAILURE - Indicates an exception was 
   --               raised in this unit.
   --
   --               Other - If an error occurs in a call to a sub-routine, the 
   --               procedure will terminate and the status (error code) for the
   --               failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Entity_To_Geocentric_Conversion( 
      Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Entity_Coordinates              : in     DIS_Types.
                                                 AN_ENTITY_COORDINATE_VECTOR;
      Geocentric_Coordinates          :    out DIS_Types.A_WORLD_COORDINATE;
      Status                          :    out DL_Status.STATUS_TYPE);

  --==========================================================================
   -- ENTITY_TO_GEOCENTRIC_VEL_CONVERSION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from the entity of interest coordinate system to a geocentric
   --   coordinate system.  
   --
   --   This routine is the same as the ENTITY_TO_GEOCENTRIC_CONVERSION routine
   --   except that the Entity_Coordinates and Geocentric_Cordinates parameters
   --   are changed to DIS_Types.A_LINEAR_VELOCITY_VECTOR to make the unit more
   --   compatible with velocity calculations.
   --
   --   One of the following status values will be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     DL_Status.ENT_GCC_VEL_FAILURE - Indicates an exception was raised in
   --       this unit.
   --
   --     Other - If an error occurs in a call to a sub-routine, the procedure 
   --       will terminate and the status (error code) for the failed routine will
   --       be returned.
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Entity_To_Geocentric_Vel_Conversion( 
      Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Entity_Coordinates              : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Geocentric_Coordinates          :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Status                          :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GEOCENTRIC_TO_ENTITY_CONVERSION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from a geocentric coordinate system to the entity of interest
   --   coordinate system.
   --
   --   Input Parameters:
   --
   --     Euler_Angles - Defines the reference entity's location in the
   --                    geocentric coordinate system in terms of pitch
   --                    (rotation about the lateral or X axis), roll
   --                    (rotation about the longitudinal or Y axis), and
   --                    yaw (rotation about the altitude or Z axis).
   --                    Angles are defined in degrees.
   --
   --     Entity_Coordinate_System_Center - The origin of the entity of
   --                                       interest coordinate system defined
   --                                       in terms of the X,Y,Z axis in the
   --                                       geocentric coordinate system in
   --                                       meters.
   --
   --
   --      Geocentric_Coordinates - The entity of interest location defined in
   --                               terms of the X,Y,Z axis in the geocentric
   --                               coordinate system in meters.
   --
   --   Output Parameters:
   --
   --     Entity_Coordinates - The location of the point of interest defined
   --                          in terms of the X,Y,Z axis in the reference
   --                          entity's coordinate system in meters.
   --
   --    Status - Indicates whether this unit encountered an error condition.
   --             One of the following status values will be returned:
   --
   --             DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --             DL_Status.GCC_ENT_FAILURE - Indicates an exception was raised
   --             in this unit.
   --
   --             Other - If an error occurs in a call to a sub-routine, the 
   --             procedure will terminate and the status (error code) for the
   --             failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Geocentric_To_Entity_Conversion( 
      Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Geocentric_Coordinates          : in     DIS_Types.A_WORLD_COORDINATE;
      Entity_Coordinates              :    out DIS_Types.
                                                 AN_ENTITY_COORDINATE_VECTOR;
      Status                          :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GEOCENTRIC_TO_ENTITY_VEL_CONVERSION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from a geocentric coordinate system to the entity of interest
   --   coordinate system.
   --
   --   This routine is the same as the GEOCENTRIC_TO_ENTITY_CONVERSION routine
   --   except that the Geocentric_Cordinates and Entity_Coordinates parameters
   --   are changed to DIS_Types.A_LINEAR_VELOCITY_VECTOR to make the unit more
   --   compatible with velocity calculations.
   -- 
   --   One of the following status values will be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     DL_Status.GCC_ENT_VEL_FAILURE - Indicates an exception was raised in
   --       this unit.
   --
   --     Other - If an error occurs in a call to a sub-routine, the procedure 
   --       will terminate and the status (error code) for the failed routine
   --       will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Geocentric_To_Entity_Vel_Conversion( 
      Euler_Angles                    : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Entity_Coordinate_System_Center : in     DIS_Types.A_WORLD_COORDINATE;
      Geocentric_Coordinates          : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Entity_Coordinates              :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Status                          :    out DL_Status.STATUS_TYPE);


   --==========================================================================
   -- GEOCENTRIC_TO_GEODETIC_CONVERSION
   --==========================================================================
   -- Purpose:
   --
   --   Converts geocentric X,Y,Z coordinates to geodetic latitude,
   --   longitude and altitude. 
   --
   --   Input Parameters:
   --
   --     Geocentric_Coordinates - Entity location defined in terms of the 
   --                              X,Y,Z axis in the geocentric coordinate
   --                              system in meters.
   -- 
   --   Output Parameters:
   -- 
   --     Geodetic_Coordinates - Position coordinates defined in terms of
   --                            latitude (degrees), longitude (degrees), and
   --                            altitude (meters).
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GCC_GDC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the 
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Geocentric_To_Geodetic_Conversion(
      Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
      Geodetic_Coordinates   :    out DL_Types.THE_GEODETIC_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GEOCENTRIC_TO_LOCAL_CONVERSION
   --==========================================================================
   -- Purpose:
   --
   --   Converts geocentric coordinates to local coordinates.
   --
   --   Input Parameters:
   --
   --     Geocentric_Coordinates - Entity location defined in terms of the 
   --                              X,Y,Z axis in the geocentric coordinate
   --                              system in meters.
   --
   --     Local_Origin - Origin of local coordinates defined in terms of 
   --                    latitude (degrees), longitude (degrees), and
   --                    altitude (meters).
   --
   --   Output Parameters:
   -- 
   --     Local_Coordinates - Entity location defined in terms of the X,Y,Z
   --                         axis in the local coordinate system in feet.
   --
   -- 
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GCC_LOC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Geocentric_To_Local_Conversion(
      Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE);
 
   --==========================================================================
   -- GEOCENTRIC_TO_LOCAL_IN_METERS_CONVERSION
   --==========================================================================
   -- Purpose:
   --
   --   Converts geocentric coordinates to local coordinates.
   --
   --   Note: This is the same as Geocentric_To_Local_Conversion except the 
   --   local coordinates are in meters instead of feet.
   --
   --   Input Parameters:
   --
   --     Geocentric_Coordinates - Entity location defined in terms of the 
   --                              X,Y,Z axis in the geocentric coordinate
   --                              system in meters.
   --
   --     Local_Origin - Origin of local coordinates defined in terms of 
   --                    latitude (degrees), longitude (degrees), and
   --                    altitude (meters).
   --
   --   Output Parameters:
   -- 
   --     Local_Coordinates - Entity location defined in terms of the X,Y,Z
   --                         axis in the local coordinate system in meters.
   --
   -- 
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GCC_LOC_M_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Geocentric_To_Local_In_Meters_Conversion(
      Geocentric_Coordinates : in     DIS_Types.A_WORLD_COORDINATE;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GEODETIC_TO_GEOCENTRIC_CONVERSION
   --==========================================================================
   -- Purpose:
   --
   --   Converts geodetic latitude, longitude, and altitude to geocentric
   --   X,Y,Z coordinates. 
   --
   --   Input Parameters:
   --
   --     Geodetic_Coordinates - Position coordinates defined in terms of
   --                            latitude (degrees), longitude (degrees), and
   --                            altitude (meters).
   --
   --   Output Parameters:
   -- 
   --     Geocentric_Coordinates - Entity location defined in terms of the 
   --                              X,Y,Z axis in the geocentric coordinate
   --                              system in meters.
   -- 
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GDC_GCC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Geodetic_To_Geocentric_Conversion(
      Geodetic_Coordinates   : in     DL_Types.THE_GEODETIC_COORDINATES;
      Geocentric_Coordinates :    out DIS_Types.A_WORLD_COORDINATE;
      Status                 :    out DL_Status.STATUS_TYPE);
   
   --==========================================================================
   -- GEODETIC_TO_LOCAL_CONVERSION
   --==========================================================================
   -- Purpose:
   --
   --   Converts geodetic latitude, longitude, and altitude to local X,Y,Z
   --   coordinates. 
   --
   --   Input Parameters:
   --
   --     Geodetic_Coordinates - Position coordinates defined in terms of
   --                            latitude (degrees), longitude (degrees), and
   --                            altitude (meters).
   --
   --     Local_Origin - Origin of local coordinates defined in terms of 
   --                    latitude (degrees), longitude (degrees), and
   --                    altitude (meters).
   --
   --   Output Parameters:
   -- 
   --     Local_Coordinates - Entity location defined in terms of the X,Y,Z axis
   --                         in the local coordinate system in feet.
   -- 
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GDC_LOC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Geodetic_To_Local_Conversion(
      Geodetic_Coordinates   : in     DL_Types.THE_GEODETIC_COORDINATES;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Coordinates      :    out DL_Types.THE_LOCAL_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- LOCAL_TO_GEOCENTRIC_CONVERSION
   --==========================================================================
   -- Purpose:
   --
   --   Converts geocentric coordinates to local coordinates.
   --
   --   Input Parameters:
   --
   --     Geocentric_Coordinates - Entity location defined in terms of the 
   --                              X,Y,Z axis in the geocentric coordinate
   --                              system in meters.
   --   Output Parameters:
   -- 
   --     Local_Coordinates - Entity location defined in terms of the X,Y,Z axis
   --                         in the local coordinate system in feet.
   --
   --     Local_Origin - Origin of local coordinates defined in terms of 
   --                    latitude (degrees), longitude (degrees), and
   --                    altitude (meters).
   -- 
   --     Status - Indicates whether this unit encountered an error condition.   
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.LOC_GCC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the 
   --              failed routine will be returned.
   --  
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Local_To_Geocentric_Conversion(
      Local_Coordinates      : in     DL_Types.THE_LOCAL_COORDINATES;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Geocentric_Coordinates :    out DIS_Types.A_WORLD_COORDINATE;
      Status                 :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- LOCAL_TO_GEODETIC_CONVERSION
   --==========================================================================
   -- Purpose:
   --
   --   Converts local X,Y,Z coordinated to geodetic latitude, longitude, and 
   --   altitude. 
   --
   --   Input Parameters:
   --
   --     Local_Coordinates    - Entity location defined in terms of the 
   --                            X,Y,Z axis in the local coordinate
   --                            system in feet.
   --
   --     Local_Origin          - Origin of local coordinates defined in terms of 
   --                            latitude (degrees), longitude (degrees), and
   --                            altitude (meters).
   --
   --   Output Parameters:
   -- 
   --     Geodetic_Coordinates - Position coordinates defined in terms of
   --                            latitude (degrees), longitude (degrees), and
   --                            altitude (meters).
   -- 
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.LOC_GDC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Local_To_Geodetic_Conversion(
      Local_Coordinates      : in     DL_Types.THE_LOCAL_COORDINATES;
      Local_Origin           : in     DL_Types.THE_LOCAL_ORIGIN;
      Geodetic_Coordinates   :    out DL_Types.THE_GEODETIC_COORDINATES;
      Status                 :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- LOCAL_TO_DIS_VELOCITY
   --==========================================================================
   -- Purpose:
   --
   --   Converts local velocity vector to DIS velocity vector.
   --
   --   Input Parameters:
   --
   --     Local_Velocity    - The velocity vector in feet per second with
   --                         respect to the local database reference.
   --
   --     Local_Position    - The location of the entity at the time the
   --                         velocity vector is valid in GEODETIC coordinates.
   --
   --   Output Parameters:
   --
   --     DIS_Velocity      - The velocity vector of the entity in meters per sec
   --                         with respect to the DIS (Geocentric) refernce system.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.LOC_GDC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Local_To_DIS_Velocity(
      Local_Velocity : in     DIS_Types.A_VECTOR;
      Local_Position : in     DL_Types.THE_LOCAL_ORIGIN;
      DIS_Velocity   :    out DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Status         :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- DIS_TO_LOCAL_VELOCITY
   --==========================================================================
   -- Purpose:
   --
   --   Converts local velocity vector to DIS velocity vector.
   --
   --   Input Parameters:
   --
   --     DIS_Velocity      - The velocity vector of the entity in meters per sec
   --                         with respect to the DIS (Geocentric) refernce system.
   --
   --     Local_Position    - The location of the entity at the time the
   --                         velocity vector is valid in GEODETIC coordinates.
   --
   --   Output Parameters:
   --
   --     Local_Velocity    - The velocity vector in feet per second with
   --                         respect to the local database reference.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.LOC_GDC_FAILURE - Indicates an exception was raised
   --              in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the
   --              procedure will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure DIS_To_Local_Velocity(
      DIS_Velocity   : in     DIS_Types.A_LINEAR_VELOCITY_VECTOR;
      Local_Position : in     DL_Types.THE_LOCAL_ORIGIN;
      Local_Velocity :    out DIS_Types.A_VECTOR;
      Status         :    out DL_Status.STATUS_TYPE);


 end Coordinate_Conversions;

--==============================================================================
--
-- MODIFICATIONS:
--
-- June 30, 1994 / Charlotte Mildren / Added Entity_To_Geocentric_Vel_Conversion
--                                       and Geocentric_To_Entity_Vel_Conversion
--
-- July 26, 1994 / Charlotte Mildren / Added Geodetic_To_Geocentric_Conversion
--                                     
-- July 28, 1994 / Charlotte Mildren / Added Local_To_Geocentric_Conversion,
--                                           Geocentric_To_Local_Conversion,
--                                           Local_To_Geodetic_Conversion,
--                                           and Geodetic_To_Local_Conversion
--
-- Sept 9, 1994 / Charlotte Mildren / Added Geocentric_To_Local_In_Meters_
--                                          Conversion
-- Nov  3, 1994 / Larry Ullom       / Added Local_To_DIS_Velocity,
--                                          DIS_To_Local_Velocity
--==============================================================================
