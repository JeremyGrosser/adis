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
--  ADIS / DIS_TYPES_.ADA
--  
--  
--  DESCRIPTION:
--  
-- 	This package contains all the DIS object definitions and the operators
--	to use with them for the DIS 2.0.3 (IEEE 1278) standard.
--  
--  
--  MODIFICATION HISTORY:
--   
--  24 Mar 1994 / Larry Ullom
--  	  Initial Baseline Version V1.0
--  13 May 1994 / Brett Dufault
--        Added 'SIZE clause to A_DATUM_PARAMETER type to explicitly set
--        type size to 32 bits.
--  16 May 1994 / Brett Dufault
--        Changed Entity_ID component of type AN_ENTITY_IDENTIFIER from
--        POSITIVE_16_BIT to UNSIGNED_16_BIT.
--  20 May 1994 / Larry Ullom
--  	  Changed SIM management PDUs to use AN_ENTITY_IDENTIFIER and Group
--	  instead of using A_SIM_MANAGEMENT_ENTITY_ID.  This was to make the
--	  upgrade to 2.0.4, which eleminates the Group field, more transparent.
--  26 May 1994 / Larry Ullom
--  	  Moved the varient parameter Number_Of_Systems in AN_EMISSION_PDU to
--	  to a normal field in the record since there is no way to create a 
--	  record that uses it for sizing the data structure.
--  19 Jul 1994 / Brett Dufault
--        Reversed positions of Linear_Velocity and Location components in
--        type AN_ENTITY_STATE_PDU to match DIS standard.
--  22 Aug 1994 / Larry Ullom
--        Fixed alignment problem with A_MESSAGE_PDU.
--  [change_entry]...
--  
--  ===========================================================================
 
with NUMERIC_TYPES;
 
--  *===================================*
--  |                                   |
--  |   DIS_TYPES			|
--  |                                   |
--  *===================================*
 
--| 
--|  Package Description:
--| 
--	 {tbs}...
--| 
--|  Initialization Exceptions:
--| 
--	 {description_or_none}...
--| 
--|  Notes:
--| 
--	 It is assumed in all the rep specs in this package that bit 0 is
--	 the Least Significant Bit (LSB) and Bit 'n' is the Most Significant
--       Bit (MSB).  It is also assumed that word 0 is the least significant
--	 word.  To adapt this package to a different machine ordering will
--	 require changing all rep specs.  It is HIGHLY recommended the rep 
--	 specs not be commented out since different Ada compilers may produce
--	 incorrectly aligned records without them.  There are several places
--       where the standard is not implementable directly; these are commented
--       with a boarder of \/\/\/\/\/ to call attention to these problems.
--	 [tbs]...
--| 
 
