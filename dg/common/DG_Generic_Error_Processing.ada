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
-- FILE NAME        : DG_Generic_Error_Processing.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June dd, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with Calendar;

package body DG_Generic_Error_Processing is

   --
   -- Overflow_Count tracks the last Occurrence_Count for the GEP_RE_OVERFLOW
   -- error.  It is used by the Get_Error procedure to detect new occurrences
   -- of error queue overflow.
   --
   Overflow_Count : INTEGER := 0;

   ---------------------------------------------------------------------------
   -- Add_Error_Log_Entry
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Add_Error_Log_Entry(
      Error          : in DG_Status.STATUS_TYPE;
      Error_Log_File : in Text_IO.FILE_TYPE;
      Timestamp      : in Calendar.TIME) is

      Hours   : INTEGER;
      Minutes : INTEGER;
      Seconds : INTEGER;

      K_Seconds_Per_Minute : constant := 60;
      K_Minutes_Per_Hour   : constant := 60;
      K_Seconds_Per_Hour   : constant := K_Seconds_Per_Minute
                                           * K_Minutes_Per_Hour;

      ------------------------------------------------------------------------
      -- Digit_String
      ------------------------------------------------------------------------
      -- Purpose:  This function returns a two-digit, zero-padded string
      --           containing the input integer.
      ------------------------------------------------------------------------

      function Digit_String(Digit : in INTEGER) return STRING is

         -- Text value of digit.  Not that 'IMAGE will prefix the string
         -- with a space for non-negative values.
         Local_String : constant STRING := INTEGER'IMAGE(Digit);

         -- Local_String without the prefixed space.
         No_Space_String : constant STRING
                             := Local_String(2..Local_String'LAST);

      begin  -- Digit_String

         if (Digit < 10) then
            return ("0" & No_Space_String);
         else
            return (No_Space_String);
         end if;

      end Digit_String;

   begin  -- Add_Error_Log_Entry

      --
      -- Calculate the hours, minutes, and seconds of the current time
      --
      Seconds := INTEGER(Calendar.Seconds(Timestamp));
      Hours   := Seconds / K_Seconds_Per_Hour;
      Seconds := Seconds - (Hours * K_Seconds_Per_Hour);
      Minutes := Seconds / K_Seconds_Per_Minute;
      Seconds := Seconds - (Minutes * K_Seconds_Per_Minute);

      --
      -- Write the timestamp in the log file as hh:mm:ss
      --
      Text_IO.Put(
        Error_Log_File,
        Digit_String(Hours) & ":" & Digit_String(Minutes) & ":"
          & Digit_String(Seconds) & "    ");

      --
      -- Write the error in the log file
      --
      Text_IO.Put_Line(Error_Log_File, DG_Status.STATUS_TYPE'IMAGE(Error));

   end Add_Error_Log_Entry;

   ---------------------------------------------------------------------------
   -- Add_Error_Monitor_Entry
   ---------------------------------------------------------------------------
   -- Purpose:
   ---------------------------------------------------------------------------

   procedure Add_Error_Monitor_Entry(
      Error                   : in     DG_Status.STATUS_TYPE;
      Timestamp               : in     Calendar.TIME;
      Error_Queue_Read_Index  : in     INTEGER;
      Error_Queue_Write_Index : in out INTEGER;
      Error_Queue             : in out DG_Error_Processing_Types.
                                         ERROR_QUEUE_TYPE;
      Error_History           : in out DG_Error_Processing_Types.
                                         ERROR_HISTORY_TYPE) is

      Next_Write_Index : INTEGER;

   begin  -- Add_Error_Monitor_Entry

      --
      -- Update error history information
      --
      Error_History(Error) := (
        Occurrence_Count     => Error_History(Error).Occurrence_Count + 1,
        Last_Occurrence_Time => Timestamp);

      Next_Write_Index
        := (Error_Queue_Write_Index MOD Error_Queue'LENGTH) + 1;

      --
      -- Check for queue overflow.
      --
      if (Next_Write_Index = Error_Queue_Read_Index) then

         --
         -- Update overflow history information
         --
         Error_History(DG_Status.GEP_RE_OVERFLOW) := (
           Occurrence_Count     => Error_History(DG_Status.GEP_RE_OVERFLOW).
                                     Occurrence_Count + 1,
           Last_Occurrence_Time => Timestamp);

      else

         --
         -- Insert the error into the error queue
         --
         Error_Queue(Error_Queue_Write_Index) := (
           Error           => Error,
           Occurrence_Time => Timestamp);

         Error_Queue_Write_Index := Next_Write_Index;

      end if;

   end Add_Error_Monitor_Entry;

   ---------------------------------------------------------------------------
   -- Report_Error
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
                                            ERROR_HISTORY_TYPE) is

      Timestamp        : Calendar.TIME;

   begin  -- Report_Error

      --
      -- Get the current system time
      --
      Timestamp := Calendar.Clock;

      if (Error_Monitor_Enabled_Flag) then

         Add_Error_Monitor_Entry(
           Error                   => Error,
           Timestamp               => Timestamp,
           Error_Queue_Read_Index  => Error_Queue_Read_Index,
           Error_Queue_Write_Index => Error_Queue_Write_Index,
           Error_Queue             => Error_Queue,
           Error_History           => Error_History);

      end if;

      if (Error_Log_Enabled_Flag) then

         Add_Error_Log_Entry(
           Error          => Error,
           Error_Log_File => Error_Log_File,
           Timestamp      => Timestamp);

      end if;  -- Error_Log_Enabled_Flag

   exception

      when OTHERS =>

         null;

   end Report_Error;

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
      Overflow_Present        :    out BOOLEAN) is

   begin  -- Get_Error

      if (Error_Queue_Write_Index /= Error_Queue_Read_Index) then

         Error_Entry   := Error_Queue(Error_Queue_Read_Index);
         Error_Present := TRUE;

         Error_Queue_Read_Index
           := (Error_Queue_Read_Index MOD Error_Queue'LENGTH) + 1;

      else

         Error_Present := FALSE;

      end if;

      if (Error_History(DG_Status.GEP_RE_OVERFLOW).Occurrence_Count
            > Overflow_Count) then

         Overflow_Count
           := Error_History(DG_Status.GEP_RE_OVERFLOW).Occurrence_Count;

         Overflow_Present := TRUE;

      else

         Overflow_Present := FALSE;

      end if;

   end Get_Error;

end DG_Generic_Error_Processing;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
