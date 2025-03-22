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
------------------------------------------------------------------------------
--
-- PACKAGE NAME     : System_Signal
--
-- FILE NAME        : System_Signal.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : June 15, 1994
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with System;

package body System_Signal is

   --
   -- Original_Handler_Routine is the address of the routine which previously
   -- handled this signal.  It may also be set to the values SIG_DFL or
   -- SIG_IGN, if these were the original actions associated with the signal.
   --
   Original_Handler_Routine : System.ADDRESS;

   ---------------------------------------------------------------------------
   -- Signal
   ---------------------------------------------------------------------------
   -- Purpose: Provides access to the system "signal" routine.
   ---------------------------------------------------------------------------

   function Signal(
      Sig  : in INTEGER;
      Func : in System.ADDRESS)
     return System.ADDRESS;

   pragma INTERFACE(C, Signal);

   ---------------------------------------------------------------------------
   -- Set_Handler
   ---------------------------------------------------------------------------

   procedure Set_Handler is

   begin  -- Set_Handler

      Original_Handler_Routine
        := Signal(Signal_Handled, Handler_Routine'ADDRESS);

   end Set_Handler;

   ---------------------------------------------------------------------------
   -- Restore_Original_Handler
   ---------------------------------------------------------------------------

   procedure Restore_Original_Handler is

      --
      -- The call to signal returns the current handler, which is no longer
      -- needed at this point, since we're replacing it with the original
      -- handler.
      --
      Temp_Handler : System.ADDRESS;

   begin  -- Restore_Original_Handler

      Temp_Handler
        := Signal(Signal_Handled, Original_Handler_Routine);

   end Restore_Original_Handler;

   ---------------------------------------------------------------------------
   -- Ignore_Signal
   ---------------------------------------------------------------------------

   procedure Ignore_Signal is

      Sig_Return : System.ADDRESS;

      --
      -- Define the SIG_IGN constant, based on <sys/signal.h> constant.
      --

      SIG_IGN : System.ADDRESS := System."+"(1);

   begin  -- Ignore_Signal

      Sig_Return := Signal(Signal_Handled, SIG_IGN);

   end Ignore_Signal;

end System_Signal;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
