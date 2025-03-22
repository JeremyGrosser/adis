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
-- PACKAGE NAME     : DG_Generic_Error_Processing
--
-- FILE NAME        : DG_Generic_Error_Processing_.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 12, 1994
--
-- PURPOSE:
--   - This package contains routines to support error monitoring and logging.
--
-- EFFECTS:
--   - The expected usage is:
--     1. If Error_Log_Enabled_Flag is set TRUE, then Error_Log_File must
--        be set to an open file.
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Error_Processing_Types,
     DG_Status,
     Text_IO;

package DG_Generic_Error_Processing is

   ---------------------------------------------------------------------------
   -- Report_Error
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Report_Error(
      Error                      : in     DG_Status.STATUS_TYPE;
      Error_Log_Enabled_Flag     : in     BOOLEAN;
      Error_Monitor_Enabled_Flag : in     BOOLEAN;
      Error_Log_File             : in     Text_IO.FILE_TYPE
                                            := Text_IO.Standard_Output;
      Error_Queue_Read_Index     : in     INTEGER;
      Error_Queue_Write_Index    : in out INTEGER;
      Error_Queue                : in out DG_Error_Processing_Types.
                                            ERROR_QUEUE_TYPE;
      Error_History              : in out DG_Error_Processing_Types.
                                            ERROR_HISTORY_TYPE);

   ---------------------------------------------------------------------------
   -- Get_Error
   ---------------------------------------------------------------------------
   -- Purpose: 
   ---------------------------------------------------------------------------

   procedure Get_Error(
      Error_History           : in     DG_Error_Processing_Types.
                                         ERROR_HISTORY_TYPE;
      Error_Queue_Write_Index : in     INTEGER;
      Error_Queue_Read_Index  : in out INTEGER;
      Error_Queue             : in out DG_Error_Processing_Types.
                                         ERROR_QUEUE_TYPE;
      Error_Present           :    out BOOLEAN;
      Error_Entry             :    out DG_Error_Processing_Types.
                                         ERROR_QUEUE_ENTRY_TYPE;
      Overflow_Present        :    out BOOLEAN);

end DG_Generic_Error_Processing;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
