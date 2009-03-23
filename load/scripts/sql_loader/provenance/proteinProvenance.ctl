-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
INFILE '$CABIO_DATA_DIR/temp/protein/Protein_ProvData.dat'
 
APPEND
INTO TABLE URL_source_reference 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
TRAILING NULLCOLS
( source_reference_TYPE CONSTANT "URL",
  ID_FILLER filler POSITION(1),
  source_URL char(10000),
  REFERENCE char(10000),
  ID SEQUENCE(MAX,1)
)

INTO TABLE source_reference 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
TRAILING NULLCOLS
( source_reference_TYPE CONSTANT "URL",
  ID filler POSITION(1),
  source_URL filler,
  REFERENCE char(10000),
  source_reference_ID SEQUENCE(MAX,1)
)

INTO TABLE provenance 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
TRAILING NULLCOLS
( evidence_code CONSTANT "EV-AS-TAS",
  IMMEDIATE_source_ID CONSTANT "1",
  SUPPLYING_source_ID CONSTANT "2",
  ORIGINAL_source_ID CONSTANT "1",
  FULLY_QUALIFIED_CLASS_NAME CONSTANT "gov.nih.nci.cabio_fut.domain.Protein",
  OBJECT_IDENTIFIER POSITION(1),
  ID SEQUENCE(MAX,1),
  source_reference_ID SEQUENCE(MAX,1)
)
