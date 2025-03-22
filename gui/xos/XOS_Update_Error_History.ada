
--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--

with Motif_Utilities;
with OS_Error_Messages;
with OS_GUI;
with OS_Status;
with Text_IO;
with Utilities;
with XOS_Main_CB;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XOS)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Update_Error_History
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 18, 1994
--
-- PURPOSE:
--   This procedure is a time proc which updates the Error History window.
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
procedure Update_Error_History (
   Error_History_Data : in out XOS_Types.
				  XOS_MON_ERROR_HISTORY_DATA_REC_PTR) is

   --
   -- Time Proc Interval ID
   --
   Interval_ID : Xt.INTERVALID;

   --
   -- Error History Variables
   --

   -- 
   -- Renamed functions
   -- 
   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";
   function "="(Left, Right:
     XOS_Types.XOS_MON_ERROR_HISTORY_DATA_REC_PTR) return BOOLEAN 
       renames XOS_Types."=";

begin
 
    --
    -- Only reinstall and update if the Error_History_Data record ptr and
    -- the Error_History_Text text widget are non-NULL.
    --
    if ((Error_History_Data /= NULL) and then
      (Error_History_Data.Error_History_Scrolled_Window /= Xt.XNULL)) then

       --
       -- Reinstall ourselves...
       --
       Interval_ID := Xt.AppAddTimeOut(
	 App_Context => XOS_Main_CB.App_Context,
	 Interval    => K_Update_Error_History_Timeout_Interval_ms,
	 Proc        => Update_Error_History'address,
	 Client_Data => XOS_Types.
	   XOS_MON_ERROR_HISTORY_DATA_REC_PTR_to_XtPOINTER(
	     Error_History_Data));

       if (Xt.IsManaged (Error_History_Data.Error_History_Scrolled_Window))
	 then

	  --
	  -- Perform Updating...
	  --
	  UPDATE_ERROR_HISTORY_LOOP:
	  for Index in OS_Status.STATUS_TYPE loop

	     if (OS_GUI.Interface.Error_Parameters.History(Index).
	       Occurrence_Count > 0) then

		--
		-- Update the Error History entry Time Of Last Occurrence
		-- label widget.
		--
		Motif_Utilities.Set_Labelstring(
		  Error_History_Data.History(Index).Time,
		    Utilities.Time_To_String (OS_GUI.Interface.
		      Error_Parameters.History(Index).
			Last_Occurrence_Time));

		--
		-- Update the Error History entry Occurrence Count
		-- label widget.
		--
		Motif_Utilities.Set_Labelstring(
		  Error_History_Data.History(Index).Occurrences,
		    INTEGER'image(OS_GUI.Interface.Error_Parameters.
		      History(Index).Occurrence_Count));

		--
		-- On first error occurrence, set the Error History entry
		-- message and manage the Error History entry widgets.
		--
                if (not Xt.IsManaged (Error_History_Data.History(Index).
		  Message)) then

		   Motif_Utilities.Set_Labelstring(
		     Error_History_Data.History(Index).Message,
		       OS_Error_Messages.K_Error_Message(Index).Text);
		   Xt.ManageChild (Error_History_Data.History(Index).Time);
		   Xt.ManageChild (Error_History_Data.History(Index).
		     Occurrences);
		   Xt.ManageChild (Error_History_Data.History(Index).Message);

		end if; -- first occurrence

	     end if; -- occurrence > 0

	  end loop UPDATE_ERROR_HISTORY_LOOP;
       
       end if; -- ScrolledWindow is managed

    end if; -- Error_History_Data and ScrolledWindow are non-NULL

end Update_Error_History;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/20/94   D. Forrest
--      - Initial version
--
-- --

