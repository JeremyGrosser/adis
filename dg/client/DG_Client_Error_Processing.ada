--
--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--
------------------------------------------------------------------------------
--
-- PACKAGE NAME     : DG_Client_Error_Processing
--
-- FILE NAME        : DG_Client_Error_Processing.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 12, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Generic_Error_Processing,
     DG_Client_GUI,
     Text_IO;

package body DG_Client_Error_Processing is

   ---------------------------------------------------------------------------
   -- Report_Error
   ---------------------------------------------------------------------------

   procedure Report_Error(
      Error : in DG_Status.STATUS_TYPE) is

   begin  -- Report_Error

      DG_Generic_Error_Processing.Report_Error(
        Error                      => Error,
        Error_Log_Enabled_Flag     => Error_Log_Enabled,
        Error_Monitor_Enabled_Flag => Error_Monitor_Enabled,
--        Error_Log_File             => Text_IO.Standard_Output,
        Error_Queue_Read_Index     => DG_Client_GUI.Interface.
                                        Error_Queue_Read_Index,
        Error_Queue_Write_Index    => DG_Client_GUI.Interface.
                                        Error_Queue_Write_Index,
        Error_Queue                => DG_Client_GUI.Interface.Error_Monitor.
                                        Error_Queue,
        Error_History              => DG_Client_GUI.Interface.Error_Monitor.
                                        Error_History);

   exception

      when OTHERS =>

         Text_IO.Put_Line(
           "Exception in DG_Client_Error_Processing.Report_Error");

   end Report_Error;

   ---------------------------------------------------------------------------
   -- Get_Error
   ---------------------------------------------------------------------------

   procedure Get_Error(
      Overflow      : out BOOLEAN;
      Error_Present : out BOOLEAN;
      Error_Entry   : out DG_Error_Processing_Types.ERROR_QUEUE_ENTRY_TYPE) is

   begin  -- Get_Error

      DG_Generic_Error_Processing.Get_Error(
        Error_History           => DG_Client_GUI.Interface.Error_Monitor.
                                     Error_History,
        Error_Queue_Write_Index => DG_Client_GUI.Interface.
                                     Error_Queue_Write_Index,
        Error_Queue_Read_Index  => DG_Client_GUI.Interface.
                                     Error_Queue_Read_Index,
        Error_Queue             => DG_Client_GUI.Interface.Error_Monitor.
                                     Error_Queue,
        Error_Present           => Error_Present,
        Error_Entry             => Error_Entry,
        Overflow_Present        => Overflow);

   end Get_Error;

end DG_Client_Error_Processing;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
