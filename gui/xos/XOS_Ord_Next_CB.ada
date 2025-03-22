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

with DIS_Types;
with Motif_Utilities;
with Numeric_Types;
with OS_GUI;
with Text_IO;
with Unchecked_Conversion;
with Unchecked_Deallocation;
with Utilities;
with Xlib;
with Xm;
with Xmdef;
with XOS_Types;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Ord_Next_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 21, 1994
--
-- PURPOSE:
--   This procedure instructs the OS to place the data for the next
--   munition in the list in shared memory. After this is complete, this
--   procedure reinitializes all panels in this window to reflect this
--   new data. This procedure also checks to see if either of the booleans
--   OS_GUI.Interface.Ordnance_Display.[Top_Of_List,End_Of_List] are true,
--   and sensitizes/insensitizes the Prev/Next buttons as appropriate.
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
procedure Ord_Next_CB (
   Parent              : in     Xt.WIDGET;
   Ord_Parameters_Data : in out XOS_Types.XOS_ORD_PARM_DATA_REC_PTR;
   Call_Data           :    out Xm.PUSHBUTTONCALLBACKSTRUCT_PTR) is

begin

--   Text_IO.Put_Line ("XOS Ordnance Parameters: Next...");

   OS_GUI.Interface.Ordnance_Display.Command
      := OS_GUI.NEXT;

   Ord_Update_Previous_Next_Buttons(Ord_Parameters_Data);


end Ord_Next_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/21/94   D. Forrest
--      - Initial version
--
-- --

