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
-- File Name:          Generic_Binary_Insertion_Sort.ada
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
--
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--==============================================================================
package body Generic_Binary_Insertion_Sort is

   --==========================================================================
   -- SORT
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts an array of records in either accending or decending order
   --   according to the imported "greater than" function.
   --
   -- Implementation:
   --
   --   Sorts the list of items by putting the first two items in sorted order
   --   and then expanding the sort list by one.  The new item is then placed
   --   at the proper position within the previously sorted list.  This process
   --   is speeded up by  dividing the sorted list into two parts and 
   --   determining into which part the current item will be placed.  This means
   --   that only half of a sublist must be searched in order to insert the 
   --   item.  This process is repeated until all the items are in sorted order. 
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
   --==========================================================================
   procedure Sort(
      The_Items : in out ITEMS) is

      -- 
      -- Declare local variables
      --

      -- Temporary storage for item.
      Item_To_Insert : ITEM;

      -- Indexes into the array.
      Left_Index     : INDEX;
      Middle_Index   : INDEX;
      Right_Index    : INDEX;

   begin
             
      -- Outer_Index is 2 to end.
      for Outer_Index in INDEX'SUCC(The_Items'FIRST)..The_Items'LAST loop

         -- Get the new item that will be inserted into the sorted list.
         Item_To_Insert := The_Items(Outer_Index);

         -- Initialize the left and right index so that the saved item can be
         -- inserted in the proper order between the first item and the 
         -- item at the current array index (Outer_Index).
         Left_Index  := The_Items'FIRST;
         Right_Index := Outer_Index;

         -- If the Left_Index > than Right_Index then the saved item should be
         -- inserted at the Left_Index.
         while Left_Index <= Right_Index loop

            -- Find the middle of the sorted list.
            Middle_Index := INDEX'VAL((INDEX'POS(Left_Index) 
                             + INDEX'POS(Right_Index)) / 2);

            if Item_To_Insert < The_Items(Middle_Index) then

               -- At begining of array.
               exit when (Middle_Index = The_Items'FIRST);

               -- Will be inserted before Middle_Index.
               -- Continue to narrow search area.
               Right_Index := INDEX'PRED(Middle_Index);

            else

               -- Reached end of array.
               exit when (Middle_Index = Outer_Index);

               -- Will be inserted after Middle_Index. 
               -- Continue to narrow search area.
               Left_Index := INDEX'SUCC(Middle_Index);

            end if;

         end loop; -- while

         -- If Left_Index = Outer_Index then the item is in the correct
         -- position.
         if Left_Index /= Outer_Index then

            -- Move items down one index to leave a space to insert item. 
            The_Items(INDEX'SUCC(Left_Index)..Outer_Index) :=
              The_Items(Left_Index..INDEX'PRED(Outer_Index));

            The_Items(Left_Index) := Item_To_Insert;

         end if;

      end loop;-- for

   end Sort;
    
end Generic_Binary_Insertion_Sort; 
