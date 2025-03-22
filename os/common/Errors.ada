--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- PACKAGE NAME :      Errors
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  31 May 94
--
-- PURPOSE :
--
-- EFFECTS:
--
-- EXCEPTIONS :
--
-- PORTABILITY ISSUES :
--
-- ANTICIPATED CHANGES :
--
------------------------------------------------------------------------------
package body Errors is

   Overflow_Count : INTEGER := 0;

   -- Function to determine length of strings
   function "+" (
      Text:  STRING)
      return OS_Data_Types.V_STRING
     is
   begin
     return (Text'LENGTH, Text);
   end "+";

   -- Procedure bodies
   procedure Detonate_Due_to_Error(
      Detonation_Result :  in     DIS_Types.A_DETONATION_RESULT;
      Hashing_Index     :  in     INTEGER;
      Status            :     out OS_Status.STATUS_TYPE)
     is separate;

   procedure Report_Error(
      Detonated_Prematurely :  in BOOLEAN;
      Error                 :  in OS_Status.STATUS_TYPE)
     is separate;

   procedure Get_Error(
      Overflow      : out BOOLEAN;
      Error_Present : out BOOLEAN;
      Error_Entry   : out OS_Data_Types.ERROR_QUEUE_ENTRY_TYPE)
     is separate;

end Errors;
