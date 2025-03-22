with CALENDAR;
with NUMERIC_TYPES;

function Get_Time_Stamp return NUMERIC_TYPES.UNSIGNED_32_BIT;

function Get_Time_Stamp return NUMERIC_TYPES.UNSIGNED_32_BIT is
  function "*" (Left,Right : NUMERIC_TYPES.UNSIGNED_32_BIT)
    return NUMERIC_TYPES.UNSIGNED_32_BIT renames NUMERIC_TYPES."*";
  Scale_Factor      : constant := (2.0**31) / 3600.0;
  The_Time          : CALENDAR.TIME;
  Integer_Seconds   : INTEGER;
  Seconds_Past_Hour : FLOAT;
  Time_Stamp        : NUMERIC_TYPES.UNSIGNED_32_BIT;
begin
  The_Time := CALENDAR.Clock;
  Seconds_Past_Hour := FLOAT(CALENDAR.Seconds(The_Time)) / 3600.0;
  Integer_Seconds := INTEGER(Seconds_Past_Hour);
  if (Seconds_Past_Hour - FLOAT(Integer_Seconds)) < 0.0 then
    Integer_Seconds := Integer_Seconds - 1;
  end if;
  Seconds_Past_Hour := (Seconds_Past_Hour - FLOAT(Integer_Seconds)) * 3600.0;
  Time_Stamp := NUMERIC_TYPES.UNSIGNED_32_BIT(Seconds_Past_Hour * Scale_Factor);
  return Time_Stamp * 2;  -- Left Shift by 1 place
end Get_Time_Stamp;
