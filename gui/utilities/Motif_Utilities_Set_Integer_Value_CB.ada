
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

with Text_IO;
with Unchecked_Conversion;
with Utilities;
with Xlib;
with XlibR5;
with Xm;
with Xmdef;
with Xtdef;
with Xt;
with XtR5;

separate (Motif_Utilities)

---------------------------------------------------------------------------
--
-- UNIT NAME:          Set_Integer_Value_CB
--
-- PROJECT:            Ada Distributed Interactive Simulation (ADIS)
--
-- AUTHOR:             James Daryl Forrest (J.F. Taylor, Inc.)
--
-- ORIGINATION DATE:   August 4, 1994
--
-- PURPOSE:
--   This procedure sets the value of the Integer variable in the
--   client_data parameter (named Integer_Value here) to the value
--   in the userData field of the activating button.
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
procedure Set_Integer_Value_CB(
   Parent        : in     Xt.WIDGET;
   Integer_Value : in out INTEGER;
   CBS           : in out Xm.ANYCALLBACKSTRUCT_PTR) is

   type AINTEGER is access INTEGER;

   Arglist          : Xt.ArgList (1..9);  -- X argument list
   Argcount         : Xt.Int := 0;        -- number of arguments

   New_Integer_Value_Address : AINTEGER;
   New_Integer_Value : INTEGER;

   function INTEGER_To_AINTEGER
     is new Unchecked_Conversion (INTEGER, AINTEGER);

begin

   --
   -- Extract the new boolean value from the parent widget.
   --
   if (Parent /= Xt.XNULL) then

      --
      -- Get the address of the destination boolean variable out
      -- of the userData field of the callback's widget.
      -- 
      Argcount := 0;
      Argcount := Argcount + 1;
      Xt.SetArg (Arglist (Argcount), Xmdef.NuserData,
	New_Integer_Value'address);
      Xt.GetValues (Parent, Arglist, Argcount);
      New_Integer_Value_Address := INTEGER_To_AINTEGER(New_Integer_Value);

      --
      -- Assign the callback data boolean value to the destination
      -- boolean variable.
      -- 
      New_Integer_Value_Address.all := INTEGER'val(Integer_Value);

   end if;

exception
    
    when OTHERS =>
       Text_IO.Put_Line ("exception raised in Set_Integer_Value_CB.");

end Set_Integer_Value_CB;

----------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
--   08/04/94   D. Forrest
--      - Initial version
--
-- --

