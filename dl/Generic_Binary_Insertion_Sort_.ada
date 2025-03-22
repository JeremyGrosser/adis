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
-- Package Name:       Generic_Binary_Insertion_Sort
--
-- File Name:          Generic_Binary_Insertion_Sort_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 18, 1994
--
-- Purpose:
--
--   Sorts an array of items by inserting the current item to sort at the proper
--   place within a list of previously sorted items. 
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
generic

   type ITEM is private;
   type INDEX is (<>);
   type ITEMS is array(INDEX range <>) of ITEM;

   with function "<" (
           Left  : in ITEM;
           Right : in ITEM) 
          return BOOLEAN;

package Generic_Binary_Insertion_Sort is

   procedure Sort(
      The_Items : in out ITEMS);
      
end Generic_Binary_Insertion_Sort; 
