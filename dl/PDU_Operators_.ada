--
--  *=========================================================================*
--  |                                                                         |
--  |                         Manned Flight Simulator                         |
--  |                Naval Air Warfare Center Aircraft Division               |
--  |                        Patuxent River, Maryland                         |
--  |                                                                         |
--  *=========================================================================*
--  
--  
--  ADIS / PDU_Operators_.ada
--  
--  
--  DESCRIPTION:
--  
-- 	This package contains the primatives for manipulating the PDU objects
--	defined in the DIS 2.0.3 (IEEE 1278) standard and enumerated in the
--      DIS_Types package.
--  
--  
--  MODIFICATION HISTORY:
--   
--  27 Jul 1994 / Larry Ullom
--  	  Initial Baseline Version V1.0
--  25 Aug 1994 / Larry Ullom
--        Modified emissions handlers to not depend on the alignment of the data
--        within an emission pdu.
--        Added Get_Number_Of_Beams that accepts a system number instead of an
--        identifier.
--  
--  ===========================================================================
 
with DIS_TYPES;
with DL_STATUS;
with DIS_PDU_POINTER_TYPES;
 
--  *===================================*
--  |                                   |
--  |   PDU_Operators                   |
--  |                                   |
--  *===================================*
 
--| 
--|  Initialization Exceptions:
--| 
--	 none.
--| 
--|  Notes:
--| 
--       * Any deviations from or clarification of the standard are commented
--       with a boarder of \/\/\/\/\/.
--       * The exceptions defined in this package are only raised by the
--       function calls.  All procedures use Status codes to indicate an error
--       occured durring processing.
--| 
 
