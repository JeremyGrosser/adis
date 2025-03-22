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
with DG_Server_GUI;
with DIS_Types;
with Motif_Utilities;
with Numeric_Types;
with Text_IO;
with Utilities;
with XDG_Server_Types;
with Xlib;
with Xm;
with Xt;

separate (XDG_Server)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Initialize_Panel_PDU_Filters
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 1, 1994
--
-- PURPOSE:
--   This procedure initializes the PDU_Filters Panel widgets with the
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
procedure Initialize_Panel_PDU_Filters (
   PDU_Filters : in     XDG_Server_Types.XDG_PDU_FILTERS_DATA_REC) is

   K_Temp_String_Max : constant INTEGER := 256;

   Temp_String       : STRING(1..K_Temp_String_Max) := (OTHERS => ASCII.NUL);
   Temp_Float        : FLOAT    := 0.0;
   Temp_Integer      : INTEGER  := 0;
   Temp_Enabled      : BOOLEAN  := XDG_Server.K_Enabled;

   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";

begin

   --
   -- Initialize Keep Entity_State PDU Filter option menu
   --
   if (PDU_Filters.Entity_State /= Xt.XNULL) then

      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ENTITY_STATE) = XDG_Server.K_Enabled) then

	 XDG_Server.Entity_State_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Entity_State), K_Enabled_String);

      else

	 XDG_Server.Entity_State_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Entity_State), K_Disabled_String);

      end if;

   end if;

   --
   -- Initialize Keep Fire PDU Filter option menu
   --
   if (PDU_Filters.Fire /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.FIRE) = XDG_Server.K_Enabled) then
	 XDG_Server.Fire_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Fire), K_Enabled_String);
      else
	 XDG_Server.Fire_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Fire), K_Disabled_String);
      end if;
   end if;


   --
   -- Initialize Keep Detonation PDU Filter option menu
   --
   if (PDU_Filters.Detonation /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.DETONATION) = XDG_Server.K_Enabled) then
	 XDG_Server.Detonation_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Detonation), K_Enabled_String);
      else
	 XDG_Server.Detonation_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Detonation), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Collision PDU Filter option menu
   --
   if (PDU_Filters.Collision /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.COLLISION) = XDG_Server.K_Enabled) then
	 XDG_Server.Collision_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Collision), K_Enabled_String);
      else
	 XDG_Server.Collision_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Collision), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Service_Request PDU Filter option menu
   --
   if (PDU_Filters.Service_Request /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.SERVICE_REQUEST) = XDG_Server.K_Enabled) then
	 XDG_Server.Service_Request_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Service_Request), K_Enabled_String);
      else
	 XDG_Server.Service_Request_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Service_Request), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Resupply_Offer PDU Filter option menu
   --
   if (PDU_Filters.Resupply_Offer /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RESUPPLY_OFFER) = XDG_Server.K_Enabled) then
	 XDG_Server.Resupply_Offer_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Resupply_Offer), K_Enabled_String);
      else
	 XDG_Server.Resupply_Offer_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Resupply_Offer), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Resupply_Received PDU Filter option menu
   --
   if (PDU_Filters.Resupply_Received /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RESUPPLY_RECEIVED) = XDG_Server.K_Enabled) then
	 XDG_Server.Resupply_Received_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Resupply_Received), K_Enabled_String);
      else
	 XDG_Server.Resupply_Received_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Resupply_Received), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Resupply_Cancel PDU Filter option menu
   --
   if (PDU_Filters.Resupply_Cancelled /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RESUPPLY_CANCEL) = XDG_Server.K_Enabled) then
	 XDG_Server.Resupply_Cancelled_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Resupply_Cancelled), K_Enabled_String);
      else
	 XDG_Server.Resupply_Cancelled_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Resupply_Cancelled), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Repair_Complete PDU Filter option menu
   --
   if (PDU_Filters.Repair_Complete /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.REPAIR_COMPLETE) = XDG_Server.K_Enabled) then
	 XDG_Server.Repair_Complete_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Repair_Complete), K_Enabled_String);
      else
	 XDG_Server.Repair_Complete_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Repair_Complete), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Repair_Response PDU Filter option menu
   --
   if (PDU_Filters.Repair_Response /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.REPAIR_RESPONSE) = XDG_Server.K_Enabled) then
	 XDG_Server.Repair_Response_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Repair_Response), K_Enabled_String);
      else
	 XDG_Server.Repair_Response_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Repair_Response), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Create_Entity PDU Filter option menu
   --
   if (PDU_Filters.Create_Entity /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.CREATE_ENTITY) = XDG_Server.K_Enabled) then
	 XDG_Server.Create_Entity_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Create_Entity), K_Enabled_String);
      else
	 XDG_Server.Create_Entity_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Create_Entity), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Remove_Entity PDU Filter option menu
   --
   if (PDU_Filters.Remove_Entity /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.REMOVE_ENTITY) = XDG_Server.K_Enabled) then
	 XDG_Server.Remove_Entity_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Remove_Entity), K_Enabled_String);
      else
	 XDG_Server.Remove_Entity_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Remove_Entity), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Start_Resume PDU Filter option menu
   --
   if (PDU_Filters.Start_Resume /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.START_OR_RESUME) = XDG_Server.K_Enabled) then
	 XDG_Server.Start_Resume_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Start_Resume), K_Enabled_String);
      else
	 XDG_Server.Start_Resume_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Start_Resume), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Stop_Freeze PDU Filter option menu
   --
   if (PDU_Filters.Stop_Freeze /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.STOP_OR_FREEZE) = XDG_Server.K_Enabled) then
	 XDG_Server.Stop_Freeze_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Stop_Freeze), K_Enabled_String);
      else
	 XDG_Server.Stop_Freeze_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Stop_Freeze), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Acknowledge PDU Filter option menu
   --
   if (PDU_Filters.Acknowledge /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ACKNOWLEDGE) = XDG_Server.K_Enabled) then
	 XDG_Server.Acknowledge_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Acknowledge), K_Enabled_String);
      else
	 XDG_Server.Acknowledge_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Acknowledge), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Action_Request PDU Filter option menu
   --
   if (PDU_Filters.Action_Request /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ACTION_REQUEST) = XDG_Server.K_Enabled) then
	 XDG_Server.Action_Request_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Action_Request), K_Enabled_String);
      else
	 XDG_Server.Action_Request_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Action_Request), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Action_Response PDU Filter option menu
   --
   if (PDU_Filters.Action_Response /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.ACTION_RESPONSE) = XDG_Server.K_Enabled) then
	 XDG_Server.Action_Response_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Action_Response), K_Enabled_String);
      else
	 XDG_Server.Action_Response_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Action_Response), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Data_Query PDU Filter option menu
   --
   if (PDU_Filters.Data_Query /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.DATA_QUERY) = XDG_Server.K_Enabled) then
	 XDG_Server.Data_Query_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Data_Query), K_Enabled_String);
      else
	 XDG_Server.Data_Query_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Data_Query), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Set_Data PDU Filter option menu
   --
   if (PDU_Filters.Set_Data /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.SET_DATA) = XDG_Server.K_Enabled) then
	 XDG_Server.Set_Data_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Set_Data), K_Enabled_String);
      else
	 XDG_Server.Set_Data_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Set_Data), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Data PDU Filter option menu
   --
   if (PDU_Filters.Data /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.DATA) = XDG_Server.K_Enabled) then
	 XDG_Server.Data_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Data), K_Enabled_String);
      else
	 XDG_Server.Data_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Data), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Event_Report PDU Filter option menu
   --
   if (PDU_Filters.Event_Report /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.EVENT_REPORT) = XDG_Server.K_Enabled) then
	 XDG_Server.Event_Report_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Event_Report), K_Enabled_String);
      else
	 XDG_Server.Event_Report_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Event_Report), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Message PDU Filter option menu
   --
   if (PDU_Filters.Message /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.MESSAGE) = XDG_Server.K_Enabled) then
	 XDG_Server.Message_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Message), K_Enabled_String);
      else
	 XDG_Server.Message_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Message), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Emission PDU Filter option menu
   --
   if (PDU_Filters.Emission /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.EMISSION) = XDG_Server.K_Enabled) then
	 XDG_Server.Emission_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Emission), K_Enabled_String);
      else
	 XDG_Server.Emission_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Emission), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Laser PDU Filter option menu
   --
   if (PDU_Filters.Laser /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.LASER) = XDG_Server.K_Enabled) then
	 XDG_Server.Laser_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Laser), K_Enabled_String);
      else
	 XDG_Server.Laser_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Laser), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Transmitter PDU Filter option menu
   --
   if (PDU_Filters.Transmitter /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.TRANSMITTER) = XDG_Server.K_Enabled) then
	 XDG_Server.Transmitter_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Transmitter), K_Enabled_String);
      else
	 XDG_Server.Transmitter_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Transmitter), K_Disabled_String);
      end if;
   end if;

   --
   -- Initialize Keep Receiver PDU Filter option menu
   --
   if (PDU_Filters.Receiver /= Xt.XNULL) then
      if (DG_Server_GUI.Interface.Filter_Parameters.
	Keep_PDU(DIS_Types.RECEIVER) = XDG_Server.K_Enabled) then
	 XDG_Server.Receiver_Flag := XDG_Server.K_Enabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Receiver), K_Enabled_String);
      else
	 XDG_Server.Receiver_Flag := XDG_Server.K_Disabled;
	 Motif_Utilities.Set_LabelString (Xm.OptionButtonGadget(
	   PDU_Filters.Receiver), K_Disabled_String);
      end if;
   end if;


exception
   
   when OTHERS =>
      null;

end Initialize_Panel_PDU_Filters;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/01/94   D. Forrest
--      - Initial version
--
-- --

