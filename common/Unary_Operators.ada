-- {source_file_header_comment}
 
with SYSTEM;
 
-- {package_title_header}
 
package body UNARY_OPERATORS is
--[implementation_notes_comment]
  type BOOLEAN_ARRAY is array (INTEGER range <>) of BOOLEAN;
  pragma PACK(BOOLEAN_ARRAY);

  function U_not (Number : UNSIGNED_TYPE) return UNSIGNED_TYPE is
    BITS	: BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    for BITS use at Number'address;
    Boolean_Rep : BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    Result	: UNSIGNED_TYPE;
    for Result use at Boolean_Rep'address;
  begin
    for bit in 1..BITS'last loop
      Boolean_Rep(bit) := not BITS(bit);
    end loop;
    return Result;
  end U_not;

  function U_and (Left,Right : UNSIGNED_TYPE) return UNSIGNED_TYPE is
    BITS_Left	: BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    for BITS_Left use at Left'address;
    BITS_Right	: BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    for BITS_Right use at Right'address;
    Boolean_Rep : BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    Result	: UNSIGNED_TYPE;
    for Result use at Boolean_Rep'address;
  begin
    for bit in 1..BITS_Left'last loop
      Boolean_Rep(bit) := BITS_Left(bit) and  BITS_Right(bit);
    end loop;
    return Result;
  end U_and;

  function U_or  (Left,Right : UNSIGNED_TYPE) return UNSIGNED_TYPE is
    BITS_Left	: BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    for BITS_Left use at Left'address;
    BITS_Right	: BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    for BITS_Right use at Right'address;
    Boolean_Rep : BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    Result	: UNSIGNED_TYPE;
    for Result use at Boolean_Rep'address;
  begin
    for bit in 1..BITS_Left'last loop
      Boolean_Rep(bit) := BITS_Left(bit) or  BITS_Right(bit);
    end loop;
    return Result;
  end U_or;

  function L_Shift (Number : UNSIGNED_TYPE; By : INTEGER) return UNSIGNED_TYPE is
    BITS	: BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    for BITS use at Number'address;
    Boolean_Rep : BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    Result	: UNSIGNED_TYPE;
    for Result use at Boolean_Rep'address;
  begin
    Boolean_Rep(By+1..Boolean_Rep'last) := BITS(1..BITS'last-By);
    Boolean_Rep(1..By) := (others=>FALSE);
    return Result;
  end L_Shift;

  function R_Shift (Number : UNSIGNED_TYPE; By : INTEGER) return UNSIGNED_TYPE is
    BITS	: BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    for BITS use at Number'address;
    Boolean_Rep : BOOLEAN_ARRAY(1..UNSIGNED_TYPE'size);
    Result	: UNSIGNED_TYPE;
    for Result use at Boolean_Rep'address;
  begin
    Boolean_Rep(1..Boolean_Rep'last-By) := BITS(By+1..BITS'last);
    Boolean_Rep(Boolean_Rep'last-By+1..Boolean_Rep'last) := (others=>FALSE);
    return Result;
  end R_Shift;

end UNARY_OPERATORS;