package PDU_OPERATORS is 

  -- EXCEPTIONS ----------------------------------------------------------------
  TEXT_NOT_VALID         : exception;	-- A non ASCII character was found when
					-- only ASCII was expected.
  OBJECT_STRUCTURE_ERROR : exception;	-- The object referenced contained an
					-- error in the field structure.
  ------------------------------------------------------------------------------

  -- MARKING SET OPERATIONS ----------------------------------------------------

  ------------------------------------------------------------------------------
  function Is_Valid_String (Marking : DIS_TYPES.A_MARKING_SET) return BOOLEAN;
  --
  -- Description: Determine if the values of the Marking Set can be converted to
  --		  standard ASCII characters and represented in an object of type
  --		  STRING.
  -- Parameters: Marking -> an object containing A_MARKING_SET
  --		 return value <- True or False

  ------------------------------------------------------------------------------
  procedure Valid_String (Marking  : in     DIS_TYPES.A_MARKING_SET;
			  Responce :    out BOOLEAN;
			  Status   :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: Same as function Is_Valid_String.
  -- Parameters: Marking -> an object containing A_MARKING_SET
  --		 Resopnce <- the result of the evaluation
  --		 Status <- indicates success or reason for failure of procedure
  --			   SUCCESS.................Normal execution completed.
  --			   OBJECT_STRUCTURE_ERROR..The structure passed in was
  --						   improperly constucted.

  ------------------------------------------------------------------------------
  function As_String (Marking : DIS_TYPES.A_MARKING_SET) return STRING;
  --
  -- Description: This function takes a DIS marking text and converts it to an
  --		  ASCII STRING that can be manipulated and displayed by
  --		  standard Ada operators.  The translation will end at the first
  --		  "null" character found in the Marking text.
  -- Parameters: Marking -> an object containing A_MARKING_SET
  --		 return value <- the Ada STRING that is represented by Marking
  -- Exceptions: TEXT_NOT_VALID....If the Marking text can not be represented as
  --				   an ASCII String.
  --		 CONSTRAINT_ERROR..If the STRING recieving the returned value is
  --				   not large enough to hold it.

  ------------------------------------------------------------------------------
  procedure Convert_To_String (Marking : in     DIS_TYPES.A_MARKING_SET;
			       Text    :    out STRING;
			       Length  :    out NATURAL;
			       Status  :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure has the same use as the function As_String.
  -- Parameters: Marking -> an object containing A_MARKING_SET
  --		 Text <- a STRING containing the translation of the Marking text
  --			 text/ if the STRING passed in is not big enough to
  --			 contain the text the text will be truncated
  --		 Length <- The Number of characters translated from the Marking
  --		 Status <- SUCCESS : Comlpeted execution normaly.
  --			   TEXT_NOT_VALID : Some part of Marking could not be
  --					    translated to ASCII.  The Text and
  --					    Length values are not valid.

  ------------------------------------------------------------------------------
  function As_Marking (Text : STRING) return DIS_TYPES.A_MARKING_SET;
  --
  -- Description: This function converts an ASCII character STRING to
  --		  A_MARKING_SET.  If the STRING is too long it will be
  --		  truncated.  If it is shorter than Marking's Text it will be
  --		  padded with "null" characters.
  -- Parameters: Text -> The ASCII Character STRING to translate.
  --		 return value <- Marking Text version of the STRING

  ------------------------------------------------------------------------------
  procedure Convert_To_Marking (Text    : in     STRING;
				Marking :    out DIS_TYPES.A_MARKING_SET;
				Status  :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure serves the same use as the function As_Marking.
  -- Parameters: Text -> The ASCII character STRING to translate
  --		 Marking <- The DIS Marking Text image of the ASCII STRING
  --		 Status <- SUCCESS : execution completed normally

  -- EMISSION PDU OPERATIONS ---------------------------------------------------

  type AN_EMITTER_POINTER is access DIS_TYPES.AN_EMITTER_SYSTEM_DATA_HEADER;
  type A_BEAM_DATA_POINTER is access DIS_TYPES.A_BEAM_DATA_RECORD;

  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  -- The following routines are used to build an emission pdu durring run time.
  -- The multiple varient structure of this PDU makes it impossable to directly
  -- assign these fields to the PDU.
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

  ------------------------------------------------------------------------------
  procedure Add_Emitter_To_Emission (Emission : in out DIS_PDU_POINTER_TYPES.EMISSION_PDU_PTR;
				     System   : in     AN_EMITTER_POINTER;
				     Status   :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure will concatenate the contents of the emitter
  --		  system pointed to by System onto the end of the EMISSION_PDU
  --		  pointed to by Emission.  If the length of the new emission
  --		  structure exceeds the maximum PDU length an error will be
  --		  returned and no concatenation will be performed.  The Emission
  --		  PDU fields are modified to reflect the existance of the new
  --		  emitter system.
  -- Parameters: Emission <-> This is a pointer to the Emission PDU data
  --			      structure.  The pointer must allready have been
  --			      allocated although the size of the Data array can
  --			      be zero.
  --		 System -> Pointer to the emitter system data structure that is
  --			   to be added to the Emission PDU structure.
  --		 Status <- SUCCESS : Normal execution completed.
  --			   EXCEEDS_MAX_SIZE : the resultant Emission PDU would
  --					      be larger than the maximum allowed
  --					      PDU size.
  --			   PDU_STRUCTURE_ERROR : The structure pointed to by
  --						 Emission contains an error or
  --						 does not exist (null pointer)
  --			   DATA_STRUCTURE_ERROR : The System is a null pointer

  ------------------------------------------------------------------------------
  procedure Add_Beam_To_Emitter (Emitter : in out AN_EMITTER_POINTER;
				 Beam    : in     DIS_TYPES.A_BEAM_DATA_RECORD;
				 Status  :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure will concatenate a Beam Data Record to the end
  --		  of the emitter system structure pointed to by Emitter.  The
  --		  system pointed to by Emitter will be updated to reflect the
  --		  beam.  The Emitter pointer must be allocated before this
  --		  procedure is called, but it need not contain any beam data.
  -- Parameters: Emitter <-> pointer to the emitter system structure to be
  --			     modified.
  --		 Beam -> A Beam Data Record structure containing all the
  --			 associated track/jam fields.
  --		 Status <- SUCCESS : Normal execution completed
  --			   DATA_STRUCTURE_ERROR : The format of the data in one
  --						  of the structures is not
  --						  consistant with its definition
  --						  or a null pointer was passed.

  ------------------------------------------------------------------------------
  procedure Add_Beam_To_Emitter (Emission : in out DIS_PDU_POINTER_TYPES.EMISSION_PDU_PTR;
				 System	  : in     DIS_TYPES.AN_EMITTER_SYSTEM_RECORD;
				 Beam	  : in     DIS_TYPES.A_BEAM_DATA_RECORD;
				 Status   :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure is functionaly equivelent to the first
  --		  Add_Beam_To_Emitter except that the emitter system record to
  --		  be modified is embeded in an Emission PDU structure.
  -- Parameters: Emission <-> pointer to the emitter system structure to be
  --			     modified.
  --		 System -> The ID of the emitter system to whose record the Beam
  --			   Data record should be added.
  --		 Beam -> A Beam Data Record structure containing all the
  --			 associated track/jam fields.
  --		 Status <- SUCCESS : Normal execution completed
  --			   DATA_STRUCTURE_ERROR : The format of the data in one
  --						  of the structures is not
  --						  consistant with its definition
  --						  or a null pointer was passed.
  --			   EXCEEDS_MAX_SIZE : the resultant Emission PDU would
  --					      be larger than the maximum allowed
  --					      PDU size.
  --			   PDU_STRUCTURE_ERROR : The structure pointed to by
  --						 Emission contains an error or
  --						 does not exist (null pointer)
  --			   SYSTEM_NOT_FOUND : There is no emitter system record
  --					      matching System in the Emission.

  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  -- The following routines are used to read the fields of an emission pdu
  -- durring run time.  The multiple varient structure of this PDU makes it
  -- impossable to directly access these fields.
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

  ------------------------------------------------------------------------------
  procedure Get_Emitter (System	       :    out AN_EMITTER_POINTER;
			 System_Number : in     NATURAL;
			 Emission      : in     DIS_TYPES.AN_EMISSION_PDU;
			 Status        :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure will extract an emitter system record from the
  --		  Emission PDU and return a pointer to that structure.
  -- Parameters: System <- The pointer to the extracted data
  --		 System_Number -> The position of the emitter system record to
  --				  extract.  The first system would be 0 the last
  --				  would be Number_Of_Systems - 1
  --		 Emission -> The PDU to extract the system data from
  --		 Status -> SUCCESS : Normal completion
  --			   BAD_SYSTEM_NUMBER : The system number requested does
  --					       not exist.

  ------------------------------------------------------------------------------
  function Number_Of_Beams (Emission : DIS_TYPES.AN_EMISSION_PDU;
			    System   : DIS_TYPES.AN_EMITTER_SYSTEM_RECORD) return NATURAL;
  --
  -- Description: This function will return the number of beam data records in
  --		  the specified emitter System record of the Emission PDU,
  -- Parameters: Emission -> pointer to the emitter system structure to be
  --			     modified.
  --		 System -> The ID of the emitter system to whose record the Beam
  --			   Data record belongs.
  --		 return value <- 0 if none or system not found else # of beams

  ------------------------------------------------------------------------------
  procedure Get_Number_Of_Beams (Emission : in     DIS_TYPES.AN_EMISSION_PDU;
				 System   : in     DIS_TYPES.AN_EMITTER_SYSTEM_RECORD;
				 Beams    :    out NATURAL;
				 Status   :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure will return the number of beam data records in
  --		  the specified emitter System record of the Emission PDU,
  -- Parameters: Emission -> pointer to the emitter system structure to be
  --			     modified.
  --		 System -> The ID of the emitter system to whose record the Beam
  --			   Data record belongs.
  --		 Beams <- The number of beam data records
  --		 Status <- SUCCESS : Normal execution completed
  --			   PDU_STRUCTURE_ERROR : The structure pointed to by
  --						 Emission contains an error or
  --						 does not exist (null pointer)
  --			   SYSTEM_NOT_FOUND : There is no emitter system record
  --					      matching System in the Emission.

  ------------------------------------------------------------------------------
  procedure Get_Number_Of_Beams (Emission : in     DIS_TYPES.AN_EMISSION_PDU;
				 System   : in     NATURAL;
				 Beams    :    out NATURAL;
				 Status   :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: This procedure will return the number of beam data records in
  --		  the specified emitter System record of the Emission PDU,
  -- Parameters: Emission -> pointer to the emitter system structure to be
  --			     modified.
  --		 System -> The number of the emitter system to which the Beam
  --			   Data record belongs.
  --		 Beams <- The number of beam data records
  --		 Status <- SUCCESS : Normal execution completed
  --			   PDU_STRUCTURE_ERROR : The structure pointed to by
  --						 Emission contains an error or
  --						 does not exist (null pointer)
  --			   SYSTEM_NOT_FOUND : There is no emitter system record
  --					      matching System in the Emission.

  ------------------------------------------------------------------------------
  procedure Get_Beam (Beam	    :    out A_BEAM_DATA_POINTER;
		      Beam_Number   : in     NATURAL;
		      Emission	    : in     DIS_TYPES.AN_EMITTER_SYSTEM_DATA_HEADER;
		      Status        :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: Extract the named beam data record from the emitter system
  --		  record.
  -- Parameters: Beam <- Pointer to the extracted beam data record
  --		 Beam_Number -> The position number of the beam to extract.
  --				Posision 0 is the first record.
  --		 Emission -> An emitter system data record to extract the beam
  --			     data from
  --		 Status <- SUCCESS : Normal completion
  --			   BAD_BEAM_NUMBER : the beam number does not exist

  ------------------------------------------------------------------------------
  procedure Get_Beam (Beam	    :    out A_BEAM_DATA_POINTER;
		      Beam_Number   : in     NATURAL;
		      System_Number : in     NATURAL;
		      Emission	    : in     DIS_TYPES.AN_EMISSION_PDU;
		      Status        :    out DL_STATUS.STATUS_TYPE);
  --
  -- Description: Extract the named beam from the named emitter system from
  --		  the Emission PDU.
  -- Parameters: Beam <- Pointer to the extracted beam data record
  --		 Beam_Number -> The position number of the beam to extract.
  --				Posision 0 is the first record.
  --		 System_Number -> The position of the emitter system data record
  --				  (0 is the first position)
  --		 Emission -> An emitter system data record to extract the beam
  --			     data from
  --		 Status <- SUCCESS : Normal completion
  --			   BAD_BEAM_NUMBER : the beam number does not exist

end PDU_OPERATORS;
