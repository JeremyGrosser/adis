--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Munition (spec)
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
with DIS_Types,
     OS_Data_Types,
     OS_Status;

package Munition is

   -- Variables global to this package
   Top_of_Entity_Data_List_Pointer :  OS_Data_Types.
                                      USER_SUPPLIED_DATA_RECORD_PTR;

   procedure Instantiate_Munition(
      Entity_Type   : in     DIS_Types.AN_ENTITY_TYPE_RECORD;
      Hashing_Index : in     INTEGER;
      Status        :    out OS_Status.STATUS_TYPE);

   procedure Add_Related_Entity_Data(
      General_Parameters : in     OS_Data_Types.GENERAL_PARAMETERS_RECORD;
      Status             :    out OS_Status.STATUS_TYPE);

   procedure Find_Related_Entity_Data(
      Entity_Type        :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
      General_Parameters :     out OS_Data_Types.GENERAL_PARAMETERS_RECORD_PTR;
      Status             :     out OS_Status.STATUS_TYPE);

   procedure Update_GUI_Display(
      Status : out OS_Status.STATUS_TYPE);

   procedure Update_Munition(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE);

end Munition;