package DIS_TYPES is                                           

  MAXIMUM_PDU_SIZE : constant := 1400; --octets per IST-CR-93-41 5.3.1.3 (CADIS)

  ------------------------------------------------------------------------------
  --| Basic Elements Definitions |----------------------------------------------
  ------------------------------------------------------------------------------

  type A_PADDING_FIELD is array(POSITIVE range <>) of NUMERIC_TYPES.UNSIGNED_1_BIT;
  pragma PACK (A_PADDING_FIELD);

  type AN_ANGULAR_VELOCITY_VECTOR is
    record
      Phi_Rate   : NUMERIC_TYPES.FLOAT_32_BIT;
      Theta_Rate : NUMERIC_TYPES.FLOAT_32_BIT;
      Psi_Rate   : NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for AN_ANGULAR_VELOCITY_VECTOR use
    record
      Phi_Rate   at 0 * NUMERIC_TYPES.WORD range 0..31;
      Theta_Rate at 2 * NUMERIC_TYPES.WORD range 0..31;
      Psi_Rate   at 4 * NUMERIC_TYPES.WORD range 0..31;
    end record;
  for AN_ANGULAR_VELOCITY_VECTOR'size use 96;

  type AN_ARTICULATION_PARAMETER_TYPE is
    record
      Type_Metric : NUMERIC_TYPES.UNSIGNED_5_BIT;
      Type_Class  : NUMERIC_TYPES.UNSIGNED_26_BIT;
      MSB         : NUMERIC_TYPES.UNSIGNED_1_BIT;
    end record;
  for AN_ARTICULATION_PARAMETER_TYPE use
    record
      Type_Metric at 0 range 0..4;
      Type_Class  at 0 range 5..30;
      MSB         at 0 range 31..31;
    end record;
  for AN_ARTICULATION_PARAMETER_TYPE'size use 32;

  type A_PARAMETER_VALUE is
    record
      High_Word : NUMERIC_TYPES.FLOAT_32_BIT;
      Low_Word	: NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for A_PARAMETER_VALUE use
    record
      Low_Word	at 0 range 0..31;
      High_Word at 0 range 32..63;
    end record;
  for A_PARAMETER_VALUE'size use 64;

  type AN_ARTICULATION_PARAMETER is
    record
      Change_Indicator : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Part_ID          : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Parameter_Type   : AN_ARTICULATION_PARAMETER_TYPE;
      Parameter_Value  : A_PARAMETER_VALUE;
    end record;
  for AN_ARTICULATION_PARAMETER use
    record
      Change_Indicator at 0 * NUMERIC_TYPES.WORD range 0..15;
      Part_ID          at 1 * NUMERIC_TYPES.WORD range 0..15;
      Parameter_Type   at 2 * NUMERIC_TYPES.WORD range 0..31;
      Parameter_Value  at 4 * NUMERIC_TYPES.WORD range 0..63;
    end record;
  for AN_ARTICULATION_PARAMETER'size use 128;

  type AN_ARTICULATION_PARAMETER_LIST is array (NUMERIC_TYPES.UNSIGNED_8_BIT range <>) of AN_ARTICULATION_PARAMETER;
  pragma PACK(AN_ARTICULATION_PARAMETER_LIST);

  type AN_ENTITY_KIND is (OTHER_ENTITY,  PLATFORM,         MUNITION, LIFE_FORM,
			  ENVIRONMENTAL, CULTURAL_FEATURE, SUPPLY,   RADIO);
  for AN_ENTITY_KIND use (0, 1, 2, 3, 4, 5, 6, 7);
  for AN_ENTITY_KIND'size use 8;

  type A_COUNTRY_ID is (OTHER_COUNTRY,AFGHANISTAN,ALBANIA,ALGERIA,
			AMERICAN_SAMOA,ANDORRA,ANGOLA,ANGUILLA,ANTARCTICA,
			ANTIGUA_AND_BARBUDA,ARGENTINA,ARUBA,
			ASHMORE_AND_CARTIER_ISLANDS,AUSTRALIA,AUSTRIA,BAHAMAS,
			BAHRAIN,BAKER_ISLAND,BANGLADESH,BARBADOS,
			BASSAS_DA_INDIA,BELGIUM,BELIZE,BENIN_DAHOMEY,BERMUDA,
			BHUTAN,BOLIVIA,BOTSWANA,BOUVET_ISLAND,BRAZIL,
			BRITISH_INDIAN_OCEAN_TERRITORY,BRITISH_VIRGIN_ISLANDS,
			BRUNEI,BULGARIA,BURKINA_FASO,BURMA,BURUNDI,
			CAMBODIA_KAMPUCHEA,CAMEROON,CANADA,
			REPUBLIC_OF_CAPE_VERDE,CAYMAN_ISLANDS,
			CENTRAL_AFRICAN_REPUBLIC,CHAD,CHILE,
			PEOPLES_REPUBLIC_OF_CHINA,CHRISTMAS_ISLAND,
			COCOS_KEELING_ISLANDS,COLOMBIA,COMOROS,CONGO,
			COOK_ISLANDS,CORAL_SEA_ISLANDS,COSTA_RICA,CUBA,CYPRUS,
			CZECHOSLOVAKIA,DENMARK,DJIBOUTI,DOMINICA,
			DOMINICAN_REPUBLIC,ECUADOR,EGYPT,EL_SALVADOR,
			EQUATORIAL_GUINEA,ETHIOPIA,EUROPA_ISLANDS,
			FALKLAND_ISLANDS_ISLAS_MALVINAS,FAROE_ISLAND,FIJI,
			FINLAND,FRANCE,FRENCH_GUIANA,FRENCH_POLYNESIA,
			FRENCH_SOUTHERN_AND_ANTARCTIC_ISLANDS,GABON,GAMBIA,
			GAZA_STRIP,GERMANY,GHANA,GIBRALTAR,GLORIOSO_ISLAND,
			GREECE,GREENLAND,GRENADA,GUADALOUPE,GUAM,GUATEMALA,
			GUERNSEY,GUINEA,GUINEA_BISSUA,GUYANA,HAITI,
			HEARD_ISLAND_AND_MCDONALD_ISLANDS,HONDURAS,HONG_KONG,
			HOWLAND_ISLAND,HUNGARY,ICELAND,INDIA,INDONESIA,IRAN,
			IRAQ,IRAQ_SAUDI_ARABIA_NEUTRAL_ZONE,IRELAND,ISRAEL,
			ITALY,IVORY_COAST,JAMAICA,JAN_MAYEN,JAPAN,
			JARVIS_ISLAND,JERSEY,JOHNSTON_ATOLL,JORDAN,
			JUAN_DE_NOVA_ISLAND,KENYA,KINGMAN_REEF_US_TERRITORY,
			KIRIBATI,DEMOCRATIC_PEOPLES_REPUBLIC_OF_KOREA,
			REPUBLIC_OF_KOREA,KUWAIT,LAOS,LEBANON,LESOTHO,LIBERIA,
			LIBYA,LIECHTENSTEIN,LUXEMBOURG,MADAGASCAR,MACAO,MALAWI,
			MALAYSIA,MALDIVES,MALI,MALTA,ISLE_OF_MAN,
			MARSHALL_ISLANDS,MARTINIQUE,MAURITANIA,MAURITIUS,
			MAYOTTE,MEXICO,FEDERATIVE_STATES_OF_MICRONESIA,MONACO,
			MONGOLIA,MONTSERRAT,MOROCCO,MOSAMBIQUE,
			NAMIBIA_SOUTH_WEST_AFRICA,NAURU,NAVASSA_ISLAND,NEPAL,
			NETHERLANDS,NETHERLANDS_ANTILLES,NEW_CALEDONIA,
			NEW_ZEALAND,NICARAGUA,NIGER,NIGERIA,NIUE,
			NORFOLK_ISLAND,NORTHERN_MARIANA_ISLANDS,NORWAY,OMAN,
			PAKISTAN,PALMYRA_ATOLL,REPUBLIC_OF_PALAU,PANAMA,
			PAPUA_NEW_GUINEA,PARACEL_ISLANDS,PARAGUAY,PERU,
			PHILIPPINES,PITCAIM_ISLANDS,POLAND,PORTUGAL,
			PUERTO_RICO,QATAR,REUNION,ROMANIA,RWANDA,
			ST_KITTS_AND_NEVIS,ST_HELENA,ST_LUCIA,
			ST_PIERRE_AND_MIQUELON,ST_VINCENT_AND_THE_GRENADINES,
			SAN_MARINO,SAO_TOME_AND_PRINCIPE,SAUDI_ARABIA,SENEGAL,
			SEYCHELLES,SIERRA_LEONE,SINGAPORE,SOLOMON_ISLANDS,
			SOMALIA,SOUTH_GEORGIA_AND_SOUTH_SANDWICH_ISLANDS,
			SOUTH_AFRICA,SPAIN,SPRATLY_ISLANDS,SRI_LANKA,SUDAN,
			SURINAME,SVALBARD,SWAZILAND,SWEDEN,SWITZERLAND,SYRIA,
			TAIWAN,TANZANIA,THAILAND,TOGO,TOKELAU,TONGA,
			TRINIDAD_AND_TOBAGO,TROMELIN_ISLAND,
			TRUST_TERRITORY_OF_PACIFIC_ISLANDS,TUNISIA,TURKEY,
			TURKS_AND_CAICOS_ISLAND,TUVALU,UGANDA,
			UNION_OF_SOVIET_SOCIALIST_REPUBLICS,
			UNITED_ARAB_EMIRATES,UNITED_KINGDOM,UNITED_STATES,
			URUGUAY,VANUATU,VATICAN_CITY,VENEZUELA,VIETNAM,
			VIRGIN_ISLANDS,WAKE_ISLAND,WALLIS_AND_FUTUNA,
			WESTERN_SAHARA,WEST_BANKS,WESTERN_SAMOA,YEMEN,
			YEMEN_ADEN,YEMEN_SANAA,YUGOSLAVIA,ZAIRE,ZAMBIA,
			ZIMBABWE);
  for A_COUNTRY_ID use (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
			21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,
			39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,
			57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,
			75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,
			93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,
			108,109,110,111,112,113,114,115,116,117,118,119,120,
			121,122,123,124,125,126,127,128,129,130,131,132,133,
			134,135,136,137,138,139,140,141,142,143,144,145,146,
			147,148,149,150,151,152,153,154,155,156,157,158,159,
			160,161,162,163,164,165,166,167,168,169,170,171,172,
			173,174,175,176,177,178,179,180,181,182,183,184,185,
			186,187,188,189,190,191,192,193,194,195,196,197,198,
			199,200,201,202,203,204,205,206,207,208,209,210,211,
			212,213,214,215,216,217,218,219,220,221,222,223,224,
			225,226,227,228,229,230,231,232,233,234,235,236,237,
			238,239,240,241,242,243);
  for A_COUNTRY_ID'size use 8;

  type AN_ENTITY_TYPE_RECORD is
    record
      Entity_Kind : AN_ENTITY_KIND;
      Domain	  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Country     : A_COUNTRY_ID;
      Category	  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Subcategory : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Specific    : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Extra	  : NUMERIC_TYPES.UNSIGNED_8_BIT;
    end record;
  for AN_ENTITY_TYPE_RECORD use
    record
      Entity_Kind at 0 * NUMERIC_TYPES.WORD range 0..7;
      Domain	  at 0 * NUMERIC_TYPES.WORD range 8..15;
      Country     at 1 * NUMERIC_TYPES.WORD range 0..15;
      Category	  at 2 * NUMERIC_TYPES.WORD range 0..7;
      Subcategory at 2 * NUMERIC_TYPES.WORD range 8..15;
      Specific    at 3 * NUMERIC_TYPES.WORD range 0..7;
      Extra	  at 3 * NUMERIC_TYPES.WORD range 8..15;
    end record;
  for AN_ENTITY_TYPE_RECORD'size use 64;

  type A_WARHEAD_TYPE is (OTHER_WARHEAD, HIGH_EXPLOSIVE, HIGH_EXPLOSIVE_PLASTIC,
		          HIGH_EXPLOSIVE_INCENDIARY,
			  HIGH_EXPLOSIVE_FRAGMENTATION,
			  HIGH_EXPLOSIVE_ANTI_TANK, HIGH_EXPLOSIVE_BOMBLETS,
			  HIGH_EXPLOSIVE_SHAPED_CHARGE, SMOKE, ILLUMINATION,
			  PRACTICE, KINETIC, NUCLEAR, CHEMICAL_GENERAL,
			  CHEMICAL_BLISTER_AGENT, CHEMICAL_BLOOD_AGENT,
			  CHEMICAL_NERVE_AGENT, BIOLOGICAL_GENERAL);
  for A_WARHEAD_TYPE use  (0,1000,1100,1200,1300,1400,1500,1600,2000,3000,4000,
			   5000,7000,8000,8100,8200,8300,9000);
  for A_WARHEAD_TYPE'size use 16;

  type A_FUZE_TYPE is (OTHER_FUZE, CONTACT, CONTACT_INSTANT, CONTACT_DELAYED,
		       TIMED, PROXIMITY, COMMAND, ALTITUDE, DEPTH, ACOUSTIC);
  for A_FUZE_TYPE use (0,1000,1100,1200,2000,3000,4000,5000,6000,7000);
  for A_FUZE_TYPE'size use 16;

  type A_BURST_DESCRIPTOR is
    record
      Munition : AN_ENTITY_TYPE_RECORD;
      Warhead  : A_WARHEAD_TYPE;
      Fuze     : A_FUZE_TYPE;
      Quantity : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Rate     : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for A_BURST_DESCRIPTOR use
    record
      Munition at 0 * NUMERIC_TYPES.WORD range 0..63;
      Warhead  at 4 * NUMERIC_TYPES.WORD range 0..15;
      Fuze     at 5 * NUMERIC_TYPES.WORD range 0..15;
      Quantity at 6 * NUMERIC_TYPES.WORD range 0..15;
      Rate     at 7 * NUMERIC_TYPES.WORD range 0..15;
    end record;
  for A_BURST_DESCRIPTOR'size use 128;

  type A_PAINT_SCHEME is (UNIFORM_COLOR,CAMOUFLAGE);
  for A_PAINT_SCHEME use (0,1);
  for A_PAINT_SCHEME'size use 1;

  type A_MOBILITY_KILL is (FULLY_MOBILE, MOBILITY_DISABLED);
  for A_MOBILITY_KILL use (0,1);
  for A_MOBILITY_KILL'size use 1;

  type A_FIRE_POWER_KILL is (FIRE_POWER_NORMAL, FIRE_POWER_DISABLED);
  for A_FIRE_POWER_KILL use (0,1);
  for A_FIRE_POWER_KILL'size use 1;

  type A_DAMAGE_LEVEL is (NO_DAMAGE, SLIGHT, MODERATE, DESTROYED);
  for A_DAMAGE_LEVEL use (0,1,2,3);
  for A_DAMAGE_LEVEL'size use 2;
                               
  type A_SMOKE_EFFECT is (NOT_SMOKING,  SMOKE_PLUME,
			  ENGINE_SMOKE, PLUME_AND_ENGINE);
  for A_SMOKE_EFFECT use (0,1,2,3);
  for A_SMOKE_EFFECT'size use 2;

  type A_TRAILING_EFFECT is (NO_TRAILING, SMALL, MEDIUM, LARGE);
  for A_TRAILING_EFFECT use (0,1,2,3);
  for A_TRAILING_EFFECT'size use 2;

  type A_HATCH_STATE is (HATCH_NA, CLOSED, POPPED, POPPED_WITH_PERSON_VISIBLE,
			 OPEN, OPEN_WITH_PERSON_VISIBLE);
  for A_HATCH_STATE use (0,1,2,3,4,5);
  for A_HATCH_STATE'size use 3;

  type A_LIGHT_STATUS is (NO_LIGHTS, RUNNING_ON, NAVIGATION_ON, FORMATION_ON);
  for A_LIGHT_STATUS use (0,1,2,3);
  for A_LIGHT_STATUS'size use 3;

  type A_FLAME_STATUS is (NO_FLAMES, FLAMES_PRESENT);
  for A_FLAME_STATUS use (0,1);
  for A_FLAME_STATUS'size use 1;

  type A_GENERAL_APPEARANCE_RECORD is
    record
      Paint      : A_PAINT_SCHEME;
      Mobility   : A_MOBILITY_KILL;
      Fire_Power : A_FIRE_POWER_KILL;
      Damage     : A_DAMAGE_LEVEL;
      Smoke	 : A_SMOKE_EFFECT;
      Trailing   : A_TRAILING_EFFECT;
      Hatch	 : A_HATCH_STATE;
      Lights	 : A_LIGHT_STATUS;
      Flaming	 : A_FLAME_STATUS;
    end record;
  for A_GENERAL_APPEARANCE_RECORD use
    record
--      Paint      at 0 range 0..0;
--      Mobility   at 0 range 1..1;
--      Fire_Power at 0 range 2..2;
--      Damage     at 0 range 3..4;
--      Smoke	 at 0 range 5..6;
--      Trailing   at 0 range 7..8;
--      Hatch	 at 0 range 9..11;
--      Lights	 at 0 range 12..14;
--      Flaming	 at 0 range 15..15;
      --
      -- Rearrange representation specification since VADS doesn't seem to
      -- do this correctly.
      --
      Flaming	 at 0 range 0..0;
      Lights	 at 0 range 1..3;
      Hatch	 at 0 range 4..6;
      Trailing   at 0 range 7..8;
      Smoke	 at 0 range 9..10;
      Damage     at 0 range 11..12;
      Fire_Power at 0 range 13..13;
      Mobility   at 0 range 14..14;
      Paint      at 0 range 15..15;
    end record;

  for A_GENERAL_APPEARANCE_RECORD'size use 16;

  type AN_ENTITY_APPEARANCE is
    record
      General  : A_GENERAL_APPEARANCE_RECORD;
      Specific : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for AN_ENTITY_APPEARANCE use
    record
