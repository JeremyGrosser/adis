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
-- Package Name:       DL_Linked_List_Types
--
-- File Name:          DL_Linked_List_Types.ada 
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 7, 1994
--
-- Purpose:
--
--    Provides instantiations of the Generic_List and Generic_List_Utilities
--    packages which contain units to manage a generic double linked list (see
--    package specifications).  The packages are instantiated for a pointer
--    to a PDU node that is stored in shared memory.  Since the DG will be
--    handling this shared memory no method of freeing the pointer to the 
--    shared memory location is provided.  A method of freeing the pointer to the
--    generic list nodes is provided.
--    
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
--	None
--
--=============================================================================	    
package body DL_Linked_List_Types is
  
   --==========================================================================
   -- INSTANTIATE GENERICS FOR DETONATION PDUS
   --==========================================================================
 
   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If this unit is called, a specific function body should be defined.
   function Detonation_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.DETONATION_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.DETONATION_PDU_PTR)
   return BOOLEAN is
 
      begin
          if (Item_1.World_Location.X < Item_2.World_Location.X)
            and
             (Item_1.World_Location.Y < Item_2.World_Location.y)
            and
             (Item_1.World_Location.Z < Item_2.World_Location.Z)
          then
             return TRUE;
          else
             return FALSE;
          end if;
       end Detonation_Less_Than;

  

   --==========================================================================
   -- INSTANTIATE GENERICS FOR ENTITY STATE PDUS
   --==========================================================================
  
   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If this unit is called, a specific function body should be defined.
   function Entity_State_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR)
   return BOOLEAN is

      begin
          if (Item_1.Location.X < Item_2.Location.X)
            and
             (Item_1.Location.Y < Item_2.Location.y)
            and
             (Item_1.Location.Z < Item_2.Location.Z)
          then
             return TRUE;
          else
             return FALSE;
          end if;
       end Entity_State_Less_Than;

  
   --==========================================================================
   -- INSTANTIATE GENERICS FOR FIRE PDUS
   --==========================================================================

   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If this unit is called, a specific function body should be defined.
   function Fire_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.FIRE_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.FIRE_PDU_PTR)
   return BOOLEAN is

      begin
          if (Item_1.World_Location.X < Item_2.World_Location.X)
            and
             (Item_1.World_Location.Y < Item_2.World_Location.y)
            and
             (Item_1.World_Location.Z < Item_2.World_Location.Z)
          then
             return TRUE;
          else
             return FALSE;
          end if;
       end Fire_Less_Than;



   --==========================================================================
   -- INSTANTIATE GENERICS FOR LASER PDUS
   --==========================================================================

   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If this unit is called, a specific function body should be defined.
   function Laser_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.LASER_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.LASER_PDU_PTR)
   return BOOLEAN is

      begin
          if (Item_1.Laser_Spot_Location.X < Item_2.Laser_Spot_Location.X)
            and
             (Item_1.Laser_Spot_Location.Y < Item_2.Laser_Spot_Location.y)
            and
             (Item_1.Laser_Spot_Location.Z < Item_2.Laser_Spot_Location.Z)
          then
             return TRUE;
          else
             return FALSE;
          end if;
       end Laser_Less_Than;


   --==========================================================================
   -- INSTANTIATE GENERICS FOR TRANSMITTER PDUS
   --==========================================================================

   -- This is a dummy function.
   -- This function is required by the Straight_Insertion_Sort which is not
   -- used.  If this unit is called, a specific function body should be defined.
   function Transmitter_Less_Than(
      Item_1 : in DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR;
      Item_2 : in DIS_PDU_Pointer_Types.TRANSMITTER_PDU_PTR)
   return BOOLEAN is

      begin
          if (Item_1.Antenna_Location.Antenna_Location.X < 
              Item_2.Antenna_Location.Antenna_Location.X)
            and
             (Item_1.Antenna_Location.Antenna_Location.Y < 
              Item_2.Antenna_Location.Antenna_Location.Y)
            and
             (Item_1.Antenna_Location.Antenna_Location.Z < 
              Item_2.Antenna_Location.Antenna_Location.Z)
            and
             (Item_1.Antenna_Location.
                Relative_Antenna_Location.X < 
              Item_2.Antenna_Location.
                Relative_Antenna_Location.X)
            and
              (Item_1.Antenna_Location.
                Relative_Antenna_Location.Y < 
              Item_2.Antenna_Location.
                Relative_Antenna_Location.Y)
            and
              (Item_1.Antenna_Location.
                Relative_Antenna_Location.Z < 
              Item_2.Antenna_Location.
                Relative_Antenna_Location.Z)
          then

             return TRUE;

          else

             return FALSE;

          end if;

       end Transmitter_Less_Than;

end DL_Linked_List_Types; 

--==============================================================================
-- 
-- Modification History
--
--
--
--
--=============================================================================== 
