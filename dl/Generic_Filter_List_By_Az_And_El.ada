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
-- Package Name:       Generic_Filter_List_By_Az_And_El
--
-- File Name:          Generic_Filter_List_By_Az_And_El.ada
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
with Filter,
     Filter_By_PDU_Components;

package body Generic_Filter_List_By_Az_And_El is

   --
   -- Import function to improve code readability.
   --
   function "="(Left, Right : DL_Status.STATUS_TYPE) 
     return BOOLEAN
     renames DL_Status."=";

   --==========================================================================
   -- FILTER_AZ_AND_EL
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist of entity or event PDUs that meets both the specified
   --   azimuth and elevation thresholds.
   --
   -- Implementation:
   --
   --    Loop through the list and get the geocentric location of the entity 
   --    or event.  Call Filter.Az_And_El to determine if the entity or event is 
   --    within the input threshold.  If either the azimuth or elevation
   --    exceeds the threshold, delete the PDU from the list. 
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
   procedure Filter_Az_And_El(
      The_List                   : in out PTR;
      First_Az_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_Az_Threshold        : in     Numeric_Types.FLOAT_32_BIT;   
      First_El_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_El_Threshold        : in     Numeric_Types.FLOAT_32_BIT;  
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

        PDU := Value_Of(Temp_List);

        Filter.Az_And_El(
          Az_Angle_1           => First_Az_Threshold,
          Az_Angle_2           => Second_Az_Threshold, 
          El_Angle_1           => First_El_Threshold,
          El_Angle_2           => Second_El_Threshold,
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
             At_Position => Position_Of(PDU,The_List),
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

   end Filter_Az_And_El;

   --==========================================================================
   -- FILTER_AZ_AND_EL
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist of entity or event PDUs that meets both the specified
   --   azimuth and elevation thresholds.
   --
   -- Implementation:
   --
   --    Loop through the list and get the geocentric location of the entity 
   --    or event.  Call Filter.Az_And_El to determine if the entity or event is 
   --    within the input threshold.  If either the azimuth or elevation
   --    exceeds the threshold, delete the PDU from the list. 
   --	
   --   The following status values may be returned:
   --
   --     DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --     Other - The error code for the instantiated unit will be returned if 
   --       this unit enconters an error.  If an error occurs in a call to a 
   --       sub-routine, the procedure will terminate and the status (error code)
   --       for the failed routine will be returned.	
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
   procedure Filter_Az_And_El(
      The_List                   : in out PTR;
      First_Az_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_Az_Threshold        : in     Numeric_Types.FLOAT_32_BIT;   
      First_El_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_El_Threshold        : in     Numeric_Types.FLOAT_32_BIT;  
      Location                   : in     DIS_Types.A_WORLD_COORDINATE;
      Orientation                : in     DIS_Types.AN_EULER_ANGLES_RECORD;  
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

        Filter_By_PDU_Components.Az_And_El(
          Az_Angle_1           => First_Az_Threshold,
          Az_Angle_2           => Second_Az_Threshold, 
          El_Angle_1           => First_El_Threshold,
          El_Angle_2           => Second_El_Threshold,
          Location             => Location,
          Orientation          => Orientation,
          Position_Of_Interest => PDU_Location(PDU),
          Status               => Call_Status, 
          Within_Threshold     => Keep_PDU);

        -- Get next node.
        Temp_List := Tail_Of(Temp_List);

        if not Keep_PDU then

           -- Delete from the list.
           Delete_Item_And_Free_Storage(
             The_List    => The_List,
             At_Position => Position_Of(PDU,The_List),
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

   end Filter_Az_And_El;

end Generic_Filter_List_By_Az_And_El;
