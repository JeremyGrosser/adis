--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Fly_Out_Model
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
package body Fly_Out_Model is

   procedure Instantiate_Fly_Out_Model(
      Entity_Type      :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
      Fly_Out_Model_ID :  in     OS_Data_Types.FLY_OUT_MODEL_IDENTIFIER;
      Hashing_Index    :  in     INTEGER;
      Status           :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Move_Munition(
      Hashing_Index        :  in     INTEGER;
      Illuminated_Entities :  in     DL_Linked_List_Types.
                                     Entity_State_List.PTR;
      Status               :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure DRA_FPW_Fly_Out_Model(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Generic_Fly_Out_Model(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Kinematic_Fly_Out_Model(
      Hashing_Index :  in     INTEGER;
      Status        :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Beam_Rider_Guidance(
      Hashing_Index      :  in     INTEGER;
      Required_Azimuth   :     out OS_Data_Types.RADIANS;
      Required_Elevation :     out OS_Data_Types.RADIANS;
      Status             :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Collision_Guidance(
      Hashing_Index      :  in     INTEGER;
      Required_Azimuth   :     out OS_Data_Types.RADIANS;
      Required_Elevation :     out OS_Data_Types.RADIANS;
      Status             :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Pursuit_Guidance(
      Hashing_Index      :  in     INTEGER;
      Required_Azimuth   :     out OS_Data_Types.RADIANS;
      Required_Elevation :     out OS_Data_Types.RADIANS;
      Status             :     out OS_Status.STATUS_TYPE)
     is separate;

end Fly_Out_Model;
