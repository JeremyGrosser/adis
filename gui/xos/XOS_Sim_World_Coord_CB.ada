--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--

with Coordinate_Conversions;
with DIS_Types;
with DL_Status;
with DL_Types;
with Motif_Utilities;
with Text_IO;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Sim_World_Coord_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 23, 1994
--
-- PURPOSE:
--   This procedure reads the values out of the standard database
--   coordinate fields (in Geodetic coordinates), converts these
--   into world coordinates (aka, Geocentric coordinates) and places
--   these new values into the appropriate labels on the Sim display.
--
-- IMPLEMENTATION NOTES:
--   None.
--
-- EXCEPTIONS:
--   None.
--
-- PORTABILITY ISSUES:
--   None.
--
-- ANTICIPATED CHANGES:
--   None.
--
---------------------------------------------------------------------------
procedure Sim_World_Coord_CB (
   Parent      : in     Xt.WIDGET;
   Sim_Data    : in out XOS_Types.XOS_SIM_PARM_DATA_REC_PTR;
   Call_Data   :    out Xm.ANYCALLBACKSTRUCT_PTR) is

   Latitude_String  : Xm.STRING_PTR := NULL;
   Longitude_String : Xm.STRING_PTR := NULL;
   Altitude_String  : Xm.STRING_PTR := NULL;

   Geodetic_Latitude_Value   : FLOAT;
   Geodetic_Longitude_Value  : FLOAT;
   Geodetic_Altitude_Value   : FLOAT;

   Geocentric_Latitude_Value   : FLOAT;
   Geocentric_Longitude_Value  : FLOAT;
   Geocentric_Altitude_Value   : FLOAT;

   K_Converted_Value_String_Max : constant INTEGER := 100;
   Converted_Value_String : STRING(1..K_Converted_Value_String_Max)
     := (OTHERS => ASCII.NUL);

   Success : BOOLEAN;

   Geodetic_Coordinates   : DL_Types.THE_GEODETIC_COORDINATES;
   Geocentric_Coordinates : DIS_Types.A_WORLD_COORDINATE;
   Status                 : DL_Status.STATUS_TYPE;

   Get_Value_From_Text_Failed        : EXCEPTION;
   Get_Value_From_Text_Failed_String : constant STRING
     := "GET VALUE ERRROR";
   Geodetic_To_Geocentric_Conversion_Failed : EXCEPTION;
   Geodetic_To_Geocentric_Conversion_Failed_String : constant STRING
     := "CONVERT ERROR";
   Unknown_Error_String              : constant STRING
     := "UNKNOWN ERROR";

   function XmSTRING_PTR_To_XtPOINTER
     is new Unchecked_Conversion (Xm.STRING_PTR, Xt.POINTER);
   function "="(Left, Right: DL_Status.STATUS_TYPE) return BOOLEAN
     renames DL_Status."=";
