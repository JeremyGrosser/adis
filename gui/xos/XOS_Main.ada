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
-- ORIGINATION DATE: May 18, 1994
--
-- PURPOSE:
--   -This package holds the code for the basic X application.
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

with Motif_Utilities;
with OS_GUI;
with OS_Status;
with Text_IO;
with System;
with Unchecked_Conversion;
with Xlib;
with Xm;
with Xmdef;
with XOS;
with XOS_Main_CB;
with XOS_Types;
with Xt;
with Xtdef;

---------------------------------------------------------------------------
--
-- UNIT NAME:          XOS_Create_Main_Window
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   May 18, 1994
--
-- PURPOSE:
--   This procedure create the main XOS window.
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
   K_App_Name : constant STRING := "xos";

   -- Constant application label (description).
   K_App_Label_String : constant STRING :=
     "ADIS X-based Ordnance Server Interface";

   -- Constant null string
   K_Null_String : constant STRING(1..1) := (1=>ASCII.NUL);

   -- Constant Fallback Application Resources
   K_Fallback_App_Resources : constant Xt.StringList(1..7) := (
     1 => new STRING'("*keyboardFocusPolicy:   explicit" & ASCII.NUL),
     2 => new STRING'("*background:            lightsteelblue" & ASCII.NUL),
     3 => new STRING'("*pointerShape:          left_ptr" & ASCII.NUL),
     4 => new STRING'(
       "*XmText.fontList:       -*-courier-bold-r-normal--17-*-*-*-*-*-*-*" &
	 ASCII.NUL),
     5 => new STRING'(
       "*XmTextField.fontList:  -*-courier-bold-r-normal--14-*-*-*-*-*-*-*" &
	 ASCII.NUL),
     6 => new STRING'(
       "*fontList:     -*-times-medium-r-normal--20-*-*-*-*-*-*-*=charset1" &
	 ASCII.NUL),
     7 => NULL);

   -- Declare basic X/MOTIF application variables.
   --
   Display          : Xlib.DISPLAY;     -- X display
   Toplevel         : Xt.WIDGET;        -- X application toplevel widget
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
   Status          : Xt.INT := 0;          -- X function call return status
   OS_Status_Flag  : OS_Status.STATUS_TYPE;
   X_Error         : EXCEPTION;            -- Fatal error exception.
   OS_Failure      : EXCEPTION;

   --
   -- Declare application widget variables.
   --
   Main_Form              : Xt.WIDGET;  -- Main window form
   Main_Menubar           : Xt.WIDGET;  -- Main window menu bar
   Main_Menu_File_Cascade : Xt.WIDGET;  -- Main window file menu cascade 
   Main_Menu_OS_Cascade   : Xt.WIDGET;  -- Main window OS menu cascade 

   Work_Form              : Xt.WIDGET;  -- Main window work form
   ADIS_Label_Widget      : Xt.WIDGET;  -- Main window app label

   --
   -- Declare application data.
   --
   XOS_Data : XOS_Types.XOS_PARM_DATA_REC_PTR;

   --
   -- Declare application file menu variables.
   --
   type FILE_MENU_ENUM is (
     FILE_OPEN,
     FILE_SEP_1,
     FILE_SAVE,
     FILE_SEP_2,
     FILE_QUIT);
   File_Menu : Motif_Utilities.MENU_ITEM_ARRAY(
     FILE_MENU_ENUM'pos(FILE_MENU_ENUM'first)..
       FILE_MENU_ENUM'pos(FILE_MENU_ENUM'last));

   --
   -- Declare application OS menu variables.
   --
   type OS_MENU_ENUM is (
     OS_SET_SIMULATION_PARAMETERS,
     OS_SET_ORDNANCE_PARAMETERS,
     OS_SET_ERROR_PARAMETERS,
     OS_SEP_1,
     OS_MONITORS,
     OS_ERROR_NOTICES);
   OS_Menu : Motif_Utilities.MENU_ITEM_ARRAY(
     OS_MENU_ENUM'pos(OS_MENU_ENUM'first)..
       OS_MENU_ENUM'pos(OS_MENU_ENUM'last));

   --
   -- Rename functions.
   --
   function "=" (Left, Right: Xlib.Pointer) return BOOLEAN 
     renames Xlib."=";
   function "=" (Left, Right: OS_Status.STATUS_TYPE) return BOOLEAN
     renames OS_Status."=";
   function XOS_PARM_DATA_REC_PTR_to_Integer is new
     Unchecked_Conversion (Source => XOS_Types.XOS_PARM_DATA_REC_PTR,
			   Target => INTEGER);
   function XOS_PARM_DATA_REC_PTR_to_XtPOINTER is new
     Unchecked_Conversion (Source => XOS_Types.XOS_PARM_DATA_REC_PTR,
			   Target => Xt.POINTER);

