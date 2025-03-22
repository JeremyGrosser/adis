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
-- UNIT NAME        : DG_Host_Specific.Translate_Net_To_Host
--
-- FILE NAME        : DG_HS_Translate_Net_To_Host.ada
--
-- PROJECT          : Ada Distributed Interactive Simulation (ADIS)
--                    DIS Gateway (DG) CSCI
--
-- AUTHOR           : B. Dufault - J. F. Taylor, Inc.
--
-- ORIGINATION DATE : August 29, 1994
--
-- PURPOSE:
--   - Performs any conversion necessary to make a PDU received from the
--     network compatible with the host.
--
-- IMPLEMENTATION NOTES:
--   - None.
--
-- EXCEPTIONS:
--   - None.
--
-- PORTABILITY ISSUES:
--   - This version of the Translate_Net_To_Host routine is specific to the
--     SGI IRIX 5.2 release of the Verdix Ada Compiler Version 6.2.  It
--     accounts for the problems encountered due to Verdix Ada's "dope
--     vector", which consists of 16-18 bytes of data between the static
--     and variant sections of variant record types.
--
-- ANTICIPATED CHANGES:
--   - None.
--
------------------------------------------------------------------------------

with DG_Generic_PDU,
     DG_Verdix_Dope_Vector,
     DIS_PDU_Pointer_Types,
     DIS_Types,
     Numeric_Types,
     System,
     Unchecked_Conversion;

separate (DG_Host_Specific)

procedure Translate_Net_To_Host(
   PDU    : in out DG_Generic_PDU.GENERIC_PDU_POINTER_TYPE;
   Status :    out DG_Status.STATUS_TYPE) is

   --
   -- PDUs which do NOT have a dope vector have all information fields set
   -- to zero.
   --
   K_No_Dope_Vector : constant DG_Verdix_Dope_Vector.DOPE_VECTOR_INFO_TYPE
                        := (Static_Start  => 0,
                            Dope_Start    => 0,
                            Variant_Start => 0);

   PDU_Header : DIS_Types.A_PDU_HEADER;
     for PDU_Header use at PDU.ALL'ADDRESS;

begin  -- Translate_Net_To_Host

   Status := DG_Status.SUCCESS;

   case (PDU_Header.PDU_Type) is

      when DIS_Types.ENTITY_STATE =>

         --
         -- Overlay enough of 'PDU' into an Entity State PDU to overwrite the
         -- default "Number_Of_Parms" field with the value from PDU.
         --
         Find_Articulated_Part_Count:
         declare
            Artic_PDU   : DIS_Types.AN_ENTITY_STATE_PDU(Number_Of_Parms => 0);
            Generic_PDU : DG_Generic_PDU.GENERIC_PDU_TYPE(
                            1..DG_Verdix_Dope_Vector.Offset(
                              DIS_Types.ENTITY_STATE).Dope_Start)
                            := PDU(1..DG_Verdix_Dope_Vector.Offset(
                                 DIS_Types.ENTITY_STATE).Dope_Start);
              for Generic_PDU use at Artic_PDU'ADDRESS;
         begin

            Create_Dope_Entity_State_PDU:
            declare
               Dope_PDU     : DIS_Types.AN_ENTITY_STATE_PDU(
                                Number_Of_Parms => Artic_PDU.Number_Of_Parms);
               Generic_Dope : DG_Generic_PDU.GENERIC_PDU_TYPE(
                                1..Dope_PDU'SIZE/8);
                 for Generic_Dope use at Dope_PDU'ADDRESS;
            begin

               --
               -- Copy data from static portions of PDU
               --
               Generic_Dope(
                 DG_Verdix_Dope_Vector.Offset(DIS_Types.ENTITY_STATE).
                   Static_Start+1..DG_Verdix_Dope_Vector.Offset(
                     DIS_Types.ENTITY_STATE).Dope_Start)
                 := PDU(
                     DG_Verdix_Dope_Vector.Offset(DIS_Types.ENTITY_STATE).
                       Static_Start+1..DG_Verdix_Dope_Vector.Offset(
                         DIS_Types.ENTITY_STATE).Dope_Start);

               --
               -- Dope vector information is set automatically by the
               -- "use at" clause.
               --

               --
               -- Check to ensure that variant data exists, and copy to
               -- the dope-vectored PDU.
               --

               if (PDU.ALL'LAST > DG_Verdix_Dope_Vector.Offset(
                 DIS_Types.ENTITY_STATE).Dope_Start) then

                  Generic_Dope(
                    DG_Verdix_Dope_Vector.Offset(DIS_Types.ENTITY_STATE).
                      Variant_Start+1..Generic_Dope'LAST)
                    := PDU(
                         DG_Verdix_Dope_Vector.Offset(DIS_Types.ENTITY_STATE).
                           Dope_Start+1..PDU.ALL'LAST);

               end if;

               --
               -- Deallocate old PDU
               --
               DG_Generic_PDU.Free_Generic_PDU(PDU);

               --
               -- Reassign PDU to new doped data
               --
               PDU := new DG_Generic_PDU.GENERIC_PDU_TYPE(
                            1..Generic_Dope'LENGTH);

               PDU.ALL := Generic_Dope;

            end Create_Dope_Entity_State_PDU;

         end Find_Articulated_Part_Count;

      when OTHERS =>

         null;  -- No dope vector fixes done

   end case;

exception

   when STORAGE_ERROR =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

   when OTHERS =>

      Status := DG_Status.DG_PLACEHOLDER_ERROR;

end Translate_Net_To_Host;

------------------------------------------------------------------------------
--
-- MODIFICATION HISTORY:
--
------------------------------------------------------------------------------
