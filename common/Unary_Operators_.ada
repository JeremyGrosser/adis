--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--  
--  
--  ADIS / UNARY_OPERATORS_.ADA
--  
--  
--  DESCRIPTION:
--  
-- 	This package contains a set of generic functions to perform
--	unary math on any integer type.  Each function is declared as
--	inline to maximize the speed at which they execute.  If storage
--	is a problem then override the pragmas with comments or command
--	line directives.
--  
--  
--  MODIFICATION HISTORY:
--   
--  11 Apr 1994 / Larry Ullom
--  	  Initial Baseline Version V1.0
--  {change_entry}...
--  
--  ===========================================================================
 
--  *===================================*
--  |                                   |
--  |   UNARY_OPERATORS			|
--  |                                   |
--  *===================================*
 
--| 
--|  Initialization Exceptions:
--| 
--	 NONE
--| 
--|  Notes:
--| 
--	 [tbs]...
--| 
 
generic
  type UNSIGNED_TYPE is range <>;
package UNARY_OPERATORS is

--------------------------------------------------------------------------------
-- Perform bit by bit negation. ------------------------------------------------

  function U_not (Number : UNSIGNED_TYPE) return UNSIGNED_TYPE;
  pragma INLINE(U_not);
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Bit by bit "and" of Left and Right. -----------------------------------------

  function U_and (Left,Right : UNSIGNED_TYPE) return UNSIGNED_TYPE;
  pragma INLINE(U_and);
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Bit by bit "or" of Left and Right. ------------------------------------------

  function U_or  (Left,Right : UNSIGNED_TYPE) return UNSIGNED_TYPE;
  pragma INLINE(U_or);
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Shift bits of Number left By number of places filling with 0s. --------------
-- Assume leftmost bit is most significant and rightmost is least. -------------

  function L_Shift (Number : UNSIGNED_TYPE; By : INTEGER) return UNSIGNED_TYPE;
  pragma INLINE(L_Shift);
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Shift bits of Number right By number of places filling with 0s. -------------
-- Assume leftmost bit is most significant and rightmost is least. -------------

  function R_Shift (Number : UNSIGNED_TYPE; By : INTEGER) return UNSIGNED_TYPE;
  pragma INLINE(R_Shift);
--------------------------------------------------------------------------------

end UNARY_OPERATORS;
