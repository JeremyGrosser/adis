--                          U N C L A S S I F I E D
--
--  *======================================================================*
--  |                                                                      |
--  |                       Manned Flight Simulator                        |
--  |              Naval Air Warfare Center Aircraft Division              |
--  |                      Patuxent River, Maryland                        |
--  |                                                                      |
--  *======================================================================*
--
----------------------------------------------------------------------------
--
--                        Manned Flight Simulator
--                        Bldg 2035
--                        Patuxent River, MD 20670
--
-- PACKAGE NAME:     Main
--
-- PROJECT:          Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:           James Daryl Forrest (J.F. Taylor, Inc)
--
-- ORIGINATION DATE: June 2, 1994
--
-- PURPOSE:
--   -This package holds the code for the basic XDG Server application.
--
-- EFFECTS:
--   None.
--
-- EXCEPTIONS:
--   None.
--
-- PORTABILITY ISSUES:
--   This package uses Xlib, Xm, Xmdef, Xt, and Xtdef.
--
-- ANTICIPATED CHANGES:
--   None.
--
----------------------------------------------------------------------------

with DG_Error_Processing_Types;
with DG_Server_Error_Processing;
with DG_Server_GUI;
with DG_Status;

with Motif_Utilities;
with Mrm;
with Text_IO;
with System;
with Unchecked_Conversion;
with Xlib;
with XlibR5;
with Xm;
with Xmdef;
with XDG_Server;
with XDG_Server_Main_CB;
with XDG_Server_Types;
with Xt;
with XtR5;
with Xtdef;

---------------------------------------------------------------------------
--
-- UNIT NAME:          XDG_Create_Main_Window
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 18, 1994
--
-- PURPOSE:
--   This procedure create the main XDG window.
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
procedure Main is

   -- Link to external functions
     procedure XtAppSetFallbackResources (
       App_Context        : in Xt.AppContext;
       Specification_List : in System.ADDRESS);
     pragma INTERFACE(C, XtAppSetFallbackResources);
     pragma INTERFACE_NAME(XtAppSetFallbackResources, "XtAppSetFallbackResources");

   -- Contant for the number of bits in a byte
   K_Bits_Per_Byte : constant INTEGER := 8;

   -- Constant application name.
   K_App_Name : constant STRING := "XDG_Server";

   -- Constant application label (description).
   K_App_Label_String : constant STRING :=
     "ADIS X-based DIS Gateway Server Interface";

   -- Constant null string
   K_Null_String : constant STRING(1..1) := (1=>ASCII.NUL);

   -- Constant Fallback Application Resources
   K_Fallback_App_Resources : constant Xt.StringList(1..9) := (
     1 => new STRING'("*keyboardFocusPolicy:   explicit" & ASCII.NUL),
     2 => new STRING'("*background:            lightsteelblue" & ASCII.NUL),
     3 => new STRING'("*pointerShape:          left_ptr" & ASCII.NUL),
     4 => new STRING'(
       "*XmText.fontList:-*-courier-bold-r-normal--17-*-*-*-*-*-*-*" &
         ASCII.NUL),
     5 => new STRING'(
       "*XmTextField.fontList:-*-courier-bold-r-normal--17-*-*-*-*-*-*-*" &
         ASCII.NUL),
     6 => new STRING'(
       "*fontList:-*-times-medium-r-normal--20-*-*-*-*-*-*-*=charset1" &
         ASCII.NUL),
     7 => new STRING'("*DragInitiatorProtocolStyle:   DRAG_NONE" & ASCII.NUL),
     8 => new STRING'("*DragReceiverProtocolStyle:    DRAG_NONE" & ASCII.NUL),
     9 => NULL);

   -- Declare basic X/MOTIF application variables.
   --
   Display      : Xlib.DISPLAY;         -- X display
   Toplevel     : Xt.WIDGET;            -- X application toplevel widget
   WM_Delete_Window : Xlib.ATOM;        -- X window manager atom

   --
   -- Declare miscellaneous X/MOTIF application variables.
   --
   Arglist      : Xt.ARGLIST (1..9);    -- X argument list
   Argcount     : Xt.INT := 0;          -- Item count for X argument list
   Argv         : Xt.STRINGLIST_PTR;    -- Application Cmd-Line arguments

   --
   -- Declare miscellaneous application variables.
   --
   Status       : Xt.INT := 0;          -- X function call return status
   Error        : EXCEPTION;            -- Fatal error exception.

   --
   -- Declare application widget variables.
   --
   Main_Form              : Xt.WIDGET;  -- Main window form
   Main_Menubar           : Xt.WIDGET;  -- Main window menu bar
   Main_Menu_File_Cascade : Xt.WIDGET;  -- Main window file menu cascade 
   Main_Menu_DG_Cascade   : Xt.WIDGET;  -- Main window DG menu cascade 

   Work_Form              : Xt.WIDGET;  -- Main window work form
   ADIS_Label_Widget      : Xt.WIDGET;  -- Main window app label

   --
   -- Declare application data.
   --
   XDG_Data : XDG_Server_Types.XDG_DATA_REC_PTR;

   --
   -- Declare DG Server data
   --
   DG_Status_Flag  : DG_Status.STATUS_TYPE;
   DG_Failure      : EXCEPTION;

   --
   -- Declare application file menu variables.
   --
   type FILE_MENU_ENUM is (
     FILE_OPEN,
     FILE_SEP_1,
     FILE_SAVE,
     FILE_SEP_2,
     FILE_SHUTDOWN_SERVER,
     FILE_SEP_3,
     FILE_QUIT);
   File_Menu : Motif_Utilities.MENU_ITEM_ARRAY(
     FILE_MENU_ENUM'pos(FILE_MENU_ENUM'first)..
       FILE_MENU_ENUM'pos(FILE_MENU_ENUM'last));

   --
   -- Declare application DG menu variables.
   --
   type DG_MENU_ENUM is (
     DG_SET_PARAMETERS,
     DG_SEP_1,
     DG_MONITORS,
     DG_ERROR_NOTICES);
   DG_Menu : Motif_Utilities.MENU_ITEM_ARRAY(
     DG_MENU_ENUM'pos(DG_MENU_ENUM'first)..
       DG_MENU_ENUM'pos(DG_MENU_ENUM'last));

   --
   -- Rename functions.
   --
   function "=" (Left, right: Xlib.Pointer) return Boolean 
     renames Xlib."=";
   function XDG_PARM_DATA_REC_PTR_to_Integer is new
     Unchecked_Conversion (Source => XDG_Server_Types.XDG_DATA_REC_PTR,
			   Target => INTEGER);

