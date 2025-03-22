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
-- Package Name:       Generic_Filter_List_By_Distance
--
-- File Name:          Generic_Filter_List_By_Distance.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 12, 1994
--
-- Purpose:
--
--   Contains routines to evaluate each PDU in a list and remove those PDUs
--   which do not meet a specified criteria.
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
--=============================================================================	
with Filter;
     

package body Generic_Filter_List_By_Distance is

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   --==========================================================================
   -- FILTER_DISTANCE
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist of entity or event PDUs that meet the specified 
   --   distance threshold.
   --
   -- Implementation:
   --
   --    Loop through the list and get the geocentric location of the entity or
   --    event.  Call Filter.Distance to determine if the entity or event is
   --    within the input threshold.  If it is not within the threshold, delete
   --    the PDU from the list.
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
   --   None.
   --==========================================================================
   procedure Filter_Distance(
      The_List           : in out PTR;
      Reference_Position : in     DIS_TYPES.A_WORLD_COORDINATE;  
      Threshold          : in     Numeric_Types.FLOAT_64_BIT;
      Status             :    out DL_Status.STATUS_TYPE) is
      
      --
      -- Declare local variables
      --
      
      Call_Status  : DL_Status.STATUS_TYPE;
      Keep_PDU     : BOOLEAN;
      PDU          : ITEM;
      Temp_List    : PTR := The_List;

      --
      -- Declare local exception
      --
      CALL_FAILURE : EXCEPTION;

   begin

     Status := DL_Status.SUCCESS;

     while not Is_Null(Temp_List) loop

        -- Get the pointer to the PDU record.
        PDU := Value_Of(Temp_List);

        Filter.Distance(
          Position_1       => Reference_Position,
          Position_2       => PDU_Location(PDU),
          Threshold        => Threshold, 
          Status           => Call_Status,
          Within_Threshold => Keep_PDU);

        -- Get next node.
        Temp_List := Tail_Of(Temp_List);

        if not Keep_PDU then

           -- Delete from the list.
           Delete_Item_And_Free_Storage(
             The_List    => The_List,
             At_Position => Position_Of(PDU, The_List),
             Status      => Call_Status);

           if Call_Status /= DL_Status.SUCCESS then
              raise CALL_FAILURE;
           end if;   

         end if;

      end loop;
     
   exception

      when CALL_FAILURE     =>
        Status := Call_Status;

      when OTHERS           =>
        Status := Get_Status;

   end Filter_Distance;

end Generic_Filter_List_By_Distance;
