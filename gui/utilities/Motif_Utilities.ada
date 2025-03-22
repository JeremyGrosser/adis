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

with Character_Type;
with BasicTypes;
with Text_IO;
with Utilities;
with Xlib;
with XlibR5;
with Xm;
with Xmdef;
with Xtdef;
with Xt;
with XtR5;

package body Motif_Utilities is
 
   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Create_Label ()                         --
   --                                                     --
   -- PURPOSE:    This function creates a Label with the  --
   --             passed Label Parented to the passed     --
   --             Parent.                                 --
   --                                                     --
   -- PARAMETERS: Parent - Parent widget of Label.        --
   --             Label  - Label string for Label.        --
   --                                                     --
   -- RETURNS:    Label widget : Xt.WIDGET                --
   --                                                     --
   ---------------------------------------------------------
   function Create_Label (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING) return Xt.WIDGET is

      Label_widget: Xt.WIDGET;

   begin

      if (Parent /= Xt.XNULL) then
         Label_widget := Create_Widget (Parent, Label, Xm.LabelWidgetClass);
         return (Label_widget);
      end if;

   end Create_Label;

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Create_Pushbutton ()                    --
   --                                                     --
   -- PURPOSE:    This function creates a pushbutton with --
   --             the passed Label Parented to the passed --
   --             Parent.                                 --
   --                                                     --
   -- PARAMETERS: Parent - Parent widget of pushbutton.   --
   --             Label  - Label string for pushbutton.   --
   --                                                     --
   -- RETURNS:    pushbutton widget : Xt.WIDGET           --
   --                                                     --
   ---------------------------------------------------------
   function Create_Pushbutton (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING) return Xt.WIDGET is

      Pushbutton_Widget: Xt.WIDGET;

   begin

      if (Parent /= Xt.XNULL) then
         Pushbutton_Widget := Create_Widget (Parent, Label,
           Xm.PushButtonWidgetClass);
         return (Pushbutton_Widget);
      end if;

   end Create_Pushbutton;

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Create_Togglebutton ()                  --
   --                                                     --
   -- PURPOSE:    This function creates a togglebutton    --
   --             with the passed Label Parented to the   --
   --             passed Parent.                          --
   --                                                     --
   -- PARAMETERS: Parent - Parent widget of togglebutton. --
   --             Label  - Label string for togglebutton. --
   --                                                     --
   -- RETURNS:    togglebutton widget : Xt.WIDGET         --
   --                                                     --
   ---------------------------------------------------------
   function Create_Togglebutton (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING) return Xt.WIDGET is

      Togglebutton_Widget: Xt.WIDGET;

   begin

      if (Parent /= Xt.XNULL) then
         Togglebutton_Widget := Create_Widget (Parent, Label,
           Xm.ToggleButtonWidgetClass);
         return (Togglebutton_Widget);
      end if;

   end Create_Togglebutton;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Create_Widget ()                        --
   --                                                     --
   -- PURPOSE:    This function creates a widget of the   --
   --             passed Class with the passed Label      --
   --             Parented to the passed Parent.          --
   --                                                     --
   -- PARAMETERS: Parent - Parent widget of Label.        --
   --             Label  - Label string for Label.        --
   --                                                     --
   -- RETURNS:    Label widget : Xt.WIDGET                --
   --                                                     --
   ---------------------------------------------------------
   function Create_Widget (
      Parent: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING;
      Class : in     Xt.WIDGETClass) return Xt.WIDGET is

      Nargs    : Xt.CARDINAL;
      Args     : Xt.ARGLIST (1..1);
      Widget   : Xt.WIDGET;
      Xmstring : Xm.XMSTRING;

   begin

      --
      -- Initialize widget to Xt.XNULL
      --
      Widget := Xt.XNULL;

      if (Parent /= Xt.XNULL) then
         --
         -- Convert the Label string into an X string.
         --
         Xmstring := Xm.StringCreateLtoR (Label, Xm.STRING_DEFAULT_CHARSET);

         --
         -- Put the Label arguments into an X Args structure.
         --
         Nargs := 1;
         Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NLabelString,
           Xt.POINTER (Xmstring));

         --
         -- Create the Label widget.
         --
         Widget := Xt.CreateManagedWidget ("Widget", Class, Parent, Args,
           Nargs);

         --
         -- Free the Label X string.
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Xmstring);

      end if;

      --
      -- Return the Label widget.
      --
      return Widget;

   end Create_Widget;

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Get_Shell ()                            --
   --                                                     --
   -- PURPOSE:    This function returns the first shell   --
   --             Parent of the passed widget.            --
   --                                                     --
   -- PARAMETERS: widget  - widget in hierarchy.          --
   --                                                     --
   ---------------------------------------------------------
   function Get_Shell (Widget: in Xt.WIDGET := Xt.XNULL) return Xt.WIDGET is

      Temp_Widget : Xt.WIDGET;

   begin

      --
      --  "Back up" in widget hierarchy until a shell is found...
      --
      Temp_Widget := Widget;
      while ((Temp_Widget /= Xt.XNULL) and then
        (not Xt.IsShell (Temp_Widget))) loop
         Temp_Widget := Xt.Parent (Temp_Widget);
      end loop;

      --
      -- return pointer to shell widget
      --
      return (Temp_Widget);

   end Get_Shell;

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Get_Topshell ()                         --
   --                                                     --
   -- PURPOSE:    This function returns the first WMshell --
   --             Parent of the passed widget.            --
   --                                                     --
   -- PARAMETERS: widget  - widget in hierarchy.          --
   --                                                     --
   ---------------------------------------------------------
   function Get_Topshell (Widget: in Xt.WIDGET := Xt.XNULL) return Xt.WIDGET is

      Temp_Widget : Xt.WIDGET;

   begin

      --
      --  "Back up" in widget hierarchy until a shell is found...
      --
      Temp_Widget := Widget;
      while ((Temp_Widget /= Xt.XNULL) and then 
        (not Xt.IsWMShell (Temp_Widget))) loop
         Temp_Widget := Xt.Parent (Temp_Widget);
      end loop;

      --
      -- return pointer to shell widget
      --
      return (Temp_Widget);

   end Get_Topshell;

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Display_Message ()                      --
   --                                                     --
   -- PURPOSE:    This procedure creates a dialog         --
   --             displaying the passed message, with     --
   --             the passed Title. Pressing the dialog's --
   --             only button unmanages it.               --
   --                                                     --
   -- PARAMETERS: Parent  - Parent widget of dialog.      --
   --             Title   - Message dialog Title.         --
   --             message - Message dislog message.       --
   --                                                     --
   ---------------------------------------------------------
   procedure Display_Message (
      Parent  : in     Xt.WIDGET := Xt.XNULL;
      Title   : in     STRING;
      Message : in     STRING) is
   
      Temp_Xmstring    : Xm.XMSTRING;

      Arglist          : Xt.ARGLIST (1..9);
      Argcount         : Xt.INT;

      dialog_widget    : Xt.WIDGET;
      message_frame    : Xt.WIDGET;
      message_Label    : Xt.WIDGET;
      message_separator: Xt.WIDGET;
      ok_button        : Xt.WIDGET;

   begin

      --
      -- Ensure that Parent is non-null before building dialog.
      --
      if (Parent /= Xt.XNULL) then

         --
         -- Create the dialog
         --
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NTitle, Title);
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NresizePolicy, 
           INTEGER (Xm.RESIZE_GROW));
         dialog_widget := Xm.CreateFormDialog (Parent, Title, Arglist,
           Argcount);

         --
         -- Create the OK button
         --
         Temp_Xmstring := Xm.StringCreateSimple ("OK");
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NLabelString, Temp_Xmstring);
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.Nalignment, 
           INTEGER(Xm.ALIGNMENT_CENTER));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NtopAttachment, 
           INTEGER(Xm.ATTACH_NONE));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomAttachment, 
           INTEGER(Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomOffset, INTEGER(15));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NrightAttachment, 
           INTEGER(Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NrightOffset, INTEGER(15));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NleftAttachment, 
           INTEGER(Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NleftOffset, INTEGER(15));
         ok_button := Xt.CreateManagedWidget ("ok_button",
           Xm.PushButtonWidgetClass, dialog_widget, Arglist, Argcount);
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Temp_Xmstring);

         --
         -- Create the message/ OK button separator
         --
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.Norientation, 
           INTEGER(Xm.HORIZONTAL));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NtopAttachment, 
           INTEGER(Xm.ATTACH_NONE));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomAttachment,
           INTEGER(Xm.ATTACH_WIDGET));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomWidget, ok_button);
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomOffset, INTEGER(10));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NrightAttachment, 
           INTEGER(Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NrightOffset, INTEGER(15));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NleftAttachment, 
           INTEGER(Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NleftOffset, INTEGER(15));
         message_separator := Xt.CreateManagedWidget ("message_separator",
           Xm.SeparatorWidgetClass, dialog_widget, Arglist, Argcount);

         --
         -- Create the framed message field
         --
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NtopAttachment, 
           INTEGER (Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NtopOffset, INTEGER(15));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomAttachment, 
           INTEGER (Xm.ATTACH_WIDGET));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomWidget, 
           message_separator);
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NbottomOffset, INTEGER(10));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NrightAttachment, 
           INTEGER (Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NrightOffset, INTEGER(15));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NleftAttachment, 
           INTEGER (Xm.ATTACH_FORM));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NleftOffset, INTEGER(15));
         message_frame := Xt.CreateManagedWidget ("message_frame",
           Xm.FrameWidgetClass, dialog_widget, Arglist, Argcount);

         Temp_Xmstring := Xm.StringCreateLtoR (message, 
           Xm.STRING_DEFAULT_CHARSET);
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NLabelString, Temp_Xmstring);
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.Nalignment, 
           INTEGER (Xm.ALIGNMENT_CENTER));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NrecomputeSize, TRUE);
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NmarginWidth, INTEGER(15));
         Argcount := Argcount + 1;
         Xt.SetArg (Arglist(Argcount), Xmdef.NmarginHeight, INTEGER(15));
         message_Label := Xt.CreateManagedWidget ("message_Label",
           Xm.LabelWidgetClass, message_frame, Arglist, Argcount);
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Temp_Xmstring);

         Xt.ManageChild (dialog_widget);

      end if;

   end Display_Message;

   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Set_Cursor ()                           --
   --                                                     --
   -- PURPOSE:    This procedure sets the cursor of the   --
   --             window of the passed widget to the      --
   --             passed cursor id.                       --
   --                                                     --
   -- PARAMETERS: Parent    - Parent widget of dialog.    --
   --             Cursor_ID - id of cursor.               --
   --                         see file "/usr/include/X11/ --
   --                         cursorfont.h" for a list of --
   --                         available cursors.          --
   --                                                     --
   ---------------------------------------------------------
   procedure Set_Cursor (
      Parent   : in     Xt.WIDGET := Xt.XNULL;
      Cursor_ID: in     INTEGER) is

      Attributes: Xlib.SetWindowAttributes;

   begin

      --
      -- ensure that Parent widget is non-null
      --
      if (Parent /= Xt.XNULL) then

         --
         -- Get the cursor corresponding to the passed cursor id.
         --
         if (Cursor_ID = Xlib.None) then
            Attributes.window_cursor := Xlib.Cursor(Xlib.None);
         else
            Attributes.window_cursor := Xlib.CreateFontCursor (
              Xt.GetDisplay (Parent), Cursor_ID);
         end if;

         --
         -- Assign the cursor to its Parent widget.
         --
         Xlib.ChangeWindowAttributes (Xt.GetDisplay(Parent),
           Xt.WindowOfObject(Parent), Xlib.CWCursor, Attributes);

         --
         -- Flush the display of the Parent widget.
         --
         Xlib.Flush (Xt.GetDisplay(Parent));

      end if;

   end Set_Cursor;


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Set_Labelstring ()                      --
   --                                                     --
   -- PURPOSE:    This procedure sets the LabelString     --
   --             resource of the passed widget to the    --
   --             passed string.                          --
   --                                                     --
   -- PARAMETERS: widget - windget for which Label is to  --
   --                      be set.                        --
   --             Label  - Label sting.                   --
   --                                                     --
   ---------------------------------------------------------
   procedure Set_Labelstring (
      Widget: in     Xt.WIDGET := Xt.XNULL;
      Label : in     STRING) is

      type AXMSTRING is access Xm.XMSTRING;
      function AXMSTRING_to_XtPOINTER is
        new UNCHECKED_CONVERSION (AXMSTRING, Xt.POINTER);

      Temp_String   : STRING(1..256) := (OTHERS => ASCII.NUL);
      Temp_Boolean  : BOOLEAN := FALSE;
      Temp_Axmstring: AXMSTRING := NULL;
      Temp_Xmstring : Xm.XMSTRING;
      Context       : Xm.STRINGCONTEXT := Xt.XNULL;
      Context_Valid : BOOLEAN;
      Text          : Xm.STRING_PTR := NULL;
      Charset       : Xm.STRINGCHARSET(1..256) := (OTHERS => ASCII.NUL);
      Direction     : Xm.STRINGDIRECTION := Xm.STRING_DIRECTION_L_TO_R;
      Success       : BOOLEAN := FALSE;
      Arglist       : Xt.ARGLIST(1..9);
      Argcount      : Xt.CARDINAL := 0;

   begin

      --
      -- Make sure parameters are non-null...
      --
      if (widget /= Xt.XNULL) then

         Temp_Axmstring := new Xm.XMSTRING;
         Text := new STRING(1..256);
         Argcount := 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.NLabelString, 
           AXMSTRING_to_XtPOINTER(Temp_Axmstring));
         Xt.GetValues (Widget, Arglist, Argcount);

         Context_Valid := Xm.StringInitContext (Context, Temp_Axmstring.all);

         if (Context_Valid and (Context /= Xt.XNULL)) then
            Xm.StringGetNextSegment (Context, Text,
              Charset, Direction, Temp_Boolean, Success);
	    --
	    -- Don't free this (as you normally would), because Verdix Ada
	    -- may corrupt memory when you do...
	    --
            --Xm.StringFreeContext (Context);
         else
            Charset(1..Xm.STRING_DEFAULT_CHARSET'last) :=
              Xm.STRING_DEFAULT_CHARSET(1..Xm.STRING_DEFAULT_CHARSET'last);
         end if;

         --
         -- Fix for MOTIF bug specified in the
         -- release notes (motif_dev, 6.3.17).
         --
         if ((Temp_Axmstring /= NULL) and 
           ((Xm.IsRowColumn (widget) /= TRUE))) then

	    null;
	    --
	    -- Don't free this (as you normally would), because Verdix Ada
	    -- may corrupt memory when you do...
	    --
            --Xm.StringFree (Temp_Axmstring.all);

         end if;

         --
         -- Set the widget's Label, preserving the Char Set.
         --
         Temp_Xmstring := Xm.StringCreateLtoR (Label, Charset);
         if (Temp_Xmstring /= Xt.XNULL) then
            Argcount := 1;
            Xt.SetArg (Arglist(Argcount), Xmdef.NLabelString,
              Temp_Xmstring);
            Xt.SetValues (widget, Arglist, Argcount);
	    --
	    -- Don't free this (as you normally would), because Verdix Ada
	    -- may corrupt memory when you do...
	    --
            --Xm.StringFree (Temp_Xmstring);
         end if;

      end if;

   end Set_Labelstring;

   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Get_Labelstring ()                      --
   --                                                     --
   -- PURPOSE:    This function returns the Label string  --
   --             of the passed widget.                   --
   --                                                     --
   -- PARAMETERS: widget - widget for which Label is to   --
   --                      be set.                        --
   --                                                     --
   ---------------------------------------------------------
   procedure Get_Labelstring (
      Widget : in     Xt.WIDGET := Xt.XNULL;
      Label  :    out STRING) is

      type AXMSTRING is access Xm.XMSTRING;
      function AXMSTRING_to_XtPOINTER is
        new UNCHECKED_CONVERSION (AXMSTRING, Xt.POINTER);

      Preferred_Method_Fails : exception;
      Null_Axmstring         : exception;

      Temp_Label     : STRING(1..1024) := (OTHERS => ASCII.NUL);
      Temp_Axmstring : AXMSTRING := NULL;
      Context        : Xm.STRINGCONTEXT := Xt.XNULL;
      Context_Valid  : BOOLEAN;
      Text           : Xm.STRING_PTR := NULL;
      Charset        : Xm.STRINGCHARSET(1..256) := (OTHERS => ASCII.NUL);
      Direction      : Xm.STRINGDIRECTION := Xm.STRING_DIRECTION_L_TO_R;
      Unknown_Tag    : Xm.STRINGCOMPONENTTYPE := Xm.STRING_COMPONENT_UNKNOWN;
      Unknown_Length : Xm.UNSIGNEDSHORT := 0;
      Unknown_Value  : Xm.STRING_PTR := NULL;
      Component_Type : Xm.STRINGCOMPONENTTYPE := Xm.STRING_COMPONENT_UNKNOWN;
      Arglist        : Xt.ARGLIST(1..9);
      Argcount       : Xt.CARDINAL := 0;
      Success        : BOOLEAN;

   begin

      --
      -- Initialize variables
      --
      Context_Valid := FALSE;

      --
      -- Make sure parameters are non-null...
      --
      if (Widget /= Xt.XNULL) then

         Temp_Axmstring := new Xm.XMSTRING;

         --
         -- Retrieve the compound string from the widget
         --
         Argcount := 1;
         Xt.SetArg (Arglist (Argcount), Xmdef.NLabelString, 
           AXMSTRING_to_XtPOINTER(Temp_Axmstring));
         Xt.GetValues (Widget, Arglist, Argcount);

         --
         -- Extract the Ada string from the compound string.
         --
         if (Temp_Axmstring.all /= Xt.XtNULL) then
            Context_Valid := Xm.StringInitContext (Context, 
              Temp_Axmstring.all);
         else
            raise Null_Axmstring;
         end if;

         if (Context = Xt.XNULL) then
            raise Preferred_Method_Fails;
         end if;

         if ((Temp_Axmstring.all /= Xt.XtNULL) and (Context_Valid)) then

            Xm.StringGetNextComponent (Context, Text, Charset, Direction,
              Unknown_Tag, Unknown_Length, Unknown_Value, Component_Type);

            while (Component_Type /= 
              Xm.STRINGCOMPONENTTYPE (Xm.STRING_COMPONENT_END)) loop

               case Component_Type is
                  when Xm.STRING_COMPONENT_TEXT =>
                     Temp_Label := Temp_Label & Text.all;
		     -- Normally you free here, but Ada crashes when you do so
                     -- BasicTypes.FreeAdaString (Text);
                  when Xm.STRING_COMPONENT_SEPARATOR =>
                     Temp_Label := Temp_Label &
                       Utilities.K_String_Separator;
                  when Xm.STRING_COMPONENT_UNKNOWN =>
		     -- Normally you free here, but Ada crashes when you do so
                     -- BasicTypes.FreeAdaString (Unknown_Value);
                     NULL;
                  when Xm.STRING_COMPONENT_CHARSET =>
                     NULL;
                  when Xm.STRING_COMPONENT_DIRECTION =>
                     NULL;
                  when OTHERS =>
                     NULL;
               end case;

            end loop;

	    -- Normally you free here, but Ada crashes when you do so
            -- Xm.StringFreeContext (Context);

         else
            raise Preferred_Method_Fails;
         end if ;

      end if;

      Label(Label'first..Label'last) := Temp_Label(Label'first..Label'last);

      exception

         when Preferred_Method_Fails =>

            Xm.StringGetLtoR (Temp_Axmstring.all, Xm.STRING_DEFAULT_CHARSET,
              Text, Success);

            if (Success) then

               Label := (OTHERS => ASCII.NUL);
               if (Text'length > Label'length) then
                  Label := Text (Text'first..Text'first+Label'length-1);
               else
                  Label (Label'first..Label'first + Text'length - 1)
		    := Text.all;
               end if;
               Label(Label'last) := ASCII.NUL;
               return;

            else
               Label := "";
               return;
            end if;

         when Null_Axmstring =>

            Text_IO.Put_Line ("Label XMSTRING is NULL.");
            Label := "";
            return;

   end Get_Labelstring;


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Make_Color ()                           --
   --                                                     --
   -- PURPOSE:    This function returns the Pixel Colormap--
   --             entry associated with the Color         --
   --             Color_Name in the widget Parent,        --
   --             allocating it if necessary.             --
   --             The returned value Pixel can be used to --
   --             set the XmNbackground and XmNforeground --
   --             widget resources.                       --
   --                                                     --
   -- PARAMETERS: Parent     - widget in hierarchy.       --
   --             Color_Name - string holding name of     --
   --                          Color.                     --
   --                                                     --
   -- RETURNS:    Pixel                                   --
   --                                                     --
   ---------------------------------------------------------
   function Make_Color (
      Parent     : in     Xt.WIDGET;
      Color_Name : in     STRING) return Xlib.Pixel is

      type ACOLORMAP_TYPE is access Xlib.COLORMAP;
      function ACOLORMAP_to_XtPOINTER
        is new UNCHECKED_CONVERSION (ACOLORMAP_TYPE, Xt.POINTER);

      Acmap    : ACOLORMAP_TYPE;
      Display  : Xlib.Display;
      Color    : Xlib.Color;
      Unused   : Xlib.Color;
      Arglist  : Xt.ARGLIST(1..9);
      Argcount : Xt.CARDINAL := 0;
      Status   : BOOLEAN;

      Color_Status : Xlib.Status;

      begin

         Acmap := new Xlib.COLORMAP;

         --
         -- Retrieve the Colormap from the Parent widget.
         --
         Argcount := 0;
         Argcount := Argcount + 1;
         Xt.SetArg(Arglist (Argcount), Xmdef.NColormap, 
           ACOLORMAP_to_XtPOINTER(Acmap));
         Xt.GetValues(Parent, Arglist, Argcount);

	 Display := Xt.GetDisplay(Parent);
	 if (not Xlib."="(Display, Xlib.XNULL)) then

            Xlib.AllocNamedColor(Display, Acmap.all, Color_Name,
              Color, Unused, Status);

	 end if;

         return(Xlib.Pixel(Color.Pixel));

   end Make_Color;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Prompt_User ()                          --
   --                                                     --
   -- PURPOSE:    This function presents the user with a  --
   --             prompt, and allows them to choose one   --
   --             of up to thres Choices (from input      --
   --             parms). The chosen response's mnemonic  --
   --             is returned.                            --
   --                                                     --
   --             Parent        - Parent widget of dialog.--
   --             Dialog_Type   - X/MOTIF dialog type.    --
   --             Title         - dialog Title string.    --
   --             Prompt_String - dialog prompt string.   --
   --             Choice1       - Choice 1 string.        --
   --             Mnemonic1     - Mnemonic 1 char.        --
   --             Choice2       - Choice 2 string.        --
   --             Mnemonic2     - Mnemonic 2 char.        --
   --             Choice3       - Choice 3 string.        --
   --             Mnemonic3     - Mnemonic 3 char.        --
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
      Mnemonic3     : in CHARACTER := '3') return CHARACTER is

      function APROMPTDATA_to_INTEGER is
        new UNCHECKED_CONVERSION (APROMPT_DATA_STRUCT, INTEGER);

      Arglist          : Xt.ARGLIST(1..9);
      Argcount         : Xt.CARDINAL := 0;
      Prompt_Dialog    : Xt.WIDGET := Xt.XNULL;
      Aprompt_Data     : APROMPT_DATA_STRUCT;
      Choice           : CHARACTER;
      Choice1_Xmstring : Xm.XMSTRING;
      Choice2_Xmstring : Xm.XMSTRING;
      Choice3_Xmstring : Xm.XMSTRING;
      Accel1           : STRING(1..32);
      Accel2           : STRING(1..32);
      Accel3           : STRING(1..32);
      Accel1_Text      : STRING(1..32);
      Accel2_Text      : STRING(1..32);
      Accel3_Text      : STRING(1..32);
      Temp_Xmstring    : Xm.XMSTRING;
      Status_Int       : INTEGER;

   begin

      --
      -- Initialize the prompt_data structure
      --
      Aprompt_Data           := new PROMPT_DATA_STRUCT;
      Aprompt_Data.Choice    := K_Prompt_No_Choice;
      Aprompt_Data.Mnemonic1 := Mnemonic1;
      Aprompt_Data.Mnemonic2 := Mnemonic2;
      Aprompt_Data.Mnemonic3 := Mnemonic3;

      --
      -- Create the modal dialog.
      -- Add Callbacks for the Choice buttons.   
      --
      Argcount := 1;
      Xt.SetArg (Arglist(Argcount), Xmdef.NdialogStyle,
        INTEGER(Xm.DIALOG_APPLICATION_MODAL));
      Prompt_Dialog := Xm.CreateMessageDialog (Get_Topshell (Parent),
       "Prompt_Dialog", Arglist, Argcount);

      Xt.AddCallback (Prompt_Dialog, Xmdef.NokCallback, 
        Prompt_Response'address, APROMPTDATA_to_XtPOINTER(Aprompt_Data));
      Xt.AddCallback (Prompt_Dialog, Xmdef.NcancelCallback, 
        Prompt_Response'address, APROMPTDATA_to_XtPOINTER(Aprompt_Data));
      Xt.AddCallback (Prompt_Dialog, Xmdef.NhelpCallback, 
        Prompt_Response'address, APROMPTDATA_to_XtPOINTER(Aprompt_Data));

      Aprompt_Data.Grabbed_Widget := Prompt_Dialog;
      if (Prompt_Dialog = Xt.XNULL) then
         Text_IO.Put_Line ("Prompt_Dialog is NULL.");
      end if;

      --
      -- Set the dialog Title
      --
      Argcount := 1;
      Xt.SetArg (Arglist(Argcount), Xmdef.NTitle, Title);
      Xt.SetValues (Xt.Parent (Prompt_Dialog), Arglist, Argcount);

      --
      -- Set the dialog message string to the
      -- Prompt_String parameter, and set the Choice
      -- button strings to the appropriate Choice
      -- parameters.
      --
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist(Argcount), Xmdef.NdialogType, Dialog_Type);
      Argcount := Argcount + 1;
      Temp_Xmstring := Xm.StringCreateLtoR (Prompt_String,
	Xm.STRING_DEFAULT_CHARSET);
      Xt.SetArg (Arglist(Argcount), Xmdef.NmessageString, Temp_Xmstring);
      Xt.SetValues (Prompt_Dialog, Arglist, Argcount);
      --
      -- Don't free this (as you normally would), because Verdix Ada
      -- may corrupt memory when you do...
      --
      --Xm.StringFree (Temp_Xmstring);

      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist(Argcount), Xmdef.Nalignment,
	INTEGER(Xm.ALIGNMENT_CENTER));
      Xt.SetValues (
	Xm.MessageBoxGetChild(Prompt_Dialog, Xm.DIALOG_MESSAGE_LABEL),
	  Arglist, Argcount);


      --
      -- Setup Choice1 widgets if Choice1 is active.
      --
      if (Choice1 /= "") then
	 Argcount := 0;
         Argcount := Argcount + 1;
         Temp_Xmstring := Xm.StringCreateSimple (Choice1);
         Xt.SetArg (Arglist(Argcount), Xmdef.NokLabelString, Temp_Xmstring);
         Xt.SetValues (Prompt_Dialog, Arglist, Argcount);
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Temp_Xmstring);

         if (Mnemonic1 /= ASCII.NUL) then
            Argcount := 1;
            Xt.SetArg (Arglist(Argcount), Xmdef.NMnemonic,
              INTEGER(CHARACTER'pos(Mnemonic1)));
            Xt.SetValues (Xm.MessageBoxGetChild (Prompt_Dialog, 
              Xm.DIALOG_OK_BUTTON), Arglist, Argcount);
         end if;

         Xt.ManageChild (Xm.MessageBoxGetChild (Prompt_Dialog, 
           Xm.DIALOG_OK_BUTTON));
      else
         Xt.UnManageChild (Xm.MessageBoxGetChild (Prompt_Dialog, 
           Xm.DIALOG_OK_BUTTON));
      end if;

      --
      -- Setup Choice2 widgets if Choice1 is active.
      --
      if (Choice2 /= "") then
         Argcount := 1;
         Temp_Xmstring := Xm.StringCreateSimple (Choice2);
         Xt.SetArg (Arglist(Argcount), Xmdef.NcancelLabelString,
           Temp_Xmstring);
         Xt.SetValues (Prompt_Dialog, Arglist, Argcount);
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Temp_Xmstring);

         if (Mnemonic2 /= ASCII.NUL) then
            Argcount := 1;
            Xt.SetArg (Arglist(Argcount), Xmdef.NMnemonic,
              INTEGER(CHARACTER'pos(Mnemonic2)));
            Xt.SetValues (Xm.MessageBoxGetChild (Prompt_Dialog, 
              Xm.DIALOG_CANCEL_BUTTON), Arglist, Argcount);
         end if;

            Xt.ManageChild (Xm.MessageBoxGetChild (Prompt_Dialog, 
              Xm.DIALOG_CANCEL_BUTTON));
      else
         Xt.UnManageChild (Xm.MessageBoxGetChild (Prompt_Dialog, 
           Xm.DIALOG_CANCEL_BUTTON));
      end if;

      --
      -- Setup Choice3 widgets if Choice1 is active.
      --
      if (Choice3 /= "") then
         Argcount := 1;
         Temp_Xmstring := Xm.StringCreateSimple (Choice3);
         Xt.SetArg (Arglist(Argcount), Xmdef.NhelpLabelString, Temp_Xmstring);
         Xt.SetValues (Prompt_Dialog, Arglist, Argcount);
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Temp_Xmstring);

         if (Mnemonic3 /= ASCII.NUL) then
            Argcount := 1;
            Xt.SetArg (Arglist(Argcount), Xmdef.NMnemonic,
              INTEGER(CHARACTER'pos(Mnemonic3)));
            Xt.SetValues (Xm.MessageBoxGetChild (Prompt_Dialog, 
              Xm.DIALOG_HELP_BUTTON), Arglist, Argcount);
         end if;

         Xt.ManageChild (Xm.MessageBoxGetChild (Prompt_Dialog, 
           Xm.DIALOG_HELP_BUTTON));
      else
         Xt.UnManageChild (Xm.MessageBoxGetChild (Prompt_Dialog, 
           Xm.DIALOG_HELP_BUTTON));
      end if;

      --
      -- Manage, popup, and map the Prompt_Dialog.
      --
      Xt.ManageChild (Prompt_Dialog);
      Xt.Popup (Xt.Parent (Prompt_Dialog), Xt.GrabNone);
      Xlib.MapRaised (Xt.GetDisplay (Prompt_Dialog), 
        Xt.GetWindow (Prompt_Dialog));

      --
      -- Grab the keyboard and install a keyrelease Event handler.
      --
      Status_Int := Xlib.GrabKeyboard (
        Xt.GetDisplay (Aprompt_Data.Grabbed_Widget),
        Xt.GetWindow (Aprompt_Data.Grabbed_Widget),
        FALSE,
        Xlib.GrabModeAsync,
        Xlib.GrabModeAsync,
        Xlib.Time(Xlib.CurrentTime));
      Xt.InsertEventHandler (Aprompt_Data.Grabbed_Widget, 
        Xlib.KeyReleaseMask, FALSE, Prompt_Handle_Event'address,
        APROMPTDATA_to_XtPOINTER (Aprompt_Data), Xt.ListHead);

      --
      -- Force the user to respond before unmanaging the modal dialog.
      --
      GET_CHOICE_LOOP:
      while (Aprompt_Data.Choice = K_Prompt_No_Choice) loop
         Xt.AppProcessEvent (Xt.WidgetToApplicationContext (Prompt_Dialog),
           Xt.IMAll);
      end loop GET_CHOICE_LOOP;

      --
      -- Unmanage, popdown, and destroy the dialog.
      --
      Xt.UnManageChild (Xt.Parent (Prompt_Dialog));
      Xt.Popdown (Xt.Parent (Prompt_Dialog));
      Xt.DestroyWidget (Xt.Parent (Prompt_Dialog));

      --
      -- Remove the Event Handler and the Keyboard Grab
      --
      Xt.RemoveEventHandler (Aprompt_Data.Grabbed_Widget,
        K_Xt_Allevents, TRUE, Prompt_Response'address, 
        APROMPTDATA_to_XtPOINTER(Aprompt_Data));
      Xt.UngrabKeyboard (Aprompt_Data.Grabbed_Widget, 
        Xlib.Time(Xlib.CurrentTime));

      --
      -- Return the Mnemonic of the appropriate Choice button.
      --
      Choice := Aprompt_Data.Choice;
      return (Choice);

   end Prompt_User;

   ---------------------------------------------------------
   --                                                     --
   -- PRIVATE                                             --
   -- FUNCTION:   Prompt_Response ()                      --
   --                                                     --
   -- PURPOSE:    This function is the Callback for the   --
   --             above function "Prompt_User".           --
   --                                                     --
   -- PARAMETERS: Parent      - Parent widget.            --
   --             prompt_data - Choice data.              --
   --             cbs         - Callback data.            --
   --                                                     --
   ---------------------------------------------------------
   procedure Prompt_Response (
      w            : in     Xt.WIDGET;
      Aprompt_Data : in out APROMPT_DATA_STRUCT;
      cbs          : in out Xm.ANYCALLBACKSTRUCT_PTR) is
   begin

      --
      -- Return the Choice value of the chosen button.
      --
      case (cbs.reason) is

         when Xm.CR_OK =>
            Aprompt_Data.Choice := Aprompt_Data.Mnemonic1;

         when Xm.CR_CANCEL =>
            Aprompt_Data.Choice := Aprompt_Data.Mnemonic2;

         when Xm.CR_HELP =>
            Aprompt_Data.Choice := Aprompt_Data.Mnemonic3;

         when OTHERS =>
            Aprompt_Data.Choice := K_Prompt_No_Choice;

      end case;

   end Prompt_Response;

   ---------------------------------------------------------
   --                                                     --
   -- PRIVATE                                             --
   -- FUNCTION:   Prompt_Handle_Event ()                  --
   --                                                     --
   -- PURPOSE:    This function is the Callback for the   --
   --             above function "Prompt_User".           --
   --                                                     --
   -- PARAMETERS: Parent        - Parent widget.          --
   --             Prompt_Dialog - Prompt dialog widget.   --
   --             Event         - triggering X Event.     --
   --             continue_to_dispatch_return - BOOLEAN   --
   --                                                     --
   --                                                     --
   ---------------------------------------------------------
   procedure Prompt_Handle_Event (
      Parent       : in     Xt.WIDGET;
      Aprompt_Data : in out APROMPT_DATA_STRUCT;
      Event        : in out Xlib.EVENT;
      continue_to_dispatch_return : out BOOLEAN) is
   
      K_Temp_String_Length : constant INTEGER := 1;

      Temp_String        : STRING(1..K_Temp_String_Length);
      Temp_Character     : CHARACTER;
      Temp_KeySym        : Xlib.KeySym;
      Temp_ComposeStatus : Xlib.ComposeStatus;
      Temp_Int           : Xlib.Int;

   begin

      --
      -- Extract the character (STRING(1..K_Temp_String_Length)) 
      -- from the XKey Event
      -- 
      Xlib.LookupString (Event, Temp_String, Temp_String'length,
	Temp_KeySym, Temp_ComposeStatus, Temp_Int);

      --
      -- Convert the pressed key character to lowercase for case-insensitive
      -- comparison.
      --
      Temp_Character := Utilities.K_To_Lower(Temp_String(Temp_String'first));

      --
      -- If the pressed key matches mnemonic 1, then
      -- set the prompt data choice field to mnemonic 1.
      --
      if (Temp_Character = Utilities.K_To_Lower(Aprompt_Data.Mnemonic1)) then

         Aprompt_Data.Choice := Aprompt_Data.Mnemonic1;

      --
      -- If the pressed key matches mnemonic 2, then
      -- set the prompt data choice field to mnemonic 2.
      --
      elsif (Temp_Character = Utilities.K_To_Lower(Aprompt_Data.Mnemonic2)) then

         Aprompt_Data.Choice := Aprompt_Data.Mnemonic2;

      --
      -- If the pressed key matches mnemonic 3, then
      -- set the prompt data choice field to mnemonic 3.
      --
      elsif (Temp_Character = Utilities.K_To_Lower(Aprompt_Data.Mnemonic3)) then

         Aprompt_Data.Choice := Aprompt_Data.Mnemonic3;

      end if;

   end Prompt_Handle_Event;


   ---------------------------------------------------------
   --                                                     --
   -- FUNCTION:   Build_Menu ()                           --
   --                                                     --
   -- PURPOSE:    This function builds a Menu based on    --
   --             the passed data of type                 --
   --             MENU_ITEM_STRUCT, Parented to the       --
   --             passed widget Parent.                   --
   --                                                     --
   --             If Menu_Type is Xm.MENU_PULLDOWN,       --
   --             Parent should probably be a Menubar     --
   --             widget.                                 --
   --                                                     --
   --             If Menu_Type is Xm.MENU_POPUP, be sure  --
   --             to either add a Callback like:          --
   --               Xt.AddCallback (popup_Parent_widget,  --
   --                 Xmdef.NinputCallback,               --
   --                 popup_post_Callback'address,        --
   --                 popup_Menu);                        --
   --             or an Event handler like:               --
   --               Xt.AddEventHandler (                  --
   --                 popup_Parent_widget,                --
   --                 Xlib.ButtonPressMask, FALSE,        --
   --                 popup_post_Callback'address,        --
   --                 popup_Menu);                        --
   --             to post the popup Menu, as well as      --
   --             creating the appropriate Menu button    --
   --             Xmdef.NactivateEvent (or whatever)      --
   --             Callbacks.                              --
   --                                                     --
   -- PARAMETERS: Parent        - Parent widget of dialog --
   --             Menu_Type     - Menu type               --
   --             Menu_Title    - X/MOTIF dialog type     --
   --             Menu_Mnemonic - dialog Title string     --
   --             Menu_Sensitivity - Menu sensitivity     --
   --             Items         - dialog prompt string    --
   --                                                     --
   -- RETURNS:    Widget        - created Menu Cascade    --
   --                             button                  --
   --                                                     --
   ---------------------------------------------------------
   procedure Build_Menu (
      Parent           : in     Xt.WIDGET;
      Menu_Type        : in     INTEGER;
      Menu_Title       : in     STRING;
      Menu_Mnemonic    : in     CHARACTER;
      Menu_Sensitivity : in     BOOLEAN;
      Items            : in out MENU_ITEM_ARRAY;
      Return_Widget    :    out Xt.WIDGET) is

      K_Max_Args  : constant Xt.CARDINAL := 9;

      Menu        : Xt.WIDGET;
      Cascade     : Xt.WIDGET;
      Temp_Widget : Xt.WIDGET;

      Nargs       : Xt.CARDINAL;
      Args        : Xt.ARGLIST (1..K_Max_Args);
      Xmstring    : Xm.XMSTRING;

   begin

      --
      -- Return if Parent is NULL.
      -- 
      if (Parent = Xt.XNULL) then
	 Return_Widget := Xt.XNULL;
         return;
      end if;

      --
      -- Create the Menu.
      -- 
      if ((Menu_Type = Xm.MENU_PULLDOWN) or (Menu_Type = Xm.MENU_OPTION)) then
       
         Menu := Xm.CreatePulldownMenu (Parent, "pulldown", Args, 0);

      else

	 Menu := Xm.CreatePopupMenu (Parent, "popup", Args, 0);

      end if;

      --
      -- Create the Menu cascade or option menu
      -- 
      if (Menu_Type = Xm.MENU_PULLDOWN) then

         --
         -- Convert the Label string into an X string.
         --
         Xmstring := Xm.StringCreateLtoR (Menu_Title,
           Xm.STRING_DEFAULT_CHARSET);

         --
         -- Put the Label arguments into an X Args structure.
         --
         Nargs := 0;
         Nargs := Nargs + 1;
         Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NsubMenuId,
           Xt.POINTER (Menu));
         Nargs := Nargs + 1;
         Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NLabelString,
           Xt.POINTER (Xmstring));
         Nargs := Nargs + 1;
         Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NMnemonic,
           INTEGER(CHARACTER'pos(Menu_Mnemonic)));
         Nargs := Nargs + 1;
         Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NSensitive,
           Menu_Sensitivity);

         --
         -- Create the Menu Cascade
         --
         Cascade := Xt.CreateManagedWidget ("widget", 
           Xm.CascadeButtonWidgetClass, Parent, Args, Nargs);

         --
         -- Free the Label X string.
         --
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Xmstring);

      elsif (Menu_Type = Xm.MENU_OPTION) then

         --
         -- Convert the Label string into an X string.
         --
         Xmstring := Xm.StringCreateLtoR (Menu_Title,
           Xm.STRING_DEFAULT_CHARSET);

         --
         -- Put the Label arguments into an X Args structure.
         --
         Nargs := 0;
         Nargs := Nargs + 1;
         Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NsubMenuId,
           Xt.POINTER (Menu));
         Nargs := Nargs + 1;
         Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NLabelString,
           Xt.POINTER (Xmstring));

         --
         -- Create the option menu, returning it's pointer in
	 -- the cascade button field.
         --
         Cascade := Xm.CreateOptionMenu (Parent, Menu_Title, Args, Nargs);

         --
         -- Free the Label X string.
         --
         --
	 -- Don't free this (as you normally would), because Verdix Ada
         -- may corrupt memory when you do...
	 --
         --Xm.StringFree (Xmstring);

      end if;

      --
      -- Create the Menu Items
      --
      MENU_ITEMS_CREATION_LOOP:
      for counter in Items'range loop

         --
         -- If we are to create a subMenu (i.e. the Subitems
         -- field is non-null),  create it by calling 
         -- ourselves recursively.
         --
         if (Items(counter).Subitems /= NULL) then

	    if (Menu_Type /= Xm.MENU_OPTION) then

               Build_Menu (
                 Parent           => Menu,
                 Menu_Type        => Xm.MENU_PULLDOWN,
                 Menu_Title       => Items(counter).Label,
                 Menu_Mnemonic    => Items(counter).Mnemonic,
                 Menu_Sensitivity => Items(counter).Sensitive,
                 Items            => Items(counter).Subitems.ALL,
                 Return_Widget    => Temp_Widget);

	    end if;

         --
         -- Build the regular Menu item.
         --
         else

            --
            -- Create the Menu item widget.
            --
            Nargs := 1;
            Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NSensitive,
              Items(counter).Sensitive);
            Nargs := 2;
            Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NMnemonic,
              INTEGER(CHARACTER'pos(Items(counter).Mnemonic)));
            Temp_Widget := Xt.CreateManagedWidget (Items(counter).Label,
              Items(counter).Class, Menu, Args, Nargs);

            --
            -- If the Menu item is a toggle button,
            -- set any special toggle Attributes.
            --
            if ((Items(counter).Class = Xm.ToggleButtonWidgetClass) 
              or (Items(counter).Class = Xm.ToggleButtonGadgetClass)) then
          
               Nargs := 1;
               Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NvisibleWhenOff,
                 TRUE);
               Xt.SetValues (Temp_Widget, Args, Nargs);

            end if;

            --
            -- Attach the Menu item's Accelerator
            --
            if (Items(counter).Accelerator /= "") then

               Nargs := 0;
               Nargs := Nargs + 1;
               Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NAccelerator,
                 Items(counter).Accelerator);
               Nargs := Nargs + 1;
               Xmstring := Xm.StringCreateLtoR (Items(counter).Accel_Text,
                 Xm.STRING_DEFAULT_CHARSET);
               Xt.SetArg (Args (Xt.INT (Nargs)), Xmdef.NAcceleratorText,
                 Xmstring);
               Xt.SetValues (Temp_Widget, Args, Nargs);

            end if;

            --
            -- Attach the Menu item's Callback
            --
            if (Items(counter).Callback /= Xt.XNULL) then

               if ((Items(counter).Class = Xm.SeparatorWidgetClass)
                 or (Items(counter).Class = Xm.SeparatorGadgetClass)) then

                  --
                  -- No Callbacks for separators.
                  --
                  null;

               elsif ((Items(counter).Class = Xm.ToggleButtonWidgetClass)
                 or (Items(counter).Class = Xm.ToggleButtonGadgetClass)) then

                  --
                  -- valueChanged Callbacks for toggle buttons
                  --
                  Xt.AddCallback (Temp_Widget,
                    Xmdef.NvalueChangedCallback,
                    Items(counter).Callback,
                    Items(counter).CB_Data);

               else

                  --
                  -- activate Callbacks for other Menu Items
                  -- (i.e. pushButtons, arrowButtons)
                  --
                  Xt.AddCallback (Temp_Widget, Xmdef.NactivateCallback,
                    Items(counter).Callback, Items(counter).CB_Data);

               end if;

            end if;

         end if;

         --
         -- Put the Menu item widget pointer into the out structure
         --
	 if (not Motif_Utilities."="(Items(counter).Item_Widget, NULL)) then
            Items(counter).Item_Widget.all := Temp_Widget;
         end if;

      end loop MENU_ITEMS_CREATION_LOOP;

      --
      -- Return the Menu Cascade widget for pulldown Menus;
      -- return the Menu widget for other Menus.
      --
      if ((Menu_Type = Xm.MENU_PULLDOWN) or (Menu_Type = Xm.MENU_OPTION)) then
         Return_Widget := Cascade;
      else
         Return_Widget := Menu;
      end if;

   end Build_Menu;


   ---------------------------------------------------------
   --                                                     --
   -- PROCEDURE:  Build_Menu_Item ()                      --
   --                                                     --
   -- PURPOSE:    This function assembles a MENU_ITEM_REC --
   --             from a list of parameters. This is an   --
   --             optional convenience function.          --
   --                                                     --
   -- PARAMETERS: Label       - the Menu item Label       --
   --             Class       - the Menu item widget Class--
   --             Sensitive   - the Menu item sensitivity --
   --             Mnemonic    - the Menu item Mnemonic    --
   --             Accelerator - the Menu item Accelerator --
   --             Accel_Text  - the Accelerator Text      --
   --             Callback    - the Menu item Callback    --
   --             CB_Data     - the Callback data         --
   --             Subitems    - the Menu item Subitems ptr--
   --             Item_Widget - the Menu item (out) widget--
   --             Menu_Item   - the destination record    --
   --                                                     --
   ---------------------------------------------------------
   procedure Build_Menu_Item (
      Label       : in     STRING;
      Class       : in     Xt.WIDGETClass;
      Sensitive   : in     BOOLEAN;
      Mnemonic    : in     CHARACTER;
      Accelerator : in     STRING;
      Accel_Text  : in     STRING;
      Callback    : in     Xt.CALLBACKPROC;     -- Callback procedure pointer
      CB_Data     : in     Xt.POINTER;          -- Callback data pointer
      Subitems    : in     MENU_ITEM_ARRAY_PTR; -- ptr to MENU_ITEM_ARRAY
      Item_Widget : in     AWIDGET;             -- pointer to Menu widget
      Menu_Item   :    out MENU_ITEM_REC) is

   begin

      --
      -- Pad out the strings with ASCII.NULs...
      --
      Menu_Item.Label       := (OTHERS => ASCII.NUL);
      Menu_Item.Accelerator := (OTHERS => ASCII.NUL);
      Menu_Item.Accel_Text  := (OTHERS => ASCII.NUL);

      --
      -- Build the Menu item structure.
      --
      Menu_Item.Label(Label'first..Label'last) := Label;
      Menu_Item.Class                          := Class;
      Menu_Item.Sensitive                      := Sensitive;
      Menu_Item.Mnemonic                       := Mnemonic;
      Menu_Item.Accelerator(Accelerator'first..Accelerator'last) :=
        Accelerator;
      Menu_Item.Accel_Text(Accel_Text'first..Accel_Text'last) := Accel_Text;
      Menu_Item.Callback                       := Callback;
      Menu_Item.CB_Data                        := CB_Data;
      Menu_Item.Subitems                       := Subitems;
      Menu_Item.Item_Widget                    := Item_Widget;

      --
      -- Ensure that all of the strings are null terminated.
      --
      Menu_Item.Label(Menu_Item.Label'last)             := ASCII.NUL;
      Menu_Item.Accelerator(Menu_Item.Accelerator'last) := ASCII.NUL;
      Menu_Item.Accel_Text(Menu_Item.Accel_Text'last)   := ASCII.NUL;

   end Build_Menu_Item;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Active_Help
   --
   -------------------------------------------------------------------------
   procedure Install_Active_Help(
      Parent                      : in out Xt.WIDGET;
      Help_Text_Widget            : in out Xt.WIDGET;
      Help_Text_Message           : in     STRING)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Update_Help_Field_EH
   --
   -------------------------------------------------------------------------
   procedure Update_Help_Field_EH(
      Parent                      : in     Xt.WIDGET;
      Help_Text_String            : in out Xt.POINTER;
      Event                       : in out Xlib.EVENT;
      Continue_To_Dispatch_Return : in out BOOLEAN)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Text_Restrictions
   --
   -------------------------------------------------------------------------
   procedure Install_Text_Restrictions(
      Parent           : in     Xt.WIDGET;
      Text_Type        : in     Motif_Utilities.TEXT_RESTRICTION_ENUM;
      Characters_Count : in     INTEGER)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Text_Restrictions_With_Integer_Range
   --
   -------------------------------------------------------------------------
   procedure Install_Text_Restrictions_With_Integer_Range(
      Parent           : in     Xt.WIDGET;
      Text_Type        : in     Motif_Utilities.TEXT_RESTRICTION_ENUM;
      Characters_Count : in     INTEGER;
      Minimum_Integer  : in     INTEGER;
      Maximum_Integer  : in     INTEGER)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Install_Text_Restrictions_With_Float_Range
   --
   -------------------------------------------------------------------------
   procedure Install_Text_Restrictions_With_Float_Range(
      Parent           : in     Xt.WIDGET;
      Text_Type        : in     Motif_Utilities.TEXT_RESTRICTION_ENUM;
      Characters_Count : in     INTEGER;
      Minimum_Float    : in     FLOAT;
      Maximum_Float    : in     FLOAT)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Get_Integer_From_Text_Widget
   --
   -------------------------------------------------------------------------
   procedure Get_Integer_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Get_Float_From_Text_Widget
   --
   -------------------------------------------------------------------------
   procedure Get_Float_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out FLOAT;
      Success      :    out BOOLEAN)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Get_Hexadecimal_From_Text_Widget
   --
   -------------------------------------------------------------------------
   procedure Get_Hexadecimal_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Get_Binary_From_Text_Widget
   --
   -------------------------------------------------------------------------
   procedure Get_Binary_From_Text_Widget(
      Text_Widget  : in     Xt.WIDGET;
      Return_Value :    out INTEGER;
      Success      :    out BOOLEAN)
     is separate;


   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Set_Boolean_Value_CB
   --
   -------------------------------------------------------------------------
   procedure Set_Boolean_Value_CB (
      Parent        : in     Xt.WIDGET;
      Boolean_Value : in out INTEGER;
      CBS           : in out Xm.ANYCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Set_Integer_Value_CB
   --
   -------------------------------------------------------------------------
   procedure Set_Integer_Value_CB (
      Parent        : in     Xt.WIDGET;
      Integer_Value : in out INTEGER;
      CBS           : in out Xm.ANYCALLBACKSTRUCT_PTR)
     is separate;

   -------------------------------------------------------------------------
   --
   -- UNIT NAME:          Destroy_Widget_CB
   --
   -------------------------------------------------------------------------
   procedure Destroy_Widget_CB(
      Parent                 : in     Xt.WIDGET;
      Widget_To_Be_Destroyed : in     Xt.WIDGET;
      CBS                    : in out Xm.ANYCALLBACKSTRUCT_PTR) is
   begin
      --
      -- Destroy the Widget_To_Be_Destroyed.
      --
      Xt.DestroyWidget (Widget_To_Be_Destroyed);

   end Destroy_Widget_CB;

   -------------------------------------------------------------------------
   --
   -- PRIVATE
   -- UNIT NAME:          Text_Restrict_CB
   --
   -------------------------------------------------------------------------
   procedure Text_Restrict_CB(
      Text_Widget        : in     Xt.WIDGET;
      Text_Restrictions  : in out Motif_Utilities.ATEXT_RESTRICTION_RECORD;
      cbs                : in out Xm.TEXTVERIFYCALLBACKSTRUCT_PTR)
     is separate;

end Motif_Utilities;
