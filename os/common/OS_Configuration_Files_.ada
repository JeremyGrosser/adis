--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_Configuration_Files (spec)
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  23 August 94
--
-- PURPOSE :
--
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with OS_Status;

package OS_Configuration_Files is

   type USER_KEYWORD_TYPE is (

      -- Simulation Parameters
      CONTACT_THRESHOLD,
      CYCLE_TIME,
      DATABASE_ORIGIN_LATITUDE,
      DATABASE_ORIGIN_LONGITUDE,
      DATABASE_ORIGIN_ALTITUDE,
      EXERCISE_ID,
      HASH_TABLE_INCREMENT,
      HASH_TABLE_SIZE,
      MODSAF_DATABASE_FILENAME,
      MEMORY_LIMIT_FOR_MODSAF_FILE,
      NUMBER_OF_LOOPS_UNTIL_UPDATE,
      PARENT_SITE_ID,
      PARENT_APPLICATION_ID,
      PARENT_ENTITY_ID,
      PROTOCOL_VERSION,
      SIMULATION_STATE,
      -- General Parameters
      DEAD_RECKONING,
      FLY_OUT_MODEL_ID,
      -- Entity Type
      KIND,
      DOMAIN,
      COUNTRY,
      CATEGORY,
      SUBCATEGORY,
      SPECIFIC,
      EXTRA,
      -- Aerodynamic Parameters
      BURN_RATE,
      BURN_TIME,
      AZIMUTH_DETECTION_ANGLE,
      ELEVATION_DETECTION_ANGLE,
      DRAG_COEFFICIENTS_1,
      DRAG_COEFFICIENTS_2,
      DRAG_COEFFICIENTS_3,
      DRAG_COEFFICIENTS_4,
      DRAG_COEFFICIENTS_5,
      DRAG_COEFFICIENTS_6,
      FRONTAL_AREA,
      G_GAIN,
      GUIDANCE,
      ILLUMINATION_FLAG,
      INITIAL_MASS,
      MAX_GS,
      MAX_SPEED,
      THRUST,
      -- Termination Parameters
      FUZE,
      DETONATION_PROXIMITY_DISTANCE,
      HEIGHT_RELATIVE_TO_SEA_LEVEL_TO_DETONATE,
      MAX_RANGE,
      TIME_TO_DETONATION,
      WARHEAD,
      HARD_KILL,
      RANGE_TO_DAMAGE,
      -- Error Parameters
      DISPLAY_ERROR,
      LOG_ERROR,
      LOG_FILE,
      -- Emitter Parameters
      EMITTER_NAME,
      EMITTER_FUNCTION,
      EMITTER_ID,
      LOCATION_X,
      LOCATION_Y,
      LOCATION_Z,
      FREQUENCY,
      FREQUENCY_RANGE,
      ERP,
      PRF,
      PULSE_WIDTH,
      BEAM_SWEEP_SYNC,
      BEAM_PARAMETER_INDEX,
      BEAM_FUNCTION,
      HIGH_DENSITY_TRACK_JAM,
      -- Munition Parameter Control
      ADDITIONAL_CONFIG_FILE,
      START_MUNITION_DATA,
      END_MUNITION_DATA);

   procedure Load_Configuration_File(
      Filename :  in     STRING;
      Status   :     out OS_Status.STATUS_TYPE);

   procedure Save_Configuration_File(
      Filename :  in     STRING;
      Status   :     out OS_Status.STATUS_TYPE);

end OS_Configuration_Files;
