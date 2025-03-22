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
-- Package Name:       DL_Math
--
-- File Name:          DL_Math_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   May 16, 1994
--
-- Purpose
--
--	Contains data math types and functions used by the DL CSCI.
--	
-- 
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
     DIS_Types,
     Language,
     Numeric_Types; 
    
package DL_Math is

   --
   -- Constants     
   --

   -- /* Define WGS-84 ellipsoidal earth parameter values */.
   K_Equatorial_Earth_Radius    : constant := 6.378137E+6;

   -- Eccentricity squared
   K_Eccentricity_Sq            : constant := 6.69437999013E-03;

   -- (Eccentricity squared) divided by (equatorial earth raduis squared)
   K_Eccen_Sq_Divided_By_Equat_Earth_Radius_Sq : constant := 1.64559391739E-16;
 
   -- 1 - eccentricity squared 
   K_One_Minus_Eccentricity_Sq  : constant := 9.9330562000987E-01;
  
   -- Second eccentricity squared.
   K_Second_Eccentricity_Sq     : constant := 6.73949674227E-03;
 
   -- /* Angular values*/   
   K_Pi                         : constant := 3.141592653589793239;
   K_Two_Pi                     : constant := 6.283185307179586478;                                               
   K_Half_Pi                    : constant := 1.570796326794896619;
   K_One_Hundred_Eighty_Degrees : constant := 180.0;

   -- /* Degree to radians conversion constants */
   K_Degrees_To_Radians         : constant := 1.745329251994329577E-02; -- Pi/180

   -- 1/K_Degrees_To_Radians
   K_Radians_To_Degrees         : constant := 5.729577951308232087E+01; 

   -- /* Feet to meters conversion constants.
   -- US Survey feet to meters: WGS-84  
   K_Feet_To_Meters             : constant := 3.048006096012192025E-01;
 
   -- Meters to US Survey feet: 1/K_Feet_To_Meters 
   K_Meters_To_Feet             : constant := 3.280833333333333333;

   -- The following defines the trigometric function names required in the
   -- rotations about the axis.
   type EULER_TRIG is (SIN_PSI, SIN_THETA, SIN_PHI, COS_PSI, COS_THETA,
     COS_PHI, SIN_PSI_COS_PHI, SIN_PSI_SIN_PHI, COS_PSI_COS_PHI,
     COS_PSI_SIN_PHI);

   type EULER_TRIG_32_BIT is array (EULER_TRIG) of 
     Numeric_Types.FLOAT_32_BIT;

   type EULER_TRIG_64_BIT is array (EULER_TRIG) of
     Numeric_Types.FLOAT_64_BIT;

   subtype HALF_PI_ANGLE is Numeric_Types.FLOAT_64_BIT 
     range -K_Half_Pi..K_Half_Pi;

   subtype PI_ANGLE is Numeric_Types.FLOAT_64_BIT range -K_Pi..K_Pi;

   subtype PERCENT is Numeric_Types.FLOAT_32_BIT range 0.0..1.0;
 
   --==========================================================================
   -- SIN_COS_LAT
   --==========================================================================
   -- 
   -- Purpose: 
   -- 
   --   Simultaneous sine and cosine calculation to be used in place of
   --   Math Library Sine and Cosine functions when the angle is known
   --   to be between -pi and +pi radians (such as latitude).
   -- 
   --    Input Parameters:
   --
   --      Angle - an angle in radians between -pi/2 and pi/2.
   --
   --    Output Parameters:
   --
   --      Cos_Angle - The cosine value for the input angle.
   --
   --      Sin_Angle - The sine value for the input angle.
   --  
   -- 
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.SIN_COS_LAT_FAILURE - Indicates an exception was 
   --               raised in this unit.
   --        
   -- Exceptions:
   --   None  
   --==========================================================================
     procedure Sin_Cos_Lat (Angle     : in     HALF_PI_ANGLE;
                            Cos_Angle :    out Numeric_Types.FLOAT_64_BIT;
                            Sin_Angle :    out Numeric_Types.FLOAT_64_BIT;
                            Status    :    out DL_Status.STATUS_TYPE); 

     --========================================================================
     -- SIN_COS_LON
     --======================================================================== 
     --
     -- Purpose:
     --    Simultaneous sine and cosine calculation to be used in place of
     --    Math Sine and Cosine functions when the angle is known to be 
     --    between -pi and +pi radians (such as longitude).
     --
     --    Input Parameters:
     --
     --      Angle - an angle in radians between -pi and pi.
     --
     --    Output Parameters:
     --
     --
     --      Cos_Angle - The cosine value for the input angle.
     -- 
     --      Sin_Angle - The sine value for the input angle.
     --
     --      Status - Indicates whether this unit encountered an error condition.
     --               One of the following status values will be returned:
     --
     --               DL_Status.SUCCESS - Indicates the unit executed successfully.
     --
     --               DL_Status.SIN_COS_LON_FAILURE - Indicates an exception was 
     --               raised in this unit.
     --       
     --
     --========================================================================
     procedure Sin_Cos_Lon (Angle     : in     PI_ANGLE;
                            Cos_Angle :    out Numeric_Types.FLOAT_64_BIT;
                            Sin_Angle :    out Numeric_Types.FLOAT_64_BIT;
                            Status    :    out DL_Status.STATUS_TYPE);


    --=========================================================================
    --  CALCULATE_EULER_TRIG
    --=========================================================================
    -- 
    -- Purpose:
    -- 
    --   Since the transformation matrix to convert between entity and
    --   geocentric coordinates uses many of the same math functions multiple
    --   times, this unit stores these values for use in other calculations.
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
    --    Output Parameters:
    --
    --
    --      Trig_Values - Calculated Transformation matrix values 
    --
    --     Status - Indicates whether this unit encountered an error condition.
    --              One of the following status values will be returned:    
    -- 
    --              DL_Status.SUCCESS - Indicates the unit executed successfully.
    --
    --              DL_Status.CAL_EULER_TRIG_FAILURE - Indicates an exception 
    --              was raised in this unit.
    --
    --=========================================================================
    procedure Calculate_Euler_Trig (
      Euler_Angles : in      DIS_Types.AN_EULER_ANGLES_RECORD;
      Trig_Values  :    out  EULER_TRIG_32_BIT;
      Status       :    out  DL_Status.STATUS_TYPE); 
     
    --=========================================================================
    --  CALCULATE_EULER_TRIG
    --=========================================================================
    -- 
    -- Purpose:
    -- 
    --   Since the transformation matrix to convert between entity and
    --   geocentric coordinates uses many of the same math functions multiple
    --   times, this unit stores these values for use in other calculations.
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
    --    Output Parameters:
    --
    --
    --      Trig_Values - Calculated Transformation matrix values 
    --
    --     Status - Indicates whether this unit encountered an error condition.
    --              One of the following status values will be returned:    
    -- 
    --              DL_Status.SUCCESS - Indicates the unit executed successfully.
    --
    --              DL_Status.CAL_EULER_TRIG_FAILURE - Indicates an exception 
    --              was raised in this unit.
    --
    --=========================================================================
    procedure Calculate_Euler_Trig (
      Euler_Angles : in      DIS_Types.AN_EULER_ANGLES_RECORD;
      Trig_Values  :    out  EULER_TRIG_64_BIT;
      Status       :    out  DL_Status.STATUS_TYPE);

    --=========================================================================
    --
    --  ATAN2
    --
    --=========================================================================
    --  Import Math.Atan2 function.  The following definition was extracted
    --  from the Manual Pages:
    --  For argument X in radians, the atan routines return the arc tangent in 
    --  the range -pi/2 to pi/2.  The type of both the return value and the 
    --  single argument are double for atan, and float for fatan and its 
    --  ANSI-named counterpart atanf.
    --
    --  The atan2 routines return the arctangent of y/x in the range -pi to pi
    --  using the signs of both arguments to determine the quadrant of the return
    --  value.  Both the return value and the argument types are double for
    --  atan2, and float for fatan2 and its ANSI-named counterpart atan2f.
    --
    -- The atan2 functions will return zero if both arguments are zero.

    --=========================================================================

    function C_atan2f(
       Y : in Numeric_Types.FLOAT_32_BIT;
       X : in Numeric_Types.FLOAT_32_BIT)
      return Numeric_Types.FLOAT_32_BIT;

    pragma INTERFACE(C, C_atan2f);

    pragma INTERFACE_NAME(C_atan2f, Language.C_SUBP_PREFIX & "atan2f");

    function C_atan2(
       X : in Numeric_Types.FLOAT_64_BIT;
       Y : in Numeric_Types.FLOAT_64_BIT)
     return Numeric_Types.FLOAT_64_BIT;

    pragma INTERFACE(C, C_atan2);

    pragma INTERFACE_NAME(C_atan2, Language.C_SUBP_PREFIX & "atan2");

    --
    -- Overload "ATan2" Ada functions with corresponding C function
    -- interfaces.
    --

    function ATan2(
       X : in Numeric_Types.FLOAT_32_BIT;
       Y : in Numeric_Types.FLOAT_32_BIT)
     return Numeric_Types.FLOAT_32_BIT
       renames C_atan2f;

    function ATan2(
       X : in Numeric_Types.FLOAT_64_BIT;
       Y : in Numeric_Types.FLOAT_64_BIT)
      return Numeric_Types.FLOAT_64_BIT
        renames C_atan2;

    --=========================================================================
    --
    --  ACos
    --=========================================================================
    --   For agrument X in radians, the asin routines return the arc cosine in the 
    --   range 0 to pi. 
    --   The type of both the return value and the single argument are double 
    --   for acos, and float for facos and its ANSI-named counterpart acosf.
    --
    --=========================================================================

    function C_acosf(
       X : in Numeric_Types.FLOAT_32_BIT)
      return Numeric_Types.FLOAT_32_BIT;

    pragma INTERFACE(C, C_acosf);

    pragma INTERFACE_NAME(C_acosf, Language.C_SUBP_PREFIX & "acosf");

    function C_acos(
       X : in Numeric_Types.FLOAT_64_BIT)
     return Numeric_Types.FLOAT_64_BIT;

    pragma INTERFACE(C, C_acos);

    pragma INTERFACE_NAME(C_acos, Language.C_SUBP_PREFIX & "acos");

    --
    -- Overload "ACos" Ada functions with corresponding C function
    -- interfaces.
    --

    function ACos(
       X : in Numeric_Types.FLOAT_32_BIT)
      return Numeric_Types.FLOAT_32_BIT
       renames C_acosf;

    function ACos(
       X : in Numeric_Types.FLOAT_64_BIT)
      return Numeric_Types.FLOAT_64_BIT
        renames C_acos;

    --=========================================================================
    --
    --  ASIN
    --=========================================================================
    --
    --   For X in radians, the asin routines return the arc sine in the range
    --   -pi/2 to pi/2. 
    --   The type of both the return value and the single argument are double 
    --   for asin, and float for fasin and its ANSI-named counterpart asinf.
    --
    --=========================================================================

    function C_asinf(
       X : in Numeric_Types.FLOAT_32_BIT)
      return Numeric_Types.FLOAT_32_BIT;

    pragma INTERFACE(C, C_asinf);

    pragma INTERFACE_NAME(C_asinf, Language.C_SUBP_PREFIX & "asinf");

    function C_asin(
       X : in Numeric_Types.FLOAT_64_BIT)
     return Numeric_Types.FLOAT_64_BIT;

    pragma INTERFACE(C, C_asin);

    pragma INTERFACE_NAME(C_asin, Language.C_SUBP_PREFIX & "asin");

    --
    -- Overload "ASin" Ada functions with corresponding C function
    -- interfaces.
    --

    function ASin(
       X : in Numeric_Types.FLOAT_32_BIT)
      return Numeric_Types.FLOAT_32_BIT
       renames C_asinf;

    function ASin(
       X : in Numeric_Types.FLOAT_64_BIT)
      return Numeric_Types.FLOAT_64_BIT
        renames C_asin;
    --=========================================================================
    --
    --  FAbs 
    --=========================================================================
    --
    --   The folloiwng was extracted from the Manual (man) pages:
    --   The fabs routine returns the absolute value of the double X |X|.
    --   It has a counterpart of type float, namely fabsf.
    --
    --=========================================================================

    function C_fabsf(
       X : in Numeric_Types.FLOAT_32_BIT)
      return Numeric_Types.FLOAT_32_BIT;

    pragma INTERFACE(C, C_fabsf);

    pragma INTERFACE_NAME(C_fabsf, Language.C_SUBP_PREFIX & "fabsf");

    function C_fabs(
       X : in Numeric_Types.FLOAT_64_BIT)
     return Numeric_Types.FLOAT_64_BIT;

    pragma INTERFACE(C, C_fabs);

    pragma INTERFACE_NAME(C_fabs, Language.C_SUBP_PREFIX & "fabs");

    --
    -- Overload "ABS" Ada functions with corresponding C function
    -- interfaces.
    --

    function FAbs(
       X : in Numeric_Types.FLOAT_32_BIT)
      return Numeric_Types.FLOAT_32_BIT
       renames C_fabsf;

    function FAbs(
       X : in Numeric_Types.FLOAT_64_BIT)
      return Numeric_Types.FLOAT_64_BIT
        renames C_fabs;

end DL_Math;

--=============================================================================
--  
-- Modification History
--
--  June 9, 1994  / Brett Dufault     / Imported Math.ATan2 function.
--
--  June 30, 1994 / Charlotte Mildren / Imported Math.ASin function.
--
--  July 26, 1994 / Charlotte MIldren / Added K_Degrees_To_Radians and 
--                                      K_Radians_To_Degrees constants and
--                                      deleted the converstion routines.
--
--                                      Added K_Two_Pi.
--
-- July 28, 1994 / Charlotte MIldren / Added K_Feet_To_Meters and K_Meters_To_Feet.
-- 
--
-- Aug 11, 1994  / Charlotte Mildren / Imported Math.FAbs and Math.FAbsf
--                                     functions    
--
-- Aug 12, 1994 / Charlotte Mildren /  Added PERCENT data type.  
--
-- Aug 15, 1994 / Charlotte Mildren / Imported Math.ACos functions
--         
--=============================================================================
                                   
