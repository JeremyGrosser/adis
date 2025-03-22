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
-- UNIT NAME        : DG_Configuration_File_Management.Load_Configuration_File
--
-- FILE NAME        : DG_CFM_Load_Configuration_File.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 28, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - 
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

with Text_IO;

separate (DG_Configuration_File_Management)

procedure Load_Configuration_File(
   Filename  : in     STRING;
   Status    :    out DG_Status.STATUS_TYPE) is

   K_Max_Configuration_Line : constant := 255;

   Config_File   : Text_IO.FILE_TYPE;
   Config_Length : NATURAL;
   Config_Line   : STRING(1..K_Max_Configuration_Line);
   Found_Keyword : BOOLEAN;
   Found_Equal   : BOOLEAN;
   Found_Value   : BOOLEAN;
   Keyword_End   : INTEGER;
   Line_Position : INTEGER;
   Local_Status  : DG_Status.STATUS_TYPE;

begin  -- Load_Configuration_File

   Status := DG_Status.SUCCESS;

   --
   -- Open the configuration file
   --
   Text_IO.Open(
     File => Config_File,
     Mode => Text_IO.IN_FILE,
     Name => Filename);

   --
   -- Read in all the lines in the configuration file
   --
   Read_Configuration_Lines:
   while (not Text_IO.End_Of_File(Config_File)) loop

      Text_IO.Get_Line(
        File => Config_File,
        Item => Config_Line,
        Last => Config_Length);

      --
      -- Skip blank lines
      --
      if (Config_Length > 0) then

         --
         -- Skip comment lines
         --
         if (Config_Line(1) /= '#') then

            --
            -- Initialize Line_Position to start of Config_Line
            --
            Line_Position := 1;

            --
            -- Extract text for keyword
            --

            Found_Keyword := FALSE;

            Find_Keyword_End:
            for Config_Index in 1..INTEGER(Config_Length) loop

               --
               -- The keyword text ends when a space, tab, or "=" is found
               --
               if ((Config_Line(Config_Index) = ' ')
                 or (Config_Line(Config_Index) = ASCII.HT)
                 or (Config_Line(Config_Index) = '=')) then

                  Found_Keyword := TRUE;

                  exit Find_Keyword_End;

               end if;

               Line_Position := Config_Index;

            end loop Find_Keyword_End;

            if (Found_Keyword) then

               Keyword_End := Line_Position;

               --
               -- Locate equal sign
               --

               Found_Equal := TRUE;

               Find_Equal_Sign:
               while (Config_Line(Line_Position) /= '=') loop

                  Line_Position := Line_Position + 1;

                  if (Line_Position > Config_Length) then
                     Found_Equal := FALSE;
                     exit Find_Equal_Sign;
                  end if;

               end loop Find_Equal_Sign;

               if (Found_Equal) then

                  --
                  -- Locate start of keyword value
                  --

                  Line_Position := Line_Position + 1;  -- Move past "="

                  Found_Value := FALSE;

                  Find_Value_Start:
                  for Config_Index in Line_Position..Config_Length loop

                     Line_Position := Config_Index;

                     if ((Config_Line(Config_Index) /= ' ')
                        and (Config_Line(Config_Index) /= ASCII.HT)) then

                        Found_Value := TRUE;

                        exit Find_Value_Start;

                     end if;

                  end loop Find_Value_Start;

                  if (Found_Value) then

                     --
                     -- Call the generic configuration data interpretation
                     -- routine
                     --

                     Interpret_Configuration_Data(
                       Keyword_Name  => Config_Line(1..Keyword_End),
                       Keyword_Value => Config_Line(
                                          Line_Position..Config_Length),
                       Status        => Local_Status);

                     if (DG_Status.Failure(Local_Status)) then
                        Report_Error(Local_Status);
                     end if;

                  else

                     Text_IO.Put_Line(
                       "No value found in line: "
                       & Config_Line(1..Config_Length));

                     Report_Error(DG_Status.CFM_LCF_VALUE_MISSING_FAILURE);

                  end if;  -- (Found_Value)

               else

                  Text_IO.Put_Line(
                    "No equal sign found in line: "
                    & Config_Line(1..Config_Length));

                  Report_Error(DG_Status.CFM_LCF_EQUAL_MISSING_FAILURE);

               end if;  -- (Found_Equal)

            else

               Text_IO.Put_Line(
                 "No keyword found in line: "
                 & Config_Line(1..Config_Length));

               Report_Error(DG_Status.CFM_LCF_KEYWORD_MISSING_FAILURE);

            end if;  -- (Found_Keyword)

         end if;  -- (Config_Line /= '#')

      end if;  -- (Config_Length > 0)

   end loop Read_Configuration_Lines;

   --
   -- Close the configuration file
   --
   Text_IO.Close(Config_File);

exception

   when Text_IO.NAME_ERROR =>

      Status := DG_Status.CFM_LCF_INVALID_FILENAME_FAILURE;

   when OTHERS =>

      Status := DG_Status.CFM_LCF_FAILURE;

end Load_Configuration_File;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
