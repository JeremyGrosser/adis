--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Munition
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  11 May 94
--
-- PURPOSE :
--
-- EFFECTS :
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
package body Munition is

   Current_Display_Entry : OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR;

   procedure Instantiate_Munition(
      Entity_Type   : in     DIS_Types.AN_ENTITY_TYPE_RECORD;
      Hashing_Index : in     INTEGER;
      Status        :    out OS_Status.STATUS_TYPE)
     is separate;

   procedure Add_Related_Entity_Data(
      General_Parameters : in     OS_Data_Types.GENERAL_PARAMETERS_RECORD;
      Status             :    out OS_Status.STATUS_TYPE)
     is separate;

   procedure Find_Related_Entity_Data(
      Entity_Type        :  in    DIS_Types.AN_ENTITY_TYPE_RECORD;
      General_Parameters :     out OS_Data_Types.GENERAL_PARAMETERS_RECORD_PTR;
      Status             :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Update_GUI_Display(
      Status : out OS_Status.STATUS_TYPE)
     is separate;

   procedure Update_Munition(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

end Munition;
