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

with DG_Error_Processing_Types;
with DG_Client_Error_Processing;
with DG_Status;
with DG_Status_Message;
with Motif_Utilities;
with Text_IO;
with Utilities;
with XDG_Client_Main_CB;
with Xlib;
with Xm;
with Xmdef;
with Xt;
with Xtdef;

separate (XDG_Client)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Update_Error_Notices
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   September 18, 1994
--
-- PURPOSE:
--   This procedure is a time proc which updates the Error Notices window.
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
procedure Update_Error_Notices (
   Error_Notices_Data : in out XDG_Client_Types.
				  XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR) is

   --
   -- Time Proc Interval ID
   --
   Interval_ID : Xt.INTERVALID;

   --
   -- Error Notices Variables
   --
   Error_Queue_Overflow : BOOLEAN;
   Error_Present        : BOOLEAN;
   Error_Entry          : DG_Error_Processing_Types.ERROR_QUEUE_ENTRY_TYPE;

   Error_String         : Utilities.ASTRING;
   K_Separation_String  : constant STRING := "    ";

   -- 
   -- Renamed functions
   -- 
   function "="(Left, Right: XDG_Client_Types.
     XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR) return BOOLEAN
       renames XDG_Client_Types."=";
   function "="(Left, Right: Xt.WIDGET) return BOOLEAN
     renames Xt."=";
   function "+"(Left, Right: Xm.TEXTPOSITION) return Xm.TEXTPOSITION
     renames Xm."+";

begin

    --
    -- Only reinstall and update if the Error_Notices_Data record ptr and
    -- the Error_Notices_Text text widget are non-NULL.
    --
    if ((Error_Notices_Data /= NULL) and then (Error_Notices_Data.
      Error_Notices_Text /= Xt.XNULL)) then

       --
       -- Reinstall ourselves...
       --
       Interval_ID := Xt.AppAddTimeOut(
	 App_Context => XDG_Client_Main_CB.App_Context,
	 Interval    => K_Update_Error_Notices_Timeout_Interval_ms,
	 Proc        => Update_Error_Notices'address,
	 Client_Data => XDG_Client_Types.
	   XDG_ERROR_NOTICES_MONITOR_DATA_REC_PTR_to_XtPOINTER(
	     Error_Notices_Data));

       --
       -- Get the first available error from the error queue.
       --
       DG_Client_Error_Processing.Get_Error(
	  Overflow      => Error_Queue_Overflow,
	  Error_Present => Error_Present,
	  Error_Entry   => Error_Entry);

       --
       -- Check for errors and update Error Notices window
       --
       UPDATE_ERROR_NOTICES_LOOP:
       while (Error_Present) loop

	  Error_String := new STRING'(Utilities.Time_To_String (
	    Error_Entry.Occurrence_Time) & K_SEPARATION_STRING
	      & DG_Status_Message.Error_Message(Error_Entry.Error).all
	        & ASCII.LF & ASCII.NUL);

	  --
	  -- Update the Error Notices text widget and the text position.
	  --
	  Xm.TextInsert (
	    Widget   => Error_Notices_Data.Error_Notices_Text,
	    Position => Error_Notices_Text_Position,
	    Value    => Error_String.all);
	  Error_Notices_Text_Position := Error_Notices_Text_Position
	    + Xm.TEXTPOSITION(Utilities.Length_Of_String(Error_String.all));
	  Xm.TextShowPosition(
	    Widget   => Error_Notices_Data.Error_Notices_Text,
	    Position => Error_Notices_Text_Position);

	  --
	  -- Get the next available error from the error queue.
	  --
	  DG_Client_Error_Processing.Get_Error(
	     Overflow      => Error_Queue_Overflow,
	     Error_Present => Error_Present,
	     Error_Entry   => Error_Entry);
	  
       end loop UPDATE_ERROR_NOTICES_LOOP;

    end if;

end Update_Error_Notices;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   09/18/94   D. Forrest
--      - Initial version
--
-- --

