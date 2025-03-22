--                            U N C L A S S I F I E D
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--

with Text_IO;
with Utilities;
with Xlib;
with XlibR5;
with Xm;
with Xmdef;
with Xtdef;
with Xt;
with XtR5;

separate (Motif_Utilities)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Text_Restrict_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   June 27, 1994
--
-- PURPOSE:
--   This callback function restrict the passed text widget to only accept as
--   valid input text matching the passed criteria.
--
-- IMPLEMENTATION NOTES:
--   None.
--
-- EXCEPTIONS:
--   None.
--
-- PORTABILITY ISSUES:
--   None.
--
-- ANTICIPATED CHANGES:
--   None.
--
---------------------------------------------------------------------------
procedure Text_Restrict_CB(
   Text_Widget        : in     Xt.WIDGET;
   Text_Restrictions  : in out Motif_Utilities.ATEXT_RESTRICTION_RECORD;
   CBS                : in out Xm.TEXTVERIFYCALLBACKSTRUCT_PTR) is

   --
   -- Local constant declarations
   --
   K_Title_String_Range    : constant STRING := "Value Out of Range";
   K_Title_String_Invalid  : constant STRING := "Invalid Value";

   K_Message_Out_Of_Range_Low_String : constant STRING  := 
     "The value you entered is smaller than allowed in this field."
       & ASCII.LF & "The minimum allowable value will been entered for you.";
   K_Message_Out_Of_Range_High_String : constant STRING  :=
     "The value you entered is greater than allowed in this field."
       & ASCII.LF & "The maximum allowable value will been entered for you.";
   K_Message_Invalid_String : constant STRING  :=
     "The value entered is invalid (out of range?). Please reenter.";

   --
   -- Declare reconstructed string constants
   --
   K_Null_Length          : constant INTEGER := 1;
   K_Float_Padding_Length : constant INTEGER := 2;

   -- ---
   -- Local variable declarations
   -- ---

   --
   -- Variable "pointing to" newly entered text
   --
   Cbs_Text_Ptr : STRING(1..INTEGER(CBS.Text.Length));
   for Cbs_Text_Ptr use at CBS.Text.ptr;

   --
   -- Variables to hold existing text and it's length
   --
   Text_Length            : INTEGER       := 0;
   Text                   : Xm.STRING_PTR := NULL;

   --
   -- Declare string variable New_Text to hold the reconstructed string.
   --
   New_Text_Length_Max : INTEGER           := 0; 
   New_Text_Length     : INTEGER           := 0; 
   New_Text            : Utilities.ASTRING := NULL;

   --
   -- Variables to hold statistics concerning the reconstructed string.
   --
   Decimal_Point_Count    : INTEGER := 0;
   Negative_Sign_Count    : INTEGER := 0;

   --
   -- Record (variant) holding text restriction information.
   --
   Restrictions : ATEXT_VALUE_RESTRICTIONS_RECORD;

   --
   -- Constants and variables associated with the failure in the 
   -- range check subroutine.
   --
   Response_Character     : CHARACTER;
   K_Value_String_Max     : constant INTEGER := 128;
   Value_String           : STRING(1..K_Value_String_Max)
     := (OTHERS => ASCII.nul);

   --
   -- Exceptions for all possible text restriction failures.
   --
   Decimal_Point_Not_Allowed             : EXCEPTION;
   Too_Many_Decimal_Points               : EXCEPTION;
   Negative_Not_Allowed                  : EXCEPTION;
   Negative_Sign_Misplaced               : EXCEPTION;
   Character_Max_Exceeded                : EXCEPTION;
   Invalid_Decimal_Integer_Character     : EXCEPTION;
   Invalid_Hexadecimal_Integer_Character : EXCEPTION;
   Invalid_Binary_Integer_Character      : EXCEPTION;
   Invalid_Float_Character               : EXCEPTION;
   Invalid_Alphabetic_Character          : EXCEPTION;
   Invalid_Alphanumeric_Character        : EXCEPTION;
   Invalid_Character                     : EXCEPTION;
   Value_Out_Of_Range_Max                : EXCEPTION;
   Value_Out_Of_Range_Min                : EXCEPTION;
   Wrong_Widget_Class                    : EXCEPTION;
   Unknown_Error                         : EXCEPTION;

   --
   -- Renamed functions
   --
   function "=" (left, right: Xt.Widget)
     return BOOLEAN renames Xt."=";

   function "=" (left, right: Xm.TextPosition)
     return BOOLEAN renames Xm."=";
   function ">" (left, right: Xm.TextPosition)
     return BOOLEAN renames Xm.">";
   function ">=" (left, right: Xm.TextPosition)
     return BOOLEAN renames Xm.">=";
   function "<" (left, right: Xm.TextPosition)
     return BOOLEAN renames Xm."<";
   function "<=" (left, right: Xm.TextPosition)
     return BOOLEAN renames Xm."<=";

   --
   -- Instantiated Packages
   --
   package Integer_IO is 
     new Text_IO.Integer_IO (INTEGER);
   package Float_IO is 
     new Text_IO.Float_IO (FLOAT);
   package TextPosition_IO is 
     new Text_IO.Integer_IO (Xm.TextPosition);

