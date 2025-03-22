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
-- Unit Name:          Smooth_Entity
--
-- File Name:          SPU__Smooth_Entity.ada
--
-- Project             Ada Distributed Interactive Simulation (ADIS)
--                     DIS Library (DL)
--
-- Author:             Charlotte Mildren
--                     J.F. Taylor, Inc.
--
-- Origination Date:   July 25, 1994
--
-- Purpose:
--
--   Dead-reckons the entity and provides filters for adjusting new Entity_State
--   PDU updates which conflict with the dead-reckoned data.  At least one of the
--   filters has to be used.  If no filtering is wanted the Dead-Reckoning unit
--   should be called instead of this unit.
--
--   This unit calls the designated filter to either dead-reckon the 
--   input data or to compensates for time discrepanies and network 
--   anomalies by adjusting the data.
--
--   NOTE:
--   All filters are written with the assumption that the entity is being 
--   dead-reckoned using the Smooth_Entity unit and this unit is called every 
--   timeslice.  If no flags are set, a Status of DL_Status.NO_FLAGS_SET will 
--   be returned and the data will not be updated.
--
-- Implementation:
--
--   Get the last position output from its storage and then calls the appropriate
--   routine to smooth/dead-reckon the entity's position.
--
--   If the entity is not in the table it is assumed to be the first reciept of 
--   the entity's position data, the input data is stored in the table and the 
--   position dead-reckoned.
--
--
-- Exceptions:
--   None.
--
-- Portability Issues:
--   None.
--
-- Anticipated Changes:
--   None.
--
-- Effects:
--   None
--=============================================================================	
with Dead_Reckoning;

separate(Smooth_Position_Update)

procedure Smooth_Entity(
   Entity_State_PDU        : in out DIS_Types.AN_ENTITY_STATE_PDU;
   Elapsed_Time            : in     INTEGER;
   Alpha_Beta_Coefficient  : in     DL_Math.PERCENT := 0.0;
   Rate_Limiter_Tolerance  : in     DL_Math.PERCENT := 0.0;
   Rate_Smoother_Tolerance : in     DL_Math.PERCENT := 0.0;
   Use_Alpha_Beta          : in     BOOLEAN := FALSE;
   Use_Rate_Limiter        : in     BOOLEAN := FALSE; 
   Use_Rate_Smoother       : in     BOOLEAN := FALSE;
   Status                  :    out DL_Status.STATUS_TYPE) is

   --
   -- Declare local variables
   --

   Call_Status          : DL_Status.STATUS_TYPE;

   Stored_Position_Data : Hashing.ENTITY_STATE_INFO_PTR;

   -- Define an exception to allow for exiting if the called routine fails.
   CALL_FAILURE : EXCEPTION;

begin

   Status := DL_Status.SUCCESS;
  
   -- Get the last position information
   Hashing.Get_Item(
     Entity_ID         => Entity_State_PDU.Entity_ID,
     Entity_State_Data => Stored_Position_Data,
     Status            => Call_Status);
      
   if Call_Status = DL_Status.ITEM_NOT_FOUND then
   
      -- First position, so add to the table.
      Hashing.Add_Item(
        Entity_State_PDU => Entity_State_PDU,
        Status           => Call_Status);

      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;

     -- Dead_Reckon this position.
     Dead_Reckoning.Update_Position(
        Entity_State_PDU => Entity_State_PDU,
        Delta_Time       => Elapsed_Time,
        Status           => Call_Status);
  
      if Call_Status /= DL_Status.SUCCESS then
         raise CALL_FAILURE;
      end if;  

   else

      if Use_Alpha_Beta then

         -- Dampen the effects of rapid changes in velocity and position.
         Alpha_Beta_Filter(
           Entity_State_PDU   => Entity_State_PDU,
           Last_Location_Data => Stored_Position_Data,
           Beta               => Alpha_Beta_Coefficient,
           Delta_Time         => Elapsed_Time,
           Status             => Call_Status);

         if Call_Status /= DL_Status.SUCCESS then
            raise CALL_FAILURE;
         end if;

      elsif Use_Rate_Limiter then
  
         -- Limit change in velocity and position to a percentage of the 
         -- difference between the new and predicted positions.
         Rate_Limiter(
           Entity_State_PDU   => Entity_State_PDU,
           Last_Location_Data => Stored_Position_Data, 
           Delta_Time         => Elapsed_Time,         
           Fudge_Factor       => Rate_Limiter_Tolerance,
           Status             => Call_Status);
  
        if Call_Status /= DL_Status.SUCCESS then
           raise CALL_FAILURE;
        end if;

     elsif Use_Rate_Smoother then
  
        -- Incrementally limit change in velocity and position to a 
        -- an offset calcuated from the difference between new and predicted
        -- position the percentage
        Rate_Change_Smoother(
          Entity_State_PDU   => Entity_State_PDU,
          Last_Location_Data => Stored_Position_Data,
          Delta_Time         => Elapsed_Time,
          Tolerance          => Rate_Smoother_Tolerance,
          Status             => Call_Status);

        if Call_Status /= DL_Status.SUCCESS then
           raise CALL_FAILURE;
        end if; 

     else

      -- unit called with either no flag set.
      Status := DL_Status.NO_FLAGS_SET;

     end if; -- Use_Alpha_Beta_Filter

   end if; -- Not found in table

exception

   when CALL_FAILURE => 
      Status    := Call_Status;
   
   when OTHERS       => 
      Status    := DL_Status.SMOOTH_ENTITY_FAILURE;
      
end Smooth_Entity;
