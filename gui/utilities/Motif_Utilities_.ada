--                           U N C L A S S I F I E D
--
--  *=======================================================================*
--  |                                                                       |
--  |                        Manned Flight Simulator                        |
--  |               Naval Air Warfare Center Aircraft Division              |
--  |                       Patuxent River, Maryland                        |
--  |                                                                       |
--  *=======================================================================*
--

----------------------------------------------------------------------------
--                                                                        --
--                        Manned Flight Simulator                         --
--                        Bldg 2035                                       --
--                        Patuxent River, MD 20670                        --
--                                                                        --
--      Title:                                                            --
--          ADIS/motif_utilities.a                                        --
--                                                                        --
--      Description:                                                      --
--          This file contains the motif utilities source code.           --
--                                                                        --
--      History:                                                          --
--          23 Nov 93     Daryl Forrest (J.F. Taylor, Inc.)  v1.0         --
--                            Initial version.                            --
--                                                                        --
----------------------------------------------------------------------------

with Language;
with System;
with Unchecked_Conversion;
with Unchecked_Deallocation;
with Xlib;
with XlibR5;
with Xt;
with XtR5;
with Xm;

package Motif_Utilities is

   K_Help_String_Max : constant INTEGER := 512; -- Max chars in help string

   ---------------------------------------------------------
   --                                                     --
   -- Constant declarations.                              --
   --                                                     --
   ---------------------------------------------------------
   --
   -- Widget Separation constants
   --
   WIDGET_SEPARATION         : constant INTEGER := 15;
   WIDGET_SEPARATION_TIGHT   : constant INTEGER := 10;
   WIDGET_SEPARATION_TIGHTER : constant INTEGER := 5;

   --
   -- Menu Item Maximum String Length Constants
   --
   MENU_ITEM_LABEL_MAX       : constant := 80;
   MENU_ITEM_ACCELERATOR_MAX : constant := 32;
   MENU_ITEM_ACCEL_TEXT_MAX  : constant := 32;

   --
   -- Motif 1.2 constants missing from the Xm and Xmdef packages
   --
   K_XmdefNchildPlacement    : constant STRING
     := "childPlacement" & ASCII.NUL;
   K_XmPLACE_TOP             : constant INTEGER := 0;
   K_XmPLACE_ABOVE_SELECTION : constant INTEGER := 1;
   K_XmPLACE_BELOW_SELECTION : constant INTEGER := 2;


   ---------------------------------------------------------
   --                                                     --
   -- Type declarations.                                  --
   --                                                     --
   ---------------------------------------------------------

   --
   -- Declare a type of pointer to Xt.WIDGET
   --
   type AWIDGET is access Xt.WIDGET;

   --
   -- Menu Item types
   --
   type MENU_ITEM_ARRAY;
   type MENU_ITEM_ARRAY_PTR is access MENU_ITEM_ARRAY;
   type MENU_ITEM_REC is
   record
      Label       : STRING(1..MENU_ITEM_LABEL_MAX);
      Class       : Xt.WIDGETCLASS;
      Sensitive   : BOOLEAN;
      Mnemonic    : CHARACTER;
      Accelerator : STRING(1..MENU_ITEM_ACCELERATOR_MAX);
      Accel_Text  : STRING(1..MENU_ITEM_ACCEL_TEXT_MAX);
      Callback    : Xt.CALLBACKPROC;     -- callback procedure pointer
      CB_Data     : Xt.POINTER;          -- callback data pointer
      Subitems    : MENU_ITEM_ARRAY_PTR; -- ptr to submenu MENU_ITEM_ARRAY
      Item_Widget : AWIDGET;             -- pointer to menu widget
   end record;
   type MENU_ITEM_ARRAY is array (INTEGER range <>) of MENU_ITEM_REC;
   function ADDRESS_TO_MENU_ITEM_ARRAY_PTR is
     new UNCHECKED_CONVERSION (System.ADDRESS, MENU_ITEM_ARRAY_PTR);

   --
   -- Text Restrict types
   --
   type TEXT_RESTRICTION_ENUM is (

     -- Input text consists of integers 1..n
     TEXT_NUMERIC_INTEGER_POSITIVE,    

     -- Input text consists of integers 0..n
     TEXT_NUMERIC_INTEGER_NONNEGATIVE,

     -- Input text consists of integers -n..n
     TEXT_NUMERIC_INTEGER,

     -- Input text consists of hexadecimal digits (01234567890ABCDEF).
     TEXT_NUMERIC_HEXADECIMAL, -- must be non-negative

     -- Input text consists of binary digits (01).
     TEXT_NUMERIC_BINARY,  -- must be non-negative

     -- Input text consists of floating point values 0.00000...1 .. n.n
     TEXT_NUMERIC_FLOAT_POSITIVE,

     -- Input text consists of floating point values 0 .. n.n
     TEXT_NUMERIC_FLOAT_NONNEGATIVE,

     -- Input text consists of floating point values -n.n .. n.n
     TEXT_NUMERIC_FLOAT,

     -- Input text consists of letters and whitespace only
     TEXT_ALPHABETIC,         

     -- Input text consists of letters, whitespace, and numeric digits
     TEXT_ALPHANUMERIC,

     -- Input text can be anything (no restrictions)
     TEXT_ANY
   );

   type TEXT_RESTRICTION_RECORD (
     Text_Type_Enum : TEXT_RESTRICTION_ENUM := TEXT_ANY) is
     record

        Characters_Count : INTEGER := INTEGER'LAST;

	case Text_Type_Enum is

	    when TEXT_NUMERIC_INTEGER | TEXT_NUMERIC_INTEGER_POSITIVE
	      | TEXT_NUMERIC_INTEGER_NONNEGATIVE 
	       | TEXT_NUMERIC_HEXADECIMAL | TEXT_NUMERIC_BINARY =>

	       Minimum_Valid_Integer : INTEGER := INTEGER'first;
	       Maximum_Valid_Integer : INTEGER := INTEGER'last;

	    when TEXT_NUMERIC_FLOAT | TEXT_NUMERIC_FLOAT_POSITIVE
	      | TEXT_NUMERIC_FLOAT_NONNEGATIVE =>

	       Minimum_Valid_Float : FLOAT := FLOAT'small;
	       Maximum_Valid_Float : FLOAT := FLOAT'large;

	    when TEXT_ALPHABETIC | TEXT_ALPHANUMERIC | TEXT_ANY =>
	       null;

	    when OTHERS =>
	       null;

	end case;

   end record;

   type ATEXT_RESTRICTION_RECORD is access TEXT_RESTRICTION_RECORD;

   function ATEXT_RESTRICTION_RECORD_to_XtPOINTER is new
     Unchecked_Conversion (Source => ATEXT_RESTRICTION_RECORD,
			   Target => Xt.POINTER);

   type TEXT_VALUE_TYPE is (
     TYPE_INTEGER,
     TYPE_FLOAT,
     TYPE_CHARACTER);

   type TEXT_VALUE_RESTRICTIONS_RECORD (
     Value_Type : TEXT_VALUE_TYPE := TYPE_CHARACTER) is
       record
	  Decimal_Point_Allowed : BOOLEAN := TRUE;
	  Negative_Sign_Allowed : BOOLEAN := TRUE;

	  case Value_Type is
	      when TYPE_INTEGER =>
		 Minimum_Integer_Allowed : INTEGER := INTEGER'first;
		 Maximum_Integer_Allowed : INTEGER := INTEGER'last;
	      when TYPE_FLOAT =>
		 Minimum_Float_Allowed : FLOAT := FLOAT'small;
		 Maximum_Float_Allowed : FLOAT := FLOAT'large;
	      when TYPE_CHARACTER =>
		 Minimum_Character_Allowed : CHARACTER := CHARACTER'first;
		 Maximum_Character_Allowed : CHARACTER := CHARACTER'last;
	  end case;
       end record;
   type ATEXT_VALUE_RESTRICTIONS_RECORD
     is access TEXT_VALUE_RESTRICTIONS_RECORD;
   procedure Free is new Unchecked_Deallocation (
     TEXT_VALUE_RESTRICTIONS_RECORD, ATEXT_VALUE_RESTRICTIONS_RECORD);

   ---------------------------------------------------------
   --                                                     --
   -- Overload operators for various X types.             --
   --                                                     --
   ---------------------------------------------------------
   function "=" (Left, Right: Xlib.POINTER) return BOOLEAN 
     renames Xlib."=";
   function "=" (Left, Right: Xm.STRINGCOMPONENTTYPE) return BOOLEAN 
     renames Xm."=";
   function "=" (Left, Right: Xlib.XID) return BOOLEAN 
     renames Xlib."=";
   function "=" (Left, Right: Xt.WIDGETCLASS) return BOOLEAN 
     renames Xt."=";
   function "<" (Left, Right: Xm.TEXTPOSITION) return BOOLEAN 
     renames Xm."<";
   function ">" (Left, Right: Xm.TEXTPOSITION) return BOOLEAN 
     renames Xm.">";