begin

   --
   -- Debugging lines...
   --
   --Text_IO.Put_Line ("       CBS.currInsert  ="
   --  & INTEGER'image(INTEGER(CBS.currInsert)) & ".");
   --Text_IO.Put_Line ("       CBS.newInsert   ="
   --  & INTEGER'image(INTEGER(CBS.newInsert)) & ".");
   --Text_IO.Put_Line ("       CBS.startPos    ="
   --  & INTEGER'image(INTEGER(CBS.startPos)) & ".");
   --Text_IO.Put_Line ("       CBS.endPos      ="
   --  & INTEGER'image(INTEGER(CBS.endPos)) & ".");
   --Text_IO.Put_Line ("       CBS.text.ptr    = `"
   --  & Cbs_Text_Ptr & "'");
   --Text_IO.Put_Line ("       CBS.text.length = `"
   --  & INTEGER'image(CBS.text.length) & "'");

   --
   -- CBS record fields:
   --
   -- CBS.reason     (int)         [Int]
   -- CBS.event      (Xevent *)    [Xlib.Event_Ptr]
   -- CBS.doit       (Boolean)     [Xt.XtBoolean]
   -- CBS.currInsert (long)        [TextPosition]
   -- CBS.newInsert  (long)        [TextPosition]
   -- CBS.startPos   (long)        [TextPosition]
   -- CBS.endPos     (long)        [TextPosition]
   -- CBS.text       (XmTextBlock) [TextBlock]
   -- CBS.text.ptr      (char *)        -- Pointer to data
   -- CBS.text.length   (int)           -- Number of bytes of data
   -- CBS.text.format   (XmTextFormat)  -- Representations format


   --
   -- Ensure that the parent Text_Widget is not Xt.XNULL before continuing...
   --
   if (Text_Widget /= Xt.XNULL) then

      -- --------------------------------------------------------
      --
      -- Set up basic text restriction state flags
      --
      -- --------------------------------------------------------
      case Text_Restrictions.Text_Type_Enum is

	 when TEXT_NUMERIC_INTEGER_POSITIVE =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_INTEGER);
	    Restrictions.Decimal_Point_Allowed := FALSE;
	    Restrictions.Negative_Sign_Allowed := FALSE;
	    Restrictions.Minimum_Integer_Allowed
	      := Utilities.Max (Text_Restrictions.Minimum_Valid_Integer, 1);
	    Restrictions.Maximum_Integer_Allowed
	      := Utilities.Min (Text_Restrictions.Maximum_Valid_Integer,
		INTEGER'last);

	 when TEXT_NUMERIC_INTEGER_NONNEGATIVE =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_INTEGER);
	    Restrictions.Decimal_Point_Allowed := FALSE;
	    Restrictions.Negative_Sign_Allowed := FALSE;
	    Restrictions.Minimum_Integer_Allowed
	      := Utilities.Max (Text_Restrictions.Minimum_Valid_Integer, 0);
	    Restrictions.Maximum_Integer_Allowed
	      := Utilities.Min (Text_Restrictions.Maximum_Valid_Integer,
		INTEGER'last);

	 when TEXT_NUMERIC_HEXADECIMAL | TEXT_NUMERIC_BINARY =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_INTEGER);
	    Restrictions.Decimal_Point_Allowed := FALSE;
	    Restrictions.Negative_Sign_Allowed := FALSE;
	    Restrictions.Minimum_Integer_Allowed
	      := Utilities.Max (Text_Restrictions.Minimum_Valid_Integer, 
		INTEGER'first);
	    Restrictions.Maximum_Integer_Allowed
	      := Utilities.Min (Text_Restrictions.Maximum_Valid_Integer,
		INTEGER'last);

	 when TEXT_NUMERIC_INTEGER =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_INTEGER);
	    Restrictions.Decimal_Point_Allowed := FALSE;
	    Restrictions.Negative_Sign_Allowed := TRUE;
	    Restrictions.Minimum_Integer_Allowed
	      := Utilities.Max (Text_Restrictions.Minimum_Valid_Integer, 
		INTEGER'first);
	    Restrictions.Maximum_Integer_Allowed
	      := Utilities.Min (Text_Restrictions.Maximum_Valid_Integer,
		INTEGER'last);

	 when TEXT_NUMERIC_FLOAT_POSITIVE =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_FLOAT);
	    Restrictions.Decimal_Point_Allowed := TRUE;
	    Restrictions.Negative_Sign_Allowed := FALSE;
	    Restrictions.Minimum_Float_Allowed
	      := Utilities.Max (Text_Restrictions.Minimum_Valid_Float, 
		FLOAT'small);
	    Restrictions.Maximum_Float_Allowed
	      := Utilities.Min (Text_Restrictions.Maximum_Valid_Float,
		FLOAT'large);

	 when TEXT_NUMERIC_FLOAT_NONNEGATIVE =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_FLOAT);
	    Restrictions.Decimal_Point_Allowed := TRUE;
	    Restrictions.Negative_Sign_Allowed := FALSE;
	    Restrictions.Minimum_Float_Allowed
	      := Utilities.Max (Text_Restrictions.Minimum_Valid_Float, 0.0);
	    Restrictions.Maximum_Float_Allowed
	      := Utilities.Min (Text_Restrictions.Maximum_Valid_Float,
		FLOAT'large);

	 when TEXT_NUMERIC_FLOAT =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_FLOAT);
	    Restrictions.Decimal_Point_Allowed := TRUE;
	    Restrictions.Negative_Sign_Allowed := TRUE;
	    Restrictions.Minimum_Float_Allowed
	      := Utilities.Max (Text_Restrictions.Minimum_Valid_Float,
		-FLOAT'large);
	    Restrictions.Maximum_Float_Allowed
	      := Utilities.Min (Text_Restrictions.Maximum_Valid_Float,
		FLOAT'large);

	 when TEXT_ALPHABETIC =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_CHARACTER);
	    Restrictions.Decimal_Point_Allowed := TRUE;
	    Restrictions.Negative_Sign_Allowed := TRUE;
	    Restrictions.Minimum_Character_Allowed := 'A';
	    Restrictions.Maximum_Character_Allowed := 'z';

	 when TEXT_ALPHANUMERIC =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_CHARACTER);
	    Restrictions.Decimal_Point_Allowed := TRUE;
	    Restrictions.Negative_Sign_Allowed := TRUE;
	    Restrictions.Minimum_Character_Allowed := '0';
	    Restrictions.Maximum_Character_Allowed := 'z';

	 when TEXT_ANY =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_CHARACTER);
	    Restrictions.Decimal_Point_Allowed := TRUE;
	    Restrictions.Negative_Sign_Allowed := TRUE;
	    Restrictions.Minimum_Character_Allowed := CHARACTER'first;
	    Restrictions.Maximum_Character_Allowed := CHARACTER'last;

	 when OTHERS =>
	    Restrictions := new Motif_Utilities.TEXT_VALUE_RESTRICTIONS_RECORD(
		Motif_Utilities.TYPE_CHARACTER);
	    Restrictions.Decimal_Point_Allowed := TRUE;
	    Restrictions.Negative_Sign_Allowed := TRUE;
	    Restrictions.Minimum_Character_Allowed := CHARACTER'first;
	    Restrictions.Maximum_Character_Allowed := CHARACTER'last;

      end case;

      -- --------------------------------------------------------
      --
      -- Reconstruct the text as if these changes are OK.
      -- This text can then be validated.
      --
      -- --------------------------------------------------------

      --
      -- Get the current contents of the Text widget.
      --
      if (Xm.IsTextField(Text_Widget)) then
         Text_Length := INTEGER(Xm.TextFieldGetLastPosition (Text_Widget));
         Text := Xm.TextFieldGetString (Text_Widget);
      elsif (Xm.IsText(Text_Widget)) then
         Text_Length := INTEGER(Xm.TextGetLastPosition (Text_Widget));
         Text := Xm.TextGetString (Text_Widget);
      else
         raise WRONG_WIDGET_CLASS;
      end if;

      --
      -- Debugging lines
      --
      --Text_IO.Put_Line ("Text is `" & Text.all & "'.");
      --Text_IO.Put_Line ("Text_Length =`" & INTEGER'image(Text_Length) & "'.");
      --Text_IO.New_Line;

      --
      -- Determine a safe value for the New_Text (reconstructed text string)
      -- length and allocate and initialize the New_Text text string.
      --
      New_Text_Length_Max := Text_Length + CBS.Text.Length + K_Null_Length 
	+ K_Float_Padding_Length;
      New_Text
	:= new STRING(Text'first..Text'first + New_Text_Length_Max);
      New_Text.all    := (OTHERS => ASCII.NUL);
      New_Text_Length := Utilities.Length_Of_String (New_Text.all);

      --
      -- Do the text re-construction
      --
      RECONSTRUCT_TEXT_BLOCK:
      declare
      begin
	 --
	 -- Assign the old text widget text to our new string
	 --
	 if (Text_Length > 0) then
	    New_Text(New_Text'first..(New_Text'first+Text_Length))
	      := Text(Text'first..(Text'first+Text_Length));
	 end if;

	 --
	 -- Handle text deletion (and the deletion phase of text replacement)
	 --
	 if (CBS.startPos < CBS.endPos) then
            --
	    -- Mimic backspace (and deletion phase of text replacement)
	    -- by deleting appropriate character(s).
	    --
	    for index in INTEGER(CBS.startPos)+1..INTEGER(CBS.endPos)
	      loop
	       BUILD_STRING_MIMIC_BACKSPACE_LOOP:
	       for counter in INTEGER(CBS.startPos)+1..(Text_Length-1) loop
		  New_Text(counter) := New_Text(counter+1);
	       end loop BUILD_STRING_MIMIC_BACKSPACE_LOOP;
	       New_Text(Text_Length) := ASCII.NUL;
	    end loop;

	 end if;

	 --
	 -- Insert new text into existing text
	 --
	    INSERT_CBS_TEXT_INTO_NEW_TEXT_BLOCK:
	    declare
	       New_Text_New_Index_1 : INTEGER :=
		 New_Text'first+INTEGER(CBS.startPos);
	       New_Text_New_Index_2 : INTEGER :=
		 New_Text_New_Index_1 + (Text_Length - INTEGER(CBS.startPos));

	       New_Text_Moved_Index_1 : INTEGER :=
		 New_Text_New_Index_1 + CBS.Text.Length;
	       New_Text_Moved_Index_2 : INTEGER :=
		 New_Text_New_Index_2 + CBS.Text.Length;
	    begin

	       MAKE_SPACE_IN_NEW_TEXT_LOOP:
	       for counter in 
		 reverse New_Text_New_Index_1..New_Text_New_Index_2 loop
		    New_Text(counter + CBS.Text.Length) := New_Text(counter);
	       end loop MAKE_SPACE_IN_NEW_TEXT_LOOP;

	       New_Text(
		 New_Text_New_Index_1..New_Text_New_Index_1+(CBS.Text.Length-1))
		   := Cbs_Text_Ptr(Cbs_Text_Ptr'first..Cbs_Text_Ptr'last);

	    end INSERT_CBS_TEXT_INTO_NEW_TEXT_BLOCK;

	    New_Text_Length := Utilities.Length_Of_String (New_Text.all);

      end RECONSTRUCT_TEXT_BLOCK;

      -- --------------------------------------------------------
      --
      -- Validate text string.
      --
      -- --------------------------------------------------------

      --
      -- Compile statistics for the New_Text string
      --
      Decimal_Point_Count := 0;
      Negative_Sign_Count := 0;
      NEW_TEXT_STATISTICS_LOOP:
      for counter in New_Text'first..New_Text_Length loop
	 if New_Text(counter) = '.' then
	    Decimal_Point_Count := Decimal_Point_Count + 1;
	 end if;
	 if New_Text(counter) = '-' then
	    Negative_Sign_Count := Negative_Sign_Count + 1;
	 end if;
      end loop NEW_TEXT_STATISTICS_LOOP;

      --
      -- DECIMAL POINT VALIDATION
      --
      -- If the user has entered a decimal point where this is invalid,
      -- discard new text.
      --
      if (Text_Restrictions.Text_Type_Enum /= TEXT_ANY) then
	 if (Decimal_Point_Count > 0) then
	    if (Restrictions.Decimal_Point_Allowed) then
	       if (Decimal_Point_Count > 1) then
                  raise Too_Many_Decimal_Points;
	       end if; -- Decimal_Point_Count > 1
	    else
	       raise Decimal_Point_Not_Allowed;
	    end if; -- Decimal_Point_Allowed
	 else
	    null; -- no decimal points, therefore no problem
	 end if; -- Decimal_Point_Count > 0
      else
	 null; -- TEXT_ANY allows any number of decimal points
      end if; -- Text type /= TEXT_ANY


      --
      -- NEGATIVE SIGN VALIDATION
      --
      -- If the user has entered a negative sign where this is invalid,
      -- discard new text.
      --
      if (Text_Restrictions.Text_Type_Enum /= TEXT_ANY) then
	 if (Negative_Sign_Count > 0) then
	    if (Restrictions.Negative_Sign_Allowed) then
	       if not ((Negative_Sign_Count = 1) 
		 and (New_Text(New_Text'first) = '-')) then
		  raise Negative_Sign_Misplaced;
	       end if; -- Negative_Sign_Count > 1
	    else
	       raise Negative_Not_Allowed;
	    end if; -- Negative_Sign_Allowed
	 else
	    null; -- no negative signs, therefore no problem
	 end if; -- Negative_Sign_Count > 0
      else
	 null; -- TEXT_ANY allows any number of negative signs
      end if; -- Text type /= TEXT_ANY

      --
      -- CHARACTER MAX VALIDATION
      --
      -- If the user has entered more characters than allowed,
      -- discard new text.
      --
      if (New_Text_Length > Text_Restrictions.Characters_Count) then
	 raise Character_Max_Exceeded;
      end if;

      --
      -- CHARACTER VALIDATION
      --
      -- If the user has entered invalid characters,
      -- discard new text.
      --
      case Text_Restrictions.Text_Type_Enum is
	 when TEXT_NUMERIC_INTEGER_POSITIVE
	   | TEXT_NUMERIC_INTEGER_NONNEGATIVE =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when '0'..'9' =>
		       null; -- Valid character
		    when OTHERS =>
                       raise Invalid_Decimal_Integer_Character;
		end case;
	    end loop;
	 when TEXT_NUMERIC_INTEGER =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when '0'..'9' | '-' =>
		       null; -- Valid character
		    when OTHERS =>
                       raise Invalid_Decimal_Integer_Character;
		end case;
	    end loop;
	 when TEXT_NUMERIC_HEXADECIMAL =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when '0'..'9' | 'A'..'F' | 'a'..'f' =>
		       null; -- Valid character
		    when OTHERS =>
		       raise Invalid_Hexadecimal_Integer_Character;
		end case;
	    end loop;
	 when TEXT_NUMERIC_BINARY =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when '0'..'1' =>
		       null; -- Valid character
		    when OTHERS =>
		       raise Invalid_Binary_Integer_Character;
		end case;
	    end loop;
	 when TEXT_NUMERIC_FLOAT_POSITIVE
	   | TEXT_NUMERIC_FLOAT_NONNEGATIVE =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when '0'..'9' | '.' =>
		       null; -- Valid character
		    when OTHERS =>
		       raise Invalid_Float_Character;
		end case;
	    end loop;
	 when TEXT_NUMERIC_FLOAT =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when '0'..'9' | '-' | '.' =>
		       null; -- Valid character
		    when OTHERS =>
		       raise Invalid_Float_Character;
		end case;
	    end loop;
	 when TEXT_ALPHABETIC =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when 'A'..'Z' | 'a'..'z' =>
		       null; -- Valid character
		    when OTHERS =>
		       raise Invalid_Alphabetic_Character;
		end case;
	    end loop;
	 when TEXT_ALPHANUMERIC =>
	    for counter in New_Text'first..New_Text_Length loop
		case New_Text(counter) is
		    when 'A'..'Z' | 'a'..'z' | '0'..'9' =>
		       null; -- Valid character
		    when OTHERS =>
		       raise Invalid_Alphanumeric_Character;
		end case;
	    end loop;
	 when TEXT_ANY =>
	    null; -- Any character is valid.
	 when OTHERS =>
	    null; -- Any character is valid?
      end case;

      VALUE_RANGE_CHECK_SUBROUTINE:
      declare
	 Temp_Integer    : INTEGER;
	 Temp_Float      : FLOAT;
	 Status          : BOOLEAN;
      begin

	 --
         -- Do not do range check if New_Text is empty.
	 --
	 if (Utilities.Length_Of_String(New_Text.all) > 0) then

	    --
	    -- Ensure that the value represented by our new string falls
	    -- within the valid range specified by the user.
	    --
	    case Restrictions.Value_Type is

		when TYPE_INTEGER =>
		   --
		   -- Extract the integer from the string
		   --
		   if (Text_Restrictions.Text_Type_Enum
		     = TEXT_NUMERIC_HEXADECIMAL) then

		      Utilities.Get_Hexadecimal_From_Text (New_Text.all,
			Temp_Integer, Status);

		   elsif (Text_Restrictions.Text_Type_Enum
		     = TEXT_NUMERIC_BINARY) then

		      Utilities.Get_Binary_From_Text (New_Text.all,
			Temp_Integer, Status);
		   else
		      Utilities.Get_Integer_From_Text (New_Text.all,
			Temp_Integer, Status);
                   end if;

		   --
		   -- If call to Utilities.Get_Integer_From_Text failed,
		   -- nullify field and give user the invalid string message.
		   --
		   if (Status = False) then

                        raise Unknown_Error;

		   --
		   -- If the extracted integer is too small, put the string
		   -- equivalent of the smallest valid integer into 
		   -- Value_String and raise 
		   --
		   elsif (Temp_Integer 
		     < Restrictions.Minimum_Integer_Allowed) then

			Utilities.Integer_To_String(
			  Restrictions.Minimum_Integer_Allowed, Value_String);
		        raise Value_Out_Of_Range_Min;

		   --
		   -- If the extracted integer is too large, put the string
		   -- equivalent of the largest valid integer into 
		   -- Value_String_Raw and set Value_String_Override to True.
		   --
		   elsif (Temp_Integer
		     > Restrictions.Maximum_Integer_Allowed) then

			Utilities.Integer_To_String(
			  Restrictions.Maximum_Integer_Allowed, Value_String);
		        raise Value_Out_Of_Range_Max;

		   end if;

		when TYPE_FLOAT =>

		   --
		   -- Extract the float from the string
		   --
		   Utilities.Get_Float_From_Text (New_Text.all,
		     Temp_Float, Status);

		   --
		   -- If call to Utilities.Get_Integer_From_Text failed,
		   -- nullify field and give user the invalid string message.
		   --
		   if (Status = False) then

                        raise Unknown_Error;

		   --
		   -- If the extracted float is too small, put the string
		   -- equivalent of the smallest valid float into 
		   -- Value_String_Raw and set Value_String_Override to True.
		   --
		   elsif (Temp_Float < Restrictions.Minimum_Float_Allowed) then

			Utilities.Float_To_String(
			  Restrictions.Minimum_Float_Allowed, Value_String);
		        raise Value_Out_Of_Range_Min;

		   --
		   -- If the extracted float is too large, put the string
		   -- equivalent of the largest valid float into 
		   -- Value_String_Raw and set Value_String_Override to True.
		   --
		   elsif (Temp_Float > Restrictions.Maximum_Float_Allowed) then

			Utilities.Float_To_String(
			  Restrictions.Maximum_Float_Allowed, Value_String);
		        raise Value_Out_Of_Range_Max;

		   end if;

		when TYPE_CHARACTER =>
		   null;

	    end case;


	 end if; -- New_Text is not empty

      end VALUE_RANGE_CHECK_SUBROUTINE;

      --
      -- Don't free this (as you normally would), because Verdix Ada
      -- corrupts memory when you do...
      --
      --Xm.StringFree (Text);
      Motif_Utilities.Free (Restrictions);

   end if;

exception

   when Decimal_Point_Not_Allowed =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Decimal_Point_Not_Allowed raised.");

--      --
--      -- TEMPORARY CODE:
--      --
--      Text_IO.Put_Line ("     CBS.currInsert  ="
--	& INTEGER'image(INTEGER(CBS.currInsert)) & ".");
--      Text_IO.Put_Line ("     CBS.newInsert   ="
--	& INTEGER'image(INTEGER(CBS.newInsert)) & ".");
--      Text_IO.Put_Line ("     CBS.startPos    ="
--	& INTEGER'image(INTEGER(CBS.startPos)) & ".");
--      Text_IO.Put_Line ("     CBS.endPos      ="
--	& INTEGER'image(INTEGER(CBS.endPos)) & ".");
--      Text_IO.Put_Line ("    `" & Text.all & "' + `" & Cbs_Text_Ptr & "' = `"
--	& New_Text.all & "'.");
   
   when Too_Many_Decimal_Points =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Too_Many_Decimal_Points raised.");
   
   when Negative_Not_Allowed =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Negative_Not_Allowed raised.");
   
   when Negative_Sign_Misplaced =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Negative_Sign_Misplaced raised.");
   
   when Character_Max_Exceeded =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Character_Max_Exceeded raised.");
   
   when Invalid_Decimal_Integer_Character =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Invalid_Decimal_Integer_Character raised.");
   
   when Invalid_Hexadecimal_Integer_Character =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Invalid_Hexadecimal_Integer_Character raised.");
   
   when Invalid_Binary_Integer_Character =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Invalid_Binary_Integer_Character raised.");
   
   when Invalid_Float_Character =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Invalid_Float_Character raised.");
   
   when Invalid_Alphabetic_Character =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Invalid_Alphabetic_Character raised.");
   
   when Invalid_Alphanumeric_Character =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Invalid_Alphanumeric_Character raised.");
   
   when Invalid_Character =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Invalid_Character raised.");
    
   --
   -- If the value was over the maximum allowable, or under the
   -- minimum allowable for the field, put the
   -- Value_String (created previously) into Text_Widget.
   --
   when Value_Out_Of_Range_Max =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

      --
      -- Inform the user that the new value would be too large, and that
      -- the largest valid value will be entered into the text field.
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget),
	  Xm.DIALOG_QUESTION, K_Title_String_Range,
	    K_Message_Out_Of_Range_High_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

      --
      -- Enter the largest valid value into the text field.
      --
      if (Xm.IsTextField(Text_Widget)) then
         Xm.TextFieldSetString (Text_Widget, Value_String);
      elsif (Xm.IsText(Text_Widget)) then
         Xm.TextSetString (Text_Widget, Value_String);
      else
         raise Wrong_Widget_Class;
      end if;

   --
   -- If the value was over the maximum allowable, or under the
   -- minimum allowable for the field, put the
   -- Value_String (created previously) into Text_Widget.
   --
   when Value_Out_Of_Range_Min =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

      --
      -- Inform the user that the new value would be too small, and that
      -- the smallest valid value will be entered into the text field.
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget),
	  Xm.DIALOG_QUESTION, K_Title_String_Range,
	    K_Message_Out_Of_Range_Low_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

      --
      -- Enter the smallest valid value into the text field.
      --
      if (Xm.IsTextField(Text_Widget)) then
         Xm.TextFieldSetString (Text_Widget, Value_String);
      elsif (Xm.IsText(Text_Widget)) then
         Xm.TextSetString (Text_Widget, Value_String);
      else
         raise Wrong_Widget_Class;
      end if;

   when Wrong_Widget_Class =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Wrong_Widget_Class raised.");

    
   when Unknown_Error =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("DEBUG: Text restriction exception "
--	& "Unknown_Error raised.");
    
   when CONSTRAINT_ERROR =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("Constraint Error raised in Text_Restrict_CB.");

      --
      -- Inform the user that there was a problem with this attempted
      -- text change...
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget), Xm.DIALOG_QUESTION,
	  K_Title_String_Invalid, K_Message_Invalid_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

   when NUMERIC_ERROR =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("Numeric Error raised in Text_Restrict_CB.");

      --
      -- Inform the user that there was a problem with this attempted
      -- text change...
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget), Xm.DIALOG_QUESTION,
	  K_Title_String_Invalid, K_Message_Invalid_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

   when PROGRAM_ERROR =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("Program Error raised in Text_Restrict_CB.");

      --
      -- Inform the user that there was a problem with this attempted
      -- text change...
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget), Xm.DIALOG_QUESTION,
	  K_Title_String_Invalid, K_Message_Invalid_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

   when STORAGE_ERROR =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("Storage Error raised in Text_Restrict_CB.");

      --
      -- Inform the user that there was a problem with this attempted
      -- text change...
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget), Xm.DIALOG_QUESTION,
	  K_Title_String_Invalid, K_Message_Invalid_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

   when TASKING_ERROR =>

      --
      -- Veto the changes to the text widget; widget contents will be unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("Tasking Error raised in Text_Restrict_CB.");

      --
      -- Inform the user that there was a problem with this attempted
      -- text change...
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget), Xm.DIALOG_QUESTION,
	  K_Title_String_Invalid, K_Message_Invalid_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

   when OTHERS =>

      --
      -- Veto the changes to the text widget; widget contents will be
      -- unchanged.
      --
      CBS.DoIt := Xt.XtFalse;

--      --
--      -- Print out useful debugging information...
--      --
--      Text_IO.Put_Line ("Unknown exception raised in Text_Restrict_CB.");

      --
      -- Inform the user that there was a problem with this attempted
      -- text change...
      --
      Response_Character := Motif_Utilities.Prompt_User (
	Motif_Utilities.Get_Shell (Text_Widget), Xm.DIALOG_QUESTION,
	  K_Title_String_Invalid, K_Message_Invalid_String,
	    "", ASCII.NUL, " OK ", 'O', "", ASCII.NUL);

end Text_Restrict_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   06/27/94   D. Forrest
--      - Initial version
--
-- --

