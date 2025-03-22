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
-- File Name:          Generic_List_Utilities.ada
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
-- Modifications:
--   11/6/94 Initialized status to DL.Success in Delete_Item_And_Free_Storage
--
--==============================================================================

package body Generic_List_Utilities is

  type NODE is
    record
      Previous : PTR; 
      The_Item : ITEM;
      Next     : PTR;
    end record;

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";
     
   --==========================================================================
   -- APPEND_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Concatenate two list.
   --
   -- Implementation:
   --
   --  Calls the End_Of function to set the inputed The_List pointer to the 
   --  last node in the list.  Then calls the imported Generic_List Swap_Tails 
   --  to swap the tail of The_List (which is a null pointer) with the input
   --  List_To_Append tail.  The pointer to List_To_Append must be at the top of 
   --  the list so that its tail will be the entire list.  Therefore, the
   --  execution of Swap_Tail will result in the List_To_Append being 
   --  attached to the end of The_List and List_To_Append pointer will be set to
   --  null (since the tail of The_List was null).
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
   procedure Append_List(
      List_To_Append : in out PTR;
      The_List       : in     PTR;
      Status         :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables
      --

      -- Pointer to the last node of List_2.  
      Last_Node : PTR := End_Of(The_List); 

   begin

      Status := DL_Status.SUCCESS;

      Swap_Tail(List_Tail => Last_Node, 
                The_List  => List_To_Append);

   exception

      when OTHERS       =>
        Status := DL_Status.APPEND_LIST_FAILURE;
    
   end Append_List;

   --==========================================================================
   -- ASSIGN_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Assign the input item to the The_Item component pointer to by the "Head"
   --   pointer.
   --
   -- Implementation:
   --  
   --   Calls the imported Generic_List procedure Set_Head to write over the current
   --   item with the new item and traps any raised exceptions.
   --
   --   (See Change_The_Item to first clear the item and them make an assignment).
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
   -- Exceptions:
   --   None
   --   
   --==========================================================================
   procedure Assign_Item(
      Head    : in     PTR;
      To_Item : in     ITEM;
      Status  :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Set_Head(Head, To_Item);


   exception

      when OTHERS       =>
        Status := DL_Status.ASSIGN_ITEM_FAILURE;

   end Assign_Item;

  --==========================================================================
   -- CHANGE_THE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Assign a new value to the node pointed to by the input pointer.   
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List Change_Item to clears the current item
   --   and assigns the new input item.  (See Assign_Item to assign an item to 
   --   a newly created node or one that does not need to be cleared first.)  
   --   Traps any exceptions raised by the called unit.
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
   -- Exceptions:
   --   None
   --
   --========================================================================== 
   procedure Change_The_Item(
      New_Item  : in ITEM;
      Null_Item : in ITEM;
      Old_Item  : in PTR;
      Status    :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Change_Item(New_Item, Null_Item, Old_Item);

   exception

      when OTHERS       =>
        Status := DL_Status.CHANGE_ITEM_FAILURE;

   end Change_The_Item;

   --==========================================================================
   -- CHECK_AT_END
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the input pointer is pointing to the last node in
   --   the list.
   --
   -- Implementation:
   --
   --   Calls the function Is_End to set The_End TRUE if the node is the last 
   --   node in the list or FALSE if it is not.  Traps any errors raised by 
   --   this function.
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   None
   --
   -- Portability Issues:
   --   None
   --
   --========================================================================== 
   Procedure Check_At_End(
      The_List : in     PTR;
      The_End  :    out BOOLEAN;
      Status   :    out DL_Status.STATUS_TYPE) is
                                         
   begin
    
      Status  := DL_Status.SUCCESS;

      The_End := Is_End(The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.CHECK_AT_END_FAILURE;

   end Check_At_End;
			 
   --==========================================================================
   -- CHECK_AT_HEAD
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the input pointer is pointing to the first node in
   --   the list.
   --
   -- Implementation:
   --
   --   Calls the function Is_Head to set The_Head TRUE if the node is the 
   --   first node in the list or FALSE if it is not.  Traps any exceptions
   --   raised by this function.
   --	
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   None
   --
   --===========================================================================
   procedure Check_At_Head(
      The_List : in     PTR;
      The_Head :    out BOOLEAN;
      Status   :    out DL_Status.STATUS_TYPE) is
  
   begin

      Status  := DL_Status.SUCCESS;

      The_Head := Is_Head(The_List);
    
   exception

      when OTHERS       =>
        Status := DL_Status.CHECK_AT_HEAD_FAILURE;

   end Check_At_Head;

   --==========================================================================
   -- CHECK_LIST_EQUAL
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the two input list are the same.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Is_Equal to set Equal TRUE if 
   --   the lists have the same state (i.e., equal number of items and the order
   --   and value of their items are the same); otherwise Equal is set to FALSE;
   --   Traps any exceptions raised by this function.
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
   procedure Check_List_Equal(
      List_1    : in     PTR;
      List_2    : in     PTR;
      Equal     :    out BOOLEAN;
      Status    :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Equal := Is_Equal(List_1, List_2);

   exception

      when OTHERS       =>
        Status := DL_Status.CHECK_LIST_EQUAL_FAILURE;

   end Check_List_Equal;
  
   --==========================================================================
   -- CHECK_NULL
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether the input pointer is null.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Is_Null to set Null_Pointer 
   --   TRUE if the input pointer is null and FALSE if it is not.  Traps any 
   --   exceptions raised by this function.
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
   procedure Check_Null(
      The_List     : in     PTR;
      Null_Pointer :    out BOOLEAN;
      Status       :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Null_Pointer := Is_Null(The_List);


   exception

      when OTHERS       =>
        Status := DL_Status.CHECK_NULL_FAILURE;
  
   end Check_Null;
    
   --==========================================================================
   -- CLEAR_PREVIOUS_PTR
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the previous pointer of the node pointed to by the input pointer to null.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Clear_Previous to set the previous
   --   pointer to null.  Traps any exceptions raised by this function.
   --
   --  The following status values may be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     DL_Status.CLEAR_PREVIOUS_FAILURE - Indicates an exception was raised in
   --       this unit.
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
   procedure Clear_Previous_Ptr(
      The_List : in     PTR;
      Status   :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Clear_Previous(The_List);
      
   exception

      when OTHERS       =>
        Status := DL_Status. CLEAR_PREVIOUS_FAILURE;

   end Clear_Previous_Ptr;

   --==========================================================================
   -- CLEAR_NEXT_PTR
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the next pointer of the node pointed to by the input pointer to null.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Clear_Next to set the next pointer
   --   to null.  Traps any exceptions raised by this function.
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   None
   --
   --==========================================================================
   procedure Clear_Next_Ptr(      
      The_List : in     PTR;
      Status   :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Clear_Next(The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.CLEAR_NEXT_FAILURE;

   end Clear_Next_Ptr;

   --==========================================================================
   -- CLEAR_THE_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the input pointer to null.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Clear_List to set the input 
   --   pointer to null.  Traps any exceptions raised by this function.
   --
   --   Note: Does not deallocate memory (See Free_List).
   --	
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   None
   --
   --==========================================================================
   procedure Clear_The_List( 
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is

    begin
 
      Status := DL_Status.SUCCESS;
   
      Clear_List(The_List);

   exception

      when OTHERS       =>
        Status := DL_Status. CLEAR_LIST_FAILURE;

   end Clear_The_List;

   --==========================================================================
   -- CLEAR_THE_NODE
   --==========================================================================
   --
   -- Purpose
   --
   --   Set the node's (pointed to by the input pointer) previous and next 
   --   pointers to null.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Clear_Node to set the node's 
   --   pointers to null.  Traps any exceptions raised by this function.
   --
   --   Note: Does not deallocate memory (See Free_Node).
   --
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   None
   --    
   --==========================================================================
   procedure Clear_The_Node(      
      The_Node : in     PTR;
      Status   :    out DL_Status.STATUS_TYPE ) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Clear_Node(The_Node);

   exception

      when OTHERS       =>
        Status := DL_Status.CLEAR_NODE_FAILURE;

   end Clear_The_Node;

   --==========================================================================
   -- COPY_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --  Create a new list that contains all the items in the input list to copy.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List procedure Copy to create the new list.
   --   Traps any exceptions raised by this procedure.
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   None
   --
   --==========================================================================
   procedure Copy_List(       
      From_List : in     PTR;
      To_List   : in out PTR;
      Status    :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Copy(From_List, To_List);

   exception

      when OTHERS       =>
        Status := DL_Status.COPY_LIST_FAILURE;

   end Copy_List; 

   --==========================================================================
   -- DELETE_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Removes an item from a list and returns the pointer to the deleted item.
   --
   -- Implementation:
   --
   --   If no position value is input, it will remove the item at the head of the 
   --   list.  If a position is input, it will remove the item at the input 
   --   position.
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
   procedure Delete_Item(
      The_List     : in out PTR;
      At_Position  : in     POSITIVE := 1;
      Deleted_Item :    out PTR;
      Status       :    out DL_Status.STATUS_TYPE) is
     
      -- 
      -- Declare local variables
      --
      Call_Status    : DL_Status.STATUS_TYPE;

      --========================================================================
      -- DELETE_TOP_ITEM
      --========================================================================
      procedure Delete_Top_Item(
         List   : in out PTR;
         Item   :    out PTR;
         Status :    out DL_Status.STATUS_TYPE)is

         -- 
         -- Declare local variables
         --
         Item_To_Delete :PTR := List;
         
      begin --Delete_Top_Item
         
         Status := DL_Status.SUCCESS;

         If Is_Null(Tail_Of(List)) then 
    
            -- If list has no tail, then set to null. 
            Clear_List(List); 

         else

            -- Set the list pointer to  next node in the list. 
            List := Tail_Of(List);

            -- Clear previous pointer. 
            Clear_Previous(List);

         end if;

         -- Clear Node pointers in deleted node.  
         Clear_Node(Item_To_Delete);

         Item := Item_To_Delete;

      exception

         when OTHERS         =>
           Status := DL_Status.DELETE_ITEM_FAILURE;

      end Delete_Top_Item;

      --========================================================================
      -- DELETE_ITEM_At_POSITION
      --========================================================================
      procedure Delete_Item_At_Position(
         List     : in out PTR;
         Position : in     POSITIVE;
         Item     :    out PTR;
         Status   :    out DL_Status.STATUS_TYPE) is

         --
         -- Declare local variables
         --
         Call_Status    : DL_Status.STATUS_TYPE;
         Temp_List      : PTR := List; -- Temporary pointer to the list.  
         Tail_Of_List   : PTR;         -- Pointer to node after node to be deleted.
         Item_To_Delete : PTR;

         CALL_FAILURE   : EXCEPTION;

      begin

         Status := DL_Status.SUCCESS;

         -- Separate the node to delete from the main list. 
         Split(The_List    => Temp_List,    
               At_Position => At_Position,  
               Sublist     => Item_To_Delete,
               Status      => Call_Status);

         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;
  
         -- If deleted node has a tail, append to list.
         if not Is_Null(Tail_Of(The_List => Item_To_Delete)) then 
 
            -- Separate the node to delete from the sublist. 
            Split(The_List    => Item_To_Delete,   
                  At_Position => 2,              
                  Sublist     => Tail_Of_List,
                  Status      => Call_Status);

            if Call_Status /= DL_Status.SUCCESS then
               raise CALL_FAILURE;
            end if;   
          
            -- Move pointer to the last node in the main list. 
            Temp_List := End_Of(The_List => Temp_List);
    
            -- Swap the null tail of the temporary list with the new 
            -- sublist (minus the deleted node). 
            Swap_Tail(List_Tail => Temp_List,      
                      The_List  => Tail_Of_List);  
 
          end if;
   
           -- Clear the node pointers in the deleted node. 
          Clear_Node(Item_To_Delete);

          Item := Item_To_Delete;

       exception

         when CALL_FAILURE   =>
           Status := Call_Status;

         when OTHERS         =>
           Status := DL_Status.DELETE_ITEM_FAILURE;

      end Delete_Item_At_Position;

   begin -- Delete_Item

      if At_Position = 1 then

         Delete_Top_Item(
           List => The_List, 
           Item => Deleted_Item,
           Status => Call_Status);

      else

         Delete_Item_At_Position(
           List     => The_List,
           Position => At_Position,
           Item     => Deleted_Item,
           Status   => Call_Status);

      end if;

      Status := Call_Status;

   exception

      when OTHERS         =>
        Status := DL_Status.DELETE_ITEM_FAILURE;

   end Delete_Item; 

   --==========================================================================
   -- DELETE_ITEM_AND_FREE_STORAGE
   --==========================================================================
   --
   -- Purpose
   --
   --   Removes an item from a list and deletes the item's storage.
   --
   -- Implementation:
   --
   --   Calls Delete_Item to delete the item. (If no position value is input, 
   --   it will remove the item at the head of the list.  If a position is input, 
   --   it will remove the item at the input position.)  It them calls Free_Node to
   --   deallocate the storage for the deleted item.
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
    procedure Delete_Item_And_Free_Storage(
       The_List    : in out PTR;
       At_Position : in     POSITIVE := 1;
       Status      :    out DL_Status.STATUS_TYPE) is
       
       --
       -- Declare local variables
       --
       Call_Status  : DL_Status.STATUS_TYPE;
       The_Node     : PTR;

       --
       -- Declare local exception
       --
       CALL_FAILURE : EXCEPTION;

    begin

       Status := DL_Status.SUCCESS;

       Delete_Item(The_List     => The_List,
                   At_Position  => At_Position,
                   Deleted_Item => The_Node,
                   Status       => Call_Status);

       if Call_Status /= DL_Status.SUCCESS then
          raise CALL_FAILURE;
       end if;   

       Free(The_Node);
      
    exception

       when CALL_FAILURE   =>
         Status := Call_Status;

       when OTHERS         =>
         Status := DL_Status.DELETE_FREE_ITEM_FAILURE;

   end Delete_Item_And_Free_Storage;

   --==========================================================================
   -- FIND_POSITION_OF_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the position in the list of the input item.
   --
   -- Implementation:
   --
   --   Calls the function Position_Of to get the position within the list of the 
   --   input item.  Traps any exceptions raised by this function.
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
   procedure Find_Position_Of_Item(
      The_Item : in     ITEM;
      The_List : in     PTR;
      Position :    out POSITIVE;
      Status   :    out DL_Status.STATUS_TYPE) is
  
    begin
 
      Status := DL_Status.SUCCESS;
   
      Position := Position_Of(The_Item, The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.FIND_POSITION_OF_FAILURE;

   end Find_Position_Of_Item;

   --==========================================================================
   -- FREE_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Deletes all the items from a list, deallocates the memory for all the 
   --   deleted items and sets the list pointer to null;
   --
   -- Implementation:
   --
   --   Loops through the list and calls Delete_Item_And_Free_Storage to remove all
   --   the items from the list.  Then calls Clear_List to set the list pointer 
   --   to null;
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
   procedure Free_List( 
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables
      --
      Call_Status  : DL_Status.STATUS_TYPE;
      
      -- 
      -- Declare local exceptions
      --
      CALL_FAILURE : EXCEPTION;

   begin
 
      Status := DL_Status.SUCCESS;
       
      while not Is_Null(Tail_Of(The_List)) loop

         Delete_Item_And_Free_Storage(
           The_List => The_List, 
           Status   => Call_Status);

         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if; 

      end loop; 
      
      Delete_Item_And_Free_Storage(
         The_List => The_List, 
         Status   => Call_Status);

      -- List is empty so set pointer to null;
      Clear_List(The_List);
      
   exception

      when CALL_FAILURE =>
        Status := Call_Status;

      when OTHERS       =>
        Status := DL_Status.FREE_LIST_FAILURE;

   end Free_List;
  
   --==========================================================================
   -- FREE_NODE
   --==========================================================================
   --
   -- Purpose
   --   
   --    Deallocates storage and sets the pointer to null;
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List Free procedure to deallocate the storage 
   --   and set the pointer to null.  Traps any exceptions raised by this procedure.
   --  
   --   If the pointer is already null, it has no effect.
   --   If ITEM is a pointer, it has no effect on the storage pointed to by 
   --   ITEM.
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
   --=========================================================================
   procedure Free_Node(
      The_Node : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is
  
   begin
 
      Status := DL_Status.SUCCESS;
   
      Free(The_Node);

   exception

      when OTHERS       =>
        Status := DL_Status.FREE_NODE_FAILURE;

   end Free_Node;
 
   --==========================================================================
   -- GET_FIRST_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the item at the head of the list.
   --
   -- Implementation:
   --
   --   Calls the function Head_Of which traverses the list backwards until the 
   --   previous pointer is null and then returns the pointer to that node.  Traps
   --   any exceptions raised by this function.
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
   Procedure Get_First_Item(
      The_List : in     PTR;
      The_Item :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is
     
   begin

      Status   := DL_Status.SUCCESS;

      The_Item := Head_Of(The_List);

   exception  
     
      when OTHERS       =>
        Status := DL_Status.GET_FIRST_ITEM_FAILURE;

   end Get_First_Item;

   --==========================================================================
   -- GET_LAST_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the last item in the list. 
   --
   -- Implementation:
   --
   --   Calls the function End_Of which traverses the list forwards until the 
   --   next pointer is null and then returns the pointer to that node.  Traps
   --   any exceptions raised by this function.
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
   procedure Get_Last_Item(
      The_List : in     PTR;
      The_Item :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is
     
   begin
      
      Status  := DL_Status.SUCCESS;

      The_Item := End_Of(The_List);

   exception  
     
      when OTHERS       =>
        Status := DL_Status.GET_LAST_ITEM_FAILURE;

   end Get_Last_Item;

   --==========================================================================
   -- GET_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Return the value of The_Item record component in the node pointed to by
   --   the input pointer.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Value_Of to get the value of 
   --   The_Item component of the node and traps any exceptions raised by this
   --   function.
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
   procedure Get_Item(
      The_List : in     PTR;
      The_Item :    out ITEM;
      Status   :    out DL_Status.STATUS_TYPE) is


   begin

      Status   := DL_Status.SUCCESS;
      The_Item := Value_Of(The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.GLU_GET_ITEM_FAILURE;

   end Get_Item;
 
   --==========================================================================
   -- GET_PREVIOUS
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes preceeding the
   --   node pointed to by the input pointer.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Predecessor_Of to get the list of 
   --   items pointed to by the previous pointer of the input pointer's node and 
   --   traps any exceptions raised by this function.
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
   procedure Get_Previous(
      The_List : in     PTR;
      Previous :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Previous := Predecessor_Of(The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.GET_PREVIOUS_FAILURE;

   end Get_Previous; 
     
   --==========================================================================
   -- GET_NEXT
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a list containing the sequence of nodes after the node 
   --   pointed to by the input pointer.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Tail_Of function to get the list
   --   of items pointed to by the next pointer of the input pointer's node and traps
   --   any exceptions raised by this function.
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
   procedure Get_Next(
      The_List : in PTR;
      Next     :    out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is
   
   begin
 
      Status := DL_Status.SUCCESS;
   
      Next   := Tail_Of(The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.GET_NEXT_FAILURE;

   end Get_Next;

   --==========================================================================
   -- GET_SIZE
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the number of items in the list (traverses top to bottom).
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List function Length_Of to get the number of 
   --   items in the input list and traps any exceptions raised by this function.
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
   Procedure Get_Size(
      The_List : in     PTR;
      Size     :    out NATURAL;
      Status   :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Size   := Length_Of(The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.GET_SIZE_FAILURE;

   end Get_Size; 
 
   --==========================================================================
   -- GET_SUBLIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the pointer to a sublist whose head is the item given
   --
   -- Implementation:
   --
   --   Calls the function Location_Of to return the pointer to the node that
   --   contains the input item and traps any exceptions raised by this function.
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
   procedure Get_Sublist(
       The_Item : in     ITEM;
       The_List : in     PTR;
       Sublist  :    out PTR;
       Status   :    out DL_Status.STATUS_TYPE) is
      
   begin
 
      Status := DL_Status.SUCCESS;
   
      Sublist := Location_Of(The_Item, The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.GET_SUBLIST_FAILURE;

   end Get_Sublist;

   --==========================================================================
   -- GET_SUBLIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist whose head is the item at the position given
   --
   -- Implementation:
   --
   --   Calls the function Location_Of to return the pointer to the node at the
   --   input position and traps any exceptions that are raised by this function.
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
   procedure Get_Sublist(
       Position : in Positive;
       The_List : in PTR;
       Sublist  :    out PTR;
       Status   :    out DL_Status.STATUS_TYPE) is
    
   begin
 
      Status := DL_Status.SUCCESS;
   
      Sublist := Location_Of(Position, The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.GET_SUBLIST_FAILURE;

   end Get_Sublist;

   --==========================================================================
   -- INSERT_ITEM
   --==========================================================================
   --
   -- Purpose
   --
   --   Inserts an item into a list after a given position.
   --
   -- Implementation:
   --
   --  Calls the imported Generic_List procedure Construct_Top to create a 
   --  temporary list of one node and assign the input item to it.  Calls the
   --  imported Generic_List procedure Swap_Tail to attach this temporary list
   --  to the main list after the position indicated and moves the tail of
   --  the main list to another list. Then reattaches the deleted main list tail
   --  after the inserted item.  Traps any exceptions raised by the imported 
   --  procedures.
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
   procedure Insert_Item(
      The_Item       : in     ITEM;
      Into_List      : in     PTR;
      After_Position : in     POSITIVE;
      Status         :    out DL_Status.STATUS_TYPE) is
     
      --
      -- Declare local variables
      --

      -- Pointer to the item which will preceed the inserted item. 
      Index     : PTR := Location_Of(After_Position, Into_List);  

      -- Pointer to a temporary list of one item. 
      Temp_List : PTR;         
 
   begin

      Status := DL_Status.SUCCESS;

      -- Create the node and assign the item to it. 
      Construct_Top(The_Item => The_Item,  
                    Head     => Temp_List);

      -- Attach the node to the main list after the position indicated and move
      --  the tail to the temporary list. 
      Swap_Tail(List_Tail => Index,   
                The_List => Temp_List);
                                   
      -- Point to the inserted item. 
      Index := Tail_Of(The_List => Index);
 
      -- Reattach the temporary list to the main list ( after the inserted item). 
      Swap_Tail(List_Tail => Index,     
                The_List => Temp_List); 

   exception

      when OTHERS       =>
        Status := DL_Status.INSERT_ITEM_FAILURE; 
        
   end Insert_Item;

   --==========================================================================
   -- INSERT_ITEM_END
   --==========================================================================
   --
   -- Purpose
   --
   --   Adds an item to the end of the list.
   -- 
   -- Implementation:
   --
   --  Calls the function End_Of to find the last node in the input list. 
   --  Then calls the imported Generic_List procedure Construct_Bottom to create 
   --  the node and assign the input item to it.  The Head_Of function
   --  is then called to return the pointer to the top of the list.  Any 
   --  exceptions raised by function or imported procedure calls are trapped.
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
   procedure Insert_Item_End(
      The_Item : in     ITEM;
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is
      
      --
      -- Declare local variables
      --

      -- Pointer to last item in the main list.  
      Last_Node : PTR := End_Of(The_List);
         
   begin

      Status := DL_Status.SUCCESS;

      Construct_Bottom
        (The_Item => The_Item,
         Tail     => Last_Node);

      The_List := Head_Of(Last_Node);

   exception

      when OTHERS       =>
        Status := DL_Status.INSERT_END_FAILURE;

   end Insert_Item_End;

   --==========================================================================
   -- INSERT_ITEM_TOP
   --==========================================================================
   --
   -- Purpose
   --
   --   Adds an item to the top of the list.
   --
   -- Implementation:
   --
   --  Calls the function Head_Of to ensure that the input pointer is 
   --  at the head of the input list.  Then calls the imported Generic_List
   --  procedure Construct_Top to create the node and assign the input item 
   --  to it.  Assigns the input pointer to the new node and traps any 
   --  exceptions that are raised by the function or imported procedure calls.
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
   procedure Insert_Item_Top(
      The_Item : in     ITEM;
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is

      --
      -- Declare local variables
      --

      -- Pointer to first item in the list.  
      First_Node : PTR := Head_Of(The_List);
         
   begin

      Status := DL_Status.SUCCESS;

      -- Add node 
      Construct_Top(The_Item => The_Item,
                    Head     => First_Node);

      The_List := First_Node;

   exception

      when OTHERS       =>
        Status := DL_Status.INSERT_TOP_FAILURE;

   end Insert_Item_Top;

   --==========================================================================
   -- INSERT_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Inserts a list into a list at a given position.
   --
   -- Implementation:
   --
   --   Calls the imported Generic_List procedure Swap_Tail to attach insert list
   --   after the position indicated and moves the tail to a temporary list.  
   --   Then attaches the temporary tail to the list after the inserted list.
   --   Traps any exceptions that are raised by the imported procedures are 
   --   function calls
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
   procedure Insert_List(
      The_List       : in     PTR;
      Insert_List    : in     PTR;
      After_Position : in     POSITIVE;
      Status         :    out DL_Status.STATUS_TYPE) is

      -- 
      -- Declare local variables
      --
  
      -- Pointer to the item which will preceed the inserted list. 
      Index     : PTR := Location_Of(After_Position, The_List);
 
      -- Temporary pointer for list to insert. 
      Temp_List : PTR := Insert_List; 
   
      -- Pointer to the last item in the list that is being inserted. *
      Temp_Tail : PTR := End_Of(Insert_List);  

   begin

      Status := DL_Status.SUCCESS;

      -- Attach insert list after position indicated and move the tail to a 
      --  temporary list. 
      Swap_Tail(List_Tail  => Index,    
                The_List   => Temp_List); 
          
      -- Reattach the temporary list to the main list (after the inserted list).
      Swap_Tail(List_Tail  => Temp_Tail, 
	        The_List   => Temp_List); 
  
   exception

      when OTHERS       =>
        Status := DL_Status.INSERT_LIST_FAILURE;

   end Insert_List;

   --==========================================================================
   -- SPLIT
   --==========================================================================
   --
   -- Purpose
   --
   --   Break a list into two lists at a given position.
   --
   -- Implementation:
   --
   --   Creates a tempory list and then calls the imported Generic_List procedure
   --   Swap_Tail to assign the tail of the list after the position input to a 
   --   temporary list.  This deletes the tail from the input list and creates 
   --   a new sublist.  Any exceptions raised by calls to imported procedures or
   --   functions are trapped.
   --   
   --  The following status values may be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     DL_Status.SPLIT_FAILURE - Indicates an exception was raised in
   --       this unit.
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
   procedure Split(
      The_List    : in     PTR;
      At_Position : in     POSITIVE;
      Sublist     :    out PTR;
      Status      :    out DL_Status.STATUS_TYPE) is
   
      -- 
      -- Declare local variables
      --
      
      -- Pointer to the node that will be at the end of The_List when it is split. 
      Index     : PTR := Location_Of((At_Position - 1), The_List);

      Temp_List : PTR;
         
   begin

      Status := DL_Status.SUCCESS;
     
      -- Make sure pointer is null; 
      Clear_List(Temp_List);

      -- Assign Tail of list to sublist 
      Swap_Tail(List_Tail => Index, 
                The_List  => Temp_List); 

      Sublist := Temp_List;

   exception

      when OTHERS         =>
        Status := DL_Status.SPLIT_FAILURE;

   end Split;

   --==========================================================================
   -- STRAIGHT_INSERTION_SORT
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts a list according to the imported "<" function.
   --
   -- Implementation:
   -- 
   --   Examines one item at a time and inserts it in the proper order relative
   --   to all previously processed items.  Equal key values maintain there order.
   --   Any exceptions rasied by imported units or function calls are trapped.
   --
   --  The following status values may be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     DL_Status.SORT_INSERT_FAILURE - Indicates an exception was raised in
   --       this unit.
   --	
   --     Other - If an error occurs in a call to a sub-routine, the procedure 
   --             will terminate and the status (error code) for the failed routine
   --             will be returned.
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
   procedure Straight_Insertion_Sort(
      The_List : in out PTR;
      Status   :    out DL_Status.STATUS_TYPE) is
 
      -- 
      -- Declare local variables
      --

      Call_Status     : DL_Status.STATUS_TYPE;

      -- Position in the list at which to insert an item 
      Insert_Position : INTEGER;
  
      -- Total number of items in the list being sorted. 
      Length_Of_List  : NATURAL := Length_Of(The_List); 

      -- The number of items from current item being moved to the first item 
      --  in the list. 
      Top_Of_List     : NATURAL;	
	
      -- Temporary storage for an item.     
      Temp_Item       : ITEM;	

      -- Pointer to the inner nodes being compared. 
      Inner_Index     : PTR;       

      -- Pointer to the item being moved. 
      Insert_Item     : PTR;	

      -- Pointer to the items in the list.
      Outer_Index     : PTR;	

      -- Temporary pointer to the list being sorted. 
      Temp_List       : PTR := The_List;

      --
      -- Declare local exception
      --
      CALL_FAILURE    : EXCEPTION;

   begin

      Status := DL_Status.SUCCESS;

      for Swap_Position in 2 .. Length_Of_List loop

         -- Set the outer index. 
         Outer_Index := Location_Of(Position => Swap_Position,
                                    The_List => Temp_List);
         -- Set the inner index. 
         Inner_Index := Outer_Index;

         -- Get the value of the node pointed to. 
         Temp_Item   := Value_Of(Inner_Index); 
    
         -- Calculate the number of items which need to be compared. 
         Top_Of_List := Swap_Position - 1;      
   					    
         for Backup in reverse 1..Top_Of_List loop

            -- Point to previous node. 
            Inner_Index := Predecessor_Of(Inner_Index);

            -- Compare node values. 
            if Temp_Item < Value_Of(Inner_Index) then

               -- Switch nodes. 
               Delete_Item(The_List     => Temp_List,
                           At_Position  => Backup + 1,
                           Deleted_Item => Insert_Item,
                           Status       => Call_Status);

               if Call_Status /= DL_Status.SUCCESS then
                  raise CALL_FAILURE;
               end if;

               Inner_Index     := Insert_Item;
               Insert_Position := Backup - 1;

               if Insert_Position = 0 then
	
	          -- Add to top of list. 
                  Swap_Tail(List_Tail => Insert_Item, 
                            The_List  => Temp_List);

                  Temp_List := Insert_Item;

               else
			
                  -- Insert in list
                  Insert_List(The_List       => Temp_List,
                              Insert_List    => Insert_Item,
                              After_Position => Insert_Position,
                              Status         => Call_Status);

                  if Call_Status /= DL_Status.SUCCESS then
                     raise CALL_FAILURE;
                  end if;

               end if; -- Insert_Position

            end if; --Temp_Item <

         end loop; -- for Backup

      end loop; -- for Swap_Position
  
      --  Reset the pointer to the list. 
      The_List := Head_Of(Temp_List);

   exception

      when CALL_FAILURE => 
        Status := Call_Status;

      when OTHERS       =>
        Status := DL_Status.SORT_INSERT_FAILURE;

   end Straight_Insertion_Sort;

   --==========================================================================
   -- SWAP_TAILS
   --==========================================================================
   --
   -- Purpose
   --
   --   Exchange the tail of one list (List_Tail) with another list (The_List).
   --
   -- Implementation:
   -- 
   --   Calls the imported Generic_List procedure Swap_Tails to exchange the tail of
   --   one list for the tail of another list.  Traps any exceptions raised by this 
   --   procedure.
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
  
   -- Exceptions:
   --   None
   -- 
   --==========================================================================
   procedure Swap_Tails(
      List_Tail : in     PTR;
      The_List  : in out PTR;
      Status    :    out DL_Status.STATUS_TYPE) is

   begin
 
      Status := DL_Status.SUCCESS;
   
      Swap_Tail(List_Tail, The_List);

   exception

      when OTHERS       =>
        Status := DL_Status.SWAP_TAILS_FAILURE;

   end Swap_Tails;

   --
   -- FUNCTIONS
   --
   --==========================================================================
   -- END_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the last item in the list. 
   --
   -- Implementation:
   --
   --   Traverses list forward until the next pointer points to null.
   -- 	(See Get_Last_Item for the same unit that returns a status value).
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
   function End_Of (The_List : in PTR) return PTR is
     
      --
      -- Declare local variables
      --
      -- Temporary pointer to traverse the list. 
      Index : PTR := The_List;  
     
   begin

      while not Is_Null(Tail_Of(The_List => Index)) loop

         Index := Tail_Of(The_List => Index);

      end loop;

      return Index;

   end End_Of;

   --==========================================================================
   -- HEAD_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a pointer to the first item in the list.
   --
   -- Implementation:
   --
   --   Traverses list backwards until the previous pointer points to null.
   -- 	(See Get_First_Item for the same unit that returns a status value)
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
   function Head_Of(The_List : in PTR) return PTR is
      
      -- 
      -- Declare local variables
      --
     
      -- Temporary pointer to traverse the list. 
      Index : PTR := The_List;  
     
   begin

      while not Is_Null(Predecessor_Of(The_List => Index)) loop

         Index := Predecessor_Of(The_List => Index);

      end loop;

      return Index;

   end Head_Of;


   --==========================================================================
   -- IS_END
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines if the pointer is pointing to the last node in the list.
   --
   -- Implementation:
   --   
   --  Calls the imported Generic_List functions Is_Null and Tail_Of to determine
   --  if the current node's next pointer is null.  If it is, return TRUE; else 
   --  return FALSE;
   --  
   -- 	(See Check_At_End for the same unit that returns a status value)
   --				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   -- 
   --   LIST_IS_NULL is raised if there are no items in the list.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Is_End (The_List : in PTR) return Boolean is

      -- 
      -- Declare local variables
      --

      -- Pointer to the suscceeding item in the list. 
      Temp_List : PTR := The_List; 
                                            
   begin

      if Is_Null(The_List => Temp_List) then

         raise LIST_IS_NULL;

      else

         if Is_Null(Tail_Of(The_List => Temp_List)) then
            return TRUE;
         else
            return FALSE;
         end if;

     end if;

  end Is_End;

   --==========================================================================
   -- IS_HEAD
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines if the pointer is pointing to the first node in the list.
   --
   -- Implementation:
   --   
   --  Calls the imported Generic_List functions Is_Null and Tail_Of to determine
   --  if the current node's previous pointer is null.  If it is, return TRUE; else 
   --  return FALSE;
   -- 
   -- 	(See Check_At_Head for the same unit that returns a status value)				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   
   --   If the input list is null, LIST_IS_NULL is raised.
   -- 
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Is_Head (The_List : in PTR) return Boolean is
      
      -- 
      -- Declare local variables
      --

      -- Use Local pointer.
      Temp_List : PTR := The_List; 
  
   begin

      if Is_Null(The_List => Temp_List) then

         raise LIST_IS_NULL;

      else

         if Is_Null(Predecessor_Of(The_List => Temp_List)) then
            return True;
         else
            return False;
         end if;

      end if;

   end Is_Head;

   --==========================================================================
   -- LOCATION_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist whose head is the item given
   --
   -- Implementation:
   --
   --   Loops through the list and calls the imported Generic_List functions
   --   Is_Null, Tail_Of, and Value_Of to traverse the list until the input ITEM
   --   is located in the list.  Returns the pointer to the node that contains the
   --   input item identifier.
   -- 
   -- 	(See Get_Sublist for the same unit that returns a status value) 
   --  				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --    If the item is not found, ITEM_NOT_FOUND is raised.
   -- 
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Location_Of(
      The_Item   : in ITEM;
      The_List   : in PTR) 
    return PTR is
      
      --
      -- Declare local variables
      --

      -- Temporary pointer to traverse the list. 
      Index : PTR := The_List;
 
   begin

      While not Is_Null(The_List =>Index) loop

         if The_Item = Value_Of(The_List => Index) then
            return Index;
         else
            Index := Tail_Of(The_List => Index);
         end if;

      end loop;

      raise ITEM_NOT_FOUND;

   end Location_Of;

   --==========================================================================
   -- LOCATION_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist whose head is the node at the input position in the 
   --   list.
   --
   -- Implementation:
   --
   --   Loops through the list and calls the imported Generic_List functions
   --   Is_Null and Tail_Of to traverse the list until it has looped to the 
   --   input position.  The pointer to the node at this position is returned.
   --
   -- 	(See Get_Sublist for the same unit that returns a status value)	
   -- 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   --   If the list is null, LIST_IS_NULL is raised.
   --   If the input position is greater than the size of the list, 
   --    POSITION_ERROR is raised.
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Location_Of(
      Position : in Positive;
      The_List : in PTR)
    return PTR is

      --
      -- Declare local variables
      --

      -- Temporary pointer to traverse the list. 
      Index : PTR := The_List; 
 
   begin

      if Is_Null(The_List) then

         raise LIST_IS_NULL;

      else

         for Count in 2..Position loop

            Index := Tail_Of(The_List => Index);

            if Is_Null(The_List => Index) then
               raise POSITION_ERROR;
            end if;

         end loop;

         return Index;

      end if;

   end Location_Of;

   --==========================================================================
   -- POSITION_OF
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns the position in the list of the given item.
   --
   -- Implementation:
   --
   -- Implementation:
   --
   --   Loops through the list and calls the imported Generic_List functions
   --   Is_Null, Tail_Of, and Value_Of to traverse the list and increment a 
   --   counter until the input ITEM is located in the list.  Returns the 
   --   position of the input ITEM in the list.  Traps any exceptions raised
   --   by the imported functions.
   --	
   -- 	(See Find_Position_Of_Item for the same unit that returns a status value)
   --	 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --   
   --   If the item is not in the list, ITEM_NOT_FOUND is raised.
   -- 
   -- Portability Issues:
   --   None
   --
   --==========================================================================
   function Position_Of(
      The_Item : in ITEM;
      The_List : in PTR)
    return Positive is

      --
      -- Declare local variables
      --

      -- Counter to step through the list.
      Position_In_List : Positive := 1;   

      -- Temporary pointer to traverse the list.
      Index            : PTR := The_List;
 
   begin

      while not Is_Null(The_List =>Index) loop

         if The_Item = Value_Of(The_List => Index) then
            return Position_In_List;
         else
            Position_In_List := Position_In_List + 1;
            Index := Tail_Of(The_List => Index);
         end if;

      end loop;

      raise ITEM_NOT_FOUND;

   end Position_Of;
      
end Generic_List_Utilities;

