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
-- File Name:          Get_PDU_Data_.ada
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
with DIS_PDU_Pointer_Types,
     DIS_Types;

package Get_PDU_Data is

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
     return DIS_Types.A_WORLD_COORDINATE;

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
     return DIS_Types.A_WORLD_COORDINATE;

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
     return DIS_Types.A_WORLD_COORDINATE;
  
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
     return DIS_Types.A_WORLD_COORDINATE;

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
     return DIS_Types.A_WORLD_COORDINATE;

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
     return DIS_Types.A_VECTOR;

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
     return DIS_PDU_Pointer_Types.DETONATION_PDU_PTR;

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
     return DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;

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
     return DIS_PDU_Pointer_Types.FIRE_PDU_PTR;

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
     return DIS_PDU_Pointer_Types.LASER_PDU_PTR;

   --==========================================================================
   -- NULL_TRANSMITTER_PDU_POINTER
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
     return DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR;
    
end Get_PDU_Data;
