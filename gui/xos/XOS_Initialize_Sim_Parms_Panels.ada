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
-- UNIT NAME:          Initialize_Sim_Parms_Panels
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 12, 1994
--
-- PURPOSE:
--   This procedure initializes all XOS Sim Parameters panels
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
procedure Initialize_Sim_Parms_Panels(
   Sim_Data    : in     XOS_Types.XOS_SIM_PARM_DATA_REC_PTR) is

   function "=" (left, right: XOS_Types.XOS_SIM_PARM_DATA_REC_PTR)
     return BOOLEAN renames XOS_Types."=";

begin

   --
   -- Only initialize the Sim Parameters panels if the Sim Parameters
   -- window has been created (and these record allocated).
   --
   if (Sim_Data /= NULL) then

      XOS.Initialize_Sim_Panel_Sim(Sim_Data.Sim);

   end if;

end Initialize_Sim_Parms_Panels;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/12/94   D. Forrest
--      - Initial version
--
-- --

