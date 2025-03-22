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
-- FILE NAME        : Generic_Linked_List_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 09, 1994
--
-- PURPOSE:
--   - This package implements a generic double-linked list package.
--
-- EFFECTS:
--   - None.
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

generic

   type LIST_ELEMENT_DATA_TYPE is private;

package Generic_Linked_List is

   ---------------------------------------------------------------------------
   -- Define the list node and list node pointer types
   ---------------------------------------------------------------------------

   type LIST_NODE;
   type LIST_NODE_PTR is access LIST_NODE;

   type LIST_NODE is
     record
       Prev : LIST_NODE_PTR;
       Next : LIST_NODE_PTR;
       Data : LIST_ELEMENT_DATA_TYPE;
     end record;

   ---------------------------------------------------------------------------
   -- Declare a head and a tail for the linked list
   ---------------------------------------------------------------------------

   List_Head : LIST_NODE_PTR;
   List_Tail : LIST_NODE_PTR;

   ---------------------------------------------------------------------------
   -- Add_Node
   ---------------------------------------------------------------------------
   --
   -- Purpose: Creates a new node, at either the head or tail of the list,
   --          and inserts the data in the new node.
   --
   -- Effects: This procedure may modify the List_Head and/or List_Tail
   --          pointers.
   --
   ---------------------------------------------------------------------------

   procedure Add_Node(
      At_Head : in BOOLEAN := TRUE;  -- If FALSE, add at tail
      Data    : in LIST_ELEMENT_DATA_TYPE);

   ---------------------------------------------------------------------------
   -- Remove_Node
   ---------------------------------------------------------------------------
   --
   -- Purpose: Removes the indicated node from the list, updating the head
   --          and/or tail as required.  The memory for the node is
   --          deallocated and the Node_Ptr reset to NULL upon exit.  Since
   --          the Node_Ptr is reset by this procedure, it should NEVER be
   --          called using List_Head or List_Tail directly.
   --
   -- Effects: This procedure may modify the List_Head and/or List_Tail
   --          pointers.
   --
   ---------------------------------------------------------------------------

   procedure Remove_Node(
      Node_Ptr : in out LIST_NODE_PTR);

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

   procedure Clear_List;

end Generic_Linked_List;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
