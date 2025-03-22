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
-- Package Name:       Generic_List_Utilities
--
-- File Name:          Generic_List_Utilities_.ada
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
--       Contains utilities to create and manipulate a generic double linked, 
--   unbounded list of zero or more items.  These utilities are built on the
--   more primitive procedures and functions in the Generic_List package.
--  
--   Note:  
--	 When instantiating this package in a package/procedure the function
--   "<" which is used by the sort utility must be defined in that package/
--   procedure.
--	
--   Contains the following procedures which return a status code:
--
--     APPEND_LIST -- concatenate one list to another and set the appended
--                     list to null.
--     ASSIGN_ITEM -- assign new data
--     CHANGE_THE_ITEM -- reinitialize the item and assign new data (usefull if
--                     -- item is a string).
--     CHECK_AT_END -- return true if pointer points to last item in list
--     CHECK_AT_HEAD -- return true if pointer points to first item in list
--     CHECK_LIST_EQUAL -- return true is two list are the same
--     CHECK_NULL -- return TRUE if null pointer
--     CLEAR_PREVIOUS_PTR -- set previous pointer to null
--     CLEAR_NEXT_PTR -- set next ponter to null
--     CLEAR_THE_LIST -- set list ponter to null
--     CLEAR_THE_NODE -- sets node previous and next pointers to null
--     COPY_LIST -- copy one list to another
--     DELETE_ITEM -- remove and return pointer to
--     DELETE_ITEM_AND_FREE_STORAGE -- delete and free storage of node
--     FIND_POSITION_OF_ITEM -- number in list
--     FREE_NODE -- deallocate storage for node
--     FREE_LIST -- deallocate storage for list
--     GET_FIRST_ITEM -- pointer to first item in list
--     GET_LAST_ITEM -- pointer to last item in list
--     GET_ITEM -- value of item pointed to
--     GET_PREVIOUS -- pointer to previous item in list
--     GET_NEXT -- pointer to next item in the list
--     GET_SIZE -- returns the length of the list
--     GET_SUBLIST -- returns a sublist whose head is the item input
--     GET_SUBLIST -- returns a sublist whos head is the item at the poistion given
--     INSERT_ITEM -- inserts an item into the list after a given position.
--     INSERT_ITEM_END -- adds an item to the end of a list
--     INSERT_ITEM_TOP -- adds an item to the top of a list
--     INSERT_LIST -- inserts a list into a list at a given position
--     SPLIT -- breaks a list into two lists at a give position
--     STRAIGHT_INSERTION_SORT -- sort routine
--     SWAP_TAILS -- exchanges the tail of one list for the tail of another list.
--
--     Contains the following funcitons which do not return a status code:
--
--     END_OF -- returns a pointer to the last item in the list
--     HEAD_OF -- returns a pointer to the first item in the list
--     IS_END -- returns TRUE if the item is the last item in the list
--     IS_HEAD -- returns TRUE if the item is the first item in the list
--     LOCATION_OF -- returns a sublist whose head is the item given
--     LOCATION_OF -- returns a sublist whose head is the item at the given 
--                 -- position
--     POSITION_OF -- returns the position in the list of the given item
--
-- Effects:
--   None
--
-- Exceptions:
--
--   The following exceptions may be propagated from the function calls.
-- 
--     ITEM_NOT_FOUND - The item searched for is not in the list.
--
--     LIST_IS_NULL   - The list should not be null, but it is.
--  
--     POSITION_ERROR - The input position exceeds the size of the list
--                      or it cannot be determined. one
--
-- Portability Issues:
--   None
--
-- Anticipated Changes:
--   None
--
--==============================================================================
with DL_Status;
 
generic

