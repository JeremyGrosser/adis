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

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Other_Parms_Panels
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 12, 1994
--
-- PURPOSE:
--   This procedure initializes all XOS Other Parameters panels
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
procedure Initialize_Other_Parms_Panels(
   Other_Data    : in     XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR) is

   function "=" (left, right: XOS_Types.XOS_OTHER_PARM_DATA_REC_PTR)
     return BOOLEAN renames XOS_Types."=";

begin

   --
   -- Only initialize the Other Parameters panels if the Other Parameters
   -- window has been created (and these record allocated).
   --
   if (Other_Data /= NULL) then

      XOS.Initialize_Other_Panel_Error  (Other_Data.Error);

   end if;

end Initialize_Other_Parms_Panels;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/12/94   D. Forrest
--      - Initial version
--
-- --

