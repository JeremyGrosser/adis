--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--  
--  
--  ADIS / PDU_Operators.ada
--  
--  
--  DESCRIPTION:
--  
-- 	This package forms part of the Ada binding to the DIS specification. The
--	procedures eleborated in this package body are useful in manipulating
--	the DIS objects represented in the specification.
--  
--  
--  MODIFICATION HISTORY:
--   
--  28 Jul 94 / L. Ullom
--  	  Initial Baseline Version V1.0
--  22 Aug 94 / L. Ullom
--	  Add patches to fix problem induced by Verdix's insertion of a 16
--	  (usualy) byte vector at the begining of all variable length arrays.
--	  This "feature" causes the PDU's and thier constuant parts to be
--	  misaligned.
--  
--  ===========================================================================

with SYSTEM;  use SYSTEM;
with UNCHECKED_DEALLOCATION;
with NUMERIC_TYPES;  use NUMERIC_TYPES;

--  *===================================*
--  |                                   |
--  |   DIS_TYPES			|
--  |                                   |
--  *===================================*

package body PDU_OPERATORS is
-- 
--|
--| Implementation Notes:
--|
--	[tbs]...
--|

  use DIS_TYPES;
  use DIS_PDU_POINTER_TYPES;

  -- Internal Type Definitions -------------------------------------------------

  EMITTER_SYSTEM_HEADER_SIZE : constant NUMERIC_TYPES.UNSIGNED_16_BIT := 20; -- octets.
  EMISSION_HEADER_SIZE       : constant NUMERIC_TYPES.UNSIGNED_16_BIT := 28; -- octets
  TRACK_JAM_SIZE             : constant INTEGER := A_TRACK_OR_JAM'size / 32; -- long words

  type A_WORD_BUFFER is array (INTEGER range <>) of NUMERIC_TYPES.UNSIGNED_32_BIT;
  type AN_EMITTER_HEADER is
    record
      System_Data_Length  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Number_Of_Beams	  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Padding		  : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Emitter_System	  : AN_EMITTER_SYSTEM_RECORD;
      Location		  : AN_ENTITY_COORDINATE_VECTOR;
    end record;
  for AN_EMITTER_HEADER use
    record
      System_Data_Length  at 0 range 0..7;
      Number_Of_Beams	  at 0 range 8..15;
      Padding		  at 0 range 16..31;
      Emitter_System	  at 0 range 32..63;
      Location		  at 0 range 64..159;
    end record;
  type A_BEAM_HEADER is
    record
      Beam_Data_Length           : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Beam_ID_Number             : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Beam_Parameter_Index       : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Fundamental_Parameter_Data : A_FUNDAMENTAL_PARAMETER_DATA_RECORD;
      Beam_Function              : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Number_Of_Targets          : NUMERIC_TYPES.UNSIGNED_8_BIT;
      High_Density_Track_Jam     : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Padding                    : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Jamming_Mode_Sequence      : NUMERIC_TYPES.UNSIGNED_32_BIT;
    end record;
  for A_BEAM_HEADER use
    record
      Beam_Data_Length           at 0 range 0..7;
      Beam_ID_Number             at 0 range 8..15;
      Beam_Parameter_Index       at 0 range 16..31;
      Fundamental_Parameter_Data at 0 range 32..351;
      Beam_Function              at 0 range 352..359;
      Number_Of_Targets          at 0 range 360..367;
      High_Density_Track_Jam     at 0 range 368..375;
      Padding                    at 0 range 376..383;
      Jamming_Mode_Sequence      at 0 range 384..415;
    end record;

  -- Internal Exceptions -------------------------------------------------------
  EXCEEDS_MAXIMUM_LENGTH : exception;  -- The resulting PDU length would > MAX
  STRUCTURE_ERROR        : exception;  -- A data structure contains an error
  NULL_POINTER           : exception;  -- An "in" or "in out" access type is nul
  EXIT_NOW               : exception;  -- Subunit terminate and retain status

  -- Internal Procedure Definitions --------------------------------------------

  ------------------------------------------------------------------------------
  -- Copy a block of 32 bit words from one location in memory to another
  ------------------------------------------------------------------------------
  procedure Word_Copy (To_Location   : SYSTEM.ADDRESS;
		       From_Location : SYSTEM.ADDRESS;
		       Total_Words   : INTEGER) is
    To_Buffer   : A_WORD_BUFFER(1..Total_Words);
    for To_Buffer use at To_Location;
    From_Buffer : A_WORD_BUFFER(1..Total_Words);
    for From_Buffer use at From_Location;
  begin
    To_Buffer := From_Buffer;
  end Word_Copy;

  ------------------------------------------------------------------------------
  -- Read an Emitter system record header block from an address
  ------------------------------------------------------------------------------
  procedure Get_Header (Header :    out AN_EMITTER_HEADER;
			From   : in     SYSTEM.ADDRESS) is
    Temp : AN_EMITTER_HEADER;
    for Temp use at From;
  begin
    Header := Temp;
  end Get_Header;

  ------------------------------------------------------------------------------
  -- Read a Beam Data Record header block from an address
  ------------------------------------------------------------------------------
  procedure Get_Header (Header :    out A_BEAM_HEADER;
			From   : in     SYSTEM.ADDRESS) is
    Temp : A_BEAM_HEADER;
    for Temp use at From;
  begin
    Header := Temp;
  end Get_Header;

  procedure Free is new UNCHECKED_DEALLOCATION (AN_EMISSION_PDU,
						EMISSION_PDU_PTR);
  procedure Free is new UNCHECKED_DEALLOCATION (AN_EMITTER_SYSTEM_DATA_HEADER,
						AN_EMITTER_POINTER);

  -- Body Segments For Spec Defines --------------------------------------------

  function Is_Valid_String (Marking : A_MARKING_SET) return BOOLEAN is
    Test : CHARACTER;
  begin
    for Char in Marking'first..Marking'last loop
      Test := As_Character(Marking(Char));
    end loop;
    return TRUE;
  exception
    when CONSTRAINT_ERROR =>
      return FALSE;
  end Is_Valid_String;

  procedure Valid_String (Marking  : in     DIS_TYPES.A_MARKING_SET;
			  Responce :    out BOOLEAN;
			  Status   :    out DL_STATUS.STATUS_TYPE) is
  begin
    Status := DL_STATUS.SUCCESS;
    Responce := Is_Valid_String(Marking);
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Valid_String;

  function As_String (Marking : A_MARKING_SET) return STRING is
    Text  : STRING (Marking'first..Marking'last);
    Index : INTEGER := Marking'first;
  begin
    while Index <= Text'last and then Marking(Index) /= 0 loop
      Text(Index) := As_Character(Marking(Index));
      Index := Index + 1;
    end loop;
    return Text(Text'first..Index-1);
  exception
    when CONSTRAINT_ERROR =>
      raise TEXT_NOT_VALID;
  end As_String;

  procedure Convert_To_String (Marking : in     DIS_TYPES.A_MARKING_SET;
			       Text    :    out STRING;
			       Length  :    out NATURAL;
			       Status  :    out DL_STATUS.STATUS_TYPE) is
    Marking_Text : STRING(Marking'first..Marking'last);
    Mark_Length  : NATURAL;
    Text_Length  : NATURAL;
  begin
    Status := DL_STATUS.SUCCESS;
    Mark_Length := As_String(Marking)'length;
    Text_length := Text'length;
    if Text_length < Mark_Length then
      Text := As_String(Marking)(Marking'first..Marking'first+Text_length-1);
      Length := Text_Length;
    elsif Text_Length = Mark_Length then
      Text := As_String(Marking);
      Length := Text_Length;
    else
      Text(Text'first..Text'first+Mark_Length-1) := As_String(Marking);
      Length := Mark_Length;
    end if;
  exception
    when TEXT_NOT_VALID =>
--      Status := DL_STATUS.TEXT_NOT_VALID;
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Convert_To_String;

  function As_Marking (Text : STRING) return A_MARKING_SET is
    Marking : A_MARKING_SET;
    T_Index : INTEGER;
    M_Index : INTEGER;
    M_First : INTEGER := Marking'first;
    T_First : INTEGER := Text'first;
    T_Last  : INTEGER := Text'last;
  begin
    for Char in 0..INTEGER(Marking'length-1) loop
      M_Index := M_First + Char;
      T_Index := T_First + Char;
      if T_Index <= T_Last then
	Marking(M_Index) := As_Unsigned_8(Text(T_Index));
      else
	Marking(M_Index) := 0;
      end if;
    end loop;                                                                 
    return Marking;
  end As_Marking;

  procedure Convert_To_Marking (Text    : in     STRING;
				Marking :    out DIS_TYPES.A_MARKING_SET;
				Status  :    out DL_STATUS.STATUS_TYPE) is
  begin
    Status := DL_STATUS.SUCCESS;
    Marking := As_Marking(Text);
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Convert_To_Marking;

  procedure Add_Emitter_To_Emission (Emission : in out DIS_PDU_POINTER_TYPES.EMISSION_PDU_PTR;
				     System   : in     AN_EMITTER_POINTER;
				     Status   :    out DL_STATUS.STATUS_TYPE) is
    New_Emission      : EMISSION_PDU_PTR;
    New_System_Length : NUMERIC_TYPES.UNSIGNED_16_BIT;
    Local_Status      : DL_STATUS.STATUS_TYPE;
  begin
    if Emission = null then
      Local_Status := DL_STATUS.ADA_EXCEPTION_RAISED;
      --Status := PDU_STRUCTURE_ERROR;
    elsif System = null then
      Local_Status := DL_STATUS.ADA_EXCEPTION_RAISED;
      --Status := DATA_STRUCTURE_ERROR;
    else
      Local_Status := DL_STATUS.SUCCESS;
      New_System_Length := Emission.Total_System_Length
			   + NUMERIC_TYPES.UNSIGNED_16_BIT(System.System_Data_Length*4)
			   + EMITTER_SYSTEM_HEADER_SIZE;
      New_Emission := new AN_EMISSION_PDU(New_System_Length);
      New_Emission.PDU_Header := Emission.PDU_Header;
      New_Emission.Emitting_Entity_ID := Emission.Emitting_Entity_ID;
      New_Emission.Event_ID := Emission.Event_ID;
      New_Emission.State_Update_Indicator := Emission.State_Update_Indicator;
      New_Emission.Number_Of_Systems := Emission.Number_Of_Systems + 1;
      New_Emission.System_Data(1..Emission.Total_System_Length) := 
        Emission.System_Data(1..Emission.Total_System_Length);
      declare
	Emitter_Header : AN_EMITTER_HEADER;
	for Emitter_Header use at New_Emission.System_Data(Emission.Total_System_Length+1)'address;
      begin
	Emitter_Header.System_Data_Length := System.System_Data_Length;
	Emitter_Header.Number_Of_Beams := System.Number_of_Beams;
	Emitter_Header.Padding := System.Padding;
	Emitter_Header.Emitter_System := System.Emitter_System;
	Emitter_Header.Location := System.Location;
        Word_Copy(New_Emission.System_Data(Emission.Total_System_Length+Emitter_Header'size/8)'address,
	          System.Data'address,
	          INTEGER(System.System_Data_Length));
      end;
      Free(Emission);
      Emission := New_Emission;
      Emission.PDU_Header.Length := EMISSION_HEADER_SIZE + Emission.Total_System_Length;
      Status := Local_Status;
    end if;
  exception
    when others =>
      if New_System_Length > A_SYSTEM_DATA_SIZE'last then
	Status := DL_STATUS.ADA_EXCEPTION_RAISED;
	--Status := EXCEEDS_MAX_SIZE;
      else
	Status := DL_STATUS.ADA_EXCEPTION_RAISED;
      end if;
  end Add_Emitter_To_Emission;

  procedure Add_Beam_To_Emitter (Emitter : in out AN_EMITTER_POINTER;
				 Beam	 : in     DIS_TYPES.A_BEAM_DATA_RECORD;
				 Status  :    out DL_STATUS.STATUS_TYPE) is
    New_Emitter : AN_EMITTER_POINTER;
  begin
    if Emitter = null then
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
      --Status := DATA_STRUCTURE_ERROR;
    else
      Status := DL_STATUS.SUCCESS;
      New_Emitter := new AN_EMITTER_SYSTEM_DATA_HEADER(Emitter.System_Data_Length
						       + Beam.Beam_Data_Length);
      New_Emitter.Number_Of_Beams := Emitter.Number_Of_Beams + 1;   
      New_Emitter.Emitter_System := Emitter.Emitter_System;
      New_Emitter.Location := Emitter.Location;
      New_Emitter.Data(1..Emitter.System_Data_Length) :=
        Emitter.Data(1..Emitter.System_Data_Length);
      declare
	Beam_Header : A_BEAM_HEADER;
	for Beam_Header use at New_Emitter.Data(Emitter.System_Data_Length+1)'address;
      begin
        Beam_Header.Beam_Data_Length := Beam.Beam_Data_Length;
        Beam_Header.Beam_ID_Number := Beam.Beam_ID_Number;
        Beam_Header.Beam_Parameter_Index := Beam.Beam_Parameter_Index;
        Beam_Header.Fundamental_Parameter_Data := Beam.Fundamental_Parameter_Data;
        Beam_Header.Beam_Function := Beam.Beam_Function;
        Beam_Header.Number_Of_Targets := Beam.Number_Of_Targets;
        Beam_Header.High_Density_Track_Jam := Beam.High_Density_Track_Jam;
        Beam_Header.Padding := Beam.Padding;
        Beam_Header.Jamming_Mode_Sequence := Beam.Jamming_Mode_Sequence;
        Word_Copy(New_Emitter.Data(Emitter.System_Data_Length+UNSIGNED_8_BIT(Beam_Header'size/32)+1)'address,
	          Beam.Track_Jam'address, Beam.Track_Jam'length*TRACK_JAM_SIZE);
      end;
      Free(Emitter);
      Emitter := New_Emitter;
    end if;
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Add_Beam_To_Emitter;

  procedure Add_Beam_To_Emitter (Emission : in out DIS_PDU_POINTER_TYPES.EMISSION_PDU_PTR;
				 System	  : in     DIS_TYPES.AN_EMITTER_SYSTEM_RECORD;
				 Beam	  : in     DIS_TYPES.A_BEAM_DATA_RECORD;
				 Status   :    out DL_STATUS.STATUS_TYPE) is
    Emitter	  : AN_EMITTER_POINTER;
    Old_Emitter   : AN_EMITTER_POINTER;
    New_Emission  : EMISSION_PDU_PTR;
    System_Number : NATURAL := 0;
    Local_Status  : DL_STATUS.STATUS_TYPE;
  begin
    if Emission = null then
      raise NULL_POINTER;
    elsif Emission.Total_System_Length + A_SYSTEM_DATA_SIZE(Beam.Beam_Data_Length*4) > A_SYSTEM_DATA_SIZE'last then
      raise EXCEEDS_MAXIMUM_LENGTH;
    end if;
    Status := DL_STATUS.SUCCESS;
    loop
      Get_Emitter(Emitter,System_Number,Emission.all,Local_Status);
      exit when (System_Number = NATURAL(Emission.Number_Of_Systems - 1)) or Emitter.Emitter_System = System or DL_STATUS."/="(Local_Status,DL_STATUS.SUCCESS);
      System_Number := System_Number + 1;
    end loop;
    if DL_STATUS."="(Local_Status,DL_STATUS.SUCCESS) then
      if Emitter.Emitter_System = System then
	Add_Beam_To_Emitter(Emitter,Beam,Local_Status);
	New_Emission := new AN_EMISSION_PDU(0);
	New_Emission.PDU_Header := Emission.PDU_Header;
	New_Emission.Emitting_Entity_ID := Emission.Emitting_Entity_ID;
	New_Emission.Event_ID := Emission.Event_ID;
	New_Emission.State_Update_Indicator := Emission.State_Update_Indicator;
	New_Emission.Number_Of_Systems := 0;
	for Old_System in 0..NATURAL(Emission.Number_Of_Systems-1) loop
	  if Old_System = System_Number then
	    Add_Emitter_To_Emission(New_Emission,Emitter,Local_Status);
	    Free(Emitter);
            if DL_STATUS."/="(Local_Status,DL_STATUS.SUCCESS) then
	      Status := Local_Status;
	      raise EXIT_NOW;
	    end if;
	  else
	    Get_Emitter(Old_Emitter,Old_System,Emission.all,Local_Status);
            if DL_STATUS."/="(Local_Status,DL_STATUS.SUCCESS) then
	      Status := Local_Status;
	      raise EXIT_NOW;
	    end if;
	    Add_Emitter_To_Emission(New_Emission,Old_Emitter,Local_Status);
	    Free(Old_Emitter);
            if DL_STATUS."/="(Local_Status,DL_STATUS.SUCCESS) then
	      Status := Local_Status;
	      raise EXIT_NOW;
	    end if;
	  end if;
	end loop;
	Free(Emission);
	Emission := New_Emission;
        Emission.PDU_Header.Length := EMISSION_HEADER_SIZE + Emission.Total_System_Length;
      else
	Status := DL_STATUS.ADA_EXCEPTION_RAISED;
	--Status := SYSTEM_NOT_FOUND;
      end if;
    else
      Status := Local_Status;
    end if;
  exception
    when EXIT_NOW =>
      null;
    when EXCEEDS_MAXIMUM_LENGTH =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
      --Status := EXCEEDS_MAX_SIZE;
    when NULL_POINTER =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
      --Status := PDU_STRUCTURE_ERROR;
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Add_Beam_To_Emitter;

  procedure Get_Emitter (System	       :    out AN_EMITTER_POINTER;
			 System_Number : in     NATURAL;
			 Emission      : in     AN_EMISSION_PDU;
			 Status        :    out DL_STATUS.STATUS_TYPE) is
    Offset  : A_SYSTEM_DATA_SIZE := 1;
    Emitter : AN_EMITTER_HEADER;
    Temp    : AN_EMITTER_POINTER;
    Length  : INTEGER;
    Index   : INTEGER := 0;
  begin
    if System_Number > INTEGER(Emission.Number_Of_Systems-1) then
--      Status := DL_STATUS.BAD_SYSTEM_NUMBER;
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
    else
      Status := DL_STATUS.SUCCESS;
      loop
        Get_Header(Emitter,Emission.System_Data(Offset)'address);
        exit when index = System_Number;
        Offset := Offset + EMITTER_SYSTEM_HEADER_SIZE + UNSIGNED_16_BIT(Emitter.System_Data_Length*4);
      end loop;
      Temp := new AN_EMITTER_SYSTEM_DATA_HEADER(Emitter.System_Data_Length);
      Length := INTEGER(Emitter.System_Data_Length) + INTEGER(EMITTER_SYSTEM_HEADER_SIZE/4);
      Word_Copy(Temp.all'address,Emission.System_Data(Offset)'address,Length);
      System := Temp;
    end if;
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Get_Emitter;

  function Number_Of_Beams (Emission : AN_EMISSION_PDU;
			    System   : AN_EMITTER_SYSTEM_RECORD) return NATURAL is
    Sys_Number : NATURAL := 0;
    Beams      : NATURAL := 0;
    Emitter    : AN_EMITTER_POINTER;
    Status     : DL_STATUS.STATUS_TYPE;
  begin
    if Emission.Number_Of_Systems > 0 then
      loop
	Get_Emitter(Emitter,Sys_Number,Emission,Status);
	if DL_STATUS."/="(Status,DL_STATUS.SUCCESS) then
	  raise OBJECT_STRUCTURE_ERROR;
	end if;
	Sys_Number := Sys_Number + 1;
        exit when Sys_Number < NATURAL(Emission.Number_Of_Systems) or Emitter.Emitter_System = System;
      end loop;
      if Emitter.Emitter_System = System then
	Beams := NATURAL(Emitter.Number_Of_Beams);
      end if;
    end if;
    return Beams;
  end Number_Of_Beams;

  procedure Get_Number_Of_Beams (Emission : in     AN_EMISSION_PDU;
			         System   : in     NATURAL;
				 Beams    :    out NATURAL;
				 Status   :    out DL_STATUS.STATUS_TYPE) is
    Sys_Number : NATURAL := 0;
    Emitter    : AN_EMITTER_POINTER;
    L_Status   : DL_STATUS.STATUS_TYPE;
  begin
    if Emission.Number_Of_Systems > 0 then
      loop
	Get_Emitter(Emitter,Sys_Number,Emission,L_Status);
        exit when Sys_Number = System or DL_STATUS."/="(L_Status,DL_STATUS.SUCCESS);
	Sys_Number := Sys_Number + 1;
      end loop;
      if DL_STATUS."="(L_Status,DL_STATUS.SUCCESS) then
	Beams := NATURAL(Emitter.Number_Of_Beams);
      else
	Beams := 0;
      end if;
      Status := L_Status;
    end if;
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Get_Number_Of_Beams;

  procedure Get_Number_Of_Beams (Emission : in     AN_EMISSION_PDU;
			         System   : in     AN_EMITTER_SYSTEM_RECORD;
				 Beams    :    out NATURAL;
				 Status   :    out DL_STATUS.STATUS_TYPE) is
  begin
    Status := DL_STATUS.SUCCESS;
    Beams := Number_Of_Beams(Emission,System);
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Get_Number_Of_Beams;

  procedure Get_Beam (Beam	    :    out A_BEAM_DATA_POINTER;
		      Beam_Number   : in     NATURAL;
		      Emission	    : in     AN_EMITTER_SYSTEM_DATA_HEADER;
		      Status        :    out DL_STATUS.STATUS_TYPE) is
    Offset   : NUMERIC_TYPES.UNSIGNED_8_BIT := 1;
    New_Beam : A_BEAM_DATA_POINTER;
    Beam_Hdr : A_BEAM_HEADER;
  begin
    if Beam_Number > NATURAL(Emission.Number_Of_Beams-1) then
--      Status := DL_STATUS.BAD_BEAM_NUMBER;
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
    else
      Status := DL_STATUS.SUCCESS;
      for index in 0..Beam_Number loop
        Get_Header(Beam_Hdr,Emission.Data(Offset)'address);
        Offset := Offset + Beam_Hdr.Beam_Data_Length * 4;
      end loop;
      Get_Header(Beam_Hdr,Emission.Data(Offset)'address);
      New_Beam := new A_BEAM_DATA_RECORD(Beam_Hdr.Number_Of_Targets);
      Word_Copy(New_Beam.all'address,Emission.Data(Offset)'address,INTEGER(Beam_Hdr.Beam_Data_Length));
      Beam := New_Beam;
    end if;
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Get_Beam;

  procedure Get_Beam (Beam	    :    out A_BEAM_DATA_POINTER;
		      Beam_Number   : in     NATURAL;
		      System_Number : in     NATURAL;
		      Emission	    : in     AN_EMISSION_PDU;
                      Status        :    out DL_STATUS.STATUS_TYPE) is
    Emitter      : AN_EMITTER_POINTER;
    New_Beam     : A_BEAM_DATA_POINTER;
    Local_Status : DL_STATUS.STATUS_TYPE;
  begin
    Get_Emitter(Emitter,System_Number,Emission,Local_Status);
    if DL_STATUS."="(Local_Status,DL_STATUS.SUCCESS) then
      Get_Beam(New_Beam,Beam_Number,Emitter.all,Local_Status);
      if DL_STATUS."="(Local_Status,DL_STATUS.SUCCESS) then
        Beam := New_Beam;
      end if;
    end if;
    Status := Local_Status;
  exception
    when others =>
      Status := DL_STATUS.ADA_EXCEPTION_RAISED;
  end Get_Beam;

end PDU_OPERATORS;
