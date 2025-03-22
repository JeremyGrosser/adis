--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Issue_Emission_PDU
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  16 May 94
--
-- PURPOSE :
--   - The IEPDU CSU generates an Emission PDU which it then passes to the DG
--     CSCI.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DG_Client, DG_Status, DIS_Types,
--     DL_Linked_List_Types, DL_Status, Errors, Numeric_Types, OS_Data_Types,
--     OS_GUI, OS_Hash_Table_Support, OS_Status, and PDU_Operators.
--   - The Number_of_Systems and the Number_of_Beams_per_System have been set
--     to one each.  Number_of_Beams_per_System would be better defined as an
--     array if multiple systems are implemented with a varying number of beams
--     per system per emitter.
--   - Beam ID is defaulted to one since only one beam per system is allowed at
--     this time.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with DG_Client,
     DG_Status,
     DL_Status,
     Errors,
     OS_Data_Types,
     OS_GUI,
     OS_Hash_Table_Support,
     PDU_Operators;

separate (Gateway_Interface)

procedure Issue_Emission_PDU(
   Hashing_Index        :  in     INTEGER;
   Illuminated_Entities :  in     DL_Linked_List_Types.Entity_State_List.PTR;
   Status               :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Number_of_Targets :  Numeric_Types.UNSIGNED_8_BIT;
   Returned_Status   :  OS_Status.STATUS_TYPE;
   Size              :  NATURAL;
   Status_DL         :  DL_Status.STATUS_TYPE;

   -- Local exceptions
   DL_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DL_Status.STATUS_TYPE)
     return BOOLEAN
     renames DL_Status."=";

