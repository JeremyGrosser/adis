--
--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--
------------------------------------------------------------------------------
--
-- PACKAGE NAME     : Generic_Linked_List
--
-- FILE NAME        : Generic_Linked_List.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 09, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with Unchecked_Deallocation;

package body Generic_Linked_List is

   ---------------------------------------------------------------------------
   -- Instantiate a deallocator function for the list nodes
   ---------------------------------------------------------------------------

   procedure Free is
     new Unchecked_Deallocation(LIST_NODE, LIST_NODE_PTR);

   ---------------------------------------------------------------------------
   -- Add_Node
   ---------------------------------------------------------------------------

   procedure Add_Node(
      At_Head : in BOOLEAN := TRUE;
      Data    : in LIST_ELEMENT_DATA_TYPE) is

      New_Node : LIST_NODE_PTR := new LIST_NODE;

   begin  -- Add_Node

      New_Node.Data := Data;

      if (List_Head = NULL) then

         --
         -- List is empty.  In this case, it doesn't matter if the data
         -- was to be added to the head or tail, since the same processing
         -- is performed in either case.
         --
         List_Head := New_Node;
         List_Tail := New_Node;

      else  -- not (List_Head = NULL)

         --
         -- List contains data.  Check if the data is to be added at the head
         -- or tail of the list.
         --
         if (At_Head) then

            --
            -- Link the new node at the head of the list
            --
            List_Head.Prev := New_Node;   -- Backward link current head node
            New_Node.Next  := List_Head;  -- Forward link the new node
            List_Head      := New_Node;   -- Set new node as list head node

         else  -- not (At_Head)

            --
            -- Link the new node at the tail of the list
            --
            List_Tail.Next := New_Node;   -- Forward link current tail node
            New_Node.Prev  := List_Tail;  -- Backward link the new node
            List_Tail      := New_Node;   -- Set new node as list tail node

         end if;  -- (At_Head)

      end if;  -- (List_Head = NULL)

   end Add_Node;

   ---------------------------------------------------------------------------
   -- Remove_Node
   ---------------------------------------------------------------------------
   --
   -- Purpose: Removes the indicated node from the list, updating the head
   --          and/or tail as required.  The memory for the node is
   --          deallocated and the Node_Ptr set to NULL upon exit.
   --
   -- Effects: This procedure may modify the List_Head and/or List_Tail
   --          pointers.
   --
   ---------------------------------------------------------------------------

   procedure Remove_Node(
      Node_Ptr : in out LIST_NODE_PTR) is

   begin  -- Remove_Node

      if (Node_Ptr = List_Head) then

         --
         -- Move list head to next node
         --
         List_Head := List_Head.Next;

         if (List_Head = NULL) then

            --
            -- Last node on the list was just removed.  Reset tail to NULL.
            --
            List_Tail := NULL;

         else

            --
            -- Reset the Prev pointer of the new list head to NULL.
            --
            List_Head.Prev := NULL;

         end if;

      elsif (Node_Ptr = List_Tail) then

         --
         -- Move list tail to previous node
         --
         List_Tail := List_Tail.Prev;

         if (List_Tail = NULL) then

            --
            -- First node on the list was just removed.  Reset head to NULL.
            --
            List_Head := NULL;

         else

            --
            -- Reset the Next pointer of the new list tail to NULL.
            --
            List_Tail.Next := NULL;

         end if;

      else  -- Node_Ptr is neither head nor tail of list

         Node_Ptr.Next.Prev := Node_Ptr.Prev;  -- link next node to prev node
         Node_Ptr.Prev.Next := Node_Ptr.Next;  -- link prev node to next node

      end if;

      --
      -- Deallocate the memory used for the node.
      --
      Free(Node_Ptr);

      --
      -- Not all versions of Unchecked_Deallocation reset the pointer to NULL,
      -- so do this manually to make certain.
      --
      Node_Ptr := NULL;

   end Remove_Node;

   ---------------------------------------------------------------------------
   -- Clear_List
   ---------------------------------------------------------------------------
   --
   -- Purpose: Removes any nodes remaining in the list, and deallocates the
   --          memory used for these nodes.
   --
   -- Effects: List_Head and List_Tail are set to NULL upon exit.
   --
   ---------------------------------------------------------------------------

   procedure Clear_List is

      Free_Node : LIST_NODE_PTR;

   begin  -- Clear_List

      Clear_Loop:
      while (List_Head /= NULL) loop

         Free_Node := List_Head;
         List_Head := List_Head.Next;

         Free(Free_Node);

      end loop Clear_Loop;

      --
      -- List is now empty, reset tail to NULL.
      --
      List_Tail := NULL;

   end Clear_List;

end Generic_Linked_List;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
