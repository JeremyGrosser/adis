--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Report_Error
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

procedure Report_Error(
   Detonated_Prematurely :  in BOOLEAN;
   Error                 :  in OS_Status.STATUS_TYPE)
  is
   
   -- Local variables
   K_Seconds_Per_Minute : constant INTEGER := 60;
   K_Seconds_Per_Hour   : constant INTEGER := 3600;
   Hours            :  INTEGER;
   Minutes          :  INTEGER;
   Seconds          :  INTEGER;
   Next_Write_Index :  INTEGER;
   Timestamp        :  Calendar.TIME;

   -- Renames variables
   Errors :  OS_Data_Types.ERROR_PARAMETERS_RECORD
     renames OS_GUI.Interface.Error_Parameters;

   -- Instantiate packages
   package Integer_IO is new Text_IO.Integer_IO(INTEGER);

begin -- Report_Error

   -- Find current system time
   Timestamp := Calendar.Clock;

   if Errors.Display_Error then

      -- Update error history information
      Errors.History(Error).Occurrence_Count
        := Errors.History(Error).Occurrence_Count + 1;
      Errors.History(Error).Last_Occurrence_Time := Timestamp;

      Next_Write_Index := (Errors.Write_Index mod Errors.Queue'LENGTH) + 1;

      -- Check for overflow
      if Next_Write_Index = Errors.Read_Index then

         -- Indicate an overflow error
         Errors.History(OS_Status.RE_OVERFLOW_ERROR).Occurrence_Count
           := Errors.History(OS_Status.RE_OVERFLOW_ERROR).Occurrence_Count + 1;
         Errors.History(OS_Status.RE_OVERFLOW_ERROR).Last_Occurrence_Time
           := Timestamp;
         Errors.Queue_Overflow := TRUE;

      else

         -- Add error to queue
         Errors.Queue(Errors.Write_Index).Detonation_Flag
           := Detonated_Prematurely;
         Errors.Queue(Errors.Write_Index).Error           := Error;
         Errors.Queue(Errors.Write_Index).Occurrence_Time := Timestamp;
         Errors.Write_Index                               := Next_Write_Index;

      end if;
   end if;

   if Errors.Log_Error then

      -- Calculate hours, minutes and seconds of the current time
      Seconds := INTEGER(Calendar.Seconds(Timestamp));
      Hours   := Seconds / K_Seconds_Per_Hour;
      Seconds := Seconds - (Hours * K_Seconds_Per_Hour);
      Minutes := Seconds / K_Seconds_Per_Minute;
      Seconds := Seconds - (Minutes * K_Seconds_Per_Minute);

      -- Write the timestamp in the log file as hh:mm:ss
      Integer_IO.Put(OS_Data_Types.Log_File, Hours);
      Integer_IO.Put(OS_Data_Types.Log_File, Minutes);
      Integer_IO.Put(OS_Data_Types.Log_File, Seconds);

      -- Include appropriate message if detonated prematurely
      if Detonated_Prematurely then
        Text_IO.Put_Line(OS_Data_Types.Log_File,
          "The munition was detonated prematurely because ...");
      else
        Text_IO.Put_Line(OS_Data_Types.Log_File, "");
      end if;

      -- Write error to log file
      Text_IO.Put_Line(
        OS_Data_Types.Log_File,
        OS_Error_Messages.K_Error_Message(Error).Text);

   end if;

exception
   when OTHERS =>
      null;

end Report_Error;
