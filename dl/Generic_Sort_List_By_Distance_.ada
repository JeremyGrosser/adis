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
-- Package Name:       Generic_Sort_List_By_Distance
--
-- File Name:          Generic_Sort_List_By_Distance_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 20, 1994
--
-- Purpose:
--
--   Contains a unit which sorts a list of PDU pointers in either ascending or 
--   descending order according to the PDU's distance to some input refernce 
--   point.  Ascending order is the default which means that the first PDU in 
--   the list will be the one that is closest to the reference point.
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
--==============================================================================
with DL_Status,
     DIS_Types;

generic

   -- import private types from Generic_List package.
   type ITEM is private;
   type PTR is private;

   -- Import procedures from Generic_List package.
   with procedure Change_Item(
           New_Item  : in ITEM;
           Null_Item : in ITEM;
           Old_Item  : in PTR);

   -- Import functions from Generic_List package.
   with function Length_Of(
           The_List : in PTR) 
          return NATURAL;

   with function Is_Null(
           The_List : in  PTR) 
          return Boolean; 

   with function Tail_Of(
           The_List : in PTR) 
          return PTR;

  with function Value_Of(
          The_List : in PTR) 
         return ITEM;

   -- Import function to set the status for the correct instantiated unit.
   with function Get_Status
          return DL_Status.STATUS_TYPE;

   -- Import unit to get the location from the PDU.
   with function PDU_Location(
           PDU: in ITEM) 
          return DIS_Types.A_WORLD_COORDINATE;

   with function Null_Item
          return ITEM;

package Generic_Sort_List_By_Distance is

   --==========================================================================
   -- SORT_DISTANCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts a list of PDU pointers in either ascending or descending order 
   --   according to the PDU's distance to some input refernce point.  Ascending
   --   order is the default which means that the first PDU in the list will be
   --   the one that is closest to the reference point.
   --
   --   In/Out Parameters: 
   --  
   --     The_List - A pointer to a list of entity or event PDUs.
   --  
   --   Input Parameters:
   --
   --      Reference_Position - Used to calculate the distance to each entity in
   --                           the list. 
   --
   --      Ascending - The default is TRUE.  If this is set to FALSE the list will
   --                  be sorted in descending order.
   --
   --   Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               Other - The error code for the instantiated unit will be
   --               returned if this unit enconters an error.  If an error occurs
   --               in a call to a sub-routine, the procedure will terminate and
   --               the status (error code) for the failed routine will be 
   --               returned.	
   --	
   -- Exceptions:
   --   None.
   --==========================================================================
   procedure Sort_Distance( 
      The_List           : in out PTR;
      Ascending          : in     BOOLEAN := TRUE;
      Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
      Status             :    out DL_Status.STATUS_TYPE); 
      
end Generic_Sort_List_By_Distance; 
