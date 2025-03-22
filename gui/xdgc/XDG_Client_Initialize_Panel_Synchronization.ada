--
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

with DG_GUI_Interface_Types;
with DG_Client_GUI;
with Motif_Utilities;
with Numeric_Types;
with Text_IO;
with Utilities;
with XDG_Client_Types;
with Xlib;
with Xm;
with Xt;

separate (XDG_Client)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Panel_Synchronization
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 12 1994
--
-- PURPOSE:
--   This procedure initializes the Synchronization Panel widgets with the
--   values from the DG Shared Memory interface.
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
procedure Initialize_Panel_Synchronization (
   Synchronization :
     in     XDG_Client_Types.XDG_SYNCHRONIZATION_PARAMETERS_DATA_REC) is

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Automatic_Application_ID option menu widget
   --
   if (Synchronization.Server_Synchronization /= Xt.XNULL) then
      if (DG_Client_GUI.Interface.Synchronize_With_Server =
	XDG_Client.K_Enabled) then

	 XDG_Client.Server_Synchronization_Flag := XDG_Client.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Synchronization.Server_Synchronization), K_Enabled_String);

      else

	 XDG_Client.Server_Synchronization_Flag := XDG_Client.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   Synchronization.Server_Synchronization), K_Disabled_String);

      end if;
   end if;

exception
   
   when OTHERS =>
      null;

end Initialize_Panel_Synchronization;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/12/94   D. Forrest
--      - Initial version
--
-- --

