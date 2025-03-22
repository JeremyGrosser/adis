--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfar Center Aircraft Division                |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--  
--  
--  ADIS / NUMERIC_TYPES_.ADA
--  
--  
--  DESCRIPTION:
--  
-- 	This file contains the system dependant low level type definitions that
--	define the fixed octet size types used in DIS packets.  To make the DIS
--	type definition packages compile correctly this file should be modified
--	to reflect the correct maping of implementation dependant types to the
--	fixed octet size types declared here.
--	[tbs]...
--  
--  
--  MODIFICATION HISTORY:
--   
--  05 Apr 1994 / Larry Ullom
--  	  Initial Baseline Version V1.0
--  13 May 1994 / Brett Dufault
--        Changed parent type of FLOAT_32_BIT from FLOAT (which in Verdix
--        Ada is a 64-bit float) to SHORT_FLOAT (which is 32 bits).
--  16 May 1994 / Brett Dufault
--        Added +-*/mod functions for UNSIGNED_8/16/32_BIT types.
--  09 Jun 1994 / Brett Dufault
--        Changed FLOAT_32_BIT and FLOAT_64_BIT from type to subtype to
--          provide operator visibility.
--        Changed underlying type of FLOAT_64_BIT from LONG_FLOAT to FLOAT
--          for compatibility with Verdix's Math package.
--  10 Jun 1994 / Larry Ullom
--	  Added UNSIGNED_64_BIT to allow for the frequency field in the 
--	    transmitter PDU.
--  {change_entry}...
--  
--  ===========================================================================
 
--  *===================================*
--  |                                   |
--  |   NUMERIC_TYPES			|
--  |                                   |
--  *===================================*
 
--| 
--|  Initialization Exceptions:
--| 
--	 NONE
--| 
--|  Notes:
--| 
--	 Because Ada does not permit an nonsymetrical unsigned type definition
--	 greater then the range 0..SYSTEM.MAX_INT to atchieve a 32 bit unsigned
--	 on a machine with a 32 bit archetecture we must use signed numbers
--	 and only consider the bit paterns, rather than the signed meaning.
--	 [tbs]...
--| 

