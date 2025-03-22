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

with Motif_Utilities;
with OS_GUI;
with Text_IO;
with Unchecked_Conversion;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Ord_Parms_Panels
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 12, 1994
--
-- PURPOSE:
--   This procedure initializes all XOS Ord Parameters panels
--   by calling their respective initialize functions.
--
-- IMPLEMENTATION NOTES:
--   Panels not yet created are not initialized. This is not a problem,
--   as they will automatically be initialized at creation time.
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

procedure Initialize_Ord_Parms_Panels(
   Ord_Data    : in     XOS_Types.XOS_ORD_PARM_DATA_REC_PTR) is

   function "=" (left, right: XOS_Types.XOS_ORD_PARM_DATA_REC_PTR)
     return BOOLEAN renames XOS_Types."=";

begin

   --
   -- Only initialize the Ord Parameters panels if the Ord Parameters
   -- window has been created (and these record allocated).
   --
   if (Ord_Data /= NULL) then

      XOS.Initialize_Ord_Panel_Gen    (Ord_Data.Gen);
      XOS.Initialize_Ord_Panel_Entity (Ord_Data.Entity);
      XOS.Initialize_Ord_Panel_Aero   (Ord_Data.Aero);
      XOS.Initialize_Ord_Panel_Emitter(Ord_Data.Emitter);
      XOS.Initialize_Ord_Panel_Term   (Ord_Data.Term);

      --
      -- Sensitize Previous_Button based on value of Top_Of_List
      --
      if OS_GUI.Interface.Ordnance_Display.Top_Of_List then
	 Xt.SetSensitive (Ord_Data.Previous_Button, FALSE);
      else
	 Xt.SetSensitive (Ord_Data.Previous_Button, TRUE);
      end if;

      --
      -- Sensitize Next_Button based on value of End_Of_List
      --
      if OS_GUI.Interface.Ordnance_Display.End_Of_List then
	 Xt.SetSensitive (Ord_Data.Next_Button, FALSE);
      else
	 Xt.SetSensitive (Ord_Data.Next_Button, TRUE);
      end if;

   end if;

end Initialize_Ord_Parms_Panels;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/12/94   D. Forrest
--      - Initial version
--
-- --

