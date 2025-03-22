--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      OS_GUI
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Brett Dufault, Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  24 August 94
--
-- PURPOSE :
--
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with A_Strings,
     Calendar,
     DG_Shared_Memory,
     DG_Status,
     DIS_Types,
     Errors,
     PDU_Operators,
     U_Env,
     Unchecked_Conversion,
     Unix;

package body OS_GUI is

   -- Instantiate shared memory mapping package for use with the Server/GUI
   -- interface.  Define a pointer for the shared memory area.
   package Shared_Memory is
     new DG_Shared_Memory(OS_GUI_INTERFACE_RECORD);

   Shared_Memory_Ptr : Shared_Memory.SHARED_MEMORY_PTR_TYPE;

   -- Instantiate conversion between shared memory pointer type and the
   -- package specification's pointer type.
   function Convert_Ptr is
     new Unchecked_Conversion(
           Shared_Memory.SHARED_MEMORY_PTR_TYPE,
           OS_GUI_INTERFACE_POINTER);

   function "=" (LEFT, RIGHT :  DG_Status.STATUS_TYPE)
     return BOOLEAN
     renames DG_Status."=";

   ---------------------------------------------------------------------------
   -- Map_Interface
   ---------------------------------------------------------------------------
   procedure Map_Interface(
      Create_Interface : in     BOOLEAN;
      Status           :    out OS_Status.STATUS_TYPE)
     is

      -- Local variables
      Env_Value       :  A_Strings.A_STRING;
      Key_Value       :  INTEGER;
      Returned_Status :  OS_Status.STATUS_TYPE;
      Status_DG       :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

      -- Local exceptions
      DG_ERROR  :  exception;

   begin  -- Map_Interface

      -- Initialize status
      Status := OS_Status.SUCCESS;

      if Create_Interface then
         -- Create a new interface, using the Ordnance Server's process
         -- ID as the key.
         Shared_Memory.Map_Memory(
           Mem_Key => Unix.GetPID,
           Create  => TRUE,
           Mem_Ptr => Shared_Memory_Ptr,
           Status  => Status_DG);

         if Status_DG /= DG_Status.SUCCESS then
            Returned_Status := OS_Status.DG_ERROR;
            raise DG_ERROR;
         end if;

      else
         -- Check environment for interface key value
         Env_Value
           := U_Env.GetEnv(Var_Name => A_Strings.To_A(K_OS_GUI_Env_Var));

         Key_Value := INTEGER'VALUE(Env_Value.S);

         -- Map the existing interface
         Shared_Memory.Map_Memory(
           Mem_Key => Key_Value,
           Create  => FALSE,
           Mem_Ptr => Shared_Memory_Ptr,
           Status  => Status_DG);

         if Status_DG /= DG_Status.SUCCESS then
            Returned_Status := OS_Status.DG_ERROR;
            raise DG_ERROR;
         end if;
      end if;

      -- Set the interface pointer in the package specification
      Interface := Convert_Ptr(Shared_Memory_Ptr);

      -- If the interface was just created, then the memory area will contain
      -- random values.  Therefore, critical fields are initialized to
      -- reasonable values.
      if Create_Interface then

         Interface.ALL := (
           Error_Parameters => (
             Display_Error => TRUE,
             Log_Error     => FALSE,
             Log_File      => (
               Length => 0,
               Name   => (OTHERS => ' ')),
             History => (OTHERS => (
               Occurrence_Count     => 0,
               Last_Occurrence_Time => Calendar.Clock)),
             Queue => (OTHERS => (
               Detonation_Flag => FALSE,
               Error           => OS_Status.SUCCESS,
               Occurrence_Time => Calendar.Clock)),
             Queue_Overflow    => FALSE,
             Read_Index        => 1,
             Write_Index       => 1),
           General_Parameters => (
             Aerodynamic_Parameters => (
               Burn_Rate                 => 0.0,
               Burn_Time                 => 0.0,
               Azimuth_Detection_Angle   => 5.0,
               Elevation_Detection_Angle => 5.0,
               Drag_Coefficients         => (OTHERS => 0.0),
               Frontal_Area              => 0.0,
               G_Gain                    => 0.0,
               Guidance                  => OS_Data_Types.COLLISION,
               Illumination_Flag         => OS_Data_Types.MUNITION,
               Initial_Mass              => 0.0,
               Laser_Code                => 0,
               Max_Gs                    => 0.0,
               Max_Speed                 => 0.0,
               Thrust                    => 0.0),
             Articulation_Parameters  => null,
             Capabilities             => (OTHERS => 0),
             Dead_Reckoning_Algorithm => DIS_Types.FPW,
             Emitter_Parameters => (
               Emitter_System => (
                 Emitter_Name     => DIS_Types.OTHER_EMITTER,
                 Emitter_Function => DIS_Types.OTHER_FUNCTION,
                 Emitter_ID       => 0),
               Location => (
                 X => 0.0,
                 Y => 0.0,
                 Z => 0.0),
               Fundamental_Parameter_Data => (
                 Frequency             => 0.0,
                 Frequency_Range       => 0.0,
                 ERP                   => 0.0,
                 PRF                   => 0.0,
                 Pulse_Width           => 0.0,
                 Beam_Azimuth_Center   => 0.0,
                 Beam_Elevation_Center => 0.0,
                 Beam_Sweep_Sync       => 0.0),
               Beam_Data => (
                 Beam_ID_Number         => 1,
                 Beam_Parameter_Index   => 0,
                 Beam_Function          => 0,
                 High_Density_Track_Jam => 0,
                 Jamming_Mode_Sequence  => 0)),
             Entity_Appearance => (
               General  => (
                 Paint       => DIS_Types.UNIFORM_COLOR,
                 Mobility    => DIS_Types.FULLY_MOBILE,
                 Fire_Power  => DIS_Types.FIRE_POWER_NORMAL,
                 Damage      => DIS_Types.NO_DAMAGE,
                 Smoke       => DIS_Types.NOT_SMOKING,
                 Trailing    => DIS_Types.NO_TRAILING,
                 Hatch       => DIS_Types.HATCH_NA,
                 Lights      => DIS_Types.NO_LIGHTS,
                 Flaming     => DIS_Types.NO_FLAMES),
               Specific => 0),
             Entity_Marking    => (
               Character_Set => DIS_Types.ASCII,
               Text          => PDU_Operators.As_Marking(" ADIS OS  ")),
             Entity_Type => (
               Entity_Kind => DIS_Types.MUNITION,
               Domain      => 0,
               Country     => DIS_Types.UNITED_STATES,
               Category    => 0,
               Subcategory => 0,
               Specific    => 0,
               Extra       => 0),
             Alternate_Entity_Type => ( 
               Entity_Kind => DIS_Types.MUNITION,
               Domain      => 0,
               Country     => DIS_Types.UNITED_STATES,
               Category    => 0,
               Subcategory => 0,
               Specific    => 0,
               Extra       => 0),
             Fly_Out_Model_ID => OS_Data_Types.FOM_KINEMATIC,
             Termination_Parameters => (
               Current_Range => 0.0,
               Detonation_Proximity_Distance => 0.0,
               Fuze                          => DIS_Types.CONTACT,
               Hard_Kill                     => 0.0,
               Height_Relative_To_Sea_Level_To_Detonate => 0.0,
               Max_Range          => 0.0,
               Previous_Range     => 0.0,
               Range_To_Damage    => 0.0,
               Time_To_Detonation => 0.0,
               Warhead            => DIS_Types.HIGH_EXPLOSIVE)),
           Simulation_Parameters => (
             Contact_Threshold => 0.0,
             Cycle_Time        => 0.0333,  -- 33.3 ms, or 30 Hz
             Database_Origin   => (
               Latitude  => 0.0,
               Longitude => 0.0,
               Altitude  => 0.0),
             Database_Origin_in_WorldC => (
               X => 0.0,
               Y => 0.0,
               Z => 0.0),
             Exercise_ID => 1,
             Hash_Table_Increment => 7,
             Hash_Table_Size      => 50,
             ModSAF_Database_Filename
               => "/usr/modsaf/common/terrain/itsec93-0101/itsec93-0101.ctdb"
                  & ASCII.NUL & "                      ",
             Memory_Limit_for_ModSAF_File => 0,
             Number_of_Loops_Until_Update => 1,
             Parent_Entity_ID => (
               Sim_Address => (
                 Site_ID        => 1,
                 Application_ID => 1),
               Entity_ID        => 1),
             Protocol_Version => 3,  -- 2.0 Third Draft
             Simulation_State => OS_Simulation_Types.FREEZE),
         Ordnance_Display => (
           Command     => NONE,
           Top_Of_List => TRUE,
           End_Of_List => TRUE),
         Configuration_File => (
           Length => 0,
           Name   => (OTHERS => ASCII.NUL)),
         Configuration_File_Command => OS_Data_Types.NONE);

      end if;

   exception
      when DG_ERROR =>
         Status := Returned_Status;
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);

      when OTHERS =>
         Status := OS_Status.MI_ERROR;
   end Map_Interface;

   ---------------------------------------------------------------------------
   -- Unmap_Interface
   ---------------------------------------------------------------------------
   procedure Unmap_Interface(
      Destroy_Interface : in     BOOLEAN;
      Status            :    out OS_Status.STATUS_TYPE)
     is

      -- Local variables
      Returned_Status :  OS_Status.STATUS_TYPE;
      Status_DG       :  DG_Status.STATUS_TYPE := DG_Status.SUCCESS;

      -- Local exceptions
      DG_ERROR :  exception;

   begin  -- Unmap_Interface

      -- Initialize status
      Status := OS_Status.SUCCESS;

      -- Release the shared memory from the process virtual memory space
      Shared_Memory.Unmap_Memory(
        Mem_Ptr => Shared_Memory_Ptr,
        Status  => Status_DG);

      if Status_DG = DG_Status.SUCCESS then
         if Destroy_Interface then
            -- Destroy the memory area used by the interface.
            Shared_Memory.Remove_Memory(
              Mem_Key => Unix.GetPID,
              Status  => Status_DG);
            if Status_DG /= DG_Status.SUCCESS then
               Returned_Status := OS_Status.DG_ERROR;
               -- Report error
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error                 => Returned_Status);
            end if;
         end if;  -- Destroy_Interface

      else
         Returned_Status := OS_Status.DG_ERROR;
         -- Report error
         Errors.Report_Error(
           Detonated_Prematurely => FALSE,
           Error                 => Returned_Status);
      end if;

   exception
      when OTHERS =>
         Status := OS_Status.UI_ERROR;
   end Unmap_Interface;

end OS_GUI;
------------------------------------------------------------------------------
-- MODIFICATION HISTORY:
--
-- 3 NOV 94 -- KJN:  Added initialization of Laser_Code to
--          Aerodynamic_Parameters.
