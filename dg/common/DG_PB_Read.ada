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
-- UNIT NAME        : DG_PDU_Buffer.Read
--
-- FILE NAME        : DG_PB_Read.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : July 22, 1994
--
-- PURPOSE:
--   - 
--
-- IMPLEMENTATION NOTES:
--   - 
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - None.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DIS_Types,
     Unchecked_Conversion;

separate (DG_PDU_Buffer)

procedure Read(
   PDU_Read_Index  : in out INTEGER;
   PDU_Write_Index : in     INTEGER;
   PDU_Buffer      : in     PDU_BUFFER_TYPE;
   PDU             :    out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Status          :    out DG_Status.STATUS_TYPE) is

   K_Header_Size  : constant INTEGER := (DIS_Types.A_PDU_HEADER'SIZE+7)/8;
   K_Min_Size_PDU : constant INTEGER := K_Header_Size;
   K_Max_Size_PDU : constant INTEGER := 1200;

   Local_PDU         : DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   PDU_Header        : DIS_Types.A_PDU_HEADER;
   PDU_Header_Buffer : PDU_BUFFER_TYPE(1..K_Header_Size);
   PDU_Length        : INTEGER;

   function Buffer_To_Header is
     new Unchecked_Conversion(
           PDU_BUFFER_TYPE, --(1..K_Header_Size),
           DIS_Types.A_PDU_HEADER);

   INVALID_LENGTH_ERROR : EXCEPTION;

begin  -- Read

   Status := DG_Status.SUCCESS;
   PDU    := NULL;

   if (PDU_Read_Index = PDU_Write_Index) then
      return;
   end if;

   if (PDU_Read_Index + K_Header_Size - 1 <= PDU_Buffer'LAST) then

      --
      -- The entire header is present without wrapping
      --
      PDU_Header_Buffer
        := PDU_Buffer(PDU_Read_Index..PDU_Read_Index + K_Header_Size -1);

   else

      --
      -- The header is wrapped around the buffer
      --

      PDU_Header_Buffer(1..(PDU_Buffer'LENGTH-PDU_Read_Index+1))
        := PDU_Buffer(PDU_Read_Index..PDU_Buffer'LENGTH);

      PDU_Header_Buffer(PDU_Buffer'LENGTH-PDU_Read_Index+2..K_Header_Size)
        := PDU_Buffer(1..K_Header_Size-(PDU_Buffer'LENGTH-PDU_Read_Index+1));

   end if;

   --
   -- Retrieve header information
   --
   PDU_Header := Buffer_To_Header(PDU_Header_Buffer);

   --
   -- Determine the length of the PDU.
   --
   PDU_Length := INTEGER(PDU_Header.Length);

   --
   -- Sanity check -- assume error if length is too small or too large for a
   -- valid PDU.
   --
   if ((PDU_Length < K_Min_Size_PDU) or else (PDU_Length > K_Max_Size_PDU))
   then
      raise INVALID_LENGTH_ERROR;
   end if;

   --
   -- Increase length if neccessary to account for Verdix Ada "dope vector"
   --
   case (PDU_Header.PDU_Type) is

      when DIS_Types.EMISSION =>

         PDU_Length := PDU_Length + 16;

      when OTHERS =>

         null;

   end case;

   --
   -- Allocate space to store the new PDU
   --
   Local_PDU := new DG_Generic_PDU.GENERIC_PDU_TYPE(1..PDU_Length);

   --
   -- Retrieve PDU information
   --

   if ((PDU_Read_Index + PDU_Length - 1) <= PDU_Buffer'LAST) then

      --
      -- PDU did not wrap
      --

      Local_PDU.ALL
        := PDU_Buffer(PDU_Read_Index..(PDU_Read_Index + PDU_Length - 1));

   else

      --
      -- PDU wraps around buffer
      --

      --
      -- Copy first part of PDU
      --

      Local_PDU(1..(PDU_Buffer'LAST-PDU_Read_Index+1))
        := PDU_Buffer(PDU_Read_Index..PDU_Buffer'LAST);

      Local_PDU((PDU_Buffer'LAST-PDU_Read_Index+2)..Local_PDU.ALL'LAST)
        := PDU_Buffer(
             1..(Local_PDU.ALL'LAST-(PDU_Buffer'LAST-PDU_Read_Index+1)));

   end if;

   --
   -- Update buffer read index
   --

   PDU_Read_Index
     := ((PDU_Read_Index + PDU_Length - 1) mod PDU_Buffer'LENGTH) + 1;

   PDU := Local_PDU;

exception

   when INVALID_LENGTH_ERROR =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

      --
      -- Synchronize indexes to attempt recover
      --
      PDU_Read_Index := PDU_Write_Index;

   when OTHERS =>

      Status := DG_Status.PB_READ_FAILURE;

      --
      -- Synchronize indexes to attempt recover
      --
      PDU_Read_Index := PDU_Write_Index;

end Read;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