begin

   if ((not Xt."="(Sim_Data.Sim.DB_Origin_Latitude, Xt.XNULL))
     and (not Xt."="(Sim_Data.Sim.DB_Origin_Longitude, Xt.XNULL))
       and (not Xt."="(Sim_Data.Sim.DB_Origin_Altitude, Xt.XNULL))
         and (not Xt."="(Sim_Data.Sim.DB_Origin_X_WC, Xt.XNULL))
           and (not Xt."="(Sim_Data.Sim.DB_Origin_Y_WC, Xt.XNULL))
             and (not Xt."="(Sim_Data.Sim.DB_Origin_Z_WC, Xt.XNULL)))
	       then

      --
      -- Extract Geodetic coordinates from the standard database
      -- coordinate fields in the Simulation Parameters panel.
      --
      Latitude_String  := Xm.TextFieldGetString(Sim_Data.Sim.
	DB_Origin_Latitude);
      Utilities.Get_Float_From_Text (
	Text_String  => Latitude_String.all,
	Return_Value => Geodetic_Latitude_Value,
	Success      => Success);
      if (not Success) then
	 raise Get_Value_From_Text_Failed;
      end if;

      Longitude_String := Xm.TextFieldGetString(Sim_Data.Sim.
	DB_Origin_Longitude);
      Utilities.Get_Float_From_Text (
	Text_String  => Longitude_String.all,
	Return_Value => Geodetic_Longitude_Value,
	Success      => Success);
      if (not Success) then
	 raise Get_Value_From_Text_Failed;
      end if;

      Altitude_String  := Xm.TextFieldGetString(Sim_Data.Sim.
	DB_Origin_Altitude);
      Utilities.Get_Float_From_Text (
	Text_String  => Altitude_String.all,
	Return_Value => Geodetic_Altitude_Value,
	Success      => Success);
      if (not Success) then
	 raise Get_Value_From_Text_Failed;
      end if;

      --
      -- Convert the Geodetic coordinates to Geocentric coordinates.
      --
      Geodetic_Coordinates.Latitude  := DL_Types.DEGREES_SEMI(
	Geodetic_Latitude_Value);
      Geodetic_Coordinates.Longitude := DL_Types.DEGREES_CIRC(
	Geodetic_Longitude_Value);
      Geodetic_Coordinates.Altitude  := DL_Types.THE_ALTITUDE(
	Geodetic_Altitude_Value);
      Coordinate_Conversions.Geodetic_To_Geocentric_Conversion(
         Geodetic_Coordinates   => Geodetic_Coordinates,
         Geocentric_Coordinates => Geocentric_Coordinates,
         Status                 => Status);

      if (Status = DL_Status.SUCCESS) then

	 --
	 -- Put the Geocentric coordinates into the appropriate labels on the
	 -- Simulation Parameters panel.
	 --
	 Utilities.Float_To_String (FLOAT(Geocentric_Coordinates.X),
	   Converted_Value_String);
	 Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_X_WC, 
	   Converted_Value_String);

	 Utilities.Float_To_String (FLOAT(Geocentric_Coordinates.Y),
	   Converted_Value_String);
	 Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Y_WC, 
	   Converted_Value_String);

	 Utilities.Float_To_String (FLOAT(Geocentric_Coordinates.Z),
	   Converted_Value_String);
	 Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Z_WC, 
	   Converted_Value_String);

      else
	 raise Geodetic_To_Geocentric_Conversion_Failed;
      end if;

      --
      -- Free the memory pointed to by Altitude_String which was
      -- allocated by the X/Motif call Xm.TextfieldGetString().
      --
      -- Don't free this (as you normally would), because Verdix Ada
      -- corrupts memory when you do...
      --
      --Xt.Free (XmSTRING_PTR_To_XtPOINTER(Altitude_String));

   end if;

exception

   --
   -- Handle Get_Value_From_Text_Failed exception...
   --
   when Get_Value_From_Text_Failed =>
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_X_WC, 
	Get_Value_From_Text_Failed_String);
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Y_WC, 
	Get_Value_From_Text_Failed_String);
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Z_WC, 
	Get_Value_From_Text_Failed_String);

   --
   -- Handle Geodetic_To_Geocentric_Conversion_Failed exceptions...
   --
   when Geodetic_To_Geocentric_Conversion_Failed =>
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_X_WC, 
	Geodetic_To_Geocentric_Conversion_Failed_String);
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Y_WC, 
	Geodetic_To_Geocentric_Conversion_Failed_String);
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Z_WC, 
	Geodetic_To_Geocentric_Conversion_Failed_String);

   --
   -- Handle OTHERS exceptions...
   --
   when OTHERS =>
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_X_WC, 
	Unknown_Error_String);
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Y_WC, 
	Unknown_Error_String);
      Motif_Utilities.Set_Labelstring (Sim_Data.Sim.DB_Origin_Z_WC, 
	Unknown_Error_String);

end Sim_World_Coord_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/23/94   D. Forrest
--      - Initial version
--
-- --