-- Import the generic items needed from the Generic_List package. 

   type ITEM is private;
   type PTR is private;
  
   with procedure Change_Item      (New_Item    : in     ITEM;
                                    Null_Item   : in     ITEM;
                                    Old_Item    : in     PTR );

   with procedure Clear_List       (The_List    : in out PTR );
  
   with procedure Clear_Previous   (The_List    : in     PTR );

   with procedure Clear_Next       (The_List    : in     PTR );

   with procedure Clear_Node       (The_Node    : in     PTR );

   with procedure Construct_Bottom (The_Item    : in     ITEM;
                                    Tail        : in out PTR );

   with procedure Construct_Top    (The_Item    : in     ITEM;
                                    Head        : in out PTR );

   with procedure Copy             (From_List   : in     PTR;
                                    To_List     : in out PTR );

   with procedure Free             (The_Node    : in out PTR );

   with procedure Set_Head         (Head        : in     PTR;
                                    To_Item     : in     ITEM);

   with procedure Swap_Tail        (List_Tail   : in     PTR;
                                    The_List    : in out PTR);

   with function Is_Equal          (List_1      : in     PTR;
                                    List_2      : in     PTR ) return BOOLEAN;
                                    
   with function Is_Null           (The_List    : in     PTR ) return BOOLEAN;

   with function Length_Of         (The_List    : in     PTR ) return NATURAL;

   with function Predecessor_Of    (The_List    : in     PTR ) return PTR;

   with function Tail_Of           (The_List    : in     PTR ) return PTR;

   with function Value_Of          (The_List    : in     PTR ) return ITEM;

-- import function for sort unit.
   with function "<"               (Item_1      : in     ITEM;
                                    Item_2      : in     ITEM) return BOOLEAN;
   
