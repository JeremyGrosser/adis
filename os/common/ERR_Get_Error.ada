--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Get_Error
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  21 July 94
--
-- PURPOSE :
--   - The RE CSU reports an error message to the error buffer to be displayed
--     to the user and writes a copy of the error to an error log if these
--     capabilities are requested.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Calendar, OS_Data_Types, OS_Error_Messages,
--     OS_GUI, and Text_IO.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Calendar,
     OS_Error_Messages,
     OS_GUI,
     Text_IO;

separate(Errors)

procedure Get_Error(
   Overflow      : out BOOLEAN;
   Error_Present : out BOOLEAN;
   Error_Entry   : out OS_Data_Types.ERROR_QUEUE_ENTRY_TYPE) is
   
begin -- Get_Error

   if (OS_GUI.Interface.Error_Parameters.Write_Index
     /= OS_GUI.Interface.Error_Parameters.Read_Index) then

      Error_Entry
        := OS_GUI.Interface.Error_Parameters.Queue(
             OS_GUI.Interface.Error_Parameters.Read_Index);

      Error_Present := TRUE;

      OS_GUI.Interface.Error_Parameters.Read_Index
        := (OS_GUI.Interface.Error_Parameters.Read_Index MOD
              OS_GUI.Interface.Error_Parameters.Queue'LENGTH) + 1;

   else

      Error_Present := FALSE;

   end if;

   if (OS_GUI.Interface.Error_Parameters.History(
     OS_Status.RE_OVERFLOW_ERROR).Occurrence_Count > Overflow_Count) then

      Overflow_Count
        := OS_GUI.Interface.Error_Parameters.History(
             OS_Status.RE_OVERFLOW_ERROR).Occurrence_Count;

      Overflow := TRUE;

   else

      Overflow := FALSE;

   end if;

exception
   when OTHERS =>
      null;

end Get_Error;
