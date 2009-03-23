LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/nas.dat_nas_hsmm_revised.dat'
 
APPEND
INTO TABLE  URL_source_reference 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
  ACCESSION_NUMBER filler POSITION(1),
  sequence_type_FILLER filler,
  description filler,
  length filler,
  value filler  char(500000), 
  ID_FILLER filler,
  ACCESSION_NUMBER_FILLER filler,
  VERSION filler,
  sequence_type filler,
  DISCRIMINATOR filler,
  CLONE_ID filler,
  source_URL char(50000),
  REFERENCE char(50000),
  source_reference_TYPE CONSTANT "URL",
  ID SEQUENCE(MAX,1) 
)

INTO TABLE  source_reference 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
  ACCESSION_NUMBER FILLER,
  sequence_type_FILLER filler,
  description filler,
  length filler,
  value filler char(500000), 
  ID filler,
  ACCESSION_NUMBER_FILLER filler,
  VERSION filler,
  sequence_type filler,
  DISCRIMINATOR filler,
  CLONE_ID filler,
  REFFIELD1 filler,
  REFERENCE char(50000),
  source_reference_TYPE CONSTANT "URL",
  source_reference_ID SEQUENCE(MAX,1) 
)
 
INTO TABLE provenance 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
  evidence_code CONSTANT "EV-AS-TAS",
  IMMEDIATE_source_ID CONSTANT "4",
  SUPPLYING_source_ID CONSTANT "2",
  ORIGINAL_source_ID CONSTANT "4",
  FULLY_QUALIFIED_CLASS_NAME CONSTANT "gov.nih.nci.cabio_fut.domain.nucleicacidsequence",
  ACCESSION_NUMBER filler POSITION(1),
  sequence_type_FILLER filler,
  description filler,
  length filler,
  value filler char(500000), 
  OBJECT_IDENTIFIER,
  ACCESSION_NUMBER_FILLER filler,
  VERSION filler,
  sequence_type filler,
  CLONE_ID filler,
  REFFIELD1 filler,
  REFFIELD2 filler,
  ID SEQUENCE(MAX,1),
  source_reference_ID SEQUENCE(MAX,1)
 )
 
