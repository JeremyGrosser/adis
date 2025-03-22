--==============================================================================
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
-- Package Name:       Generic_List
--
-- File Name:          Generic_List.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 6, 1994
--
-- Purpose:
--
--   Contains primitive units to create and manage a generic double linked,
--   unbounded list of zero or more items in which items can be added and 
--   removed from any position such that a strict linear ordering is 
--   maintained.  The type of the item is immaterial to the behavior of the 
--   list which is an access based structure.  The ordering of items in the 
--   list is designated by the forward and backward linking of one item to the
--   succeeding and previous items in the list.  A null list contains zero 
--   items.  If a list is not null, the first item is the head of the list.  
--   The sequence of items following a node is called the tail of the list.  
--   There can also be a preceeding list to the referenced node.
--
--	
-- Effects:
--   None
--
-- Exceptions:
--
--   The following exceptions may be propagated from these units:
--
--     LIST_IS_NULL - The desired operation cannot be completed because there 
--                    are no items in the list.
--    
--     POSITION_ERROR - The position in the list does not exist.
--
--     NOT_AT_END - The pointer is not pointing to the last item in the list.
--                      
--     NOT_AT_HEAD - The pointer is not pointing to the first item in the list. 
--
--     OVERFLOW - The list cannot grow large enough to complete the desired 
--                operation. 
--
--     GEN_LIST_FAILURE - This error will be raised if an unhandled Ada 
--                        exception is raised in any of these units.
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--=============================================================================	
with Unchecked_Deallocation;