--
-- Example of Ada cade to mask out bits of an unsigned long.
--
--      Temp_Keysym := Xlib.KEYSYM (Xlib."and" (Xlib.UnsignedLong(Temp_Keysym),
--        Xlib.UnsignedLong(16#0000_FFFF#)));


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Create_Label ()                         --
   --                                                     --
   -- PURPOSE:    This function creates a label with the  --
   --             passed label parented to the passed     --
   --             parent.                                 --
   --                                                     --
   -- PARAMETERS: Parent - parent widget of label.        --
   --             Label  - label string for label.        --
   --                                                     --
   -- RETURNS:    Xt.WIDGET                               --
   --                                                     --
   ---------------------------------------------------------
   function Create_Label (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING) return Xt.WIDGET;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Create_Pushbutton ()                    --
   --                                                     --
   -- PURPOSE:    This function creates a pushbutton with --
   --             the passed label parented to the passed --
   --             parent.                                 --
   --                                                     --
   -- PARAMETERS: Parent - parent widget of label.        --
   --             Label  - label string for label.        --
   --                                                     --
   -- RETURNS:    pushbutton widget : Xt.WIDGET           --
   --                                                     --
   ---------------------------------------------------------
   function Create_Pushbutton (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING) return Xt.WIDGET;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Create_Togglebutton ()                  --
   --                                                     --
   -- PURPOSE:    This function creates a togglebutton    --
   --             with the passed label parented to the   --
   --             passed parent.                          --
   --                                                     --
   -- PARAMETERS: Parent - parent widget of label.        --
   --             Label  - label string for label.        --
   --                                                     --
   -- RETURNS:    togglebutton widget : Xt.WIDGET         --
   --                                                     --
   ---------------------------------------------------------
   function Create_Togglebutton (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING) return Xt.WIDGET;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Get_Shell ()                            --
   --                                                     --
   -- PURPOSE:    This function returns the first shell   --
   --             parent of the passed widget.            --
   --                                                     --
   -- PARAMETERS: Widget  - widget in hierarchy.          --
   --                                                     --
   ---------------------------------------------------------
   function Get_Shell (Widget: in Xt.WIDGET := Xt.XNULL) return Xt.WIDGET;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Get_Topshell ()                         --
   --                                                     --
   -- PURPOSE:    This function returns the first WMshell --
   --             parent of the passed widget.            --
   --                                                     --
   -- PARAMETERS: Widget  - widget in hierarchy.          --
   --                                                     --
   ---------------------------------------------------------
   function Get_Topshell (Widget: in Xt.WIDGET := Xt.XNULL) return Xt.WIDGET;


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Display_Message ()                      --
   --                                                     --
   -- PURPOSE:    This procedure creates a dialog         --
   --             displaying the passed message, with     --
   --             the passed title. Pressing the dialog's --
   --             only button unmanages it.               --
   --                                                     --
   -- PARAMETERS: Parent  - parent widget of dialog.      --
   --             Title   - Message dialog title.         --
   --             Message - Message dislog message.       --
   --                                                     --
   ---------------------------------------------------------
   procedure Display_Message (
      Parent : in     Xt.WIDGET := Xt.XNULL;
      Title  : in     STRING;
      Message: in     STRING);


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Set_Cursor ()                           --
   --                                                     --
   -- PURPOSE:    This procedure sets the cursor of the   --
   --             window of the passed widget to the      --
   --             passed cursor id.                       --
   --                                                     --
   -- PARAMETERS: Parent    - parent widget of dialog.    --
   --             Cursor_ID - id of cursor.               --
   --                         see file "/usr/include/X11/ --
   --                         cursorfont.h" for a list of --
   --                         available cursors.          --
   --                                                     --
   ---------------------------------------------------------
   procedure Set_Cursor (
      Parent   : in     Xt.WIDGET := Xt.XNULL;
      Cursor_ID: in     INTEGER);


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Set_Labelstring ()                      --
   --                                                     --
   -- PURPOSE:    This procedure sets the labelString     --
   --             resource of the passed widget to the    --
   --             passed string.                          --
   --                                                     --
   -- PARAMETERS: Widget - windget for which label is to  --
   --                      be set.                        --
   --             Label  - label sting.                   --
   --                                                     --
   ---------------------------------------------------------
   procedure Set_Labelstring (
      Widget: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING);

    
   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Get_Labelstring ()                      --
   --                                                     --
   -- PURPOSE:    This function returns the label string  --
   --             of the passed widget.                   --
   --                                                     --
   -- PARAMETERS: Widget - windget for which label is to  --
   --                      be set.                        --
   --             Label  - label sting.                   --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Labelstring (
      Widget : in     Xt.WIDGET := Xt.XNULL;
      Label  :    out STRING);


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Make_Color ()                           --
   --                                                     --
   -- PURPOSE:    This function returns the pixel colormap--
   --             entry associated with the color         --
   --             color_name in the widget parent,        --
   --             allocating it if necessary.             --
   --             The returned value Pixel can be used to --
   --             set the XmNbackground and XmNforeground --
   --             widget resources.                       --
   --                                                     --
   -- PARAMETERS: Parent     - widget in hierarchy.       --
   --             Color_Name - string holding name of     --
   --                          color.                     --
   --                                                     --
   -- RETURNS:    Pixel                                   --
   --                                                     --
   ---------------------------------------------------------
   function Make_Color (
      Parent     : in     Xt.WIDGET;
      Color_Name : in     STRING) return Xlib.Pixel;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Prompt_User ()                          --
   --                                                     --
   -- PURPOSE:    This function presents the user with a  --
   --             prompt, and allows them to choose one   --
   --             of two choices (from input parms). The  --
   --             chosen response's mnemonmic is returned.--
   --                                                     --
   -- PARAMETERS: Parent        - parent widget of dialog.--
   --             Dialog_Type   - X/MOTIF dialog type:    --
   --                               Xm.DIALOG_ERROR,      --
   --                               Xm.DIALOG_INFORMATION,--
   --                               Xm.DIALOG_MESSAGE,    --
   --                               Xm.DIALOG_QUESTION,   --
   --                               Xm.DIALOG_WARNING,    --
   --                               Xm.DIALOG_WORKING.    --
   --             Title         - dialog title string.    --
   --             Prompt_String - dialog prompt string.   --
   --             Choice1       - choice 1 string.        --
   --             Mnemonic1     - mnemonic 1 char.        --
   --             Choice2       - choice 2 string.        --
   --             Mnemonic2     - mnemonic 2 char.        --
   --             Choice3       - choice 3 string.        --
   --             Mnemonic3     - mnemonic 3 char.        --
   --                                                     --
   -- RETURNS:    CHARACTER                               --
   --                                                     --
   ---------------------------------------------------------
   function Prompt_User (
      Parent        : in Xt.WIDGET := Xt.XNULL;
      Dialog_Type   : in INTEGER   := Xm.DIALOG_QUESTION;
      Title         : in STRING    := "User Prompt";
      Prompt_String : in STRING    := "Your Choice?";
      Choice1       : in STRING    := "1";
      Mnemonic1     : in CHARACTER := '1';
      Choice2       : in STRING    := "2";
      Mnemonic2     : in CHARACTER := '2';
      Choice3       : in STRING    := "3";
      Mnemonic3     : in CHARACTER := '3') return CHARACTER;

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Build_Menu ()                           --
   --                                                     --
   -- PURPOSE:    This function builds a menu based on    --
   --             the passed data of type                 --
   --             MENU_ITEM_STRUCT, parented to the       --
   --             passed widget parent.                   --
   --                                                     --
   --             If menu_type is Xm.MENU_PULLDOWN,       --
   --             parent should probably be a menubar     --
   --             widget.                                 --
   --                                                     --
   --             If menu_type is Xm.MENU_POPUP, be sure  --
   --             to either add a callback like:          --
   --               Xt.AddCallback (popup_parent_widget,  --
   --                 Xmdef.NinputCallback,               --
   --                 popup_post_callback'address,        --
   --                 popup_menu);                        --
   --             or an event handler like:               --
   --               Xt.AddEventHandler (                  --
   --                 popup_parent_widget,                --
   --                 Xlib.ButtonPressMask, FALSE,        --
   --                 popup_post_callback'address,        --
   --                 popup_menu);                        --
   --             to post the popup menu, as well as      --
   --             creating the appropriate menu button    --
   --             Xmdef.NactivateEvent (or whatever)      --
   --             callbacks.                              --
   --                                                     --
   -- PARAMETERS: Parent        - parent widget of dialog --
   --             Menu_Type     - menu type               --
   --             Menu_Title    - X/MOTIF dialog type     --
   --             Menu_Mnemonic - dialog title string     --
   --             Menu_Sensitivity - menu sensitivity     --
   --             Items         - dialog prompt string    --
   --             Return_Widget - created cascade or menu.--
   --                                                     --
   ---------------------------------------------------------
   procedure Build_Menu (
      Parent           : in     Xt.WIDGET;
      Menu_Type        : in     INTEGER;
      Menu_Title       : in     STRING;
      Menu_Mnemonic    : in     CHARACTER;
      Menu_Sensitivity : in     BOOLEAN;
      Items            : in out MENU_ITEM_ARRAY;
      Return_Widget    :    out Xt.WIDGET);


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Build_Menu_Item ()                      --
   --                                                     --
   -- PURPOSE:    This function assembles a MENU_ITEM_REC --
   --             from a list of parameters. This is an   --
   --             optional convenience function.          --
   --                                                     --
   -- PARAMETERS: Label       - the menu item label       --
   --             Class       - the menu item widget class--
   --             Sensitive   - the menu item sensitivity --
   --             Mnemonic    - the menu item mnemonic    --
   --             Accelerator - the menu item accelerator --
   --             Accel_Text  - the accelerator text      --
   --             Callback    - the menu item callback    --
   --             CB_Data     - the callback data         --
   --             Subitems    - the menu item subitems ptr--
   --             Item_Widget - the menu item (out) widget--
   --             Menu_Item   - the destination record    --
   --                                                     --
   ---------------------------------------------------------
   procedure Build_Menu_Item (
      Label       : in     STRING;
      Class       : in     Xt.WIDGETClass;
      Sensitive   : in     BOOLEAN;
      Mnemonic    : in     CHARACTER;
      Accelerator : in     STRING;
      Accel_text  : in     STRING;
      Callback    : in     Xt.CallbackProc;     -- callback procedure pointer
      CB_Data     : in     Xt.Pointer;          -- callback data pointer
      Subitems    : in     MENU_ITEM_ARRAY_PTR; -- ptr to MENU_ITEM_ARRAY
      Item_Widget : in     AWIDGET;             -- pointer to menu widget
      Menu_Item   :    out MENU_ITEM_REC);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Active_Help
   --
   -- PURPOSE:
   --   This procedure installs active help for the specified widget.      
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Install_Active_Help(
      Parent                      : in out Xt.WIDGET;
      Help_Text_Widget            : in out Xt.WIDGET;
      Help_Text_Message           : in     STRING);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Help_Field_EH
   --
   -- PURPOSE:
   --   This procedure updates the text widget passed into Help_Text_Widget
   --   with the string held in the User_Data field of the callback's
   --   parent widget.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Update_Help_Field_EH(
      Parent                      : in     Xt.WIDGET;
      Help_Text_String            : in out Xt.POINTER;
      Event                       : in out Xlib.EVENT;
      Continue_To_Dispatch_Return : in out BOOLEAN);


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Text_Restrictions
   --
   -- PURPOSE:
   --   This callback function restricts the passed text widget to only
   --   accept as valid input text matching the passed criteria.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Install_Text_Restrictions(
      Parent           : in     Xt.WIDGET;
      Text_Type        : in     Motif_Utilities.TEXT_RESTRICTION_ENUM;
      Characters_Count : in     INTEGER);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Text_Restrictions_With_Integer_Range
   --
   -- PURPOSE:
   --   This callback function restricts the passed text widget to only
   --   accept as valid input text matching the passed criteria.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Install_Text_Restrictions_With_Integer_Range(
      Parent           : in     Xt.WIDGET;
      Text_Type        : in     Motif_Utilities.TEXT_RESTRICTION_ENUM;
      Characters_Count : in     INTEGER;
      Minimum_Integer  : in     INTEGER;
      Maximum_Integer  : in     INTEGER);

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Text_Restrictions_With_Float_Range
   --
   -- PURPOSE:
   --   This callback function restricts the passed text widget to only
   --   accept as valid input text matching the passed criteria.
   --
   -- IMPLEMENTATION NOTES:
   --   None.
   --
   -- EXCEPTIONS:
   --   None.
   --
   -------------------------------------------------------------------------
   procedure Install_Text_Restrictions_With_Float_Range(
      Parent           : in     Xt.WIDGET;
      Text_Type        : in     Motif_Utilities.TEXT_RESTRICTION_ENUM;
      Characters_Count : in     INTEGER;
      Minimum_Float    : in     FLOAT;
      Maximum_Float    : in     FLOAT);


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Integer_From_Text_Widget            --
   --                                                     --
   -- PURPOSE:    This procedure returns the integer      --
   --             equivalent of the text contained in the --
   --             passed text widget, via the passed      --
   --             parameter Return_Integer. A BOOLEAN     --
   --             True is returned in Success if the      --
   --             procedure can extract an integer, and   --
   --             False is returned if it fails (i.e. the --
   --             text widget in null, empty, or contains --
   --             an invalid integer string.              --
   --                                                     --
   -- PARAMETERS: Text_Widget    - The widget holding the --
   --                              integer string.        --
   --             Return_Integer - The extracted integer. --
   --             Success        - Procedure success or   --
   --                              failure status.        --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Integer_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Float_From_Text_Widget              --
   --                                                     --
   -- PURPOSE:    This procedure returns the float        --
   --             equivalent of the text contained in the --
   --             passed text widget, via the passed      --
   --             parameter Return_Float. A BOOLEAN       --
   --             True is returned in Success if the      --
   --             procedure can extract a float, and      --
   --             False is returned if it fails (i.e. the --
   --             text widget in null, empty, or contains --
   --             an invalid float string.                --
   --                                                     --
   -- PARAMETERS: Text_Widget  - The widget holding the   --
   --                            integer string.          --
   --             Return_Float - The extracted float.     --
   --             Success      - Procedure success or     --
   --                            failure status.          --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Float_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out FLOAT;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Hexadecimal_From_Text_Widget        --
   --                                                     --
   -- PURPOSE:    This procedure returns the integer      --
   --             equivalent of the hexadecimal text con- --
   --             tained in the passed text widget, via   --
   --             the passed parameter Return_Integer. A  --
   --             BOOLEAN True is returned in Success if  --
   --             the procedure can extract an integer,   --
   --             and False is returned if it fails (i.e. --
   --             the text widget in null, empty, or      --
   --             contains an invalid hexadecimal string. --
   --                                                     --
   -- PARAMETERS: Text_Widget    - The widget holding the --
   --                              hexadecimal string.    --
   --             Return_Integer - The extracted integer. --
   --             Success        - Procedure success or   --
   --                              failure status.        --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Hexadecimal_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Get_Binary_From_Text_Widget             --
   --                                                     --
   -- PURPOSE:    This procedure returns the integer      --
   --             equivalent of the binary text con-      --
   --             tained in the passed text widget, via   --
   --             the passed parameter Return_Integer. A  --
   --             BOOLEAN True is returned in Success if  --
   --             the procedure can extract an integer,   --
   --             and False is returned if it fails (i.e. --
   --             the text widget in null, empty, or      --
   --             contains an invalid binary string.      --
   --                                                     --
   -- PARAMETERS: Text_Widget    - The widget holding the --
   --                              binary string.         --
   --             Return_Integer - The extracted integer. --
   --             Success        - Procedure success or   --
   --                              failure status.        --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Binary_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Set_Boolean_Value_CB                    --
   --                                                     --
   -- PURPOSE:    This procedure sets the value of        --
   --             the Boolean variable in the client_data --
   --             parameter (named Boolean_Value here)    --
   --             to the value in the userData field of   --
   --             the activating button.                  --
   --                                                     --
   -- PARAMETERS: Parent        - The activating widget.  --
   --             Boolean_Value - The BOOLEAN variable    --
   --                             whose value is to be    --
   --                             set herein.             --
   --             CBS           - The callback struct.    --
   --                                                     --
   ---------------------------------------------------------
   procedure Set_Boolean_Value_CB (
      Parent        : in     Xt.WIDGET;
      Boolean_Value : in out INTEGER;
      CBS           : in out Xm.ANYCALLBACKSTRUCT_PTR);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Set_Integer_Value_CB                    --
   --                                                     --
   -- PURPOSE:    This procedure sets the value of        --
   --             the Integer variable in the client_data --
   --             parameter (named Integer_Value here)    --
   --             to the value in the userData field of   --
   --             the activating button.                  --
   --                                                     --
   -- PARAMETERS: Parent        - The activating widget.  --
   --             Integer_Value - The INTEGER variable    --
   --                             whose value is to be    --
   --                             set herein.             --
   --             CBS           - The callback struct.    --
   --                                                     --
   ---------------------------------------------------------
   procedure Set_Integer_Value_CB (
      Parent        : in     Xt.WIDGET;
      Integer_Value : in out INTEGER;
      CBS           : in out Xm.ANYCALLBACKSTRUCT_PTR);

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Destroy_Widget_CB                       --
   --                                                     --
   -- PURPOSE:    This procedure calls Xt.DestroyWidget   --
   --             on the Widget_To_Be_Destroyed parameter.--
   --                                                     --
   -- PARAMETERS: Parent        - The activating widget.  --
   --             Widget_To_Be_Destroyed - The widget     --
   --                to be destroyed.                     --
   --             CBS           - The callback struct.    --
   --                                                     --
   ---------------------------------------------------------
   procedure Destroy_Widget_CB (
      Parent                 : in     Xt.WIDGET;
      Widget_To_Be_Destroyed : in     Xt.WIDGET;
      CBS                    : in out Xm.ANYCALLBACKSTRUCT_PTR);

   ---------------------------------------------------------
   --                                                     --
   -- Re-import XmTextSetInsertionPosition since Verdix   --
   -- botched it...                                       --
   --                                                     --
   ---------------------------------------------------------
   procedure XmTextSetInsertionPosition(
      widget   : in     Xt.Widget;
      position : in     Xm.TextPosition );
   pragma INTERFACE(C,   XmTextSetInsertionPosition);
   pragma INTERFACE_NAME(XmTextSetInsertionPosition,
     Language.C_SUBP_PREFIX &    "XmTextSetInsertionPosition");

private

    type PROMPT_DATA_STRUCT is record
	Grabbed_Widget : Xt.WIDGET;
	Choice         : CHARACTER;
	Mnemonic1      : CHARACTER;
	Mnemonic2      : CHARACTER;
	Mnemonic3      : CHARACTER;
    end record;

    type APROMPT_DATA_STRUCT is access PROMPT_DATA_STRUCT;
    function APROMPTDATA_to_XtPointer is
	new UNCHECKED_CONVERSION (APROMPT_DATA_STRUCT, Xt.POINTER);

    K_Prompt_No_Choice : constant CHARACTER := ASCII.ESC;
    K_Xt_Allevents     : constant Xt.EVENTMASK := Xt.EVENTMASK (-1);


   ---------------------------------------------------------
   --                                                     --
   -- PRIVATE                                             --
   -- FUNCTION:   Create_Widget ()                        --
   --                                                     --
   -- PURPOSE:    This function creates a label with the  --
   --             passed label parented to the passed     --
   --             parent.                                 --
   --                                                     --
   -- PARAMETERS: Parent - parent widget of label.        --
   --             Label  - label string for label.        --
   --             Class  - class of widget to create.     --
   --                                                     --
   -- RETURNS:    label widget : Xt.WIDGET                --
   --                                                     --
   ---------------------------------------------------------
   function Create_Widget (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING;
      Class : in     Xt.WIDGETCLASS) return Xt.WIDGET;


   ---------------------------------------------------------
   --                                                     --
   -- PRIVATE                                             --
   -- FUNCTION:   prompt_response ()                      --
   --                                                     --
   ---------------------------------------------------------
   procedure Prompt_Response (
      W            : in     Xt.WIDGET;
      Aprompt_Data : in out APROMPT_DATA_STRUCT;
      CBS          : in out Xm.ANYCALLBACKSTRUCT_PTR);


   ---------------------------------------------------------
   --                                                     --
   -- PRIVATE                                             --
   -- FUNCTION:   prompt_handle_event ()                  --
   --                                                     --
   ---------------------------------------------------------
   procedure Prompt_Handle_Event (
      Parent                      : in     Xt.WIDGET;
      Aprompt_Data                : in out APROMPT_DATA_STRUCT;
      Event                       : in out Xlib.EVENT;
      Continue_To_Dispatch_Return : out BOOLEAN);

   ---------------------------------------------------------
   --                                                     --
   -- PRIVATE                                             --
   -- FUNCTION:   Text_Restrict_CB                        --
   --                                                     --
   -- CALLED BY: Install_Text_Restrictions                --
   --                                                     --
   ---------------------------------------------------------
   procedure Text_Restrict_CB(
      Text_Widget        : in     Xt.WIDGET;
      Text_Restrictions  : in out Motif_Utilities.ATEXT_RESTRICTION_RECORD;
      cbs                : in out Xm.TEXTVERIFYCALLBACKSTRUCT_PTR);

end Motif_Utilities;

