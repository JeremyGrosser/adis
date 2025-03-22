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
-- Package Name:       DL_Types
--
-- File Name:          DL_Types_.ada 
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 16, 1994
--
-- Purpose:
--
--	Contains data types that are required by the DIS Library (DL) CSCI.
--	
-- Effects:
--	None
--
-- Exceptions:
--	None
--
-- Portability Issues:
--	None
--
-- Anticipated Changes:
--
--	Range values added to subtypes.
--
--=============================================================================	

with DIS_Types,
     Numeric_Types;
  
    
package DL_Types is
  
   -- Define subtypes which will allow limits to be placed on ranges or 
   -- subsitution of other defined types.
   subtype THE_LATITUDE is Numeric_Types.FLOAT_64_BIT;
   subtype THE_LONGITUDE is Numeric_Types.FLOAT_64_BIT;
   subtype THE_ALTITUDE is Numeric_Types.FLOAT_64_BIT;

   subtype THE_ROLL is Numeric_Types.FLOAT_32_BIT;
   subtype THE_PITCH is Numeric_Types.FLOAT_32_BIT;
   subtype THE_HEADING is Numeric_Types.FLOAT_32_BIT;
  
   subtype PSI_ANGLE is Numeric_Types.FLOAT_64_BIT;
   subtype THETA_ANGLE is Numeric_Types.FLOAT_64_BIT;
   subtype PHI_ANGLE is Numeric_Types.FLOAT_64_BIT;

   -- Degrees of a semi-circle centered about zero
   subtype DEGREES_SEMI is Numeric_Types.FLOAT_64_BIT
     range -90.0..90.0;

   -- Degrees of a cirle centered about zero
   subtype DEGREES_CIRC is Numeric_Types.FLOAT_64_BIT
     range (-180.0 + Numeric_Types.FLOAT_64_BIT'SMALL)..180.0;

   type THE_GEODETIC_COORDINATES
   is record
     Latitude  : DEGREES_SEMI;
     Longitude : DEGREES_CIRC;
     Altitude  : THE_ALTITUDE;  -- meters
   end record; 

   subtype THE_LOCAL_ORIGIN is THE_GEODETIC_COORDINATES;

   subtype THE_LOCAL_COORDINATES is DIS_Types.A_WORLD_COORDINATE;

     -- 
     -- Define variable to be used to convert the euler angles to long floats.
     type EULER_ANGLES_LONG_FLOAT
       is record
         Psi   : PSI_ANGLE; -- degrees
         Theta : THETA_ANGLE; -- degrees
         Phi   : PHI_ANGLE; -- degrees
       end record;

     type LOCAL_ORIENTATION 
       is record
         Roll    : THE_ROLL; -- degrees
         Pitch   : THE_PITCH; -- degrees
         Heading : THE_HEADING; -- degrees
       end record;

   
end DL_Types;

--==============================================================================
-- 
-- Modification History
--
-- July 25, 1994 / Charlotte Mildren / Added type LOCAL_ORIENTATION;
--
-- Sept 9, 1994 / Charlotte Mildren / Deleted UTM records since we do not plan
--                                    to implement a UTM conversion.
--
-- Sept 22, 1994 / B. Dufault / Changed THE_LOCAL_COORDINATES from a new
--                              type to a subtype of A_WORLD_COORDINATE to
--                              improve usability.
--
--=============================================================================== 
