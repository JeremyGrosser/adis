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
-- Package Name:       Generic_Sort_List_By_Distance
--
-- File Name:          Generic_Sort_List_By_Distance.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 22, 1994
--
-- Purpose:
--
--   Contains a units required to sort a list of PDU pointers in either 
--   ascending or descending order (accending is the default) according to the
--   PDU's distance to some input refernce point.
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
with Calculate,
     Generic_Binary_Insertion_Sort,
     Numeric_Types;

package body Generic_Sort_List_By_Distance is

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   -- Define types to instantiate generic sort routine for sort by distance.

   type SORT_RECORD is
     record
       PDU      : ITEM;
       Distance : Numeric_Types.FLOAT_64_BIT; 
     end record;

   type SORT_ARRAY is array(POSITIVE range <>) of SORT_RECORD;

   --==========================================================================
   -- DISTANCE_ASCENDING
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether two input distances are in ascending order.
   --
   -- Implementation:
   --
   --   Returns TRUE if the input distances are in ascending order and
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
   function Distance_Ascending(
      Left  : in SORT_RECORD;
      RIGHT : in SORT_RECORD)
     return BOOLEAN is

   begin
      if Left.Distance < Right.Distance then
        return TRUE;
      else 
        return FALSE;
      end if;
   end Distance_Ascending;

   --==========================================================================
   -- DISTANCE_DESCENDING
   --==========================================================================
   --
   -- Purpose
   --
   --   Determines whether two input distance values are in descending order.
   --
   -- Implementation:
   --
   --   Returns TRUE if the input distance values are in descending order and
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
   function Distance_Descending(
      Left  : in SORT_RECORD;
      RIGHT : in SORT_RECORD)
     return BOOLEAN is

   begin
      if Left.Distance < Right.Distance then
        return FALSE;
      else 
        return TRUE;
      end if;
   end Distance_Descending;
  
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
   --   Calculates the distance of each entity in the linked list from the input
   --   reference point and then assigns the calculated distance along with the 
   --   corresponding PDU pointer to a record in the array.
   --   
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
      The_List           : in     PTR;
      Reference_Position : in     DIS_Types.A_WORLD_COORDINATE;
      Sort_List          :    out SORT_ARRAY;
      Status             :    out DL_Status.STATUS_TYPE) is 
   
      --
      -- Declare local variables
      -- 
      Call_Status : DL_Status.STATUS_TYPE;
      Distance    : Numeric_Types.FLOAT_64_BIT; 
      Index       : POSITIVE := POSITIVE'FIRST;
      PDU         : ITEM;
      PDU_List    : SORT_ARRAY(Sort_List'FIRST..Sort_List'LAST);
      Temp_List   : PTR := The_List;
   
      --
      -- Declare local exception
      --
      CALL_FAILURE : EXCEPTION;

   begin -- Create_Array_To_Sort

     Status := DL_Status.SUCCESS;

     while not Is_Null(Temp_List) loop
     
        -- Get the pointer to the PDU record.
        PDU := Value_Of(Temp_List);

        Calculate.Distance(
           Position_1 => Reference_Position, 
           Position_2 => PDU_Location(PDU),
           Distance   => Distance,
           Status     => Call_Status);
  
        if Call_Status /= DL_Status.SUCCESS then
           raise CALL_FAILURE;
        end if;   

        PDU_List(Index) := (PDU      => PDU,
                            Distance => Distance);
        
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
   --   distance from the input reference point.
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
        Status := DL_Status.SORT_CREATE_LIST_FAILURE;
  
   end Create_Sorted_Linked_List;

   --==========================================================================
   -- SORT_DISTANCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Sorts the PDU pointers in the linked list according to the entity's 
   --   distance from an input reference point.
   --
   -- Implementation:
   --
   --   An array that containes each PDU pointer and the calculated distance
   --   from the input reference point is created.  This array is sorted in 
   --   either ascending or descending order depending on the value of the input
   --   BOOLEAN "Ascending". (It defaults to ascending order with the first PDU
   --   pointer in the sorted list pointing to the PDU that is the closest to the
   --   reference point.)  The linked list is then overwritten with the PDU 
   --   pointers in the sorted array which results in the linked list being in
   --   the same sorted order as the sorted array.
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
    procedure Sort_Distance( 
      The_List           : in out PTR;
      Ascending          : in     BOOLEAN := TRUE;
      Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
      Status             :    out DL_Status.STATUS_TYPE) is 

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

     -- Calculate the distance of each entity and store the distance and the
     -- PDU pointer in an array which can be sorted.
     Create_Array_To_Sort( 
       The_List           => The_List,
       Reference_Position => Reference_Position,
       Sort_List          => PDU_Array,
       Status             => Call_Status);

     if Call_Status /= DL_Status.SUCCESS then
        raise CALL_FAILURE;
     end if;   

     if Ascending then
 
        -- Instantiate the sort routine to sort in ascending order.
        declare

           package Sort_Ascending is new Generic_Binary_Insertion_Sort(
             ITEM  => SORT_RECORD,
             INDEX => POSITIVE,
             ITEMS => SORT_ARRAY,
             "<"   => Distance_Ascending);

        begin
           -- Sort the distance information in ascending order.
           Sort_Ascending.Sort(PDU_Array);
        end; --declare block
        
     else

        -- Instantiate the sort routine to sort in descending order. 
        declare

           package Sort_Descending is new Generic_Binary_Insertion_Sort(
             ITEM  => SORT_RECORD,
             INDEX => POSITIVE,
             ITEMS => SORT_ARRAY,
             "<"   => Distance_Descending);
    
        begin
           -- Sort the distance information in descending order.
           Sort_Descending.Sort(PDU_Array);
        end; --declare block

     end if;

     -- Assign the sorted PDU pointers to the linked list in the sorted order.
     Create_Sorted_Linked_List( 
       The_List    => The_List,
       Sorted_List => PDU_Array,
       Status      => Call_Status); 

   exception

      when CALL_FAILURE =>
        Status := Call_Status;

      when LIST_IS_NULL => NULL; -- LIST_IS_NULL returns a status of SUCCESS

      when OTHERS       =>
        Status := Get_Status;
      
   end Sort_Distance;
    
end Generic_Sort_List_By_Distance; 