begin

   --
   -- Allocate and initialize application data.
   --
   XOS_Data := new XOS_Types.XOS_PARM_DATA_REC'(
      Sim_Data           => NULL,
      Ord_Data           => NULL,
      Other_Data         => NULL,
      
      Monitors_Data      => NULL,
      Error_Notices_Data => NULL);

   --
   -- Initialize the X Intrinsics toolkit.
   --
   Xt.ToolkitInitialize;

   --
   -- Create an application context.
   --
   XOS_Main_CB.App_Context := Xt.CreateApplicationContext;

   --
   -- Install application fallback resources
   --
   XtAppSetFallbackResources (XOS_Main_CB.App_Context,
     K_Fallback_App_Resources'address);

   --
   -- Open the X Display.
   --
   Argv := Xlib.GetArguments;
   Xt.OpenDisplay (XOS_Main_CB.App_Context, K_Null_String,
     K_App_Name, K_App_Name,
     Argv, Display);
   Xlib.FreeStringList (Argv);

   --
   -- If the X Display cannot be opened, output the appropriate
   -- Error message and raise an exception.
   --
   if (Display = Xlib.Display (Xlib.XNULL)) then
      Text_IO.Put_Line ("Unable to open Display.");
      raise X_Error;
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
   Toplevel := Xt.AppCreateShell (K_App_Name, K_App_Name,
     Xt.applicationShellWidgetClass, Display, Arglist, Argcount);
	
   --
   -- Install the Quit_CB to handle the Window Manager delete response.
   --
   WM_Delete_Window := Xm.InternAtom (Xt.GetDisplay (Toplevel),
     "WM_DELETE_WINDOW", False);
   Xm.AddWMProtocolCallback (Toplevel, WM_Delete_Window,
     XOS_Main_CB.Quit_CB'address, Xt.XNULL);

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
     Mnemonic    => ASCII.NUL, -- 'O',
     Accelerator => "",        -- "Alt<Key>O",
     Accel_text  => "",        -- "Alt+O",
     Callback    => XOS_Main_CB.Open_CB'address,
     CB_Data     => XOS_PARM_DATA_REC_PTR_to_XtPOINTER(XOS_Data),
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
     Mnemonic    => ASCII.NUL, -- 'S',
     Accelerator => "",        -- "Alt<Key>S",
     Accel_text  => "",        -- "Alt+S",
     Callback    => XOS_Main_CB.Save_CB'address,
     CB_Data     => XOS_PARM_DATA_REC_PTR_to_XtPOINTER(XOS_Data),
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

   --
   -- Create the file menu items.
   --
   Motif_Utilities.Build_Menu_Item (
     Label       => "Quit",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'Q',
     Accelerator => "Alt<Key>Q",
     Accel_text  => "Alt+Q",
     Callback    => XOS_Main_CB.Quit_CB'address,
     CB_Data     => Xt.XNULL,
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
   -- Create the OS menu items.
   --
   Motif_Utilities.Build_Menu_Item (
     Label       => "Set Simulation Parameters",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'S',
     Accelerator => "Alt<Key>S",
     Accel_text  => "Alt+S",
     Callback    => XOS.Create_Sim_Parms_Window_CB'address,
     CB_Data     => 
       XOS_Types.XOS_PARM_DATA_REC_PTR_to_XtPOINTER(XOS_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => OS_Menu(OS_MENU_ENUM'pos(OS_SET_SIMULATION_PARAMETERS)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Set Ordnance Parameters",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'O',
     Accelerator => "Alt<Key>O",
     Accel_text  => "Alt+O",
     Callback    => XOS.Create_Ord_Parms_Window_CB'address,
     CB_Data     => 
       XOS_Types.XOS_PARM_DATA_REC_PTR_to_XtPOINTER(XOS_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => OS_Menu(OS_MENU_ENUM'pos(OS_SET_ORDNANCE_PARAMETERS)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Set Error Parameters",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'E',
     Accelerator => "Alt<Key>E",
     Accel_text  => "Alt+E",
     Callback    => XOS.Create_Other_Parms_Window_CB'address,
     CB_Data     => 
       XOS_Types.XOS_PARM_DATA_REC_PTR_to_XtPOINTER(XOS_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => OS_Menu(OS_MENU_ENUM'pos(OS_SET_ERROR_PARAMETERS)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "OS_SEP_1",
     Class       => Xm.SeparatorGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => ASCII.NUL,
     Accelerator => "",
     Accel_text  => "",
     Callback    => System.NO_ADDR,
     CB_Data     => Xt.XNULL,
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => OS_Menu(OS_MENU_ENUM'pos(OS_SEP_1)));
   Motif_Utilities.Build_Menu_Item (
     Label       => "Monitors",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'M',
     Accelerator => "Alt<Key>M",
     Accel_text  => "Alt+M",
     Callback    => XOS.Create_Monitors_Window_CB'address,
     CB_Data     => XOS_Types.XOS_PARM_DATA_REC_PTR_to_XtPOINTER(XOS_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => OS_Menu(OS_MENU_ENUM'pos(OS_MONITORS)));

   Motif_Utilities.Build_Menu_Item (
     Label       => "Error Notices",
     Class       => Xm.PushButtonGadgetClass,
     Sensitive   => TRUE,
     Mnemonic    => 'N',
     Accelerator => "Alt<Key>N",
     Accel_text  => "Alt+N",
     Callback    => XOS.Create_Error_Notices_Window_CB'address,
     CB_Data     => XOS_Types.XOS_PARM_DATA_REC_PTR_to_XtPOINTER(XOS_Data),
     Subitems    => NULL,
     Item_Widget => NULL,
     Menu_Item   => OS_Menu(OS_MENU_ENUM'pos(OS_ERROR_NOTICES)));


   --
   -- Create the file menu.
   --
   Motif_Utilities.Build_Menu (
     Parent           => Main_Menubar,
     Menu_Type        => Xm.MENU_PULLDOWN,
     Menu_Title       => "XOS",
     Menu_Mnemonic    => 'X',
     Menu_Sensitivity => TRUE,
     Items            => OS_Menu,
     Return_Widget    => Main_Menu_OS_Cascade);

   --
   -- Realize the Toplevel widget and Display it's managed hierarchy.
   --
   Xt.ManageChild (Main_Menubar);
   Xt.RealizeWidget (Toplevel);

   --
   -- Attempt to map to shared memory
   --
   OS_GUI.Map_Interface(
     Create_Interface => FALSE,
     Status           => OS_Status_Flag);
   if (OS_Status_Flag /= OS_Status.SUCCESS) then
      raise OS_Failure;
--      --
--      -- vvv TEMP vvv
--      --
--      Text_IO.Put_Line("Unable to map OS/GUI interface.");
--      Text_IO.Put_Line("XOS mapping OS/GUI interface...");
--      OS_GUI.Map_Interface(
--        Create_Interface => TRUE,
--        Status           => OS_Status_Flag);
--      if (OS_Status_Flag /= OS_Status.SUCCESS) then
--         Text_IO.Put_Line("XOS unable to map OS/GUI interface");
--         raise OS_Failure;
--      else
--         XOS.Self_Mapped := True;
--      end if;
--      --
--      -- ^^^ TEMP ^^^
--      --
   end if;

   --
   -- Allow X to Loop and process events indefinitely.
   --
   Xt.AppMainLoop (XOS_Main_CB.App_Context);

exception

   --
   -- Shared memory mapping failed...
   --
   when X_Error =>
      Text_IO.Put_Line("Unable to initialize X; OS GUI Exiting...");

   when OS_Failure =>
      Text_IO.Put_Line("Unable to map OS/GUI shared memory interface.");
      Text_IO.Put_Line("Please run OS; OS GUI Exiting...");

   when OTHERS =>
      Text_IO.Put_Line(
        "Unknown Ada exception Error; OS GUI Exiting...");

end Main;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   05/18/94   D. Forrest
--      - Initial version
--
-- --