package body Generic_List is

   type NODE is
     record
       Previous : PTR; 
       The_Item : ITEM;
       Next     : PTR;
     end record;

   -- Instantiate a procedure to deallocate storage.
   procedure Free_Node is new Unchecked_Deallocation(NODE, PTR);

   --==========================================================================
   -- CHANGE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Change an item in the list.
   --
   -- Implementation:
   --  
   --   Clears the current item and assigns the input item.  (See
   --   Set_Head to assign an item to a newly created node at the head of
   --   the list.)
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
    procedure Change_Item(
      New_Item  : in ITEM;
      Null_Item : in ITEM;
      Old_Item  : in PTR) is

   begin

      if Old_Item /= null then

         Old_Item.The_Item := Null_Item;
         Old_Item.The_Item := New_Item;

      else

         raise LIST_IS_NULL;

      end if;

   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Change_Item;

   --==========================================================================
   -- CLEAR_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Sets the input pointer to null; 
   --   
   --   Note: Does not deallocate memory.
   --
   -- Implementation:
   --  
   --   Clears a list by setting the list object to point to null. 
   --   
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised. 
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Clear_List(
      The_List : in out PTR) is

   begin 

      The_List := null;

   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Clear_List;
  
   --==========================================================================
   -- CLEAR_PREVIOUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Clears a node's "previous" pointer. 
   --
   -- Implementation:
   --
   --   Checks to make sure the list is not null then sets the previous pointer
   --   of the input pointer to null;
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Clear_Previous(
      The_List : in  PTR) is 
          
   begin 
         
      if The_List /= null then

         The_List.Previous := null;

      else

         raise LIST_IS_NULL;

      end if;
  
   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Clear_Previous;

   --==========================================================================
   -- CLEAR_NEXT
   --==========================================================================
   --
   -- Purpose
   --
   --   Clears a node's "next" pointer. 
   --
   -- Implementation:
   --  
   --   Checks to make sure the list is not null then sets the next pointer
   --   of the input pointer to null;
   --    	   				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Clear_Next(
      The_List  : in  PTR) is 

   begin 
      
      if The_List /= null then

         The_List.Next := null; 
     
      else    

         raise LIST_IS_NULL;

      end if;

   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Clear_Next;

   --==========================================================================
   -- CLEAR_NODE
   --==========================================================================
   --
   -- Purpose
   --
   --   Clears a node that has been deleted from a list.
   --
   --   Note: Does not deallocate memory.
   --
   -- Implementation:
   --
   --   Check to make sure the node pointer is not null, then set the previous
   --   and next pointers to null;
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Clear_Node(
      The_Node  : in PTR) is 
         
   begin 
      
      if The_Node /= null then

         The_Node.Previous := null;
         The_Node.Next     := null;   
  
      else  
  
         raise LIST_IS_NULL;

      end if;
 
   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Clear_Node;

   --==========================================================================
   -- CONSTRUCT_BOTTOM
   --==========================================================================
   --
   -- Purpose
   --
   --   Add a new node at the end of the list. 
   --
   -- Implementation:
   --
   --   Create an object of type NODE.
   --
   --   Give the NODE record the value of the input item.
   --
   --   Set Next component to point to the end of the List (which may be null).
   --     
   --   Point the list object to this new node.
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   OVERFLOW is raised if the List cannot grow large enough to hold the item.
   --   
   --   NOT_AT_END is raised if the Tail pointer does not point to the last 
   --   item in the list.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Construct_Bottom(
      The_Item : in     ITEM;
      Tail     : in out PTR) is


   begin

      if Tail = null then 

         Tail := new NODE'(Previous => null,
                           The_Item => The_Item,
                           Next     => null); 

      elsif Tail.Next = null then 

         Tail := new NODE'(Previous => Tail,
                           The_Item => The_Item,
                           Next     => null);

         Tail.Previous.Next := Tail;

      else

         raise NOT_AT_END;

      end if;
      
   exception

      when STORAGE_ERROR =>
        raise OVERFLOW;
  
      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Construct_Bottom;

   --==========================================================================
   -- CONSTRUCT_TOP
   --==========================================================================
   --
   -- Purpose
   --
   --   Add a new node at the beginning of the list.
   --
   -- Implementation:
   -- 
   --   Create an object of type NODE.
   --
   --   Give the NODE record the value of the input item.
   --
   --   Set Next component to point to the beginning of the list (which may 
   --   be null).
   -- 
   --   Point the list object to this new node.
   --
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   OVERFLOW is raised if the list cannot grow large enough to hold the item.
   --  
   --   NOT_AT_HEAD is raised if the Head pointer does not point to the first
   --   item in the list.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Construct_Top(
      The_Item : in      ITEM;
      Head     : in out  PTR) is

   begin

      if Head = null then 

         Head  := new NODE'(Previous => null,
                            The_Item => The_Item,
                            Next     => null); 

     elsif Head.Previous = null then

        Head := new NODE'(Previous => null,
                          The_Item => The_Item,
                          Next     => Head);

        Head.Next.Previous := Head;

     else

        raise NOT_AT_HEAD;

     end if; 
     
   exception

      when STORAGE_ERROR =>
        raise OVERFLOW;

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Construct_Top;

   --==========================================================================
   -- COPY
   --==========================================================================
   --
   -- Purpose
   --
   --   Copy the items from one list to another list.
   --
   -- Implementation:
   --
   --   If the "From_List" is null set the "To_List" to null, otherwise
   --   create a new list and add a copy of all the items in the "From_List" to 
   --   the "To_List".
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   OVERFLOW is raised if the destination list cannot grow large 
   --   enough to hold the source list.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Copy(
      From_List : in     PTR;
      To_List   : in out PTR) is 

      -- Declare local variables.
      --
      -- Temporary pointer to traverse the source list. 
      From_Index: PTR:= From_List; 

      -- Temporary pointer to traverse the destination list. 
      To_Index  : PTR;

   begin

      if From_List = null then     -- Check for source list is null.
 
         To_List := null;          --  If True, set the destination list to null.
 
      else

         -- Create new nodes in the target list corresponding to the nodes in 
         -- in the source list. 
         To_List := new NODE'(Previous => null,
                              The_Item => From_Index.The_Item,
                              Next     => null);
         To_Index    := To_List;
         From_Index  := From_Index.Next;

         While From_Index /= null loop

            To_Index.Next := new NODE'(Previous => To_Index,
                                       The_Item => From_Index.The_Item,
                                       Next     => null);
            To_Index := To_Index.Next;
            From_Index := From_Index.Next;
        
         end loop;

      end if;

   exception

      when STORAGE_ERROR => 
        raise OVERFLOW;

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Copy;
 
   --==========================================================================
   -- FREE
   --==========================================================================
   --
   -- Purpose
   --   
   --    Deallocates storage and sets the pointer to null;
   --
   -- Implementation:
   --
   --   If the pointer is already null, it has no effect.
   --
   --   If ITEM is a pointer, it has no effect on the storage pointed to by 
   --   ITEM.
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --=========================================================================
   procedure Free(The_Node : in out PTR) is

     begin
        Free_Node(The_Node);
     end Free;

   --==========================================================================
   -- SET_HEAD
   --==========================================================================
   --
   -- Purpose
   --
   --   Sets the ITEM at the head of the list to the input item.
   --
   -- Implementation:
   --
   --   Assign the input item to the The_Item component at the head of the list.
   --   				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Set_Head(
      Head    : in PTR;
      To_Item : in ITEM) is
  
   begin

      if Head = null then

         raise LIST_IS_NULL;

      else

         Head.The_Item := To_Item;

      end if;

   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Set_Head;

  --===========================================================================
   -- SWAP_TAIL
   --==========================================================================
   --
   -- Purpose
   --
   --   Exchange the tail of one list (List_Tail) with another list (The_List).    
   -- 
   --  For example:
   --
   --    If List_Tail contains 2 items and the pointer to the first item is 
   --    input, its tail would be item 2.
   --     and
   --    If The_List contains 3 items (must input the pointer to the head of
   --    this list), then after the Swap_Tail call; List_Tail would contain
   --    its orginal first item and the 3 items from The_List.  The_List would
   --    contain the second item from List_Tail.
   --
   --    If List_Tail is pointing to null (no tail) the effect is the concatenation
   --    of the two list in List_Tail and The_List being set to null (i.e. 
   --    List_Tail would contain both list with The_List being appended to 
   --    List_Tail
   --
   -- Implementation:
   --		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   NOT_AT_HEAD is raised if Previous pointer is not null.
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   procedure Swap_Tail(
      List_Tail : in     PTR;
      The_List  : in out PTR) is


      --
      -- Delcare local variables
      --

      -- Temporary pointer to keep from losing track of the list. 
      Temporary_Node  : PTR;

   begin

      if List_Tail = null then

         raise LIST_IS_NULL;

      end if;

      if The_List = null then 

         if List_Tail.Next /= null then
   
            Temporary_Node          := List_Tail.Next;
            Temporary_Node.Previous := null; 
            List_Tail.Next          := null;
            The_List                := Temporary_Node;

         end if; -- List_Tail = null

      elsif The_List.Previous = null then  -- At head of list 

         if List_Tail.Next /= null then

            Temporary_Node          := List_Tail.Next;
            Temporary_Node.Previous := null;
            List_Tail.Next          := The_List;
            The_List.Previous       := List_Tail;
            The_List                := Temporary_Node;

         else

            The_List.Previous := List_Tail;
            List_Tail.Next    := The_List;
            The_List          := null;

         end if;

      else                                -- Not at the head of the list. 
    
         raise NOT_AT_HEAD;

      end if;
   
   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Swap_Tail;

  --===========================================================================
   -- IS_EQUAL
   --==========================================================================
   --
   -- Purpose
   --
   --   Return TRUE if the lists have the same state (i.e., equal number of 
   --   items and the order and value of their items are the same).
   --  
   -- Implementation:
   --
   --   Traverse through corresponding items in both lists.
   --
   --  If a match does not exist or a CONSTRAINT_ERROR is raised, exit and 
   --  return the value False.
   --
   --  Else, increment the indices and repeat the match.
   --
   --  Continue to loop until Index_1 or Index_2 is null.
   --
   --  The loop will terminate normally if Index_1 is null.
   --  If Index_2 is also null, then list are of the same size so return True.
   --
   --  Otherwise, List_2 is longer than List one so return False.
   --
   --  If List_1 is longer than List_2, the loop will be exited and a value
   --  of FALSE returned.
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Is_Equal(
      List_1 : in PTR;
      List_2 : in PTR)
    return Boolean is

      -- 
      -- Declare local variables
      -- 
      Index_1 : PTR := List_1; -- Temporary pointer to traverse List_1. 
      Index_2 : PTR := List_2; -- Temporary pointer to traverse List_2. 

   begin

      while Index_1 /= null loop

         if Index_2 = null then

            return FALSE; -- List 2 is shorter than List_1

         elsif Index_1.The_Item /= Index_2.The_Item then

            return FALSE;  -- mismatch

         end if;

         Index_1 := Index_1.Next;
         Index_2 := Index_2.Next;

      end loop;

      return(Index_2 = null);  -- If it makes it through the loop and Index_2
                               -- is the same length then they are equal.
   exception  
 
      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Is_Equal;      

   --==========================================================================
   -- IS_NULL
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns TRUE if there are no items in the list.
   --
   -- Implementation:
   --
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Is_Null(
      The_List : in PTR)
     return Boolean is

   begin 

    return (The_List = null);

   exception   

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Is_Null;


   --==========================================================================
   -- LENGTH_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the number of items in the list.
   --
   -- Implementation:
   --
   --   Traverse the list (top to bottom) keeping track of the number of items
   --   visited and return the number of items in the List. 
   --  				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Length_Of(
      The_List : in PTR) 
     return NATURAL is

      -- 
      -- Declare local variables
      --
      Count : Natural := 0;        -- Counter 
      Index : PTR     := The_List; -- Pointer to traverse the list. 

   begin

      while Index /= null loop

         Count := Count + 1;
         Index := Index.Next;

      end loop;

      return Count;

   exception

     when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Length_Of;

   --==========================================================================
   -- PREDECESSOR_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes preceeding a node in the
   --   list.   
   --
   -- Implementation:
   --
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Predecessor_Of(
      The_List : in  PTR)
     return PTR is

   begin

      if The_List = null then
        raise LIST_IS_NULL;
      else
        return The_List.Previous;
      end if; 

   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Predecessor_Of;

   --==========================================================================
   -- TAIL_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes in the tail of 
   --   the List.
   --
   -- Implementation:
   --
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --    LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Tail_Of(
      The_List : in PTR) 
     return PTR is

   begin
    
      if The_List = null then
         raise LIST_IS_NULL;
      else
         return The_List.Next;
      end if;
   
   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Tail_Of; 

   --==========================================================================
   -- VALUE_OF
   --==========================================================================
   --
   -- Purpose
   --
   --  Return the value of the item at the head of the list.
   --
   -- Implementation:
   --
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --    LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Value_Of(
      The_List : in PTR) 
     return ITEM is

   begin
      
      if The_List = null then
         raise LIST_IS_NULL;
      else
         return The_List.The_Item;
      end if;

   exception

      when OTHERS =>
        raise GEN_LIST_FAILURE;

   end Value_Of;

end Generic_List;