package Generic_List_Utilities is

   ITEM_NOT_FOUND : EXCEPTION; -- The item searched for is not in the list.

   LIST_IS_NULL   : EXCEPTION; -- The list should not be null, but it is.
 
   POSITION_ERROR : EXCEPTION; -- The input position exceeds the size of the list
                               -- or it cannot be determined. 

   --==========================================================================
   -- APPEND_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Concatenate two list in The_List and set the List_To_Append to null.
   --
   --   Input/Out Parameters:
   --
   --     List_To_Append - The list that will be appended.
   --
   --   Input Parameters:
   --
   --     The_List - The list that will contain both lists (with List_To_Append
   --                appended to the end of the original list.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.  --  The following status values may be returned:
   --               One of the following status values will be returned:
   --
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.APPEND_LIST_FAILURE - Indicates an exception was 
   --               raised in this unit.
   --
   -- Exceptions:
   --   None.
   --  
   --========================================================================== 
    procedure Append_List(
       List_To_Append : in out PTR;
       The_List       : in     PTR;
       Status         :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- ASSIGN_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Assign the input item to the The_Item component pointer to by the "Head"
   --   pointer.
   --
   --   Input Parameters:
   --
   --     Head - Pointer to the node where the item is to be assigned.
   --
   --     To_Item - The new item.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.ASSIGN_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --    				 		
   -- Exceptions:
   --   None
   --   
   --==========================================================================
   procedure Assign_Item(
      Head    : in     PTR;
      To_Item : in     ITEM;
      Status  :    out DL_Status.STATUS_TYPE);
       
   --==========================================================================
   -- CHANGE_THE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Assign a new value to the node pointed to by the input pointer.  (See
   --   Set_Head to assign an item to a newly created node at the head of
   --   the list.) 
   --
   --   Input Parameters:
   --
   --     New_Item - The new item to assign.
   --
   --     Null_Item - The item which will be used to clear the current item.
   --
   --     Old_Item - Pointer to the node in which ITEM will be changed.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   -- 
   --               DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --               DL_Status.CHANGE_ITEM_FAILURE - Indicates an exception was 
   --               raised in this unit.
   --	 		
   -- Exceptions:
   --   None
   --
   --========================================================================== 
   procedure Change_The_Item(
      New_Item  : in ITEM;
      Null_Item : in ITEM;
      Old_Item  : in PTR;
      Status    :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- CHECK_AT_END
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the input pointer is pointing to the last node in
   --   the list.
   --
   --   Input Parameters:
   --
   --     The_List - Pointer to a node in the linked list.
   --
   --   Output Parameters:
   --
   --     The_End - Set to TRUE if the input pointer is pointing to the last node
   --               in the list.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CHECK_AT_END_FAILURE - Indicates an exception was 
   --              raised in this unit.
   -- 
   -- Exceptions:
   --
   --   None
   --
   --========================================================================== 
   Procedure Check_At_End(
      The_List : in     PTR;
      The_End  :    out BOOLEAN;
      Status   :    out DL_Status.STATUS_TYPE);
			 
   --==========================================================================
   -- CHECK_AT_HEAD
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the input pointer is pointing to the first node in
   --   the list.
   --
   --   Input Parameters:
   --
   --     The_List - Pointer to a node in the linked list.
   --
   --   Output Parameters:
   --
   --     The_Head - Set to TRUE if the input pointer is pointing to the first
   --                node in the list.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CHECK_AT_HEAD_FAILURE - Indicates an exception was
   --              raised in this unit.
   --    				 	
   -- Exceptions:
   --
   --   None
   --
   --===========================================================================
   procedure Check_At_Head(
      The_List : in     PTR;
      The_Head :    out BOOLEAN;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- CHECK_LIST_EQUAL
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the two input list are the same (returns TRUE if
   --   they are the same).
   --
   --   Input Parameters:
   --
   --     List_1 - The list that will be compared to List_2.
   --  
   --     List_2 - The list that will be compared to List_1.
   --
   --   Output Parameters:
   --
   --     Equal  - Boolean returns TRUE if two list are the same and FALSE if
   --              they are not the same (i.e., equal number of items and the
   --              order and value of their items are the same); 
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CHECK_LIST_EQUAL_FAILURE - Indicates an exception
   --              was raised in this unit.
   --
   -- Exceptions:
   --   None
   -- 
   --==========================================================================  
   procedure Check_List_Equal(
      List_1    : in     PTR;
      List_2    : in     PTR;
      Equal     :    out BOOLEAN;
      Status    :    out DL_Status.STATUS_TYPE);
  
   --==========================================================================
   -- CHECK_NULL
   --==========================================================================
   --
   -- Purpose
   --   Determines whether the input pointer is null (returns TRUE if it is 
   --   null).
   --
   --   Input Parameters:
   --
   --     The_List - The pointer that is checked for null value.
   --
   --   Output Parameters:
   --
   --     Null_Pointer  - Boolean returns TRUE if the input pointer is null and
   --                     and FALSE if it is not null.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CHECK_NULL_FAILURE - Indicates an exception was
   --              raised in this unit.
   --
   -- Exceptions:
   --   None
   --   
   --==========================================================================
   procedure Check_Null(
      The_List     : in     PTR;
      Null_Pointer :    out BOOLEAN;
      Status       :    out DL_Status.STATUS_TYPE); 

  
   --==========================================================================
   -- CLEAR_PREVIOUS_PTR
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the previous pointer of the node pointed to by the input pointer to null.
   --
   --   Input Parameters:
   --
   --     The_List - Pointer to the node that has its previous pointer set to 
   --                null.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CLEAR_PREVIOUS_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --
   -- Exceptions:
   --   None
   --
   --========================================================================== 
   procedure Clear_Previous_Ptr(
      The_List : in     PTR;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- CLEAR_NEXT_PTR
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the next pointer of the node pointed to by the input pointer to 
   --   null.
   --
   --   Input Parameters:
   --
   --     The_List - Pointer to the node that has its next pointer set to 
   --                null.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CLEAR_NEXT_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   
   --   None
   --
   --==========================================================================
   procedure Clear_Next_Ptr(      
      The_List : in     PTR;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- CLEAR_THE_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the input pointer to null.
   --
   --   Note: Does not deallocate memory (see Free_List)
   --
   --   Input Parameters:
   --
   --     The_List - Pointer that will be set null.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CLEAR_LIST_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   --
   --==========================================================================
   procedure Clear_The_List( 
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE);
    
   --==========================================================================
   -- CLEAR_THE_NODE
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the node's (pointed to by the input pointer) previous and next 
   --   pointers to null. 
   --
   --   Note: Does not deallocate memory (See Free_Node to deallocate memory).
   --
   --   Input Parameters:
   --
   --     The_Node - Pointer to the node that will have its previous and next
   --                pointers set to null. 
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.CLEAR_LIST_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --
   -- Exceptions:
   --   None
   --    
   --==========================================================================
   procedure Clear_The_Node(      
      The_Node : in     PTR;
      Status   :    out DL_Status.STATUS_TYPE );

   --==========================================================================
   -- COPY_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --  Create a new list that contains all the items in the input list to copy.
   --
   --   Input Parameters:
   --
   --     From_List - The list that will be copied.
   --
   --     To_List   - Pointer to the list that will be a dublicate of the
   --                 From_List if the pointer is null or will have the 
   --                 From_List items appended if items exist in the list and
   --                 the next pointer is null.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.COPY_LIST_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --
   -- Exceptions:
   --   None
   --
   --==========================================================================
   procedure Copy_List(       
      From_List : in     PTR;
      To_List   : in out PTR;
      Status    :    out DL_Status.STATUS_TYPE); 

   --==========================================================================
   -- DELETE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Removes an item from a list and returns the pointer to the deleted item.
   --
   --   Input Parameters:
   --
   --     The_List - Pointer to the list from which the item will be deleted.
   --
   --     At_Position - The position in the list of the item to delete.
   --                   (Note: optional if the item pointed to by the input 
   --                          pointer is to be deleted this parameter does not
   --                          need to be set.)
   --
   --   Output Parameters:
   --
   --     Deleted_Item - Pointer to the node that was deleted.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.DELETE_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure  will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================  
    procedure Delete_Item(
       The_List     : in out PTR;
       At_Position  : in     POSITIVE := 1;
       Deleted_Item :    out PTR;
       Status       :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- DELETE_ITEM_AND_FREE_STORAGE
   --==========================================================================
   --
   -- Purpose
   --
   --   Removes an item from a list and deletes the item's storage. 
   --
   --   Input Parameters:
   --
   --     The_List - Pointer to the list from which the item will be deleted.
   --
   --     At_Position - The position in the list of the item to delete.
   --                   (Note: optional if the item pointed to by the input 
   --                          pointer is to be deleted this parameter does not
   --                          need to be set.)
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.DELETE_FREE_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure  will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================  
    procedure Delete_Item_And_Free_Storage(
       The_List    : in out PTR;
       At_Position : in     POSITIVE := 1;
       Status      :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- FIND_POSITION_OF_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the position in the list of the given item.
   --
   --   Input Parameters:
   --    
   --     The_Item - The identifier to search for (would be The_Item component
   --                 in the node structure).
   --
   --     The_List - Pointer to the list in which the item can be found.
   --
   --
   --   Output Parameters:
   --
   --     Position - The position in the list where the item was found.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.FIND_POSITION_OF_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --
   --
   -- Exceptions:
   --
   --   None
   --
   --==========================================================================  
   procedure Find_Position_Of_Item(
      The_Item : in     ITEM;
      The_List : in     PTR;
      Position :    out POSITIVE;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- FREE_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Deletes all the items from a list, deallocates the memory for all the 
   --   deleted items and sets the list pointer to null;
   --
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list to deallocate.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.FREE_LIST_FAILURE - Indicates an exception was 
   --              raised in this unit.
   --
   --              Other - If an error occurs in a call to a sub-routine, the 
   --              procedure  will terminate and the status (error code) for the
   --              failed routine will be returned.
   --
   --
   -- Exceptions:
   --   None
   --
   --==========================================================================
   procedure Free_List( 
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE);
 
   --==========================================================================
   -- FREE_NODE
   --==========================================================================
   --
   -- Purpose
   --   
   --    Deallocates storage and sets the pointer to null;
   --
   --   Input Parameters:
   --    
   --     The_Node - Pointer to the node to deallocate.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.FREE_NODE_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --
   -- Exceptions:
   --   None
   --
   --=========================================================================
   procedure Free_Node(
      The_Node : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GET_FIRST_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the item at the head of the list (traverses
   --   list backwards).
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list which will be used to find the first
   --                node in the list.
   --
   --     The_Item - Pointer to the first node in the list.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_FIRST_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   --
   --========================================================================== 
   Procedure Get_First_Item(
      The_List : in     PTR;
      The_Item :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GET_LAST_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the last item in the list (traverses list forward). 
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list which will be used to find the last
   --                node in the list.
   --
   --     The_Item - Pointer to the last node in the list.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_LAST_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit
   -- 
   -- Exceptions:
   --
   --  None
   --========================================================================== 
   procedure Get_Last_Item(
      The_List : in     PTR;
      The_Item :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE);
  
   --==========================================================================
   -- GET_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Return the value of The_Item record component in the node pointer to by
   --   the input pointer.
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the node which contains the desired item.
   --
   --     The_Item - Value of the node's The_Item component.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --
   -- Exceptions:
   --   None.
   --
   --==========================================================================  
   procedure Get_Item(
      The_List : in     PTR;
      The_Item :    out ITEM;
      Status   :    out DL_Status.STATUS_TYPE);
   
   --==========================================================================
   -- GET_PREVIOUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes preceeding a the
   --   node pointed to by the input pointer.
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the node after the node desired.
   --
   --   Output Parameters:
   --
   --     Previous - Pointer to the previous node before the node pointed to by
   --                The_List pointer.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_PREVIOUS_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   --
   --==========================================================================
   procedure Get_Previous(
      The_List : in     PTR;
      Previous :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE); 
     

   --==========================================================================
   -- GET_NEXT
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes after the node 
   --   pointed to by the input pointer.
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the node before the node desired.
   --
   --   Output Parameters:
   --
   --     Next - Pointer to the next node after the node pointed to by
   --            The_List pointer.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_NEXT_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   --========================================================================== 
   procedure Get_Next(
      The_List : in PTR;
      Next     :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GET_SIZE
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the number of items in the list (traverses top to bottom).
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list which will have its nodes counted.
   --
   --   Output Parameters:
   --
   --     Size - The number of nodes in the list.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_SIZE_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   --   
   --==========================================================================
   Procedure Get_Size(
      The_List : in     PTR;
      Size     :    out NATURAL;
      Status   :    out DL_Status.STATUS_TYPE); 
   
   --==========================================================================
   -- GET_SUBLIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a the pointer to a sublist whose head is the item given
   --
   --   Input Parameters:
   --    
   --     The_Item - Node component The_Item value which will be searched for
   --                in the list.
   --
   --     The_List - Pointer to the list from which the sublist will be 
   --                extracted.
   --
   --   Output Parameters:
   --
   --     Sublist - Pointer to the node that contains The_Item value.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_SUBLIST_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --     
   --   None
   --
   --========================================================================== 
   procedure Get_Sublist(
       The_Item : in     ITEM;
       The_List : in     PTR;
       Sublist  :    out PTR;
       Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- GET_SUBLIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist whose head is the item at the position given
   --
   --   Input Parameters:
   --    
   --     Position - Position at which the list will be split and a sublist
   --                provided.
   --
   --     The_List - Pointer to the list from which the sublist will be 
   --                extracted.
   --
   --   Output Parameters:
   --
   --     Sublist - Pointer to the node at the position in the list which 
   --               corresponds to the input Position value.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.GET_SUBLIST_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   --
   --========================================================================== 
   procedure Get_Sublist(
       Position : in Positive;
       The_List : in PTR;
       Sublist  :    out PTR;
       Status   :    out DL_Status.STATUS_TYPE);
   
  
   --==========================================================================
   -- INSERT_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Inserts an item into a list after a given position.
   --
   --   Input Parameters:
   --    
   --     The_Item - The item to insert into the list.
   --
   --     The_List - Pointer to the list where the item will be inserted.
   --
   --     After_Position - The position in the list of the node after which
   --                      the item will be inserted.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.INSERT_ITEM_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- 
   -- Exceptions:
   --   None.
   --
   --========================================================================== 
   procedure Insert_Item(
      The_Item       : in     ITEM;
      Into_List      : in     PTR;
      After_Position : in     Positive;
      Status         :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- INSERT_ITEM_END
   --==========================================================================
   --
   -- Purpose
   --
   --   Adds an item to the end of the list.
   --
   --   Input Parameters:
   --    
   --     The_Item - The item to insert into the list.
   --
   --     The_List - Pointer to the list where the item will be inserted.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.INSERT_ITEM_END_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- 
   -- Exceptions:
   --   None.
   --
   --========================================================================== 
   procedure Insert_Item_End(
      The_Item : in     ITEM;
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE);

   -- --==========================================================================
   -- INSERT_ITEM_TOP
   --==========================================================================
   --
   -- Purpose
   --
   --   Adds an item to the top of the list.
   --
   --   Input Parameters:
   --    
   --     The_Item - The item to insert into the list.
   --
   --     The_List - Pointer to the list where the item will be inserted.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.INSERT_TOP_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- 
   -- Exceptions:
   --   None.
   --
   --========================================================================== 
   procedure Insert_Item_Top(
      The_Item : in     ITEM;
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- INSERT_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Inserts a list into a list at a given position.
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list where the list will be inserted.
   --
   --     Insert_List - List which will be inserted into The_List.
   --
   --     After_Position - The position of the node after which the list will 
   --                      be inserted.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.INSERT_LIST_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None.
   --
   --========================================================================== 
    procedure Insert_List(
       The_List       : in     PTR;
       Insert_List    : in     PTR;
       After_Position : in     Positive;
       Status         :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- SPLIT
   --==========================================================================
   --
   -- Purpose
   --
   --   Break a list into two lists at a given position.
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list which will be split.
   --
   --     At_Position - The position of the node that will be at the head of 
   --                   of the sublist.
   --
   --   Output Parameters:
   --
   --     Sublist_List - The list that is split off from The_List.
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.SPLIT_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   --
   --========================================================================== 
   procedure Split(
      The_List    : in     PTR;
      At_Position : in     Positive;
      Sublist     :    out PTR;
      Status      :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- STRAIGHT_INSERTION_SORT
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts a list according to the imported "<" function.
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list which will be sorted.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.SORT_INSERT_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   --
   -- Exceptions:
   --   None
   --
   --===========================================================================
    procedure Straight_Insertion_Sort(
       The_List : in out PTR;
       Status   :    out DL_Status.STATUS_TYPE);
  
   --==========================================================================
   -- SWAP_TAILS
   --==========================================================================
   --
   -- Purpose
   --
   --   Exchange the tail of one list (List_Tail) with another list (The_List).
   --
   --  For example
   --    If List_Tail contains 2 items and the pointer to the first item is 
   --    input, its tail would be item 2.
   --     and
   --    If The_List contains 3 items (must input the pointer to the head of
   --    this list), then after the Swap_Tail call; List_Tail would contain
   --    its orginal first item and the 3 items from The_List.  The_List would
   --    contain the second item from List_Tail.
   --
   --    If List_Tail is pointing to null (no tail) the effect is the 
   --    concatenation of the two list in List_Tail and The_List being set 
   --    to null (i.e. List_Tail would contain both list);
   --
   --   Input Parameters:
   --    
   --     List_Tail - "Confusing parameters" but this is the pointer to the 
   --                  main list (i.e. it will contain an appended list if 
   --                  the pointer is at the end of the list).
   --
   --     The_List - Input pointer cannot be null but it will be set to null if
   --                the List_Tail pointer does not contain a tail so that the
   --                two list are appended.
   --
   --   Output Parameters:
   --
   --     Status - Indicates whether this unit encountered an error condition.
   --              One of the following status values will be returned:
   --
   --              DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --              DL_Status.SWAP_TAILS_FAILURE - Indicates an exception was 
   --              raised in this unit
   --
   -- Exceptions:
   --   None
   -- 
   --==========================================================================
   procedure Swap_Tails(
      List_Tail : in     PTR;
      The_List  : in out PTR;
      Status    :    out DL_Status.STATUS_TYPE);


   --
   --
   --  FUNCTIONS
   --
   --==========================================================================
   -- END_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the last item in the list (traverses list forward). 
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list that will be traversed.
   --
   --   Output Parameters:
   --
   --     PTR - Returns a pointer to the last node in the list.
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is propagated from Generic_List unit.
   --
   --========================================================================== 
   function End_Of(The_List : in PTR) return PTR;
  
   --==========================================================================
   -- HEAD_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the first item in the list (traverses
   --   list backwards)
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the list that will be traversed.
   --
   --   Output Parameters:
   --
   --     PTR - Returns a pointer to the first node in the list.
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is propagated from Generic_List units.
   -- 
   --========================================================================== 
   function Head_Of(The_List : in PTR) return PTR;

   --==========================================================================
   -- IS_END
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines if the pointer is pointing to the last node in the list.
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the node that will be checked.
   --
   --   Output Parameters:
   --
   --     Boolean - Returns TRUE if it the node's next pointer is null and FALSE
   --               if it is not.
   --
   -- Exceptions:
   --
   --   LIST_IS_NULL is propagated from Generic_List units.
   -- 
   --========================================================================== 
   function Is_End(The_List : in PTR) return boolean;
			 
   --==========================================================================
   -- IS_HEAD
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines if the pointer is pointing to the first node in the list.
   --   (If it is, returns TRUE).
   --
   --   Input Parameters:
   --    
   --     The_List - Pointer to the node that will be checked.
   --
   --   Output Parameters:
   --
   --     Boolean - Returns TRUE if it the node's previous pointer is null and
   --               FALSE if it is not.
   --
   -- Exceptions:
   --
   --   If the input list is null, LIST_IS_NULL is raised.
   --
   --========================================================================== 
   function Is_Head(The_List : in PTR) return boolean;

   --==========================================================================
   -- LOCATION_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist whose head is the item given.
   --
   --   Input Parameters:
   --    
   --     The_Item - Value of the node's component The_Item which is used
   --                to get the pointer to the node.
   --
   --     The_List - Pointer to the list which will be checked for the item.
   --
   --
   --   Output Parameters:
   --
   --     PTR - Returns the pointer to the node that contains The_Item.
   --
   -- Exceptions:
   --     
   --    If the item is not found, ITEM_NOT_FOUND is raised.
   --
   --========================================================================== 
    function Location_Of(
       The_Item : in ITEM;
       The_List : in PTR)
      return PTR;

   --==========================================================================
   -- LOCATION_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist whose head is the node at the input position in the 
   --   list.
   --
   --   Input Parameters:
   --    
   --     Position - The position number for the node in the list.
   --
   --     The_List - Pointer to the list which will be checked for the item.
   --
   --
   --   Output Parameters:
   --
   --     PTR - Returns the pointer to the node that corresponds to the 
   --           input position.
   --
   -- Exceptions:
   --   
   --   If the list is null, POSITION_ERROR is raised.
   -- 
   --========================================================================== 
    function Location_Of(
       Position : in Positive;
       The_List : in PTR)
      return PTR;
 
   --==========================================================================
   -- POSITION_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the position in the list of the given item.
   --
   --   Input Parameters:
   --    
   --     The_Item - Value of the node's component The_Item which is used
   --                to find the poistion of the item in the list.
   --
   --     The_List - Pointer to the list which will be checked for the item.
   --
   --
   --   Output Parameters:
   --
   --     POSITIVE - Returns the number which correspondes to the number of
   --                nodes processed before the node with The_Item was found
   --                + 1 which gives the position of the node in the list.
   --
   -- Exceptions:
   --
   --   If the item is not in the list, ITEM_NOT_FOUND is raised.
   --
   --==========================================================================  
   function Position_Of(
      The_Item : in ITEM;
      The_List : in PTR)
     return POSITIVE; 

end Generic_List_Utilities; 

--==============================================================================
--
-- MODIFICATIONS
--
-- 9  Aug 1994 / Charlotte Mildren / Added Get_Item to provide the value of an
--                                   ITEM and return an execution status.
--
-- 15 Aug 1994 / Charlotte Mildren / Added procedures that return a status for
--                                   all of the Generic_List units and all the 
--                                   functions in this package.
--                                   Added a Clear_List that clears the list and
--                                   deallocates all the nodes.
--
--==============================================================================
