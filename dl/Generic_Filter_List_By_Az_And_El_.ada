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
-- File Name:          Generic_Filter_List_By_Az_And_El_.ada
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

with DL_Status,
     DIS_Types,
     Numeric_Types;

generic

   -- Import the generic data types needed from the Generic_List package. 
   type ITEM is private;
   type PTR is private;

   -- Import function to set the status for the correct instantiated unit.
   with function Get_Status return DL_Status.STATUS_TYPE;

   -- Import unit to get the location from the PDU.
   with function PDU_Location(
           PDU: in ITEM) 
          return DIS_Types.A_WORLD_COORDINATE;

   -- Import units from the Generic_List_Utilities Package 
   with procedure Delete_Item_And_Free_Storage(
           The_List    : in out PTR;
           At_Position : in     POSITIVE := 1;
           Status      :    out DL_Status.STATUS_TYPE);

   with function Position_Of(
           The_Item : in ITEM;
           The_List : in PTR)
          return Positive;

   -- Import units from Generic_List package.
   with function Is_Null(
           The_List    : in     PTR ) 
          return BOOLEAN;

   with function Tail_Of(
          The_List : in PTR )
         return PTR;

   with function Value_Of(
           The_List : in PTR ) 
          return ITEM;

package Generic_Filter_List_By_Az_And_El is

   --==========================================================================
   -- FILTER_AZ_AND_EL
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist of entity or event PDUs that meet both the specified
   --   azimuth and elevation thresholds.
   --
   --   In/Out Parameters: 
   --  
   --     The_List - A pointer to a list of entity or event PDUs which will be 
   --                evaluated with respect to the Reference_Entity_State_PDU.
   --
   --   Input Parameters:
   --
   --     First_Az_Threshold  - Specifies the first angle (in degrees) in the
   --                            azimuth threshold range.
   --
   --     Second_Az_Threshold - Specifies the second angle (in degrees) in the 
   --                            azimuth threshold range. 
   --     
   --     First_El_Threshold  - Specifies the first angle (in degrees) in the
   --                            elevation threshold range.
   --
   --     Second_El_Threshold - Specifies the second angle (in degrees) in the 
   --                            elevation threshold range. 
   --
   --     Reference_Entity_State_PDU - Describes the reference entity or event 
   --                                  and its  geocentric position in meters.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition. 
   --                One of the following status values will be returned:
   --
   --                DL_Status.SUCCESS - Indicates the unit executed successfully.
   --
   --                Other - The error code for the instantiated unit will be 
   --                returned if this unit enconters an error.  If an error 
   --                occurs in a call to a  sub-routine, the procedure will
   --                terminate and the status (error code) for the failed 
   --                routine will be returned.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
   procedure Filter_Az_And_El(
      The_List                   : in out PTR;
      First_Az_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_Az_Threshold        : in     Numeric_Types.FLOAT_32_BIT;   
      First_El_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_El_Threshold        : in     Numeric_Types.FLOAT_32_BIT;  
      Reference_Entity_State_PDU : in     DIS_Types.AN_ENTITY_STATE_PDU;
      Status                     :    out DL_Status.STATUS_TYPE);

   --==========================================================================
   -- FILTER_AZ_AND_EL
   --==========================================================================
   --
   -- Purpose
   --
   --   Returns a sublist of entity or event PDUs that meet both the specified
   --   azimuth and elevation thresholds.
   --
   --   In/Out Parameters: 
   --  
   --     The_List - A pointer to a list of entity or event PDUs.
   --
   --   Input Parameters:
   --
   --     First_Az_Threshold  - Specifies the first angle (in degrees) in the
   --                            azimuth threshold range.
   --
   --     Second_Az_Threshold - Specifies the second angle (in degrees) in the 
   --                            azimuth threshold range. 
   --     
   --     First_El_Threshold  - Specifies the first angle (in degrees) in the
   --                            elevation threshold range.
   --
   --     Second_El_Threshold - Specifies the second angle (in degrees) in the 
   --                            elevation threshold range. 
   --
   --     Location -  Entity's geocentric position in meters.
   --
   --     Orientation -  Entity's orientation as defined by Euler Angles.
   --
   --    Output Parameters:
   --
   --      Status - Indicates whether this unit encountered an error condition.
   --               If no error is encountered, a value of DL_Status.SUCCESS 
   --               will be returned.
   --
   -- Exceptions:
   --   None.
   --			 		
   --==========================================================================
  procedure Filter_Az_And_El(
      The_List                   : in out PTR;
      First_Az_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_Az_Threshold        : in     Numeric_Types.FLOAT_32_BIT;   
      First_El_Threshold         : in     Numeric_Types.FLOAT_32_BIT;
      Second_El_Threshold        : in     Numeric_Types.FLOAT_32_BIT;
      Location                   : in     DIS_Types.A_WORLD_COORDINATE;
      Orientation                : in     DIS_Types.AN_EULER_ANGLES_RECORD;  
      Status                     :    out DL_Status.STATUS_TYPE);

end Generic_Filter_List_By_Az_And_El;
