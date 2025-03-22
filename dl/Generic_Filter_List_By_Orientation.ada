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
-- Package Name:       Generic_Filter_List_By_Orientation
--
-- File Name:          Generic_Filter_List_By_Orientation.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 13, 1994
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

package body Generic_Filter_List_By_Orientation is

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   --==========================================================================
   -- FILTER_LIST_BY_ORIENTATION
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist of entity or event PDUs that meet the specified 
   --   orientation (azimuth or elevation) threshold.
   --
   -- Implementation:
   --   
   --    Loop through the list and get the geocentric location of the entity or
   --    event.  Call Filter.Azimuth or Filter.Elevation (an instaniation of 
   --    Orientation) to determine if the entity or event is within the input
   --    threshold.  If it is not within the threshold, delete the PDU from
   --    the list.
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
   procedure Filter_Orientation(
      The_List                   : in out PTR;
      Threshold_1                : in     Numeric_Types.FLOAT_32_BIT;
      Threshold_2                : in     Numeric_Types.FLOAT_32_BIT;   
      Reference_Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status                     :    out DL_Status.STATUS_TYPE) is
      
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

         Orientation(
          Angle_1              => Threshold_1,
          Angle_2              => Threshold_2,
          Entity_State_PDU     => Reference_Entity_State_PDU,
          Position_Of_Interest => PDU_Location(PDU),
          Status               => Call_Status,
          Within_Threshold     => Keep_PDU); 
 
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

   end Filter_Orientation;

end Generic_Filter_List_By_Orientation;
