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
-- Package Name:       Orientation_Conversions
--
-- File Name:          Orientation_Conversions.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 25, 1994
--
-- Purpose:
--
--   Contains routines that convert between Euler Angles to local orientation
--   of roll, pitch and heading and vice versa.
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
with DL_Math,
     Math,
     Numeric_Types;

package body Orientation_Conversions is

   --
   -- Import functions to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";
 
   --==========================================================================
   -- EULERS_TO_LOCAL_ORIENTATION
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from Euler Angles to roll, pitch, and heading.
   --
   -- Implementation:
   --
   --   Algorithms from SIMMET/DIS Connection C code by:
   --     ETA & NOSC
   --     5505 Morehouse Dr. Suite 100
   --     San Diego Ca 92121
   --
   --   (from file convertMath.c, unit EulerstoLocalOrient)
   --
   --   If an error occurs in the call to a sub-routine, this procedure will
   --   terminate and the status for the sub-routine will be returned.
   --
   --    NOTE: Heading is normalized 0 to 360 degrees
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
   --=========================================================================	
   procedure Eulers_To_Local_Orientation( 
      Euler_Angles         : in     DIS_Types.AN_EULER_ANGLES_RECORD;
      Geodetic_Coordinates : in     DL_Types.THE_GEODETIC_COORDINATES;
      Local_Orientation    :    out DL_Types.LOCAL_ORIENTATION;
      Status               :    out DL_Status.STATUS_TYPE) is
    
      -- 
      -- Declare local variables
      --
      Call_Status       : DL_Status.STATUS_TYPE;
      
      -- Define latitude in radians.
      Latitude          : DL_Types.THE_LATITUDE
                            := Geodetic_Coordinates.Latitude
                                 * DL_Math.K_Degrees_To_Radians;

      -- Define longitude in radians.
      Longitude         : DL_Types.THE_LONGITUDE
                            := Geodetic_Coordinates.Longitude
                                 * DL_Math.K_Degrees_To_Radians;
  
      -- Define local orientation variables for calculations.
      Heading           : Numeric_Types.FLOAT_64_BIT;
      Pitch             : Numeric_Types.FLOAT_64_BIT;
      Roll              : Numeric_Types.FLOAT_64_BIT;
   
      -- Define storage for Sin and Cos function results.    
      Cos_Lat           : Numeric_Types.FLOAT_64_BIT;
      Sin_Lat           : Numeric_Types.FLOAT_64_BIT;

      Cos_Lon           : Numeric_Types.FLOAT_64_BIT; 
      Sin_Lon           : Numeric_Types.FLOAT_64_BIT;

      Cos_Lat_Cos_Lon   : Numeric_Types.FLOAT_64_BIT;
      Cos_Lat_Sin_Lon   : Numeric_Types.FLOAT_64_BIT;

      Sin_Lat_Sin_Lon   : Numeric_Types.FLOAT_64_BIT;
      Sin_Lat_Cos_Lon   : Numeric_Types.FLOAT_64_BIT;
   
      Cos_Theta_Cos_Psi : Numeric_Types.FLOAT_64_BIT;
      Cos_Theta_Sin_Psi : Numeric_Types.FLOAT_64_BIT;

      B_Sub_11          : Numeric_Types.FLOAT_64_BIT;
      B_Sub_12          : Numeric_Types.FLOAT_64_BIT;

      B_Sub_23          : Numeric_Types.FLOAT_64_BIT;
      B_Sub_33          : Numeric_Types.FLOAT_64_BIT;

      -- Define storage for Euler Angles trig calculations.
      Trig              : DL_Math.EULER_TRIG_64_BIT;

      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE      : EXCEPTION; 

   begin  -- Eulers_To_Local_Orientation

      Status := DL_Status.SUCCESS;

      -- Calculate trig functions for the latitude.
      DL_Math.Sin_Cos_Lat(
        Angle     => Latitude,
        Cos_Angle => Cos_Lat,
        Sin_Angle => Sin_Lat,
        Status    => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      -- Calculate trig functions for the Longitude.
      DL_Math.Sin_Cos_Lon(
        Angle     => Longitude,
        Cos_Angle => Cos_Lon,
        Sin_Angle => Sin_Lon,
        Status    => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;    
      
      -- Calculate combined trig functions for latitude and longitude.
      Sin_Lat_Sin_Lon := Sin_Lat * Sin_Lon;
      Sin_Lat_Cos_Lon := Sin_Lat * Cos_Lon;
      Cos_Lat_Sin_Lon := Cos_Lat * Sin_Lon;
      Cos_Lat_Cos_Lon := Cos_Lat * Cos_Lon;

      -- Convert Euler Angles to radians and calculate trig functions.
      DL_Math.Calculate_Euler_Trig(
        Euler_Angles => Euler_Angles,
        Trig_Values  => Trig,
        Status       => Call_Status);

       if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;  
   
      -- Calculate local pitch.
      Pitch := DL_Math.Asin(Cos_Lat_Cos_Lon * Trig(DL_Math.COS_THETA) 
                 * Trig(DL_Math.COS_PSI) + Cos_Lat_Sin_Lon 
                 * Trig(DL_Math.COS_THETA)
                 * Trig(DL_Math.SIN_PSI)
                 - Sin_Lat * Trig(DL_Math.SIN_THETA)); 
   
      B_Sub_23 :=  Cos_Lat_Cos_Lon * ( -Trig(DL_Math.SIN_PSI_COS_PHI)
                    + ( Trig(DL_Math.SIN_THETA) * Trig(DL_Math.COS_PSI_SIN_PHI) ))
                    + Cos_Lat_Sin_Lon 
                    * ( Trig(DL_Math.COS_PSI_COS_PHI)
                    + ( Trig(DL_Math.SIN_THETA) * Trig(DL_Math.SIN_PSI_SIN_PHI) ))
                    + Sin_Lat 
                    * ( Trig(DL_Math.SIN_PHI) * Trig(DL_Math.COS_THETA) );

      B_Sub_33 := Cos_Lat_Cos_Lon * ( Trig(DL_Math.SIN_PSI_SIN_PHI) 
                    + ( Trig(DL_Math.SIN_THETA) * Trig(DL_Math.COS_PSI_COS_PHI) ))
                    + Cos_Lat_Sin_Lon * ( -Trig(DL_Math.COS_PSI_SIN_PHI)
                    + ( Trig(DL_Math.SIN_THETA) * Trig(DL_Math.SIN_PSI_COS_PHI) ))
                    + Sin_Lat * ( Trig(DL_Math.COS_PHI) * Trig(DL_Math.COS_THETA) );

      Roll := DL_Math.ATan2(-B_Sub_23, -B_Sub_33);

      -- Calculate local heading.
      Cos_Theta_Cos_Psi := Trig(DL_Math.COS_THETA) * Trig(DL_Math.COS_PSI);
      Cos_Theta_Sin_Psi := Trig(DL_Math.COS_THETA) * Trig(DL_Math.SIN_PSI);

      B_Sub_11 := -Sin_Lon * Cos_Theta_Cos_Psi + Cos_Lon * Cos_Theta_Sin_Psi;

      B_Sub_12 := -Sin_Lat_Cos_Lon * Cos_Theta_Cos_Psi - Sin_Lat_Sin_Lon
                    * Cos_Theta_Sin_Psi - Cos_Lat * Trig(DL_Math.SIN_THETA);

      Heading := DL_Math.ATan2(B_Sub_11, B_Sub_12);

      -- Normalize heading from 0 to 2pi
      if Heading < 0.0 then
         Heading := Heading + DL_Math.K_Two_pi; 
      end if;

      -- Convert the 64 bit to 32 and radians to degrees.
     Local_Orientation.Pitch   := DL_Types.THE_PITCH(Pitch) * DL_Math.K_Radians_To_Degrees;
                                   
     Local_Orientation.Roll    := DL_Types.THE_ROLL(Roll) * DL_Math.K_Radians_To_Degrees;

     Local_Orientation.Heading := DL_Types.THE_HEADING(Heading) * 
                                    DL_Math.K_Radians_To_Degrees;
       
   exception
  
      when CALL_FAILURE =>
        Status := Call_Status;

      when OTHERS       => 
        Status := DL_Status.EUL_ORI_FAILURE;
        
   end Eulers_To_Local_Orientation;

   --==========================================================================
   -- LOCAL_ORIENTATION_TO_EULERS
   --==========================================================================
   --
   -- Purpose:
   --
   --   Converts from roll, pitch and heading to Euler Angles. 
   --
   -- Implementation:
   --
   --   Algorithms from SIMMET/DIS Connection C code by:
   --     ETA & NOSC
   --     5505 Morehouse Dr. Suite 100
   --     San Diego Ca 92121
   --
   --   (from file convertMath.c, unit LocalOrienttoEulers)
   --
   --   If an error occurs in the call to a sub-routine, this procedure will
   --   terminate and the status for the sub-routine will be returned.
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
   --==========================================================================
   procedure Local_Orientation_To_Eulers( 
      Geodetic_Coordinates : in     DL_Types.THE_GEODETIC_COORDINATES;
      Local_Orientation    : in     DL_Types.LOCAL_ORIENTATION;
      Euler_Angles         :    out     DIS_Types.AN_EULER_ANGLES_RECORD;
      Status               :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables.
      --
      Call_Status           : DL_Status.STATUS_TYPE;

      -- Define latitude in radians.
      Latitude              : DL_Types.THE_LATITUDE 
                                := Geodetic_Coordinates.Latitude
                                     * DL_Math.K_Degrees_To_Radians;

      -- Define longitude in radians and 32 bit.
      Longitude              : DL_Types.THE_LONGITUDE
                                := Geodetic_Coordinates.Longitude
                                     * DL_Math.K_Degrees_To_Radians;

      -- Define 64 bit Roll in radians.
      Roll                  : Numeric_Types.FLOAT_64_BIT
                                :=  Numeric_Types.FLOAT_64_BIT(Local_Orientation.Roll)
                                      * DL_Math.K_Degrees_To_Radians;

      -- Define 64 bit Pitch in radians.
      Pitch                 : Numeric_Types.FLOAT_64_BIT
                                :=  Numeric_Types.FLOAT_64_BIT(Local_Orientation.Pitch)
                                      * DL_Math.K_Degrees_To_Radians;

      -- Define 64 bit Heading in radians.
      Heading               : Numeric_Types.FLOAT_64_BIT
                                :=  Numeric_Types.FLOAT_64_BIT(Local_Orientation.Heading)
                                      * DL_Math.K_Degrees_To_Radians;

      -- Define 64 Bit Euler Angles.
      Psi                   : Numeric_Types.FLOAT_64_BIT;
      Theta                 : Numeric_Types.FLOAT_64_BIT;
      Phi                   : Numeric_Types.FLOAT_64_BIT;

      -- Define storage for Sin and Cos function results.

      Cos_Lat               : Numeric_Types.FLOAT_64_BIT;
      Sin_Lat               : Numeric_Types.FLOAT_64_BIT;

      Cos_Lon               : Numeric_Types.FLOAT_64_BIT;
      Sin_Lon               : Numeric_Types.FLOAT_64_BIT;

      Cos_Lat_Cos_Lon       : Numeric_Types.FLOAT_64_BIT;
      Cos_Lat_Sin_Lon       : Numeric_Types.FLOAT_64_BIT;
     
      Sin_Lat_Sin_Lon       : Numeric_Types.FLOAT_64_BIT;
      Sin_Lat_Cos_Lon       : Numeric_Types.FLOAT_64_BIT;

      Cos_Roll              : Numeric_Types.FLOAT_64_BIT;
      Sin_Roll              : Numeric_Types.FLOAT_64_BIT;

      Cos_Pitch             : Numeric_Types.FLOAT_64_BIT;
      Sin_Pitch             : Numeric_Types.FLOAT_64_BIT;

      Cos_Heading           : Numeric_Types.FLOAT_64_BIT;
      Sin_Heading           : Numeric_Types.FLOAT_64_BIT;

      Cos_Pitch_Cos_Heading : Numeric_Types.FLOAT_64_BIT;
      Cos_Pitch_Sin_Heading : Numeric_Types.FLOAT_64_BIT;

      A_Sub_11              : Numeric_Types.FLOAT_64_BIT;
      A_Sub_12              : Numeric_Types.FLOAT_64_BIT;
 
      A_Sub_23              : Numeric_Types.FLOAT_64_BIT;
      A_Sub_33              : Numeric_Types.FLOAT_64_BIT;

      -- Define an exception to allow for exiting if the called routine fails.
      CALL_FAILURE      : EXCEPTION; 

   begin -- Local_Orientation_To_Eulers

      Status := DL_Status.SUCCESS;

      -- Calculate trig functions for the latitude.
      DL_Math.Sin_Cos_Lat(
        Angle     => Latitude,
        Cos_Angle => Cos_Lat,
        Sin_Angle => Sin_Lat,
        Status    => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

      -- Calculate trig functions for the Longitude.
      DL_Math.Sin_Cos_Lon(
        Angle     => Longitude,
        Cos_Angle => Cos_Lon,
        Sin_Angle => Sin_Lon,
        Status    => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;
      
      -- Calculate combined trig functions for latitude and longitude.
      Cos_Lat_Sin_Lon := Cos_Lat * Sin_Lon;
      Cos_Lat_Cos_Lon := Cos_Lat * Cos_Lon;

      Sin_Lat_Sin_Lon := Sin_Lat * Sin_Lon;
      Sin_Lat_Cos_Lon := Sin_Lat * Cos_Lon;
 
      -- Calculate trig functions for Euler Angles.
      Cos_Roll    := Math.Cos(Roll);
      Sin_Roll    := Math.Sin(Roll);

      Cos_Pitch   := Math.Cos(Pitch);
      Sin_Pitch   := Math.Sin(Pitch);

      Cos_Heading := Math.Cos(Heading);
      Sin_Heading := Math.Sin(Heading);
  

      Cos_Pitch_Cos_Heading := Cos_Pitch * Cos_Heading;
      Cos_Pitch_Sin_Heading := Cos_Pitch * Sin_Heading;

      -- Calculate Psi.
      A_Sub_12 := (Cos_Lon * Cos_Pitch_Sin_Heading) 
                  - (Sin_Lat_Sin_Lon * Cos_Pitch_Cos_Heading)
                  + (Cos_Lat_Sin_Lon * Sin_Pitch);

      A_Sub_11 := -(Sin_Lon * Cos_Pitch_Sin_Heading) 
                     - (Sin_Lat_Cos_Lon * Cos_Pitch_Cos_Heading) 
                     + (Cos_Lat_Cos_Lon * Sin_Pitch);

      Psi      := DL_Math.ATan2(A_Sub_12, A_Sub_11);

      -- Calculate Theta.
      Theta    := DL_Math.Asin(-(Sin_Lat * Sin_Pitch) 
                    - (Cos_Lat * Cos_Pitch_Cos_Heading));

      --Calculate Phi  
      A_Sub_23 := (Cos_Lat 
                    * (Sin_Roll * Sin_Pitch * Cos_Heading - Cos_Roll 
                    * Sin_Heading)) 
                    - (Sin_Lat * Sin_Roll * Cos_Pitch);

      A_Sub_33 := (Cos_Lat *
                    (Cos_Roll * Sin_Pitch * Cos_Heading 
                   + Sin_Roll * Sin_Heading))
                   - (Sin_Lat * Cos_Roll * Cos_Pitch);

      Phi := DL_Math.ATan2(A_Sub_23, A_Sub_33);

      -- Convert to 32 bit and radians to degrees.
      Euler_Angles.Psi   := Numeric_Types.FLOAT_32_BIT(Psi); 
--                              * DL_Math.K_Radians_To_Degrees;

      Euler_Angles.Theta := Numeric_Types.FLOAT_32_BIT(Theta);
--                              * DL_Math.K_Radians_To_Degrees;

      Euler_Angles.Phi   := Numeric_Types.FLOAT_32_BIT(Phi);
--                              * DL_Math.K_Radians_To_Degrees;

   exception
  
      when CALL_FAILURE =>
        Status := Call_Status;

      when OTHERS       => 
        Status := DL_Status.ORI_EUL_FAILURE;
        
   end Local_Orientation_To_Eulers;
 


 end Orientation_Conversions;
