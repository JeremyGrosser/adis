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
with Text_IO;
with Unchecked_Conversion;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Set_Parms_Panels
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 13, 1994
--
-- PURPOSE:
--   This procedure initializes all XDG Server Set Parameters panels
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
procedure Initialize_Set_Parms_Panels(
   Set_Data    : in     XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR) is

   function "=" (left, right: XDG_Server_Types.XDG_SET_PARM_DATA_REC_PTR)
     return BOOLEAN renames XDG_Server_Types."=";

begin

   --
   -- Only initialize the Set Parameters panels if the Set Parameters
   -- window has been created (and these record allocated).
   --
   if (Set_Data /= NULL) then

      XDG_Server.Initialize_Panel_DG_Parameters (Set_Data.DG_Parameters);
      XDG_Server.Initialize_Panel_Error (Set_Data.Error);
      XDG_Server.Initialize_Panel_Exercise (Set_Data.Exercise);
      XDG_Server.Initialize_Panel_Hash (Set_Data.Hash);
      XDG_Server.Initialize_Panel_Network (Set_Data.Network);
      XDG_Server.Initialize_Panel_PDU_Filters (Set_Data.PDU_Filters);
      XDG_Server.Initialize_Panel_Specific_Filters (Set_Data.Specific_Filters);
      XDG_Server.Initialize_Panel_Threshold (Set_Data.Threshold);

   end if;

end Initialize_Set_Parms_Panels;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/13/94   D. Forrest
--      - Initial version
--
-- --

