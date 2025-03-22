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
-- Package Name:       Generic_Sort_List_By_Velocity
--
-- File Name:          Generic_Sort_List_By_Velocity.ada
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
--   Contains units required to sort a list of PDUs in either descending or 
--   ascending order (descending is the default) according to the magnitude 
--   of the PDUs velocity vector.
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
with Calculate,
     Generic_Binary_Insertion_Sort,
     Numeric_Types;

package body Generic_Sort_List_By_Velocity is

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   -- Define types to instantiate generic sort routine for sort by velocity.

   type SORT_RECORD is
     record
       PDU      : ITEM;
       Velocity : Numeric_Types.FLOAT_32_BIT; 
     end record;

   type SORT_ARRAY is array(POSITIVE range <>) of SORT_RECORD;

   --==========================================================================
   -- VELOCITY_ASCENDING
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether two input velocity values are in ascending order.
   --
   -- Implementation:
   --
   --   Returns TRUE if the input velocity values are in ascending order and
   --   FALSE if they are not in ascending order.
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
   function Velocity_Ascending(
      Left  : in SORT_RECORD;
      RIGHT : in SORT_RECORD)
     return BOOLEAN is

   begin
      if Left.Velocity < Right.Velocity then
        return TRUE;
      else 
        return FALSE;
      end if;
   end Velocity_Ascending;

   --==========================================================================
   -- VELOCITY_DESCENDING
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether two input velocity values are in descending order.
   --
   -- Implementation:
   --
   --   Returns TRUE if the input velocity values are in descending order and
   --   FALSE if they are not in descending order.
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
   function Velocity_Descending(
      Left  : in SORT_RECORD;
      RIGHT : in SORT_RECORD)
     return BOOLEAN is

   begin
      if Left.Velocity < Right.Velocity then
        return FALSE;
      else 
        return TRUE;
      end if;
   end Velocity_Descending;
  
   --==========================================================================
   -- CREATE_ARRAY_TO_SORT
   --==========================================================================
   --
   -- Purpose
   --
   --   Converts a linked list to an array of records that can be sorted by 
   --   the generic sort routine.
   --
   -- Implementation:
   --
   --   Instantiates an array the same size as the linked list.
   --   Calculates the velocity of each entity in the linked list and then
   --   assigns the calculated velocity along with the corresponding PDU pointer
   --   to a record in an array.
   --   The following status values may be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     DL_Status.SORT_CREATE_ARRAY_FAILURE - Indicates an exception was 
   --       raised in this unit.
   --
   --     Other - If an error occurs in a call to a sub-routine, the procedure 
   --       will terminate and the status (error code) for the failed routine
   --       will be returned.
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
   procedure Create_Array_To_Sort( 
      The_List   : in     PTR;
      Sort_List  :    out SORT_ARRAY;
      Status     :    out DL_Status.STATUS_TYPE) is 

      --
      -- Declare local variables
      -- 
      Call_Status : DL_Status.STATUS_TYPE;
      Index       : POSITIVE := POSITIVE'FIRST;
      PDU         : ITEM;
      PDU_List    : SORT_ARRAY(Sort_List'FIRST..Sort_List'LAST);
      Temp_List   : PTR := The_List;
      Velocity    : Numeric_Types.FLOAT_32_BIT;
  
      --
      -- Declare local exception
      --
      CALL_FAILURE : EXCEPTION;

   begin -- Create_Array_To_Sort

     Status := DL_Status.SUCCESS;

     while not Is_Null(Temp_List) loop

        -- Get the pointer to the PDU record.
        PDU := Value_Of(Temp_List);

        Calculate.Velocity(
          Linear_Velocity    => PDU_Velocity(PDU),
          Velocity_Magnitude => Velocity,
          Status             => Call_Status);

        if Call_Status /= DL_Status.SUCCESS then
           raise CALL_FAILURE;
        end if;   

        PDU_List(Index) := (PDU      => PDU,
                            Velocity => Velocity);
        
        -- Get next node.
        Temp_List := Tail_Of(Temp_List);
     
        -- Increment array index
        Index := Index + 1;

      end loop;

      Sort_List := PDU_List;

   exception

      when CALL_FAILURE     =>
        Status := Call_Status;

      when OTHERS           =>
        Status := DL_Status.SORT_CREATE_ARRAY_FAILURE;
 
   end Create_Array_To_Sort;

   --==========================================================================
   -- CREATE_SORTED_LINKED_LIST
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts the PDU pointers in the linked list according to the entity's  
   --   velocity.
   --
   -- Implementation:
   --
   --   Overwrites the PDU pointers in the linked list with the pointers in the 
   --   sorted array.  When finished the linked list is in the same sorted order
   --   as the array.
   --
   --   The following status values may be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     DL_Status.SORT_CREATE_LIST_FAILURE - Indicates an exception was 
   --       raised in this unit.
   --		 		
   --    				 		
   -- Effects:
   --   None
   --
   -- Exceptions:
   --
   -- Portability Issues:
   --   None
   --
   --==========================================================================  
   procedure Create_Sorted_Linked_List( 
      The_List    : in out PTR;
      Sorted_List : in     SORT_ARRAY;
      Status      :    out DL_Status.STATUS_TYPE) is 

      --
      -- Declare local variables
      -- 
      Call_Status : DL_Status.STATUS_TYPE;
  
      Index       : POSITIVE := POSITIVE'FIRST;
      PDU         : ITEM;
      Temp_List   : PTR := The_List;

   begin --Create_Sorted_Linked_List

      Status := DL_Status.SUCCESS;

      while not Is_Null(Temp_List) loop

         Change_Item(
           New_Item  => Sorted_List(Index).PDU,
           Null_Item => Null_Item,
           Old_Item  => Temp_List);
     
         -- Get next node.
         Temp_List := Tail_Of(Temp_List);

         -- Increment array index.
         Index := Index + 1;

      end loop;
    
   exception

      when OTHERS           =>
        Status := DL_Status.SORT_CREATE_ARRAY_FAILURE;

   end Create_Sorted_Linked_List;

   --==========================================================================
   -- SORT_VELOCITY
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts the PDU pointers in the linked list according to the entity's 
   --   velocity.
   --
   -- Implementation:
   --
   --   An array that containes each PDU pointer and the calculated velocity
   --   magnitude is created.  This array is sorted in either descending or
   --   ascending order depending on the value of the input BOOLEAN "Descending".
   --   (It defaults to descending order with the first PDU pointer in the 
   --   sorted list pointing to the PDU that contains the fastest velocity.) 
   --   The linked list is then overwritten with the PDU pointers in the sorted 
   --   array which results in the linked list being in the same sorted order as
   --   the sorted array.
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
   procedure Sort_Velocity( 
      The_List   : in out PTR;
      Descending : in     BOOLEAN := TRUE;
      Status     :    out DL_Status.STATUS_TYPE) is 

      --
      -- Declare local variables
      -- 
      Call_Status : DL_Status.STATUS_TYPE;
      Index       : POSITIVE := POSITIVE'FIRST;
      PDU         : ITEM;
      PDU_Array   : SORT_ARRAY(POSITIVE'FIRST..Length_Of(The_List));
      Temp_List   : PTR := The_List;

      --
      -- Declare local exception
      --
      CALL_FAILURE : EXCEPTION;
      LIST_IS_NULL : EXCEPTION;

   begin --Sort_List

     Status := DL_Status.SUCCESS;

     if Is_Null(The_List) then
        raise LIST_IS_NULL;
     end if;

     -- Calculate the velocity of each entity and store the velocity and the
     -- PDU pointer in an array which can be sorted.
     Create_Array_To_Sort( 
       The_List  => The_List,
       Sort_List => PDU_Array,
       Status    => Call_Status);

     if Call_Status /= DL_Status.SUCCESS then
        raise CALL_FAILURE;
     end if;   

     if Descending then 

        -- Instantiate the sort routine to sort in descending order. 
        declare

           package Sort_Descending is new Generic_Binary_Insertion_Sort(
             ITEM  => SORT_RECORD,
             INDEX => POSITIVE,
             ITEMS => SORT_ARRAY,
             "<"   => Velocity_Descending);
    
        begin
           -- Sort the distance information in descending order.
           Sort_Descending.Sort(PDU_Array);
           end;

     else

        -- Instantiate the sort routine to sort in ascending order.
        declare

           package Sort_Ascending is new Generic_Binary_Insertion_Sort(
             ITEM  => SORT_RECORD,
             INDEX => POSITIVE,
             ITEMS => SORT_ARRAY,
             "<"   => Velocity_Ascending);

        begin
           -- Sort the distance information in ascending order.
           Sort_Ascending.Sort(PDU_Array);
        end;

     end if;

     -- Assign the sorted PDU pointers to the linked list in the sorted order.
     Create_Sorted_Linked_List( 
        The_List    => The_List,
        Sorted_List => PDU_Array,
        Status      => Call_Status); 

     if Call_Status /= DL_Status.SUCCESS then
        raise CALL_FAILURE;
     end if;   

   exception

      when CALL_FAILURE   =>
        Status := Call_Status;

      when LIST_IS_NULL => NULL; -- LIST_IS_NULL returns a status of SUCCESS

      when OTHERS         =>
        Status := Get_Status;
      
   end Sort_Velocity;
    
end Generic_Sort_List_By_Velocity; 
