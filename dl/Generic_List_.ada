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
-- Package Name:       Generic_List
--
-- File Name:          Generic_List_.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 5, 1994
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
--     GEN_LIST_FAILURE  - This error will be raised if an unhandled Ada 
--                         exception is raised in any of these units.
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--=============================================================================	

-- Define objects of type List independent of a particular type of item. 
generic

   -- Permit assignment and testing for equality. 
   type ITEM is private;

package Generic_List is

   --  Permit assignment and testing for equality. 
   type PTR is private;

   K_Null_List : constant PTR;

   --
   -- Define exceptions
   --
   LIST_IS_NULL     : EXCEPTION; -- The desired operation cannot be completed 
                                 -- because the list already Is_Null. 
    
   POSITION_ERROR   : EXCEPTION; -- The position in the list does not exist.

   NOT_AT_END       : EXCEPTION; -- The pointer is not pointing to the last 
		                  -- item in the list. *
                      
   NOT_AT_HEAD      : EXCEPTION; -- The pointer is not pointing to the first 
		                 --  item in the list. 

   OVERFLOW         : EXCEPTION;  -- The list cannot grow large enough to
                                  --  complete the desired operation.
 
   GEN_LIST_FAILURE : EXCEPTION; -- This error will be raised if an Ada 
                                 -- exception is raised in any of these units.
   
   -- Define primitive procedures and functions (i.e., requiring access to the
   -- uderlying representation of the private types ITEM and PTR). 

   --==========================================================================
   -- CHANGE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Clears the current item and assigns the input item.  (See
   --   Set_Head to assign an item to a newly created node at the head of
   --   the list.) 
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --========================================================================== 
   procedure Change_Item(
      New_Item  : in ITEM;
      Null_Item : in ITEM;
      Old_Item  : in PTR);

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
   -- Exceptions:
   --     
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --==========================================================================
   procedure Clear_List( 
      The_List  : in out PTR);
    
   --==========================================================================
   -- CLEAR_PREVIOUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Clears a node's "previous" pointer.
   --
   -- Exceptions:
   --   
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --========================================================================== 
   procedure Clear_Previous(
      The_List  : in     PTR);

   --==========================================================================
   -- CLEAR_NEXT
   --==========================================================================
   --
   -- Purpose
   --
   --   Clears a node's "next" pointer.
   --
   -- Exceptions:
   --   
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --==========================================================================
   procedure Clear_Next(      
      The_List  : in     PTR);

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
   -- Exceptions:
   --   
   --   LIST_IS_NULL is raised if the input pointer is null.
   -- 
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --==========================================================================
   procedure Clear_Node(      
       The_Node  : in     PTR);

  --==========================================================================
   -- CONSTRUCT_BOTTOM
   --==========================================================================
   --
   -- Purpose
   --
   --   Add a new node at the end of the list.
   --
   -- Exceptions:
   --
   --   OVERFLOW is raised if the List cannot grow large enough to hold the item.
   --   
   --   NOT_AT_END is raised if the pointer does not point to the last item in 
   --   the list.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --   
   --========================================================================== 
   procedure Construct_Bottom( 
        The_Item  : in     ITEM;
        Tail      : in out PTR);

   --==========================================================================
   -- CONSTRUCT_TOP
   --==========================================================================
   --
   -- Purpose
   --
   --   Add a new node at the beginning (top) of the list.
   --
   -- Exceptions:
   --
   --   OVERFLOW is raised if the list cannot grow large enough to hold the item.
   --  
   --   NOT_AT_HEAD is raised if the pointer does not point to the first item 
   --   in the list.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --==========================================================================	    
   procedure Construct_Top(       
      The_Item  : in     ITEM;
      Head      : in out PTR); 
   
   --==========================================================================
   -- COPY
   --==========================================================================
   --
   -- Purpose
   --
   --   Copy the items from one list to another list
   --  
   -- Exceptions:
   --
   --   OVERFLOW is raised if the destination list cannot grow large 
   --   enough to hold the source list. 
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --==========================================================================
   procedure Copy(       
      From_List : in     PTR;
      To_List   : in out PTR); 

   --==========================================================================
   -- FREE
   --==========================================================================
   --
   -- Purpose
   --   
   --    Deallocates storage and sets the pointer to null;
   --
   --      If the pointer is already null, it has no effect.
   --      If ITEM is a pointer, it has no effect on the storage pointed to by 
   --      ITEM.
   --
   -- Exceptions:
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --=========================================================================
   procedure Free(The_Node : in out PTR);

   --==========================================================================
   -- SET_HEAD
   --==========================================================================
   --
   -- Purpose
   --
   --   Assign the input item to the private THE_ITEM component at the head of
   --   the list.
   --
   -- Exceptions:
   -- 
   --    LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --   
   --==========================================================================
   procedure Set_Head(
      Head    : in PTR;
      To_Item : in ITEM);
       
   --==========================================================================
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
   --    of the two list in List_Tail and The_List being set to null.
   --
   -- Exceptions:
   --
   --   NOT_AT_HEAD is raised if The_List.Previous pointer is not null.
   --
   --   LIST_IS_NULL is raised if The_List pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   -- 
   --==========================================================================
   procedure Swap_Tail(
      List_Tail : in     PTR;
      The_List  : in out PTR);

   --==========================================================================
   -- IS_EQUAL
   --==========================================================================
   --
   -- Purpose
   --
   --   Return TRUE if the lists have the same state (i.e., equal number of items
   --   and the order and value of their items are the same).
   --  
   -- Exceptions:
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   -- 
   --==========================================================================  
   function Is_Equal(
      List_1    : in  PTR;
      List_2    : in  PTR) 
    return Boolean;  
  
   --==========================================================================
   -- IS_NULL
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns TRUE if there are no items in the list. 
   --
   -- Exceptions:
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --   
   --==========================================================================
   function Is_Null(
      The_List : in  PTR) 
     return Boolean; 

   --==========================================================================
   -- LENGTH_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the number of items in the list (traverses top to bottom).
   --
   -- Exceptions:
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --   
   --==========================================================================
   function Length_Of(
      The_List : in PTR) 
     return NATURAL;

   --==========================================================================
   -- PREDECESSOR_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes preceeding the node 
   --   pointed to by the input pointer.
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null. 
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --==========================================================================
   function Predecessor_Of(
      The_List : in PTR) 
     return PTR;

   --==========================================================================
   -- TAIL_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes after the node 
   --   pointed to by the input pointer.
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --
   --========================================================================== 
   function Tail_Of(
      The_List : in PTR) 
     return PTR;

   --==========================================================================
   -- VALUE_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Return the value of the item at the head of the list.
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is raised if the input pointer is null.
   --
   --   GEN_LIST_FAILURE is raised if an unexpected Ada exception is raised.
   --   
   --==========================================================================
    function Value_Of(
       The_List : in PTR) 
      return ITEM;

   
private

--  The list is implemented as a series of nodes with an item component and an
--  access component that provides linkage to the succeeding node.  

    type NODE;
    type PTR is access NODE;
    K_Null_List : constant PTR := null;

end Generic_List; 
