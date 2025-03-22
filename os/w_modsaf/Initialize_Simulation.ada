--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Initialize_Simulation
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  25 August 94
--
-- PURPOSE :
--   - The IS sets up the hash table and GUI interface at the beginning of a
--     simulation.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Errors, OS_CTDB_Types, OS_GUI,
--     OS_Hash_Table_Support, OS_Simulation_Types and OS_Simulation_Types.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with C_Strings,
     Errors,
     OS_Configuration_Files,
     OS_CTDB_Types,
     OS_GUI,
     OS_Hash_Table_Support,
     OS_Simulation_Types,
     OS_Start_GUI,
     OS_Status,
     Terrain_Database_Interface;

procedure Initialize_Simulation(
   Status :  out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Returned_Status :  OS_Status.STATUS_TYPE;

   -- Local exceptions
   MI_ERROR :  exception;

   -- Rename functions
   function "=" (LEFT, RIGHT :  OS_Status.STATUS_TYPE)
     return BOOLEAN
     renames OS_Status."=";

begin -- Initialize_Simulation

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   -- Map memory
   OS_GUI.Map_Interface(
     Create_Interface => TRUE,
     Status           => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      raise MI_ERROR;
   end if;

  OS_Configuration_Files.Load_Configuration_File(
     Filename => "OS.Config",
     Status   => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if;

   OS_Start_GUI(
     GUI_Filename => "../gui/XOS",
     Status      => Returned_Status);
   if Returned_Status /= OS_Status.SUCCESS then
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);
   end if;

   -- Initialize munition hash table
   OS_Hash_Table_Support.Munition_Hash_Table
     := new OS_Hash_Table_Support.HASH_TABLE_ARRAY_TYPE(
        1..OS_GUI.Interface.Simulation_Parameters.Hash_Table_Size);

   -- Initialize pointer to ModSAF database
   OS_CTDB_Types.CTDB_Pointer := new OS_CTDB_Types.CTDB_STRUCTURE;
   Terrain_Database_Interface.CTDB_Read(
     Database_Filename => C_strings.convert_string_to_c(
                          OS_GUI.Interface.Simulation_Parameters.
                          ModSAF_Database_Filename),
     CTDB              => OS_CTDB_Types.CTDB_Pointer,
     Memory_Limit      => OS_GUI.Interface.Simulation_Parameters.
                          Memory_Limit_for_ModSAF_File);

exception
   when MI_ERROR =>
      Status := Returned_Status;
      -- Report error
      Errors.Report_Error(
        Detonated_Prematurely => FALSE,
        Error                 => Returned_Status);

   when OTHERS =>
      Status := OS_Status.IS_ERROR;

end Initialize_Simulation;