begin

   --
   -- Allocate and initialize application data.
   --
   XDG_Data := new XDG_Server_Types.XDG_DATA_REC'(
      Set_Parameters_Data => NULL,
      Monitors_Data       => NULL,
      Error_Notices_Data  => NULL);

   --
   -- Initialize the X Intrinsics toolkit.
   --
   Xt.ToolkitInitialize;

   --
   -- Create an application context.
   --
   XDG_Server_Main_CB.App_Context := Xt.CreateApplicationContext;

   --
   -- Sets the locale for internationalization to the default.
   --
   XtR5.SetLanguageProc (XDG_Server_Main_CB.App_Context, Xt.XNULL, Xt.XNULL);

   --
   -- Initialize Mrm (the Motif resource manager)
   --
   Mrm.Initialize;

   --
   -- Install application fallback resources
   --
   XtAppSetFallbackResources (XDG_Server_Main_CB.App_Context,
     K_Fallback_App_Resources'address);

   --
   -- Open the X Display.
   --
   Argv := Xlib.GetArguments;
   Xt.OpenDisplay (XDG_Server_Main_CB.App_Context, K_Null_String,
     K_App_Name, K_App_Name, Argv, Display);
   Xlib.FreeStringList (Argv);

   --
   -- If the X Display cannot be opened, output the appropriate
   -- Error message and raise an exception.
   --
   if (Display = Xlib.Display (Xlib.XNULL)) then
      Text_IO.Put_Line ("Unable to open Display.");
      raise Error;
   end if;

   --
   -- Configure and create the Toplevel widget.
   -- This widget acts as the "root" of its widget hierarchy.
   --
   Argcount := 0;
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xtdef.NallowShellResize, False);
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NdeleteResponse  ,
     INTEGER(Xm.DO_NOTHING));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xtdef.Ngeometry        , "+0+0");
   Argcount := Argcount + 1;
   Toplevel := Xt.AppCreateShell (K_App_Name, K_App_Name,
     Xt.applicationShellWidgetClass, Display, Arglist, Argcount);
	
   --
   -- Install the Quit_CB to handle the Window Manager delete response.
   --
   WM_Delete_Window := Xm.InternAtom (Xt.GetDisplay (Toplevel),
     "WM_DELETE_WINDOW", False);
   Xm.AddWMProtocolCallback (Toplevel, WM_Delete_Window,
     XDG_Server_Main_CB.Quit_CB'address, XDG_Server.INTEGER_To_XtPOINTER (
       XDG_Server_Main_CB.QUIT_ACTION_ENUM'pos(
	 XDG_Server_Main_CB.QUIT_ACTION_QUIT_GUI)));

   --
   -- Create the main form widget.
   --
   Argcount := 0;
   Main_Form := Xt.CreateManagedWidget ("Main_Form",
     Xm.FormWidgetClass, Toplevel, Arglist, Argcount);

   --
   -- Create the main menubar.
   --
   Argcount := 0;
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,
     INTEGER(Xm.ATTACH_FORM));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
     INTEGER(Xm.ATTACH_FORM));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
     INTEGER(Xm.ATTACH_NONE));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
     INTEGER(Xm.ATTACH_FORM));
   Main_Menubar := Xm.CreateMenuBar (Main_Form, "Main_Menubar", Arglist,
     Argcount);

   --
   -- Create the work form widget.
   --
   Argcount := 0;
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,    
     INTEGER(Xm.ATTACH_WIDGET));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NtopWidget, Main_Menubar);
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
     INTEGER(Xm.ATTACH_FORM));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NbottomAttachment,
     INTEGER(Xm.ATTACH_FORM));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NrightAttachment,
     INTEGER(Xm.ATTACH_FORM));
   Work_Form := Xt.CreateManagedWidget ("Work_Form",
     Xm.FormWidgetClass, Main_Form, Arglist, Argcount);

   --
   -- Create the application label.
   --
   Argcount := 0;
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NtopAttachment,    
     INTEGER(Xm.ATTACH_FORM));
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.NleftAttachment,
     INTEGER(Xm.ATTACH_FORM));
   ADIS_Label_Widget := Motif_Utilities.create_label (Work_Form, "");
   Xt.SetValues (ADIS_Label_Widget, Arglist, Argcount);

   --
   -- Set the application label to the appropiate constant string.
   --
   Motif_Utilities.Set_Labelstring (ADIS_Label_Widget, K_App_Label_String);

   --
   -- Size ADIS_Label_Widget appropriately
   --
   Argcount := 0;
   Argcount := Argcount + 1;
   Xt.SetArg (Arglist (Argcount), Xmdef.Ncolumns,
     (K_App_Label_String'last - K_App_Label_String'first) + 1);
   Xt.SetValues (ADIS_Label_Widget, Arglist, Argcount);

   --
   -- Create the file menu items.
   --
   Motif_Utilities.Build_Menu_Item (
     Label       => "Open Configuration File",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,  -- 'O',
     Accelerator => "",         -- "Alt<Key>O",
     Accel_text  => "",         -- "Alt+O",
     Callback    => XDG_Server_Main_CB.Open_CB'address,
     CB_Data     => XDG_Server_Types.XDG_DATA_REC_PTR_to_XtPOINTER(XDG_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => File_Menu(FILE_MENU_ENUM'pos(FILE_OPEN)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Separator 1",
     Class       => Xm.SeparatorGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,
     Accelerator => "",
     Accel_text  => "",
     Callback    => System.NO_ADDR,
     CB_Data     => Xt.XNULL,
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => File_Menu(FILE_MENU_ENUM'pos(FILE_SEP_1)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Save Current Data in Configuration File",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,  -- 'S',
     Accelerator => "",         -- "Alt<Key>S",
     Accel_text  => "",         -- "Alt+S",
     Callback    => XDG_Server_Main_CB.Save_CB'address,
     CB_Data     => XDG_Server_Types.XDG_DATA_REC_PTR_to_XtPOINTER(XDG_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => File_Menu(FILE_MENU_ENUM'pos(FILE_SAVE)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Separator 2",
     Class       => Xm.SeparatorGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,
     Accelerator => "",
     Accel_text  => "",
     Callback    => System.NO_ADDR,
     CB_Data     => Xt.XNULL,
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => File_Menu(FILE_MENU_ENUM'pos(FILE_SEP_2)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Shutdown Server",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,
     Accelerator => "",
     Accel_text  => "",
     Callback    => XDG_Server_Main_CB.Quit_CB'address,
     CB_Data     => XDG_Server.INTEGER_To_XtPOINTER (
       XDG_Server_Main_CB.QUIT_ACTION_ENUM'pos(
	 XDG_Server_Main_CB.QUIT_ACTION_SHUTDOWN_SERVER_AND_QUIT_GUI)),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => File_Menu(FILE_MENU_ENUM'pos(FILE_SHUTDOWN_SERVER)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Separator 3",
     Class       => Xm.SeparatorGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,
     Accelerator => "",
     Accel_text  => "",
     Callback    => System.NO_ADDR,
     CB_Data     => Xt.XNULL,
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => File_Menu(FILE_MENU_ENUM'pos(FILE_SEP_3)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Quit",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'Q',
     Accelerator => "Alt<Key>Q",
     Accel_text  => "Alt+Q",
     Callback    => XDG_Server_Main_CB.Quit_CB'address,
     CB_Data     => XDG_Server.INTEGER_To_XtPOINTER (
       XDG_Server_Main_CB.QUIT_ACTION_ENUM'pos(
	 XDG_Server_Main_CB.QUIT_ACTION_QUIT_GUI)),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => File_Menu(FILE_MENU_ENUM'pos(FILE_QUIT)));

   --
   -- Create the file menu.
   --
   Motif_Utilities.Build_Menu (
     Parent           => Main_Menubar,
     Menu_Type        => Xm.MENU_PULLDOWN,
     Menu_Title       => "File",
     Menu_Mnemonic    => 'F',
     Menu_Sensitivity => TRUE,
     Items            => File_Menu,
     Return_Widget    => Main_Menu_File_Cascade);

   --
   -- Create the DG menu items.
   --
   Motif_Utilities.Build_Menu_Item (
     Label       => "Set Parameters",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'S',
     Accelerator => "Alt<Key>S",
     Accel_text  => "Alt+S",
     Callback    => XDG_Server.Create_Set_Parms_Window_CB'address,
     CB_Data     => XDG_Server_Types.XDG_DATA_REC_PTR_to_XtPOINTER(XDG_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => DG_Menu(DG_MENU_ENUM'pos(DG_SET_PARAMETERS)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "DG_SEP_1",
     Class       => Xm.SeparatorGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,
     Accelerator => "",
     Accel_text  => "",
     Callback    => System.NO_ADDR,
     CB_Data     => Xt.XNULL,
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => DG_Menu(DG_MENU_ENUM'pos(DG_SEP_1)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Monitors",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'M',
     Accelerator => "Alt<Key>M",
     Accel_text  => "Alt+M",
     Callback    => XDG_Server.Create_Monitors_Window_CB'address,
     CB_Data     => XDG_Server_Types.XDG_DATA_REC_PTR_to_XtPOINTER(XDG_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => DG_Menu(DG_MENU_ENUM'pos(DG_MONITORS)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Error Notices",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'N',
     Accelerator => "Alt<Key>N",
     Accel_text  => "Alt+N",
     Callback    => XDG_Server.Create_Error_Notices_Window_CB'address,
     CB_Data     => XDG_Server_Types.XDG_DATA_REC_PTR_to_XtPOINTER(XDG_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => DG_Menu(DG_MENU_ENUM'pos(DG_ERROR_NOTICES)));

   --
   -- Create the XDG Server menu.
   --
   Motif_Utilities.Build_Menu (
     Parent           => Main_Menubar,
     Menu_Type        => Xm.MENU_PULLDOWN,
     Menu_Title       => "XDG Server",
     Menu_Mnemonic    => 'X',
     Menu_Sensitivity => TRUE,
     Items            => DG_Menu,
     Return_Widget    => Main_Menu_DG_Cascade);

   --
   -- Realize the Toplevel widget and Display it's managed hierarchy.
   --
   Xt.ManageChild (Main_Menubar);
   Xt.RealizeWidget (Toplevel);

   --
   -- Attempt to map to shared memory
   --
   DG_Server_GUI.Map_Interface(
     Create_Interface => FALSE,
     Status           => DG_Status_Flag);
   if (DG_Status.Failure(DG_Status_Flag)) then
      raise DG_Failure;
--      --
--      -- vvv TEMP vvv
--      --
--      Text_IO.Put_Line("Unable to map Server/GUI interface.");
--      Text_IO.Put_Line("XDG mapping Server/GUI interface...");
--      DG_Server_GUI.Map_Interface(
--	Create_Interface => TRUE,
--	Status           => DG_Status_Flag);
--      if (DG_Status.Failure(DG_Status_Flag)) then
--         Text_IO.Put_Line("XDG unable to map Server/GUI interface");
--         raise DG_Failure;
--      else
--	 XDG_Server.Self_Mapped := True;
--      end if;
--      --
--      -- ^^^ TEMP ^^^
--      --
   end if;


   --
   -- Allow X to Loop and process events indefinitely.
   --
   Xt.AppMainLoop (XDG_Server_Main_CB.App_Context);

exception

   --
   -- Shared memory mapping failed...
   -- 
   when DG_Failure =>
      Text_IO.Put_Line("Unable to map Server/GUI interface.");
      Text_IO.Put_Line("Please run DG Server; DG Server GUI Exiting...");

   when OTHERS =>
      Text_IO.Put_Line(
	"Unknown Ada exception Error; DG Server GUI Exiting...");

end Main;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