--      General  at 0 * NUMERIC_TYPES.WORD range 0..15;
--      Specific at 1 * NUMERIC_TYPES.WORD range 0..15;
      --
      -- Rearrange representation specification since VADS doesn't seem to
      -- do this correctly.
      --
      Specific at 0 * NUMERIC_TYPES.WORD range 0..15;
      General  at 1 * NUMERIC_TYPES.WORD range 0..15;
    end record;
  for AN_ENTITY_APPEARANCE'size use 32;

  type AN_ENTITY_CAPABILITY is array (0..31) of BOOLEAN;
  pragma PACK(AN_ENTITY_CAPABILITY);
  for AN_ENTITY_CAPABILITY'size use 32;

  type A_SIMULATION_ADDRESS is
    record
      Site_ID	     : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Application_ID : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for A_SIMULATION_ADDRESS use
    record
      Site_ID	     at 0 * NUMERIC_TYPES.WORD range 0..15;
      Application_ID at 1 * NUMERIC_TYPES.WORD range 0..15;
    end record;
  for A_SIMULATION_ADDRESS'size use 32;

  type AN_ENTITY_IDENTIFIER is
    record
      Sim_Address : A_SIMULATION_ADDRESS;
      Entity_ID   : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for AN_ENTITY_IDENTIFIER use
    record
      Sim_Address at 0 * NUMERIC_TYPES.WORD range 0..31;
      Entity_ID   at 2 * NUMERIC_TYPES.WORD range 0..15;
    end record;
  for AN_ENTITY_IDENTIFIER'size use 48;

  type A_CHARACTER_SET is (UNUSED, ASCII);
  for A_CHARACTER_SET use (0,1);
  for A_CHARACTER_SET'size use 8;

  type A_MARKING_SET is array (1..11) of NUMERIC_TYPES.UNSIGNED_8_BIT;
  for A_MARKING_SET'size use 88;

  type AN_ENTITY_MARKING is
    record
      Character_Set : A_CHARACTER_SET;
      Text          : A_MARKING_SET;
    end record;
  for AN_ENTITY_MARKING use
    record
      Character_Set at 0 range 0..7;
      Text          at 0 range 8..95;
    end record;
  for AN_ENTITY_MARKING'size use 96;

  type AN_EULER_ANGLES_RECORD is
    record
      Psi   : NUMERIC_TYPES.FLOAT_32_BIT;
      Theta : NUMERIC_TYPES.FLOAT_32_BIT;
      Phi   : NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for AN_EULER_ANGLES_RECORD use
    record
      Psi   at 0 * NUMERIC_TYPES.WORD range 0..31;
      Theta at 2 * NUMERIC_TYPES.WORD range 0..31;
      Phi   at 4 * NUMERIC_TYPES.WORD range 0..31;
    end record;
  for AN_EULER_ANGLES_RECORD'size use 96;

  type AN_EVENT_IDENTIFIER is
    record
      Sim_Address : A_SIMULATION_ADDRESS;
      Event_ID	  : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for AN_EVENT_IDENTIFIER use
    record
      Sim_Address at 0 * NUMERIC_TYPES.WORD range 0..31;
      Event_ID	  at 2 * NUMERIC_TYPES.WORD range 0..15;
    end record;
  for AN_EVENT_IDENTIFIER'size use 48;

  subtype AN_EXERCISE_IDENTIFIER is NUMERIC_TYPES.UNSIGNED_8_BIT;

  type A_FORCE_ID is (OTHER_FORCE, FRIENDLY, OPPOSING, NEUTRAL);
  for A_FORCE_ID use (0,1,2,3);
  for A_FORCE_ID'size use 8;

  type A_PROTOCOL_VERSION is range 0..255;
  for A_PROTOCOL_VERSION'size use 8;

  type A_PDU_KIND is (OTHER_PDU,	ENTITY_STATE,	    FIRE,
		      DETONATION,	COLLISION,	    SERVICE_REQUEST,
		      RESUPPLY_OFFER,	RESUPPLY_RECEIVED,  RESUPPLY_CANCEL,
		      REPAIR_COMPLETE,	REPAIR_RESPONSE,    CREATE_ENTITY,
		      REMOVE_ENTITY,	START_OR_RESUME,    STOP_OR_FREEZE,
		      ACKNOWLEDGE,	ACTION_REQUEST,	    ACTION_RESPONSE,
		      DATA_QUERY,	SET_DATA,	    DATA,
		      EVENT_REPORT,	MESSAGE,	    EMISSION,
		      LASER,		TRANSMITTER,	    SIGNAL,
		      RECEIVER);
  for A_PDU_KIND use (0,   1,   2,   3,   4,   5,   6,   7,   8,   9,
		      10,  11,  12,  13,  14,  15,  16,  17,  18,  19,
		      20,  21,  22,  23,  24,  25,  26,  27);
  for A_PDU_KIND'size use 8;

  subtype A_TIME_STAMP is NUMERIC_TYPES.UNSIGNED_32_BIT;

  subtype A_PDU_LENGTH is NUMERIC_TYPES.UNSIGNED_16_BIT;

  type A_PDU_HEADER is
    record
      Protocol_Version : A_PROTOCOL_VERSION;
      Exercise_ID      : AN_EXERCISE_IDENTIFIER;
      PDU_Type	       : A_PDU_KIND;
      Time_Stamp       : A_TIME_STAMP;
      Length	       : A_PDU_LENGTH;
      Padding	       : A_PADDING_FIELD(1..16);
    end record;
  for A_PDU_HEADER use
    record
      Protocol_Version at 0 * NUMERIC_TYPES.WORD range 0..7;
      Exercise_ID      at 0 * NUMERIC_TYPES.WORD range 8..15;
      PDU_Type	       at 1 * NUMERIC_TYPES.WORD range 0..7;
      Time_Stamp       at 2 * NUMERIC_TYPES.WORD range 0..31;
      Length	       at 4 * NUMERIC_TYPES.WORD range 0..15;
      Padding	       at 5 * NUMERIC_TYPES.WORD range 0..15;
  end record;
  for A_PDU_HEADER'size use 96;

  type A_REPAIR_TYPE is (NO_REPAIRS, REPAIR_EVERYTHING, MOTOR, STARTER,
			 ALTERNATOR, GENERATOR, BATTERY, ENGINE_COOLANT_LEAK,
			 FUEL_FILTER, TRANSMISSION_OIL_LEAK, ENGINE_OIL_LEAK,
			 PUMPS, FILTERS, HULL, AIRFRAME, PROPELLER,
			 TRANSMISSION, ENVIRONMENT_FILTERS, BRAKES, GUN_ELEVATION_DRIVE,
			 GUN_STABILIZATION_SYSTEM, GUNNERS_PRIMARY_SIGHT,
			 COMMANDERS_EXTENSION_TO_GPS, LOADING_MECHANISM,
			 FUEL_TRANSFER_PUMP, FUEL_LINES, GAUGES,
			 ELECTRONIC_COUNTER_MEASURE_SYSTEMS,
			 ELECTRONIC_WARFARE_SYSTEMS, LASER_RANGE_FINDER, RADIOS,
			 INTERCOMS, CODERS, DECODERS, LASERS, COMPUTERS,
			 EMITTERS, DETECTION_SYSTEMS, AIR_SUPPLY,
			 LIFE_SUPPORT_FILTERS, WATER_SUPPLY,
			 REFRIGERATION_SYSTEM,
			 CHEMICAL_BIOLOGICAL_RADIOLOGIC_PROTECTION,
			 WATER_WASH_DOWN_SYSTEMS, DECONTAMINATION_SYSTEMS,
			 HYDRAULIC_WATER_SUPPLY, COOLING_SYSTEM, WINCHES,
			 CATAPULTS, CRANES, LAUNCHERS, LIFE_BOATS,
			 LANDING_CRAFT, EJECTION_SEAT);
  for A_REPAIR_TYPE use (0,1,10,20,30,40,50,60,70,80,90,100,110,1000,1010,1500,
			 1510,1520,1530,2000,2010,2020,2030,2040,4000,4010,4020,
			 4500,4600,4700,4800,4900,5000,5100,5200,5300,5400,5600,
			 8000,8010,8020,8030,8040,8050,8060,9000,9010,9020,9030,
			 9040,9050,10000,10010,10020);
  for A_REPAIR_TYPE'size use 16;

  type A_REPAIR_RESULT is (OTHER_RESULT, REPAIR_ENDED, INVALID_REPAIR,
			   REPAIR_INTERRUPTED, CANCELED_BY_SUPPLIER);
  for A_REPAIR_RESULT use (0,1,2,3,4);
  for A_REPAIR_RESULT'size use 8;

  type A_SERVICE_TYPE is (OTHER_SERVICE, RESUPPLY, REPAIR);
  for A_SERVICE_TYPE use (0,1,2);
  for A_SERVICE_TYPE'size use 8;

  type A_SUPPLY_QUANTITY_RECORD is
    record
      Supply_Type : AN_ENTITY_TYPE_RECORD;
      Quantity    : NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for A_SUPPLY_QUANTITY_RECORD use
    record
      Supply_Type at 0 * NUMERIC_TYPES.WORD range 0..63;
      Quantity    at 4 * NUMERIC_TYPES.WORD range 0..31;
    end record;
  for A_SUPPLY_QUANTITY_RECORD'size use 96;

  type A_SUPPLY_QUANTITY_RECORD_LIST is array (NUMERIC_TYPES.UNSIGNED_8_BIT range <>) of A_SUPPLY_QUANTITY_RECORD;
  pragma PACK (A_SUPPLY_QUANTITY_RECORD_LIST);

  type A_VECTOR is
    record
      X : NUMERIC_TYPES.FLOAT_32_BIT;
      Y : NUMERIC_TYPES.FLOAT_32_BIT;
      Z : NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for A_VECTOR use
    record
      X at 0 * NUMERIC_TYPES.WORD range 0..31;
      Y at 2 * NUMERIC_TYPES.WORD range 0..31;
      Z at 4 * NUMERIC_TYPES.WORD range 0..31;
    end record;
  for A_VECTOR'size use 96;

  subtype AN_ENTITY_COORDINATE_VECTOR is A_VECTOR;

  subtype A_LINEAR_ACCELERATION_VECTOR is A_VECTOR;

  subtype A_LINEAR_VELOCITY_VECTOR is A_VECTOR;
                      
  type A_WORLD_COORDINATE is
    record
      X : NUMERIC_TYPES.FLOAT_64_BIT;
      Y : NUMERIC_TYPES.FLOAT_64_BIT;
      Z : NUMERIC_TYPES.FLOAT_64_BIT;
    end record;
  for A_WORLD_COORDINATE use
    record
      X at 0 * NUMERIC_TYPES.WORD range 0..63;
      Y at 4 * NUMERIC_TYPES.WORD range 0..63;
      Z at 8 * NUMERIC_TYPES.WORD range 0..63;
    end record;
  for A_WORLD_COORDINATE'size use 192;

  type A_DEAD_RECKONING_ALGORITHM is (OTHER_DR, STATIC, FPW, RPW, RVW,
				      FVW, FPB, RPB, RVB, FVB);
  for A_DEAD_RECKONING_ALGORITHM use (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  for A_DEAD_RECKONING_ALGORITHM'size use 8;

  type A_DEAD_RECKONING_PARAMETER is
    record
      Algorithm		: A_DEAD_RECKONING_ALGORITHM;
      Other_Parms	: A_PADDING_FIELD(1..120);
      Linear_Accel	: A_LINEAR_ACCELERATION_VECTOR;
      Angular_Velocity	: AN_ANGULAR_VELOCITY_VECTOR;
    end record;
  for A_DEAD_RECKONING_PARAMETER use
    record
      Algorithm		at 0 * NUMERIC_TYPES.WORD range 0..7;
      Other_Parms	at 0 * NUMERIC_TYPES.WORD range 8..127;
      Linear_Accel	at 8 * NUMERIC_TYPES.WORD range 0..95;
      Angular_Velocity	at 14 * NUMERIC_TYPES.WORD range 0..95;
    end record;

  type AN_ENTITY_CAPABILITIES_RECORD is array (1..32) of NUMERIC_TYPES.UNSIGNED_1_BIT;
  pragma PACK (AN_ENTITY_CAPABILITIES_RECORD);
  for AN_ENTITY_CAPABILITIES_RECORD'size use 32;

  type A_DETONATION_RESULT is (OTHER_RESULT, ENTITY_IMPACT,
			       ENTITY_PROXIMATE_DETONATION, GROUND_IMPACT,
			       GROUND_PROXIMATE_DETONATION, DETONATION, NONE);
  for A_DETONATION_RESULT use (0,1,2,3,4,5,6);
  for A_DETONATION_RESULT'size use 8;

  ------------------------------------------------------------------------------
  --| PDU Record Definitions |--------------------------------------------------
  ------------------------------------------------------------------------------

  type AN_ENTITY_STATE_PDU(Number_of_Parms : NUMERIC_TYPES.UNSIGNED_8_BIT := 0) is
    record
      PDU_Header	    : A_PDU_HEADER;
      Entity_ID		    : AN_ENTITY_IDENTIFIER;
      Force_ID		    : A_FORCE_ID;
      Entity_Type	    : AN_ENTITY_TYPE_RECORD;
      Alternative_Type	    : AN_ENTITY_TYPE_RECORD;
      Linear_Velocity	    : A_LINEAR_VELOCITY_VECTOR;
      Location		    : A_WORLD_COORDINATE;
      Orientation	    : AN_EULER_ANGLES_RECORD;
      Appearance	    : AN_ENTITY_APPEARANCE;
      Dead_Reckoning_Parms  : A_DEAD_RECKONING_PARAMETER;
      Marking		    : AN_ENTITY_MARKING;
      Capabilities	    : AN_ENTITY_CAPABILITIES_RECORD;
      Articulation_Parms    : AN_ARTICULATION_PARAMETER_LIST (1..Number_of_Parms);
    end record;
  for AN_ENTITY_STATE_PDU use
    record
      PDU_Header	    at 0 range 0..95;
      Entity_ID		    at 0 range 96..143;
      Force_ID		    at 0 range 144..151;
      Number_of_Parms	    at 0 range 152..159;
      Entity_Type	    at 0 range 160..223;
      Alternative_Type	    at 0 range 224..287;
      Linear_Velocity       at 0 range 288..383;
      Location              at 0 range 384..575;
      Orientation	    at 0 range 576..671;
      Appearance	    at 0 range 672..703;
      Dead_Reckoning_Parms  at 0 range 704..1023;
      Marking		    at 0 range 1024..1119;
      Capabilities	    at 0 range 1120..1151;
    end record;

  type A_FIRE_PDU is
    record
      PDU_Header	: A_PDU_HEADER;
      Firing_Entity_ID	: AN_ENTITY_IDENTIFIER;
      Target_Entity_ID	: AN_ENTITY_IDENTIFIER;
      Munition_ID	: AN_ENTITY_IDENTIFIER;
      Event_ID		: AN_EVENT_IDENTIFIER;
      Padding		: NUMERIC_TYPES.UNSIGNED_32_BIT;
      World_Location	: A_WORLD_COORDINATE;
      Burst_Descriptor	: A_BURST_DESCRIPTOR;
      Velocity		: A_LINEAR_VELOCITY_VECTOR;
      Target_Range	: NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for A_FIRE_PDU use
    record
      PDU_Header	at 0 range 0..95;
      Firing_Entity_ID	at 0 range 96..143;
      Target_Entity_ID	at 0 range 144..191;
      Munition_ID	at 0 range 192..239;
      Event_ID		at 0 range 240..287;
      Padding		at 0 range 288..319;
      World_Location	at 0 range 320..511;
      Burst_Descriptor	at 0 range 512..639;
      Velocity		at 0 range 640..735;
      Target_Range	at 0 range 736..767;
    end record;

  type A_DETONATION_PDU(Number_of_Parms : NUMERIC_TYPES.UNSIGNED_8_BIT := 0) is
    record
      PDU_Header	  : A_PDU_HEADER;
      Firing_Entity_ID	  : AN_ENTITY_IDENTIFIER;
      Target_Entity_ID	  : AN_ENTITY_IDENTIFIER;
      Munition_ID	  : AN_ENTITY_IDENTIFIER;
      Event_ID		  : AN_EVENT_IDENTIFIER;
      Velocity		  : A_LINEAR_VELOCITY_VECTOR;
      World_Location	  : A_WORLD_COORDINATE;
      Burst_Descriptor	  : A_BURST_DESCRIPTOR;
      Entity_Location	  : AN_ENTITY_COORDINATE_VECTOR;
      Detonation_Result	  : A_DETONATION_RESULT;
      Padding		  : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Articulation_Parms  : AN_ARTICULATION_PARAMETER_LIST (1..Number_of_Parms);
    end record;
  for A_DETONATION_PDU use
    record
      PDU_Header	at 0 range 0..95;
      Firing_Entity_ID	at 0 range 96..143;
      Target_Entity_ID	at 0 range 144..191;
      Munition_ID	at 0 range 192..239;
      Event_ID		at 0 range 240..287;
      Velocity		at 0 range 288..383;
      World_Location	at 0 range 384..575;
      Burst_Descriptor	at 0 range 576..703;
      Entity_Location	at 0 range 704..799;
      Detonation_Result	at 0 range 800..807;
      Number_of_Parms	at 0 range 808..815;
      Padding		at 0 range 816..831;
    end record;

  type A_SERVICE_REQUEST_PDU(Number_Of_Supply_Types : NUMERIC_TYPES.UNSIGNED_8_BIT) is
    record
      PDU_Header	      : A_PDU_HEADER;
      Requesting_Entity_ID    : AN_ENTITY_IDENTIFIER;
      Servicing_Entity_ID     : AN_ENTITY_IDENTIFIER;
      Service_Type_Requested  : A_SERVICE_TYPE;
      Padding		      : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Supplies		      : A_SUPPLY_QUANTITY_RECORD_LIST (1..Number_Of_Supply_Types);
    end record;
  for A_SERVICE_REQUEST_PDU use
    record
      PDU_Header              at 0 range 0..95;
      Requesting_Entity_ID    at 0 range 96..143;
      Servicing_Entity_ID     at 0 range 144..191;
      Service_Type_Requested  at 0 range 192..199;
      Number_Of_Supply_Types  at 0 range 200..207;
      Padding                 at 0 range 208..223;
    end record;

  type A_RESUPPLY_OFFER_PDU(Number_Of_Supply_Types : NUMERIC_TYPES.UNSIGNED_8_BIT) is
    record
      PDU_Header	  : A_PDU_HEADER;
      Receiving_Entity_ID : AN_ENTITY_IDENTIFIER;
      Supplying_Entity_ID  : AN_ENTITY_IDENTIFIER;
      Padding		  : A_PADDING_FIELD(1..24);
      Supplies		  : A_SUPPLY_QUANTITY_RECORD_LIST (1..Number_Of_Supply_Types);
    end record;
  for A_RESUPPLY_OFFER_PDU use
    record
      PDU_Header	      at 0 range 0..95;
      Receiving_Entity_ID     at 0 range 96..143;
      Supplying_Entity_ID      at 0 range 144..191;
      Number_Of_Supply_Types  at 0 range 192..199;
      Padding		      at 0 range 200..223;
    end record;

  type A_RESUPPLY_RECEIVED_PDU (Number_Of_Supply_Types : NUMERIC_TYPES.UNSIGNED_8_BIT) is
    record
      PDU_Header	  : A_PDU_HEADER;
      Receiving_Entity_ID : AN_ENTITY_IDENTIFIER;
      Supplying_Entity_ID  : AN_ENTITY_IDENTIFIER;
      Padding		  : A_PADDING_FIELD(1..24);
      Supplies		  : A_SUPPLY_QUANTITY_RECORD_LIST (1..Number_Of_Supply_Types);
    end record;
  for A_RESUPPLY_RECEIVED_PDU use
    record
      PDU_Header	      at 0 range 0..95;
      Receiving_Entity_ID     at 0 range 96..143;
      Supplying_Entity_ID      at 0 range 144..191;
      Number_Of_Supply_Types  at 0 range 192..199;
      Padding		      at 0 range 200..223;
    end record;

  type A_RESUPPLY_CANCEL_PDU is
    record
      PDU_Header	  : A_PDU_HEADER;
      Receiving_Entity_ID : AN_ENTITY_IDENTIFIER;
      Supplying_Entity_ID  : AN_ENTITY_IDENTIFIER;
    end record;
  for A_RESUPPLY_CANCEL_PDU use
    record
      PDU_Header	  at 0 range 0..95;
      Receiving_Entity_ID at 0 range 96..143;
      Supplying_Entity_ID  at 0 range 144..191;
    end record;

  type A_REPAIR_COMPLETE_PDU is
    record
      PDU_Header	  : A_PDU_HEADER;
      Receiving_Entity_ID : AN_ENTITY_IDENTIFIER;
      Repairing_Entity_ID : AN_ENTITY_IDENTIFIER;
      Repair		  : A_REPAIR_TYPE;
      Padding		  : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for A_REPAIR_COMPLETE_PDU use
    record
      PDU_Header	  at 0 range 0..95;
      Receiving_Entity_ID at 0 range 96..143;
      Repairing_Entity_ID at 0 range 144..191;
      Repair              at 0 range 192..207;
      Padding		  at 0 range 208..223;
    end record;

  type A_REPAIR_RESPONSE_PDU is
    record
      PDU_Header	  : A_PDU_HEADER;
      Receiving_Entity_ID : AN_ENTITY_IDENTIFIER;
      Repairing_Entity_ID : AN_ENTITY_IDENTIFIER;
      Repair_Result	  : A_REPAIR_RESULT;
      Padding		  : A_PADDING_FIELD (1..24);
    end record;
  for A_REPAIR_RESPONSE_PDU use
    record
      PDU_Header	  at 0 range 0..95;
      Receiving_Entity_ID at 0 range 96..143;
      Repairing_Entity_ID at 0 range 144..191;
      Repair_Result       at 0 range 192..199;
      Padding		  at 0 range 200..223;
    end record;

  type A_COLLISION_PDU is      
    record
      PDU_Header	  : A_PDU_HEADER;
      Issuing_Entity_ID	  : AN_ENTITY_IDENTIFIER;
      Colliding_Entity_ID : AN_ENTITY_IDENTIFIER;
      Event_ID		  : AN_EVENT_IDENTIFIER;
      Padding		  : A_PADDING_FIELD (1..16);
      Velocity		  : A_LINEAR_VELOCITY_VECTOR;
      Mass		  : NUMERIC_TYPES.FLOAT_32_BIT;
      Entity_Location	  : AN_ENTITY_COORDINATE_VECTOR;
    end record;
  for A_COLLISION_PDU use
    record
      PDU_Header	  at 0 range 0..95;
      Issuing_Entity_ID	  at 0 range 96..143;
      Colliding_Entity_ID at 0 range 144..191;
      Event_ID		  at 0 range 192..239;
      Padding		  at 0 range 240..255;
      Velocity		  at 0 range 256..351;
      Mass		  at 0 range 352..383;
      Entity_Location	  at 0 range 384..479;
    end record;

  ------------------------------------------------------------------------------
  --| Sim Management Definitions |----------------------------------------------
  ------------------------------------------------------------------------------

  type A_SIM_MANAGEMENT_ENTITY_ID is
    record
      Entity : AN_ENTITY_IDENTIFIER;
      Group  : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for A_SIM_MANAGEMENT_ENTITY_ID use
    record
      Entity at 0 range 0..47;
      Group  at 0 range 48..63;
    end record;

  type A_DATUM_PARAMETER is (MASS_OF_VEHICLE, FORCE_ID, ENTITY_TYPE_KIND,
			     ENTITY_TYPE_DOMAIN, ENTITY_TYPE_COUNTRY,
			     ENTITY_TYPE_SUBCATEGORY, ENTITY_TYPE_SPECIFIC,
			     ENTITY_TYPE_EXTRA, ALTERNATIVE_ENTITY_TYPE_KIND,
			     ALTERNATIVE_ENTITY_TYPE_DOMAIN, 
			     ALTERNATIVE_ENTITY_TYPE_COUNTRY,
			     ALTERNATIVE_ENTITY_TYPE_SUBCATEGORY, 
			     ALTERNATIVE_ENTITY_TYPE_SPECIFIC,
			     ALTERNATIVE_ENTITY_TYPE_EXTRA,
			     ENTITY_LOCATION_X, ENTITY_LOCATION_Y, 
			     ENTITY_LOCATION_Z, ENTITY_LINEAR_VELOCITY_X,
			     ENTITY_LINEAR_VLEOCITY_Y, ENTITY_LINEAR_VELOCITY_Z,
			     ENTITY_ORIENTATION_X, ENTITY_ORIENTATION_Y,
			     ENTITY_ORIENTATION_Z, DEAD_RECKONING_ALGORITHM,
			     DR_LINEAR_ACCELERATION_X, DR_LINEAR_ACCELERATION_Y,
			     DR_LINEAR_ACCELERATION_Z, DR_ANGULAR_VELOCITY_X,
			     DR_ANGULAR_VELOCITY_Y, DR_ANGULAR_VELOCITY_Z,
			     ENTITY_APPEARENCE, ENTITY_MARKING_CHARACTER_SET,
			     ENTITY_MARKING_TEXT, CAPABILITY, 
			     NUMBER_OF_ARTICULATION_PARAMETERS,
			     ARTICULATION_PARAMETER_ID, 
			     ARTICULATION_PARAMETER_TYPE,
			     ARTICULATION_PARAMETER_VALUE,
			     AMOUNT_OF_AMMUNITION_OR_SUPPLIES,
			     AMMUNITION_QUANTITY, FUEL_QUANTITY,
			     RADAR_SYSTEM_STATUS,
			     RADIO_COMMUNICATIONS_SYSTEM_STATUS,
			     DEFAULT_TIME_FOR_STATIONARY_TRANSMITTERS,
			     DEFAULT_TIME_FOR_MOVING_TRANSMITTERS,
			     BODY_PART_DAMEGED_RATIO,
			     NAME_OF_TERRAIN_DATABASE_FILE,
			     NAME_OF_LOCAL_LOGGER_FILE);
  for A_DATUM_PARAMETER use (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
			     21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,
			     38,39,40,41,42,43,44,45,46,47,48);

  for A_DATUM_PARAMETER'SIZE use 32;

  type A_FIXED_DATUM_RECORD is
    record
      Datum_ID	: A_DATUM_PARAMETER;
      Value	: NUMERIC_TYPES.UNSIGNED_32_BIT;
    end record;
  for A_FIXED_DATUM_RECORD use
    record
      Datum_ID	at 0 range 0..31;
      Value	at 0 range 32..63;
    end record;

  type A_VARIABLE_DATUM_SEGMENT is array (0..63) of NUMERIC_TYPES.UNSIGNED_1_BIT;
  pragma PACK (A_VARIABLE_DATUM_SEGMENT);
  for A_VARIABLE_DATUM_SEGMENT'size use 64;

  type A_VARIABLE_DATUM_VALUE is array (NUMERIC_TYPES.UNSIGNED_32_BIT range <>) of A_VARIABLE_DATUM_SEGMENT;
  pragma PACK (A_VARIABLE_DATUM_VALUE);

  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  -- This is not a true Variable Datum record.  There is no way to correctly
  -- implement a "true" Variable Datum record structure because the
  -- descriminant part of the record does not describe the actual length of the
  -- unconstrained array.  The user should define a variable datum type for
  -- each size record they need.
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  type A_VARIABLE_DATUM_RECORD is
    record
      Datum_ID	: A_DATUM_PARAMETER;
      Length	: NUMERIC_TYPES.UNSIGNED_32_BIT := 16; -- # of octets in record
      Value	: A_VARIABLE_DATUM_VALUE(1..1);
    end record;
  for A_VARIABLE_DATUM_RECORD use
    record
      Datum_ID	at 0 range 0..31;
      Length	at 0 range 32..63;
      Value	at 0 range 64..127;
    end record;

  type A_FIXED_DATUM_LIST is array (NUMERIC_TYPES.UNSIGNED_32_BIT range <>) of A_FIXED_DATUM_RECORD;
  pragma PACK (A_FIXED_DATUM_LIST);

  type A_VARIABLE_DATUM_LIST is array (NUMERIC_TYPES.UNSIGNED_32_BIT range <>) of A_VARIABLE_DATUM_RECORD;
  pragma PACK (A_VARIABLE_DATUM_LIST);

  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  -- This structure does not allow for a list of different sized Variable Datum
  -- records.  The DIS standard does allow this but to implement such a
  -- structure requires runtime address manipulation and is beyond the scope of
  -- this specification.
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  type A_DATUM_SPECIFICATION_RECORD (Fixed_Records : NUMERIC_TYPES.UNSIGNED_32_BIT;
				     Variable_Records : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      Fixed_List    : A_FIXED_DATUM_LIST(1..Fixed_Records);
      Variable_List : A_VARIABLE_DATUM_LIST(1..Variable_Records);
    end record;
  for A_DATUM_SPECIFICATION_RECORD use
    record
      Fixed_Records	at 0 range 0..31;
      Variable_Records	at 0 range 32..63;
    end record;

  type A_CLOCK_TIME_RECORD is
    record
      Hour		: NUMERIC_TYPES.UNSIGNED_32_BIT;
      Seconds_Past_Hour	: NUMERIC_TYPES.UNSIGNED_32_BIT;
    end record;
  for A_CLOCK_TIME_RECORD use
    record
      Hour		at 0 range 0..31;
      Seconds_Past_Hour	at 0 range 32..63;
    end record;

  type A_REASON_TO_STOP is (OTHER_REASON, RECESS, TERMINATION, SYSTEM_FAILURE,
			    SECURITY_VIOLATION, ENTITY_RECONSTRUCTION);
  for A_REASON_TO_STOP use (0,1,2,3,4,5);
  for A_REASON_TO_STOP'size use 8;

  type AN_ACKNOWLEDGEMENT is (CREATE_ENTITY, REMOVE_ENTITY,
			      START_RESUME, STOP_FREEZE);
  for AN_ACKNOWLEDGEMENT use (1,2,3,4);
  for AN_ACKNOWLEDGEMENT'size use 16;

  type AN_ACTION_ID is (OTHER_ACTION, LOCAL_STORAGE,
			INFORM_SM_OUT_OF_AMMUNITION, INFORM_SM_KILLED_IN_ACTION,
			INFORM_SM_DAMAGE, INFORM_SM_MOBILITY_DISABLED,
			INFORM_SM_FIRE_DISABLED);
  for AN_ACTION_ID use (0,1,2,3,4,5,6);
  for AN_ACTION_ID'size use 32;

  type A_REQUEST_STATUS is (OTHER_STATUS, PENDING, EXECUTING,
			    PARTIALLY_COMPLETE, COMPLETE);
  for A_REQUEST_STATUS use (0,1,2,3,4);
  for A_REQUEST_STATUS'size use 32;

  type AN_EVENT_TYPE is (OTHER_EVENT, RAN_OUT_OF_FUEL, RAN_OUT_OF_AMMUNITION,
			 KILLED_IN_ACTION, DAMAGE);
  for AN_EVENT_TYPE use (0,1,2,3,4);
  for AN_EVENT_TYPE'size use 32;

  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  -- note:
  --	The A_SIM_MANAGEMENT_ENTITY_ID type was not used in the actual PDU
  --	definitions because the group field is ommited in version 2.0.4 of the
  --	DIS standard.  By not using the A_SIM_MANAGEMENT_ENTITY_ID structure in
  --	the PDU definitions no code changes will be nessecary when the new
  --	standard is implemented.
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

  type A_CREATE_ENTITY_PDU is
    record
      PDU_Header	    : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for A_CREATE_ENTITY_PDU use
    record                  
      PDU_Header	    at 0 range 0..95;
      Originating_Entity_ID at 0 range 96..143;
      Originating_Group	    at 0 range 144..159;
      Receiving_Entity_ID   at 0 range 160..207;
      Receiving_Group	    at 0 range 208..223;
    end record;

  type A_REMOVE_ENTITY_PDU is
    record
      PDU_Header	    : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for A_REMOVE_ENTITY_PDU use
    record
      PDU_Header	    at 0 range 0..95;
      Originating_Entity_ID at 0 range 96..143;
      Originating_Group	    at 0 range 144..159;
      Receiving_Entity_ID   at 0 range 160..207;
      Receiving_Group	    at 0 range 208..223;
    end record;

  type A_START_RESUME_PDU is
    record
      PDU_Header	    : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Real_World_Time	    : A_CLOCK_TIME_RECORD;
      Simulation_Time	    : A_CLOCK_TIME_RECORD;
    end record;
  for A_START_RESUME_PDU use
    record
      PDU_Header	    at 0 range 0..95;
      Originating_Entity_ID at 0 range 96..143;
      Originating_Group	    at 0 range 144..159;
      Receiving_Entity_ID   at 0 range 160..207;
      Receiving_Group	    at 0 range 208..223;
      Real_World_Time	    at 0 range 224..287;
      Simulation_Time	    at 0 range 288..351;
    end record;

  type A_STOP_FREEZE_PDU is
    record
      PDU_Header	    : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Real_World_Time	    : A_CLOCK_TIME_RECORD;
      Reason		    : A_REASON_TO_STOP;
      Padding		    : A_PADDING_FIELD(1..24);
    end record;
  for A_STOP_FREEZE_PDU use
    record
      PDU_Header	    at 0 range 0..95;
      Originating_Entity_ID at 0 range 96..143;
      Originating_Group	    at 0 range 144..159;
      Receiving_Entity_ID   at 0 range 160..207;
      Receiving_Group	    at 0 range 208..223;
      Real_World_Time	    at 0 range 224..287;
      Reason		    at 0 range 288..295;
      Padding		    at 0 range 296..319;
    end record;

 --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
 -- Response_Flag should be an enumeration, but the enumerals are not defined.
 --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  type AN_ACKNOWLEDGE_PDU is
    record
      PDU_Header	    : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Acknowledge_Flag	    : AN_ACKNOWLEDGEMENT;
      Response_Flag	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for AN_ACKNOWLEDGE_PDU use
    record
      PDU_Header	    at 0 range 0..95;
      Originating_Entity_ID at 0 range 96..143;
      Originating_Group	    at 0 range 144..159;
      Receiving_Entity_ID   at 0 range 160..207;
      Receiving_Group	    at 0 range 208..223;
      Acknowledge_Flag	    at 0 range 224..239;
      Response_Flag	    at 0 range 240..255;
    end record;

  type AN_ACTION_REQUEST_PDU(Number_of_Fixed_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT;
                             Number_of_Variable_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      PDU_Header            : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Padding               : A_PADDING_FIELD(1..32);
      Request_ID            : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Action_ID             : AN_ACTION_ID;
      Fixed_Datum           : A_FIXED_DATUM_LIST(1..Number_of_Fixed_Datums);
      Variable_Datum        : A_VARIABLE_DATUM_LIST(1..Number_of_Variable_Datums);
    end record;
  for AN_ACTION_REQUEST_PDU use
    record
      PDU_Header		at 0 range 0..95;
      Originating_Entity_ID	at 0 range 96..143;
      Originating_Group		at 0 range 144..159;
      Receiving_Entity_ID	at 0 range 160..207;
      Receiving_Group		at 0 range 208..223;
      Padding			at 0 range 224..255;
      Request_ID		at 0 range 256..287;
      Action_ID			at 0 range 288..319;
      Number_of_Fixed_Datums	at 0 range 320..351;
      Number_of_Variable_Datums at 0 range 352..383;
    end record;

  type AN_ACTION_RESPONCE_PDU(Number_of_Fixed_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT;
                             Number_of_Variable_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      PDU_Header            : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Padding               : A_PADDING_FIELD(1..32);
      Request_ID            : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Request_Status        : A_REQUEST_STATUS;
      Fixed_Datum           : A_FIXED_DATUM_LIST(1..Number_of_Fixed_Datums);
      Variable_Datum        : A_VARIABLE_DATUM_LIST(1..Number_of_Variable_Datums);
    end record;
  for AN_ACTION_RESPONCE_PDU use
    record
      PDU_Header		at 0 range 0..95;
      Originating_Entity_ID	at 0 range 96..143;
      Originating_Group		at 0 range 144..159;
      Receiving_Entity_ID	at 0 range 160..207;
      Receiving_Group		at 0 range 208..223;
      Padding			at 0 range 224..255;
      Request_ID		at 0 range 256..287;
      Request_Status		at 0 range 288..319;
      Number_of_Fixed_Datums	at 0 range 320..351;
      Number_of_Variable_Datums at 0 range 352..383;
    end record;

  type A_DATA_QUERY_PDU(Number_of_Fixed_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT;
                        Number_of_Variable_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      PDU_Header            : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Request_ID            : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Time_Interval	    : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Fixed_Datum           : A_FIXED_DATUM_LIST(1..Number_of_Fixed_Datums);
      Variable_Datum        : A_VARIABLE_DATUM_LIST(1..Number_of_Variable_Datums);
    end record;
  for A_DATA_QUERY_PDU use
    record
      PDU_Header		at 0 range 0..95;
      Originating_Entity_ID	at 0 range 96..143;
      Originating_Group		at 0 range 144..159;
      Receiving_Entity_ID	at 0 range 160..207;
      Receiving_Group		at 0 range 208..223;
      Request_ID		at 0 range 224..255;
      Time_Interval		at 0 range 256..287;
      Number_of_Fixed_Datums	at 0 range 288..319;
      Number_of_Variable_Datums	at 0 range 320..351;
    end record;

  type A_SET_DATA_PDU(Number_of_Fixed_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT;
                      Number_of_Variable_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      PDU_Header            : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Request_ID            : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Fixed_Datum           : A_FIXED_DATUM_LIST(1..Number_of_Fixed_Datums);
      Variable_Datum        : A_VARIABLE_DATUM_LIST(1..Number_of_Variable_Datums);
    end record;
  for A_SET_DATA_PDU use
    record
      PDU_Header		at 0 range 0..95;
      Originating_Entity_ID	at 0 range 96..143;
      Originating_Group		at 0 range 144..159;
      Receiving_Entity_ID	at 0 range 160..207;
      Receiving_Group		at 0 range 208..223;
      Request_ID		at 0 range 224..255;
      Number_of_Fixed_Datums	at 0 range 256..287;
      Number_of_Variable_Datums	at 0 range 288..319;
    end record;

  type A_DATA_PDU(Number_of_Fixed_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT;
                      Number_of_Variable_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      PDU_Header            : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Request_ID            : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Fixed_Datum           : A_FIXED_DATUM_LIST(1..Number_of_Fixed_Datums);
      Variable_Datum        : A_VARIABLE_DATUM_LIST(1..Number_of_Variable_Datums);
    end record;
  for A_DATA_PDU use
    record
      PDU_Header		at 0 range 0..95;
      Originating_Entity_ID	at 0 range 96..143;
      Originating_Group		at 0 range 144..159;
      Receiving_Entity_ID	at 0 range 160..207;
      Receiving_Group		at 0 range 208..223;
      Request_ID		at 0 range 224..255;
      Number_of_Fixed_Datums	at 0 range 256..287;
      Number_of_Variable_Datums	at 0 range 288..319;
    end record;

  type AN_EVENT_REPORT_PDU(Number_of_Fixed_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT;
			   Number_of_Variable_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      PDU_Header            : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Event_Type            : AN_EVENT_TYPE;
      Fixed_Datum           : A_FIXED_DATUM_LIST(1..Number_of_Fixed_Datums);
      Variable_Datum        : A_VARIABLE_DATUM_LIST(1..Number_of_Variable_Datums);
    end record;
  for AN_EVENT_REPORT_PDU use
    record
      PDU_Header		at 0 range 0..95;
      Originating_Entity_ID	at 0 range 96..143;
      Originating_Group		at 0 range 144..159;
      Receiving_Entity_ID	at 0 range 160..207;
      Receiving_Group		at 0 range 208..223;
      Event_Type		at 0 range 224..255;
      Number_of_Fixed_Datums	at 0 range 256..287;
      Number_of_Variable_Datums	at 0 range 288..319;
    end record;

  type A_MESSAGE_PDU(Number_of_Variable_Datums : NUMERIC_TYPES.UNSIGNED_32_BIT) is
    record
      PDU_Header            : A_PDU_HEADER;
      Originating_Entity_ID : AN_ENTITY_IDENTIFIER;
      Originating_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiving_Entity_ID   : AN_ENTITY_IDENTIFIER;
      Receiving_Group	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Variable_Datum        : A_VARIABLE_DATUM_LIST(1..Number_of_Variable_Datums);
    end record;
  for A_MESSAGE_PDU use
    record
      PDU_Header		at 0 range 0..95;
      Originating_Entity_ID	at 0 range 96..143;
      Originating_Group		at 0 range 144..159;
      Receiving_Entity_ID	at 0 range 160..207;
      Receiving_Group		at 0 range 208..223;
      Number_of_Variable_Datums	at 0 range 224..255;
    end record;

  ------------------------------------------------------------------------------
  --| Emission PDU definitions |------------------------------------------------
  ------------------------------------------------------------------------------

  type AN_EMITTER_SYSTEM is (OTHER_EMITTER, TBD);
  for AN_EMITTER_SYSTEM use (0,1);
  for AN_EMITTER_SYSTEM'size use 16;

  type AN_EMISSION_FUNCTION is (OTHER_FUNCTION, TBD);
  for AN_EMISSION_FUNCTION use (0,1);
  for AN_EMISSION_FUNCTION'size use 8;

  type AN_EMITTER_SYSTEM_RECORD is
    record
      Emitter_Name     : AN_EMITTER_SYSTEM;
      Emitter_Function : AN_EMISSION_FUNCTION;
      Emitter_ID       : NUMERIC_TYPES.UNSIGNED_8_BIT;
    end record;
  for AN_EMITTER_SYSTEM_RECORD use
    record
      Emitter_Name     at 0 range 0..15;
      Emitter_Function at 0 range 16..23;
      Emitter_ID       at 0 range 24..31;
    end record;

  type A_FUNDAMENTAL_PARAMETER_DATA_RECORD is
    record
      Frequency		    : NUMERIC_TYPES.FLOAT_32_BIT;
      Frequency_Range	    : NUMERIC_TYPES.FLOAT_32_BIT;
      ERP		    : NUMERIC_TYPES.FLOAT_32_BIT;
      PRF		    : NUMERIC_TYPES.FLOAT_32_BIT;
      Pulse_Width	    : NUMERIC_TYPES.FLOAT_32_BIT;
      Beam_Azimuth_Center   : NUMERIC_TYPES.FLOAT_32_BIT;
      Beam_Azimuth_Sweep    : NUMERIC_TYPES.FLOAT_32_BIT;
      Beam_Elevation_Center : NUMERIC_TYPES.FLOAT_32_BIT;
      Beam_Elevation_Sweep  : NUMERIC_TYPES.FLOAT_32_BIT;
      Beam_Sweep_Sync	    : NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for A_FUNDAMENTAL_PARAMETER_DATA_RECORD use
    record
      Frequency		    at 0 range 0..31;
      Frequency_Range	    at 0 range 32..63;
      ERP		    at 0 range 64..95;
      PRF		    at 0 range 96..127;
      Pulse_Width	    at 0 range 128..159;
      Beam_Azimuth_Center   at 0 range 160..191;
      Beam_Azimuth_Sweep    at 0 range 192..223;
      Beam_Elevation_Center at 0 range 224..255;
      Beam_Elevation_Sweep  at 0 range 256..287;
      Beam_Sweep_Sync	    at 0 range 288..319;
    end record;

  type A_TRACK_OR_JAM is
    record
      Entity_ID	  : AN_ENTITY_IDENTIFIER;
      Emitter_ID  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Beam_ID	  : NUMERIC_TYPES.UNSIGNED_8_BIT;
    end record;
  for A_TRACK_OR_JAM use
    record
      Entity_ID	  at 0 range 0..47;
      Emitter_ID  at 0 range 48..55;
      Beam_ID	  at 0 range 56..63;
    end record;
  for A_TRACK_OR_JAM'size use 64;

  type A_TRACK_JAM_LIST is array (NUMERIC_TYPES.UNSIGNED_8_BIT range <>) of A_TRACK_OR_JAM;
  pragma PACK(A_TRACK_JAM_LIST);

  type AN_EMITTER_DATA_BLOCK is array (NUMERIC_TYPES.UNSIGNED_8_BIT range <>) of NUMERIC_TYPES.UNSIGNED_32_BIT;
  pragma PACK(AN_EMITTER_DATA_BLOCK);

  type AN_EMITTER_SYSTEM_DATA_HEADER (System_Data_Length  : NUMERIC_TYPES.UNSIGNED_8_BIT) is
    record
      Number_Of_Beams	  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Padding		  : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Emitter_System	  : AN_EMITTER_SYSTEM_RECORD;
      Location		  : AN_ENTITY_COORDINATE_VECTOR;
      Data		  : AN_EMITTER_DATA_BLOCK(1..System_Data_Length);
    end record;
  for AN_EMITTER_SYSTEM_DATA_HEADER use
    record
      System_Data_Length  at 0 range 0..7;
      Number_Of_Beams	  at 0 range 8..15;
      Padding		  at 0 range 16..31;
      Emitter_System	  at 0 range 32..63;
      Location		  at 0 range 64..159;
    end record;

  type A_BEAM_DATA_RECORD(Number_Of_Targets : NUMERIC_TYPES.UNSIGNED_8_BIT) is
    record
      Beam_Data_Length		  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Beam_ID_Number		  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Beam_Parameter_Index	  : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Fundamental_Parameter_Data  : A_FUNDAMENTAL_PARAMETER_DATA_RECORD;
      Beam_Function		  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      High_Density_Track_Jam	  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Padding			  : NUMERIC_TYPES.UNSIGNED_8_BIT;
      Jamming_Mode_Sequence	  : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Track_Jam			  : A_TRACK_JAM_LIST(1..Number_Of_Targets);
    end record;
  for A_BEAM_DATA_RECORD use
    record
      Beam_Data_Length		  at 0 range 0..7;
      Beam_ID_Number		  at 0 range 8..15;
      Beam_Parameter_Index	  at 0 range 16..31;
      Fundamental_Parameter_Data  at 0 range 32..351;
      Beam_Function		  at 0 range 352..359;
      Number_Of_Targets		  at 0 range 360..367;
      High_Density_Track_Jam	  at 0 range 368..375;
      Padding			  at 0 range 376..383;
      Jamming_Mode_Sequence	  at 0 range 384..415;
    end record;
  pragma PACK(A_BEAM_DATA_RECORD);

  --
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  -- Notes:
  --   1. The values for the State Update Indicator field are described as
  --      an 8-bit enumeration by the 2.0.3 standard, but the values of
  --      this enumeration are not defined in the 2.0.3 Enumeration/Bit
  --      Encoded Values document.  The values for this type are based upon
  --      the description in subsection (4) of paragraph 5.4.6.2.
  --   2. The size of the data describing the individual emission systems of
  --      the PDU varies, with the variants being part of the emission system
  --      data itself.  This cannot be represented by a single data type,
  --      unless additional (non-PDU) information is stored.  The field
  --      Total_System_Length in the AN_EMISSION_PDU type stores the number
  --      of bytes (octets) required for storage of all the system parameter
  --      data of the PDU.  This variant is located at the beginning of the
  --      record, so the starting address of the PDU data is the address of
  --      the PDU_Header component, not the address of the AN_EMISSION_PDU
  --      record itself.
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

  type A_STATE_UPDATE_INDICATOR is (
    STATE_UPDATE,
    CHANGED_DATA_UPDATE);
  for A_STATE_UPDATE_INDICATOR'SIZE use 8;

  subtype A_SYSTEM_DATA_SIZE is Numeric_Types.UNSIGNED_16_BIT range 0..1176;

  type A_SYSTEM_DATA_ARRAY is array (A_SYSTEM_DATA_SIZE range <>)
    of Numeric_Types.UNSIGNED_8_BIT;
  pragma PACK(A_SYSTEM_DATA_ARRAY);

  type AN_EMISSION_PDU(Total_System_Length : A_SYSTEM_DATA_SIZE) is
    record
      PDU_Header             : A_PDU_HEADER;
      Emitting_Entity_ID     : AN_ENTITY_IDENTIFIER;
      Event_ID               : AN_EVENT_IDENTIFIER;
      State_Update_Indicator : A_STATE_UPDATE_INDICATOR;
      Number_Of_Systems      : Numeric_Types.UNSIGNED_8_BIT;
      Padding                : Numeric_Types.UNSIGNED_16_BIT;
      System_Data            : A_SYSTEM_DATA_ARRAY(1..Total_System_Length);
    end record;

  for AN_EMISSION_PDU use
    record
      Total_System_Length    at 0 range   0..15;
      PDU_Header             at 0 range  16..111;
      Emitting_Entity_ID     at 0 range 112..159;
      Event_ID               at 0 range 160..207;
      State_Update_Indicator at 0 range 208..215;
      Number_Of_Systems      at 0 range 216..223;
      Padding                at 0 range 224..239;
    end record;

  ------------------------------------------------------------------------------
  --| Laser PDU definitions |---------------------------------------------------
  ------------------------------------------------------------------------------

  type A_LASER_PDU is
    record
      PDU_Header                              : A_PDU_HEADER;
      Lasing_Entity_ID                        : AN_ENTITY_IDENTIFIER;
      Code_Name                               : Numeric_Types.UNSIGNED_16_BIT;
      Lased_Entity_ID                         : AN_ENTITY_IDENTIFIER;
      Padding                                 : Numeric_Types.UNSIGNED_8_BIT;
      Laser_Code                              : Numeric_Types.UNSIGNED_8_BIT;
      Laser_Power                             : Numeric_Types.FLOAT_32_BIT;
      Laser_Wavelength                        : Numeric_Types.FLOAT_32_BIT;
      Laser_Spot_With_Respect_To_Lased_Entity : AN_ENTITY_COORDINATE_VECTOR;
      Laser_Spot_Location                     : A_WORLD_COORDINATE;
    end record;
  for A_LASER_PDU use
    record
      PDU_Header                              at 0 range 0..95;
      Lasing_Entity_ID                        at 0 range 96..143;
      Code_Name                               at 0 range 144..159;
      Lased_Entity_ID                         at 0 range 160..207;
      Padding                                 at 0 range 208..215;
      Laser_Code                              at 0 range 216..223;
      Laser_Power                             at 0 range 224..255;
      Laser_Wavelength                        at 0 range 256..287;
      Laser_Spot_With_Respect_To_Lased_Entity at 0 range 288..383;
      Laser_Spot_Location                     at 0 range 384..575;
    end record;

  ------------------------------------------------------------------------------
  --| Expendables PDU definitions |---------------------------------------------
  ------------------------------------------------------------------------------
  -- TBD

  ------------------------------------------------------------------------------
  --| IFF PDU definitions |-----------------------------------------------------
  ------------------------------------------------------------------------------
  -- TBD

  ------------------------------------------------------------------------------
  --| Radio PDU definitions |---------------------------------------------------
  ------------------------------------------------------------------------------

  type A_REFERENCE_SYSTEM is (WORLD_COORDINATES, ENTITY_COORDINATES);
  for A_REFERENCE_SYSTEM use (1,2);
  for A_REFERENCE_SYSTEM'size use 8;

  type A_COEFFICIENT_RECORD is array (NUMERIC_TYPES.UNSIGNED_8_BIT range <>) of NUMERIC_TYPES.FLOAT_32_BIT;
  pragma PACK(A_COEFFICIENT_RECORD);

  type AN_ANTENNA_LOCATION is
    record
      Antenna_Location		: A_WORLD_COORDINATE;
      Relative_Antenna_Location : AN_ENTITY_COORDINATE_VECTOR;
    end record;
  for AN_ANTENNA_LOCATION use
    record
      Antenna_Location		at 0 range 0..191;
      Relative_Antenna_Location at 0 range 192..287;
    end record;

  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  -- The values for the Antenna Pattern Type are described as a 16-bit
  -- enumeration by the 2.0.3 standard, but the values of this enumeration are 
  -- not defined in the 2.0.3 Enumeration/Bit Encoded Values document.  The
  -- values for this type are based upon the description in paragraph 5.4.7.1.2.
  --\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
  type AN_ANTENNA_PATTERN_TYPE is (OMNI_DIRECTIONAL, BEAM, SPHERICAL_HARMONIC);
  for AN_ANTENNA_PATTERN_TYPE use (0,1,2);
  for AN_ANTENNA_PATTERN_TYPE'size use 16;

  type A_BEAM_ANTENNA_PATTERN is
    record
      Beam_Direction	  : AN_EULER_ANGLES_RECORD;
      Azimuth_Beamwidth	  : NUMERIC_TYPES.FLOAT_32_BIT;
      Elevation_Beamwidth : NUMERIC_TYPES.FLOAT_32_BIT;
      Reference_System	  : A_REFERENCE_SYSTEM;
      Padding		  : A_PADDING_FIELD(1..24);
      E_sub_Z		  : NUMERIC_TYPES.FLOAT_32_BIT;
      E_sub_X		  : NUMERIC_TYPES.FLOAT_32_BIT;
      Phase		  : NUMERIC_TYPES.FLOAT_32_BIT;
    end record;
  for A_BEAM_ANTENNA_PATTERN use
    record
      Beam_Direction	  at 0 range 0..95;
      Azimuth_Beamwidth	  at 0 range 96..127;
      Elevation_Beamwidth at 0 range 128..159;
      Reference_System	  at 0 range 160..167;
      Padding		  at 0 range 168..191;
      E_sub_Z		  at 0 range 192..223;
      E_sub_X		  at 0 range 224..255;
      Phase		  at 0 range 256..287;
    end record;

  type A_SPHERICAL_HARMONIC_ANTENNA_PATTERN(Order : NUMERIC_TYPES.UNSIGNED_8_BIT) is
    record
      Coefficients	: A_COEFFICIENT_RECORD(1..Order);
      Reference_System	: A_REFERENCE_SYSTEM;
    end record;
  for A_SPHERICAL_HARMONIC_ANTENNA_PATTERN use
    record
      Order at 0 range 0..7;
    end record;
  pragma PACK (A_SPHERICAL_HARMONIC_ANTENNA_PATTERN);

  type A_SPREAD_SPECTRUM_TECHNIQUE is array (0..15) of NUMERIC_TYPES.UNSIGNED_1_BIT;
  pragma PACK(A_SPREAD_SPECTRUM_TECHNIQUE);
  for A_SPREAD_SPECTRUM_TECHNIQUE'size use 16;

  -- Define constants for the bit positions of spread spectrum types
  ------------------------------------------------------------------
  SS_MOD_TYPE_FREQUENCY_HOPPING : constant := 0;
  SS_MOD_TYPE_PSEUDO_NOISE      : constant := 1;
  SS_MOD_TYEP_TIME_HOPPING      : constant := 2;

  type A_MAJOR_MODULATION_TYPE is (OTHER_MODULATION, AMPLITUDE, AMPLITUDE_AND_ANGLE,
				   COMBINATION, PULSE, UNMODULATED);
  for A_MAJOR_MODULATION_TYPE use (0,1,2,3,4,5);
  for A_MAJOR_MODULATION_TYPE'size use 16;

  subtype A_DETAILED_MODULATION is NUMERIC_TYPES.UNSIGNED_16_BIT;

  -- Define constants for the detailed modulation parameter
  ---------------------------------------------------------
  AMPLITUDE_DETAIL_OTHER	    : constant A_DETAILED_MODULATION := 0;
  AMPLITUDE_DETAIL_AFSK		    : constant A_DETAILED_MODULATION := 1;
  AMPLITUDE_DETAIL_AM		    : constant A_DETAILED_MODULATION := 2;
  AMPLITUDE_DETAIL_CW		    : constant A_DETAILED_MODULATION := 3;
  AMPLITUDE_DETAIL_DSB		    : constant A_DETAILED_MODULATION := 4;
  AMPLITUDE_DETAIL_ISB		    : constant A_DETAILED_MODULATION := 5;
  AMPLITUDE_DETAIL_LSB		    : constant A_DETAILED_MODULATION := 6;
  AMPLITUDE_DETAIL_SSB_FULL	    : constant A_DETAILED_MODULATION := 7;
  AMPLITUDE_DETAIL_SSB_REDUC	    : constant A_DETAILED_MODULATION := 8;
  AMPLITUDE_DETAIL_USB		    : constant A_DETAILED_MODULATION := 9;
  AMPLITUDE_DETAIL_VSB		    : constant A_DETAILED_MODULATION := 10;

  AMP_AND_ANG_OTHER		    : constant A_DETAILED_MODULATION := 0;
  AMP_AND_ANG_AMPLITUDE_AND_ANGLE   : constant A_DETAILED_MODULATION := 1;

  ANGLE_OTHER			    : constant A_DETAILED_MODULATION := 0;
  ANGLE_FM			    : constant A_DETAILED_MODULATION := 1;
  ANGLE_FSK			    : constant A_DETAILED_MODULATION := 2;
  ANGLE_PM			    : constant A_DETAILED_MODULATION := 3;

  COMBINATION_OTHER		    : constant A_DETAILED_MODULATION := 0;
  COMBINATION_AMPLITUDE_ANGLE_PULSE : constant A_DETAILED_MODULATION := 1;

  UNMODULATED_OTHER		    : constant A_DETAILED_MODULATION := 0;
  UNMODULATED_CW		    : constant A_DETAILED_MODULATION := 1;

  type A_RADIO_SYSTEM is (OTHER_RADIO, GENERIC_RADIO, HQ, HQII, HQIIA, SINCGARS);
  for A_RADIO_SYSTEM use (0,1,2,3,4,5);
  for A_RADIO_SYSTEM'size use 16;

  type A_MODULATION_TYPE is
    record
      Spread_Spectrum	    : A_SPREAD_SPECTRUM_TECHNIQUE;
      Major_Modulation_Type : A_MAJOR_MODULATION_TYPE;
      Detail		    : A_DETAILED_MODULATION;
      System		    : A_RADIO_SYSTEM;
    end record;
  for A_MODULATION_TYPE use
    record
      Spread_Spectrum	    at 0 range 0..15;
      Major_Modulation_Type at 0 range 16..31;
      Detail		    at 0 range 32..47;
      System		    at 0 range 48..63;
    end record;

  type A_RADIO_CRYPTO_SYSTEM is (OTHER_CRYPTO, KY_28, KY_58);
  for A_RADIO_CRYPTO_SYSTEM use (0,1,2);
  for A_RADIO_CRYPTO_SYSTEM'size use 16;

  type A_RADIO_TRANSMIT_STATE is (OFF, ON_NOT_TX, ON_TX);
  for A_RADIO_TRANSMIT_STATE use (0,1,2);
  for A_RADIO_TRANSMIT_STATE'size use 8;

  type A_RADIO_INPUT_SOURCE is (OTHER_INPUT, PILOT, COPILOT, FIRST_OFFICER);
  for A_RADIO_INPUT_SOURCE use (0,1,2,3);
  for A_RADIO_INPUT_SOURCE'size use 8;

  type A_RADIO_RECEIVE_STATE is (OFF, ON_NOT_RECEIVING, ON_RECEIVING);
  for A_RADIO_RECEIVE_STATE use (0,1,2);
  for A_RADIO_RECEIVE_STATE'size use 16;

  type A_MODULATION_PARAMETER_BUFFER is array (NUMERIC_TYPES.UNSIGNED_8_BIT range <>) of NUMERIC_TYPES.UNSIGNED_8_BIT;
  pragma PACK(A_MODULATION_PARAMETER_BUFFER);

  type AN_ANTENNA_PATERN_PARAMETER_BUFFER is array (NUMERIC_TYPES.UNSIGNED_16_BIT range <>) of NUMERIC_TYPES.UNSIGNED_8_BIT;
  pragma PACK(AN_ANTENNA_PATERN_PARAMETER_BUFFER);

  type AN_ENCODING_CLASS is (ENCODED_VOICE, RAW_BINARY_DATA,
			     APPLICATION_SPECIFIC_DATA,
			     PRERECORDED_VOICE_POINTER);
  for AN_ENCODING_CLASS use (0, 1, 2, 3);
  for AN_ENCODING_CLASS'size use 2;

  type AN_ENCODING_TYPE is (NONE, MU_LAW_8_BIT, CVSD, ADPCM, LINEAR_PCM_16_BIT);
  for AN_ENCODING_TYPE use (0,1,2,3,4);
  for AN_ENCODING_TYPE'size use 14;

  type AN_ENCODING_SCHEME is
    record
      Encoding_Class : AN_ENCODING_CLASS;
      Encoding_Type  : AN_ENCODING_TYPE;
    end record;
  for AN_ENCODING_SCHEME use
    record
      Encoding_Class at 0 range 14..15;
      Encoding_Type  at 0 range 0..13;
    end record;
  for AN_ENCODING_SCHEME'size use 16;

  type A_SIGNAL_DATA_ARRAY is array (NUMERIC_TYPES.UNSIGNED_16_BIT range <>) of NUMERIC_TYPES.UNSIGNED_8_BIT;
  pragma PACK (A_SIGNAL_DATA_ARRAY);

  type A_TRANSMITTER_PDU(Antenna_Pattern_Length	    : NUMERIC_TYPES.UNSIGNED_16_BIT;
			 Length_Of_Modulation_Parms : NUMERIC_TYPES.UNSIGNED_8_BIT) is
    record
      PDU_Header		   : A_PDU_HEADER;
      Entity_ID			   : AN_ENTITY_IDENTIFIER;
      Radio_ID			   : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Radio_Entity_Type		   : AN_ENTITY_TYPE_RECORD;
      Transmit_State		   : A_RADIO_TRANSMIT_STATE;
      Input_Source		   : A_RADIO_INPUT_SOURCE;
      Antenna_Location		   : AN_ANTENNA_LOCATION;
      Antenna_Pattern_Type	   : AN_ANTENNA_PATTERN_TYPE;
      Frequency			   : NUMERIC_TYPES.UNSIGNED_64_BIT;
      Transmit_Frequency_Bandwidth : NUMERIC_TYPES.FLOAT_32_BIT;
      Power			   : NUMERIC_TYPES.FLOAT_32_BIT;
      Modulation_Type		   : A_MODULATION_TYPE;
      Crypto_System		   : A_RADIO_CRYPTO_SYSTEM;
      Crypto_Key		   : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Padding			   : A_PADDING_FIELD(1..24);
      Modulation_Parameters	   : A_MODULATION_PARAMETER_BUFFER(1..Length_Of_Modulation_Parms);
      Antenna_Pattern_Parameters   : AN_ANTENNA_PATERN_PARAMETER_BUFFER(1..Antenna_Pattern_Length);
    end record;
  for A_TRANSMITTER_PDU use
    record
      PDU_Header		   at 0 range 0..95;
      Entity_ID			   at 0 range 96..143;
      Radio_ID			   at 0 range 144..159;
      Radio_Entity_Type		   at 0 range 160..223;
      Transmit_State		   at 0 range 224..231;
      Input_Source		   at 0 range 232..240;
      Antenna_Location		   at 0 range 256..543;
      Antenna_Pattern_Type	   at 0 range 544..559;
      Antenna_Pattern_Length	   at 0 range 560..575;
      Frequency			   at 0 range 576..639;
      Transmit_Frequency_Bandwidth at 0 range 640..671;
      Power			   at 0 range 672..703;
      Modulation_Type		   at 0 range 704..767;
      Crypto_System		   at 0 range 768..783;
      Crypto_Key		   at 0 range 784..799;
      Length_Of_Modulation_Parms   at 0 range 800..807;
      Padding			   at 0 range 808..831;
    end record;

  type A_SIGNAL_PDU(Length : NUMERIC_TYPES.UNSIGNED_16_BIT) is
    record
      PDU_Header      : A_PDU_HEADER;
      Entity_ID	      : AN_ENTITY_IDENTIFIER;
      Radio_ID	      : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Encoding_Scheme : AN_ENCODING_SCHEME;
      Sample_Rate     : NUMERIC_TYPES.UNSIGNED_32_BIT;
      Samples	      : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Data	      : A_SIGNAL_DATA_ARRAY(1..Length);
    end record;
  for A_SIGNAL_PDU use
    record
      PDU_Header      at 0 range 0..95;
      Entity_ID	      at 0 range 96..143;
      Radio_ID	      at 0 range 144..159;
      Encoding_Scheme at 0 range 160..175;
      Sample_Rate     at 0 range 192..223;
      Length	      at 0 range 224..239;
      Samples	      at 0 range 240..255;
    end record;

  type A_RECEIVER_PDU is
    record
      PDU_Header	   : A_PDU_HEADER;
      Entity_ID		   : AN_ENTITY_IDENTIFIER;
      Radio_ID		   : NUMERIC_TYPES.UNSIGNED_16_BIT;
      Receiver_State	   : A_RADIO_RECEIVE_STATE;
      Received_Power	   : NUMERIC_TYPES.FLOAT_32_BIT;
      Transmitter_ID	   : AN_ENTITY_IDENTIFIER;
      Transmitter_Radio_ID : NUMERIC_TYPES.UNSIGNED_16_BIT;
    end record;
  for A_RECEIVER_PDU use
    record
      PDU_Header	   at 0 range 0..95;
      Entity_ID		   at 0 range 96..143;
      Radio_ID		   at 0 range 144..159;
      Receiver_State	   at 0 range 160..175;
      Received_Power	   at 0 range 192..223;
      Transmitter_ID	   at 0 range 224..271;
      Transmitter_Radio_ID at 0 range 272..287;
    end record;

end DIS_TYPES;
