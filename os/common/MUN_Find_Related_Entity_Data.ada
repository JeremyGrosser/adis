--                            U N C L A S S I F I E D
--  *====================================================================*
--  |                                                                    |
--  |                         Manned Flight Simulator                    |
--  |               Naval Air Warfare Center Aircraft Division           |
--  |                        Patuxent River, Maryland                    |
--  |                                                                    |
--  *====================================================================*
--
-- UNIT NAME :         Find_Related_Entity_Data
--
-- PROJECT :           Ada Distributed Interactive Simulation (ADIS)
--                     Ordnance Server
--
-- AUTHOR :            Kimberly J. Neff - J.F. Taylor, Inc.
--
-- ORIGINATION DATE :  13 June 94
--
-- PURPOSE :
--   - The FRED CSU searches through the General Parameters list to find the
--     closest match, if one exists, to the entity type being instantiated.
--
-- IMPLEMENTATION NOTES :
--   - This procedure requires DIS_Types, Numeric_Types, OS_Data_Types,
--     OS_Status.
--   - This procedure requires the ordering of elements in the list to be from
--     specific to general; therefore, if an elements contains zeros (generic)
--     it should follow the elements that contain enumerals.
--
-- EXCEPTIONS :  None.
--
-- PORTABILITY ISSUES :  None.
--
-- ANTICIPATED CHANGES :  None.
--
------------------------------------------------------------------------------
with Numeric_Types;

separate (Munition)

procedure Find_Related_Entity_Data(
   Entity_Type        :  in     DIS_Types.AN_ENTITY_TYPE_RECORD;
   General_Parameters :     out OS_Data_Types.GENERAL_PARAMETERS_RECORD_PTR;
   Status             :     out OS_Status.STATUS_TYPE)
  is

   -- Local variables
   Current_Pointer :  OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR;

   -- Rename functions
   function "=" (LEFT, RIGHT :  DIS_Types.A_COUNTRY_ID)
     return BOOLEAN
     renames DIS_Types."=";
   function "=" (LEFT, RIGHT :  DIS_Types.AN_ENTITY_KIND)
     return BOOLEAN
     renames DIS_Types."=";
   function "=" (LEFT, RIGHT :  DIS_Types.AN_ENTITY_TYPE_RECORD)
     return BOOLEAN
     renames DIS_Types."=";
   function "=" (LEFT, RIGHT :  Numeric_Types.UNSIGNED_8_BIT)
     return BOOLEAN
     renames Numeric_Types."=";
   function "=" (LEFT, RIGHT :  OS_Data_Types.GENERAL_PARAMETERS_RECORD_PTR)
     return BOOLEAN
     renames OS_Data_Types."=";
   function "=" (LEFT, RIGHT :  OS_Data_Types.USER_SUPPLIED_DATA_RECORD_PTR)
     return BOOLEAN
     renames OS_Data_Types."=";

begin -- Find_Related_Entity_Data

   -- Initialize Status
   Status := OS_Status.SUCCESS;

   General_Parameters := null;

   Current_Pointer := Top_of_Entity_Data_List_Pointer;

   -- Search for a matching entity type
   Search_For_Entity_Type:
   while Current_Pointer /= null loop

      if Current_Pointer.General_Parameters.Entity_Type = Entity_Type then

         General_Parameters := Current_Pointer.General_Parameters;
         exit Search_For_Entity_Type;


      else -- Entity types did not match

         if Current_Pointer.General_Parameters.Entity_Type.Entity_Kind
           = Entity_Type.Entity_Kind
         then

            if Current_Pointer.General_Parameters.Entity_Type.Domain
               = Entity_Type.Domain
              or else Current_Pointer.General_Parameters.Entity_Type.Domain = 0
            then

               if Current_Pointer.General_Parameters.Entity_Type.Country
                  = Entity_Type.Country
                 or else Current_Pointer.General_Parameters.Entity_Type.Domain
                  = 0
               then

                  if Current_Pointer.General_Parameters.Entity_Type.Category
                     = Entity_Type.Category
                    or else Current_Pointer.General_Parameters.Entity_Type.
                     Domain = 0
                  then

                     if Current_Pointer.General_Parameters.Entity_Type.
                        Subcategory = Entity_Type.Subcategory
                       or else Current_Pointer.General_Parameters.Entity_Type.
                        Domain = 0
                     then

                        if Current_Pointer.General_Parameters.Entity_Type.
                           Specific = Entity_Type.Specific
                          or else Current_Pointer.General_Parameters.
                           Entity_Type.Domain = 0
                        then

                           -- Store pointer to record and exit search
                           General_Parameters := Current_Pointer.
                             General_Parameters;
                           exit Search_For_Entity_Type;

                        end if; -- Specific

                     end if; -- Subcategory

                  end if; -- Category

               end if; -- Country

            end if; -- Domain

         end if; -- Entity Kind

      end if;

      Current_Pointer := Current_Pointer.Next;

   end loop Search_For_Entity_Type;

exception
   when OTHERS =>
      Status := OS_Status.FRED_ERROR;

end Find_Related_Entity_Data;