package NUMERIC_TYPES is

  BYTE : constant := 8; -- bits
  WORD : constant := 2; -- bytes

  type UNSIGNED_1_BIT is range 0..1;
  for UNSIGNED_1_BIT'size use 1;

  type UNSIGNED_5_BIT is range 0..(2**5)-1;
  for UNSIGNED_5_BIT'size use 5;

  type UNSIGNED_8_BIT is range 0..(2**8)-1;
  for UNSIGNED_8_BIT'size use 8;

  type UNSIGNED_16_BIT is range 0..(2**16)-1;
  for UNSIGNED_16_BIT'size use 16;

  subtype POSITIVE_16_BIT is UNSIGNED_16_BIT range 1..UNSIGNED_16_BIT'last;

  type UNSIGNED_26_BIT is range 0..(2**26)-1;
  for UNSIGNED_26_BIT'size use 26;

  type UNSIGNED_31_BIT is range 0..(2**31)-1;
  for UNSIGNED_31_BIT'size use 31;

  type UNSIGNED_32_BIT is range INTEGER'first..INTEGER'last; -- Implementation
  for UNSIGNED_32_BIT'size use 32;                           -- constrained.

  type UNSIGNED_64_BIT is array (0..1) of UNSIGNED_32_BIT;   -- Platform limit
  for UNSIGNED_64_BIT'size use 64;                           -- of 32 bit ints

  subtype FLOAT_32_BIT is SHORT_FLOAT;

  subtype FLOAT_64_BIT is FLOAT;
  
  function "not" (Number : UNSIGNED_1_BIT) return UNSIGNED_1_BIT;
  function "and" (Left,Right : UNSIGNED_1_BIT) return UNSIGNED_1_BIT;
  function "or"  (Left,Right : UNSIGNED_1_BIT) return UNSIGNED_1_BIT;

  function "not" (Number : UNSIGNED_5_BIT) return UNSIGNED_5_BIT;
  function "and" (Left,Right : UNSIGNED_5_BIT) return UNSIGNED_5_BIT;
  function "or"  (Left,Right : UNSIGNED_5_BIT) return UNSIGNED_5_BIT;
  function Shift_Left (Number : UNSIGNED_5_BIT; By : INTEGER) return UNSIGNED_5_BIT;
  function Shift_Right (Number : UNSIGNED_5_BIT; By : INTEGER) return UNSIGNED_5_BIT;
  procedure Shift_Left (Number : in out UNSIGNED_5_BIT; By : in INTEGER);
  procedure Shift_Right (Number : in out UNSIGNED_5_BIT; By : in INTEGER);

  function As_Character(Number : UNSIGNED_8_BIT) return CHARACTER;
  function As_Unsigned_8 (Char : CHARACTER) return UNSIGNED_8_BIT;
  function "+" (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function "-" (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function "*" (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function "/" (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function "mod" (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function "not" (Number : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function "and" (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function "or"  (Left,Right : UNSIGNED_8_BIT) return UNSIGNED_8_BIT;
  function Shift_Left (Number : UNSIGNED_8_BIT; By : INTEGER) return UNSIGNED_8_BIT;
  function Shift_Right (Number : UNSIGNED_8_BIT; By : INTEGER) return UNSIGNED_8_BIT;
  procedure Shift_Left (Number : in out UNSIGNED_8_BIT; By : in INTEGER);
  procedure Shift_Right (Number : in out UNSIGNED_8_BIT; By : in INTEGER);

  function "+" (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function "-" (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function "*" (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function "/" (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function "mod" (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function "not" (Number : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function "and" (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function "or"  (Left,Right : UNSIGNED_16_BIT) return UNSIGNED_16_BIT;
  function Shift_Left (Number : UNSIGNED_16_BIT; By : INTEGER) return UNSIGNED_16_BIT;
  function Shift_Right (Number : UNSIGNED_16_BIT; By : INTEGER) return UNSIGNED_16_BIT;
  procedure Shift_Left (Number : in out UNSIGNED_16_BIT; By : in INTEGER);
  procedure Shift_Right (Number : in out UNSIGNED_16_BIT; By : in INTEGER);

  function "not" (Number : UNSIGNED_26_BIT) return UNSIGNED_26_BIT;
  function "and" (Left,Right : UNSIGNED_26_BIT) return UNSIGNED_26_BIT;
  function "or"  (Left,Right : UNSIGNED_26_BIT) return UNSIGNED_26_BIT;
  function Shift_Left (Number : UNSIGNED_26_BIT; By : INTEGER) return UNSIGNED_26_BIT;
  function Shift_Right (Number : UNSIGNED_26_BIT; By : INTEGER) return UNSIGNED_26_BIT;
  procedure Shift_Left (Number : in out UNSIGNED_26_BIT; By : in INTEGER);
  procedure Shift_Right (Number : in out UNSIGNED_26_BIT; By : in INTEGER);

  function "not" (Number : UNSIGNED_31_BIT) return UNSIGNED_31_BIT;
  function "and" (Left,Right : UNSIGNED_31_BIT) return UNSIGNED_31_BIT;
  function "or"  (Left,Right : UNSIGNED_31_BIT) return UNSIGNED_31_BIT;
  function Shift_Left (Number : UNSIGNED_31_BIT; By : INTEGER) return UNSIGNED_31_BIT;
  function Shift_Right (Number : UNSIGNED_31_BIT; By : INTEGER) return UNSIGNED_31_BIT;
  procedure Shift_Left (Number : in out UNSIGNED_31_BIT; By : in INTEGER);
  procedure Shift_Right (Number : in out UNSIGNED_31_BIT; By : in INTEGER);

  function "+" (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function "-" (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function "*" (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function "/" (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function "mod" (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function "not" (Number : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function "and" (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function "or"  (Left,Right : UNSIGNED_32_BIT) return UNSIGNED_32_BIT;
  function Shift_Left (Number : UNSIGNED_32_BIT; By : INTEGER) return UNSIGNED_32_BIT;
  function Shift_Right (Number : UNSIGNED_32_BIT; By : INTEGER) return UNSIGNED_32_BIT;
  procedure Shift_Left (Number : in out UNSIGNED_32_BIT; By : in INTEGER);
  procedure Shift_Right (Number : in out UNSIGNED_32_BIT; By : in INTEGER);

end NUMERIC_TYPES; 
