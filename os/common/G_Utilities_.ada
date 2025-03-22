--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      G_Utilities (spec and body)
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Larry Ullom - Manned Flight Simulator
--                     Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  12 September 94
--
-- PURPOSE :
--   - This package contains the Find_G routine which calculates the X, Y,
--     and Z components of the g acceleration vector is World Coordinates as
--     it acts on an entity located at a specified position.
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
with DIS_Types,
     Math,
     Numeric_Types,
     OS_Data_Types,
     OS_Status;

package G_Utilities is

   type G_VECTOR_TYPE is
     record
       X_Accel :  Numeric_Types.FLOAT_64_BIT;
       Y_Accel :  Numeric_Types.FLOAT_64_BIT;
       Z_Accel :  Numeric_Types.FLOAT_64_BIT;
     end record;

   procedure Find_G(
      Entity_Position :  in     DIS_Types.A_WORLD_COORDINATE;
      G_Vector        :     out G_VECTOR_TYPE;
      Status          :     out OS_Status.STATUS_TYPE);

end G_Utilities;

package body G_Utilities is

   -- Procedure body
   procedure Find_G(
      Entity_Position :  in     DIS_Types.A_WORLD_COORDINATE;
      G_Vector        :     out G_VECTOR_TYPE;
      Status          :     out OS_Status.STATUS_TYPE)
     is

      -- Local variables
      X_Cos :  Numeric_Types.FLOAT_64_BIT;
      Y_Cos :  Numeric_Types.FLOAT_64_BIT;
      Z_Cos :  Numeric_Types.FLOAT_64_BIT;
      P_Mag :  Numeric_Types.FLOAT_64_BIT;

   begin -- Find_G

      -- Initialize status
      Status := OS_Status.SUCCESS;

      P_Mag := Math.sqrt(
          Entity_Position.X * Entity_Position.X
        + Entity_Position.Y * Entity_Position.Y
        + Entity_Position.Z * Entity_Position.Z);

      X_Cos := Entity_Position.X / P_Mag;
      Y_Cos := Entity_Position.Y / P_Mag;
      Z_Cos := Entity_Position.Z / P_Mag;

      G_Vector.X_Accel := X_Cos
        * Numeric_Types.FLOAT_64_BIT(-OS_Data_Types.K_g);
      G_Vector.Y_Accel := Y_Cos
        * Numeric_Types.FLOAT_64_BIT(-OS_Data_Types.K_g);
      G_Vector.Z_Accel := Z_Cos
        * Numeric_Types.FLOAT_64_BIT(-OS_Data_Types.K_g);

   exception
      when OTHERS =>
         Status := OS_Status.FG_ERROR;
   end Find_G;

end G_Utilities;
