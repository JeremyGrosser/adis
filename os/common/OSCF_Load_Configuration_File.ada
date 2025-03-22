--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Load_Configuration_File
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 August 94
--
-- PURPOSE :
--   - The LCF CSU loads in configuration file data from a specified
--     configuration file to the GUI.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires Errors, OS_Status, and Text_IO. 
--   - This procedure is a modified version of a similar unit in the DIS
--     Gateway CSCI which was written by Brett Dufault.
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
with Errors,
     Text_IO;

separate (OS_Configuration_Files)

procedure Load_Configuration_File(
   Filename  : in     STRING;
   Status    :    out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   K_Max_Configuration_Line :  constant := 255;
   Config_File      :  Text_IO.FILE_TYPE;
   Config_Length    :  NATURAL;
   Config_Line      :  STRING(1..K_Max_Configuration_Line);
   Found_Keyword    :  BOOLEAN;
   Found_Equal      :  BOOLEAN;
   Found_Value      :  BOOLEAN;
   Keyword_End      :  INTEGER;
   Line_Position    :  INTEGER;
   Returned_Status  :  OS_Status.STATUS_TYPE;

   -- Rename functions
   function "="(Left, Right : OS_Status.STATUS_TYPE)
     return BOOLEAN
       renames OS_Status."=";

begin  -- Load_Configuration_File

   -- Initialize status
   Status := OS_Status.SUCCESS;

   -- Open the configuration file
   Text_IO.Open(
     File => Config_File,
     Mode => Text_IO.IN_FILE,
     Name => Filename);

   -- Read in all the lines in the configuration file
   Read_Configuration_Lines:
   while not Text_IO.End_Of_File(Config_File) loop

      Text_IO.Get_Line(
        File => Config_File,
        Item => Config_Line,
        Last => Config_Length);

      -- Skip blank lines
      if Config_Length > 0 then

         -- Skip comment lines
         if Config_Line(1) /= '#' then

            -- Initialize Line_Position to start of Config_Line
            Line_Position := 1;

            -- Extract text for keyword
            Found_Keyword := FALSE;

            Find_Keyword_End:
            for Config_Index in 1..INTEGER(Config_Length) loop

               -- The keyword text ends when a space, tab, or "=" is found
               if Config_Line(Config_Index) = ' '
                 or else Config_Line(Config_Index) = ASCII.HT
                 or else Config_Line(Config_Index) = '='
               then
                  Found_Keyword := TRUE;
                  exit Find_Keyword_End;
               end if;

               Line_Position := Config_Index;
            end loop Find_Keyword_End;

            if Found_Keyword then
               Keyword_End := Line_Position;

               -- Locate equal sign
               Found_Equal := TRUE;

               Find_Equal_Sign:
               while Config_Line(Line_Position) /= '=' loop
                  Line_Position := Line_Position + 1;

                  if Line_Position > Config_Length then
                     Found_Equal := FALSE;
                     exit Find_Equal_Sign;
                  end if;
               end loop Find_Equal_Sign;

               if Found_Equal then
                  -- Locate start of keyword value
                  Line_Position := Line_Position + 1;  -- Move past "="

                  Found_Value := FALSE;

                  Find_Value_Start:
                  for Config_Index in Line_Position..Config_Length loop
                     Line_Position := Config_Index;

                     if Config_Line(Config_Index) /= ' '
                       and then Config_Line(Config_Index) /= ASCII.HT
                     then
                        Found_Value := TRUE;
                        exit Find_Value_Start;
                     end if;
                  end loop Find_Value_Start;

                  if Found_Value then
                     -- Call the generic configuration data interpretation
                     -- routine
                     Process_Configuration_Data(
                       Keyword_Name  => Config_Line(1..Keyword_End),
                       Keyword_Value => Config_Line(
                                          Line_Position..Config_Length),
                       Status        => Returned_Status);
                     if Returned_Status /= OS_Status.SUCCESS then
                        -- Report error
                        Errors.Report_Error(
                          Detonated_Prematurely => FALSE,
                          Error                 => Returned_Status);
                     end if;

                  else
                     -- Report error
                     Errors.Report_Error(
                       Detonated_Prematurely => FALSE,
                       Error => OS_Status.
                                  LCF_INCOMPLETE_LINE_IN_CONFIG_FILE_ERROR);
                  end if;  -- Found_Value

               else
                  -- Report error
                  Errors.Report_Error(
                    Detonated_Prematurely => FALSE,
                    Error => OS_Status.
                               LCF_INCOMPLETE_LINE_IN_CONFIG_FILE_ERROR);
               end if;  -- Found_Equal

            else
               -- Report error
               Errors.Report_Error(
                 Detonated_Prematurely => FALSE,
                 Error => OS_Status.LCF_INCOMPLETE_LINE_IN_CONFIG_FILE_ERROR);
            end if;  -- Found_Keyword
         end if;  -- Config_Line /= '#'
      end if;  -- Config_Length > 0
   end loop Read_Configuration_Lines;

   -- Close the configuration file
   Text_IO.Close(Config_File);

exception
   when Text_IO.NAME_ERROR =>
      Status := OS_Status.LCF_CANNOT_OPEN_FILE_ERROR;

   when OTHERS =>
      Status := OS_Status.LCF_ERROR;

end Load_Configuration_File;