-- Number_of_Beams_Block:
begin -- Number_of_Beams_Block

   -- Determine number of illuminated entities
   DL_Linked_List_Types.Entity_State_List_Utilities.Get_Size(
     The_List => Illuminated_Entities,
     Size     => Size,
     Status   => Status_DL);
   if Status_DL /= DL_Status.SUCCESS then
      Returned_Status := OS_Status.DL_ERROR;
      raise DL_ERROR;
   else
      Number_of_Targets := Numeric_Types.UNSIGNED_8_BIT(Size);
   end if;

   Issue_Emission_PDU_Block:
   declare
 
      -- Local variables
      K_Beam_Data_Length_in_Bytes  :  constant Numeric_Types.UNSIGNED_8_BIT
                                   := 52;
      K_Target_Data_Length_in_Bits :  constant Numeric_Types.UNSIGNED_8_BIT
                                   := 64;

      Beam_Data                  :  DIS_Types.A_BEAM_DATA_RECORD(
                                    Number_Of_Targets => Number_of_Targets);
      Emission_PDU               :  DIS_PDU_Pointer_Types.EMISSION_PDU_PTR;
      First_ESPDU                :  DIS_PDU_Pointer_Types.ENTITY_STATE_PDU_PTR;
      High_Density_Track_Jam     :  Numeric_Types.UNSIGNED_8_BIT
                                 := 0; -- Enumeration not defined
      State_Update_Indicator     :  DIS_Types.A_STATE_UPDATE_INDICATOR
                                 := DIS_Types.STATE_UPDATE; -- Regular updates
      Status_DG                  :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;
      System                     :  PDU_Operators.AN_EMITTER_POINTER;
      Target_List                :  DL_Linked_List_Types.Entity_State_List.PTR;

      -- Rename functions
      function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
        return BOOLEAN
        renames DG_Status."=";
      function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
        return BOOLEAN
        renames Numeric_Types."=";
      function "+" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
        return Numeric_Types.UNSIGNED_8_BIT
        renames Numeric_Types."+";
      function "*" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
        return Numeric_Types.UNSIGNED_8_BIT
        renames Numeric_Types."*";
      function "/" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
        return Numeric_Types.UNSIGNED_8_BIT
        renames Numeric_Types."/";

      -- Rename variables
      Aerodynamic_Parameters :  OS_Data_Types.AERODYNAMIC_PARAMETERS_RECORD
        renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
        Aerodynamic_Parameters;
      Emitter_Parameters :  OS_Data_Types.EMITTER_PARAMETERS_RECORD
        renames OS_Hash_Table_Support.Munition_Hash_Table(Hashing_Index).
        Emitter_Parameters;

   begin -- Issue_Emission_PDU_Block

      -- Initialize Status
      Status := OS_Status.SUCCESS;

      -- Generate PDU
      Emission_PDU := new DIS_Types.AN_EMISSION_PDU(0);
      Emission_PDU.PDU_Header.Protocol_Version
        := OS_GUI.Interface.Simulation_Parameters.Protocol_Version;
      Emission_PDU.PDU_Header.Exercise_ID
        := OS_GUI.Interface.Simulation_Parameters.Exercise_ID;
      Emission_PDU.PDU_Header.PDU_Type    := DIS_Types.EMISSION;
      Emission_PDU.PDU_Header.Length
        := Numeric_Types.UNSIGNED_16_BIT((Emission_PDU.All'SIZE + 7) / 8);
      Emission_PDU.PDU_Header.Padding     := (OTHERS => 0);
      Emission_PDU.Emitting_Entity_ID     := OS_Hash_Table_Support.
        Munition_Hash_Table(Hashing_Index).Network_Parameters.Entity_ID;
      Emission_PDU.Event_ID               := OS_Hash_Table_Support.
        Munition_Hash_Table(Hashing_Index).Network_Parameters.Event_ID;
      Emission_PDU.State_Update_Indicator := State_Update_Indicator;
      -- Number of systems and number of beams are set to zero because they are
      -- updated when the actual system and beam are added
      Emission_PDU.Number_of_Systems := 0;
      System := new DIS_Types.AN_EMITTER_SYSTEM_DATA_HEADER(0);
      System.Number_Of_Beams := 0;
      System.Padding         := 0;
      System.Emitter_System  := Emitter_Parameters.Emitter_System;
      System.Location        := Emitter_Parameters.Location;

      -- Beam ID is set to one since each system is only set to allow one beam
      Beam_Data.Beam_ID_Number := Emitter_Parameters.Beam_Data.Beam_ID_Number;
      Beam_Data.Beam_Parameter_Index
        := Emitter_Parameters.Beam_Data.Beam_Parameter_Index;
      Beam_Data.Fundamental_Parameter_Data.Frequency
        := Emitter_Parameters.Fundamental_Parameter_Data.Frequency;
      Beam_Data.Fundamental_Parameter_Data.Frequency_Range
        := Emitter_Parameters.Fundamental_Parameter_Data.Frequency_Range;
      Beam_Data.Fundamental_Parameter_Data.ERP
        := Emitter_Parameters.Fundamental_Parameter_Data.ERP;
      Beam_Data.Fundamental_Parameter_Data.PRF
        := Emitter_Parameters.Fundamental_Parameter_Data.PRF;
      Beam_Data.Fundamental_Parameter_Data.Pulse_Width
        := Emitter_Parameters.Fundamental_Parameter_Data.Pulse_Width;
      Beam_Data.Fundamental_Parameter_Data.Beam_Azimuth_Center
        := Emitter_Parameters.Fundamental_Parameter_Data.Beam_Azimuth_Center;
      Beam_Data.Fundamental_Parameter_Data.Beam_Azimuth_Sweep
        := OS_Data_Types.K_Degrees_to_Radians
         * Aerodynamic_Parameters.Azimuth_Detection_Angle;
      Beam_Data.Fundamental_Parameter_Data.Beam_Elevation_Center
        := Emitter_Parameters.Fundamental_Parameter_Data.Beam_Elevation_Center;
      Beam_Data.Fundamental_Parameter_Data.Beam_Elevation_Sweep
        := OS_Data_Types.K_Degrees_to_Radians
         * Aerodynamic_Parameters.Elevation_Detection_Angle;
      Beam_Data.Fundamental_Parameter_Data.Beam_Sweep_Sync
        := Emitter_Parameters.Fundamental_Parameter_Data.Beam_Sweep_Sync;
      Beam_Data.Beam_Function := Emitter_Parameters.Beam_Data.Beam_Function;
      Beam_Data.High_Density_Track_Jam := Emitter_Parameters.Beam_Data.
        High_Density_Track_Jam;
      Beam_Data.Padding                := 0;
      Beam_Data.Jamming_Mode_Sequence  := Emitter_Parameters.Beam_Data.
        Jamming_Mode_Sequence;
      -- Need beam data length in 32-bit words
      Beam_Data.Beam_Data_Length := K_Beam_Data_Length_in_Bytes / 4
        + ((Number_of_Targets * K_Target_Data_Length_in_Bits) / 32);

      Target_List := Illuminated_Entities;
      if Number_of_Targets /= 0 then
         for Target_Index in 1 .. Number_of_Targets loop 

            -- Access the first item on the list
            DL_Linked_List_Types.Entity_State_List_Utilities.Get_Item(
              The_List => Target_List,
              The_Item => First_ESPDU,
              Status   => Status_DL);
            if Status_DL /= DL_Status.SUCCESS then
               Returned_Status := OS_Status.DL_ERROR;
               raise DL_ERROR;
            end if;

            Beam_Data.Track_Jam(Target_Index).Entity_ID := First_ESPDU.
              Entity_ID;

            -- Move to the next item on the list (this procedure eliminates
            -- preceding items)
            DL_Linked_List_Types.Entity_State_List_Utilities.Get_Next(
              The_List => Target_List,
              Next     => Target_List,
              Status   => Status_DL);
            if Status_DL /= DL_Status.SUCCESS then
               Returned_Status := OS_Status.DL_ERROR;
               raise DL_ERROR;
            end if;

         end loop;
      end if;

      -- Add system to emitter
      PDU_Operators.Add_Emitter_To_Emission(
        Emission => Emission_PDU,
        System   => System,
        Status   => Status_DL);

      if Status_DL /= DL_Status.SUCCESS then
         Returned_Status := OS_Status.DL_ERROR;
         raise DL_ERROR;
      end if;

      PDU_Operators.Add_Beam_To_Emitter(
        Emission => Emission_PDU,
        System   => System.Emitter_System,
        Beam     => Beam_Data,
        Status   => Status_DL);
      if Status_DL /= DL_Status.SUCCESS then
        Returned_Status := OS_Status.DL_ERROR;
        raise DL_ERROR;
      end if;

      -- Send PDU to DIS Gateway
--      DG_Client.Send_PDU(
--        PDU_Address => Emission_PDU.All'ADDRESS,
--        Status      => Status_DG);

      DG_Client.Set_Emission_Info(
        Emission_Info => Emission_PDU.All,
        Status        => Status_DG);

      -- In case of error in DG, the error will be logged but no additional
      -- action will be taken
      if Status_DG /= DG_Status.SUCCESS then
         Returned_Status := OS_Status.DG_ERROR;
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

   end Issue_Emission_PDU_Block;

exception
   when DL_ERROR =>
     -- Report error
     Errors.Report_Error(
       Detonated_Prematurely => FALSE,
       Error                 => Returned_Status);
   when OTHERS =>
     Status := OS_Status.IEPDU_ERROR;

end Issue_Emission_PDU;
