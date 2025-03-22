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
-- Package Name:       Generic_Sort_PDUs_By_Velocity
--
-- File Name:          Generic_Sort_PSUs_By_Velocity_.ada
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
--   Contains a unit to sort a list of PDU pointers in either ascending or 
--   descending order according to the PDU's velocity.  Descending order is
--   the default which means that the first PDU in the list will be the with 
--   the fastest velocity.
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

   -- Import function to get the velocity vector from the PDU.
   with function PDU_Velocity(
           PDU : in ITEM) 
          return DIS_Types.A_VECTOR;

   with function Null_Item
          return ITEM;

package Generic_Sort_List_By_Velocity is

   --==========================================================================
   -- SORT_VELOCITY
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts a list of PDU pointers in either ascending or descending order 
   --   according to the PDU's velocity.  Descending order is the default which
   --   means that the first PDU in the list will be the with the fastest
   --   velocity.
   --
   --   In/Out Parameters: 
   --  
   --     The_List            - A pointer to a list of entity or event PDUs.
   --  
   --   Input Parameters:
   --
   --      Descending         - The default is TRUE.  If this is set to FALSE
   --                           the list will be sorted in ascending order.
   --
   --   Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --                One of the following status values will be returned:
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
   procedure Sort_Velocity( 
      The_List   : in out PTR;
      Descending : in     BOOLEAN := TRUE;
      Status     :    out DL_Status.STATUS_TYPE); 
      
end Generic_Sort_List_By_Velocity; 
