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
-- Package Name:       Get_PDU_Data
--
-- File Name:          Get_PDU_Data.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   Sept 2, 1994
--
-- Purpose:
--
--   Contains functions that get data from PDUs for instantiations of generic
--   packages.
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

package body Get_PDU_Data is

   --==========================================================================
   -- DETONATION_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Detonation_Location( 
      PDU: in  DIS_PDU_Pointer_Types.DETONATION_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.World_Location;
   end Detonation_Location;

   --==========================================================================
   -- ENTITY_STATE_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Entity_State_Location( 
      PDU: in  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.Location;
   end Entity_State_Location;

   --==========================================================================
   -- FIRE_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Fire_Location( 
      PDU: in  DIS_PDU_Pointer_Types.FIRE_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.World_Location;
   end Fire_Location;
  
   --==========================================================================
   -- LASER_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Laser_Location( 
      PDU: in  DIS_PDU_Pointer_Types.LASER_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.Laser_Spot_Location;
   end Laser_Location;

   --==========================================================================
   -- TRANSMITTER_LOCATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's geocentric location from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Transmitter_Location( 
      PDU: in  DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR) 
     return DIS_Types.A_WORLD_COORDINATE is

   begin
      return PDU.Antenna_Location.Antenna_Location;
   end Transmitter_Location;

   --==========================================================================
   -- ENTITY_STATE_VELOCITY
   --==========================================================================
   --
   -- Purpose
   --
   --   Gets the PDU's velocity vector from the record structure. 
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Entity_State_Velocity(
      PDU: in  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR) 
     return DIS_Types.A_VECTOR is --(LINEAR_VELOCITY IS 
                                  -- A_LINEAR_VELOCITY_VECTOR A SUBTYPE OF
                                  --   A_VECTOR)
   begin
      return PDU.Linear_Velocity;
   end Entity_State_Velocity;

   --==========================================================================
   -- NULL_DETONATION_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Detonation_PDU_Pointer
     return DIS_PDU_Pointer_Types.DETONATION_PDU_PTR is

      PDU_Pointer : DIS_PDU_Pointer_Types.DETONATION_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Detonation_PDU_Pointer;

   --==========================================================================
   -- NULL_ENTITY_STATE_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Entity_State_PDU_Pointer
     return DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR is

    PDU_Pointer : DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Entity_State_PDU_Pointer;

   --==========================================================================
   -- NULL_FIRE_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Fire_PDU_Pointer
     return DIS_PDU_Pointer_Types.FIRE_PDU_PTR is

    PDU_Pointer : DIS_PDU_Pointer_Types.FIRE_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Fire_PDU_Pointer;

   --==========================================================================
   -- NULL_LASER_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Laser_PDU_Pointer
     return DIS_PDU_Pointer_Types.LASER_PDU_PTR is

    PDU_Pointer : DIS_PDU_Pointer_Types.LASER_PDU_PTR := NULL;

   begin
      return PDU_Pointer;
   end Null_Laser_PDU_Pointer;

   --==========================================================================
   -- NULL_ENTITY_STATE_PDU_POINTER
   --==========================================================================
   --
   -- Purpose
   --
   --   Creates a null PDU pointer.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   function Null_Transmitter_PDU_Pointer
     return DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR is

      PDU_Pointer : DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR:= NULL;

   begin
      return PDU_Pointer;
   end Null_Transmitter_PDU_Pointer;
  
end Get_PDU_Data;
