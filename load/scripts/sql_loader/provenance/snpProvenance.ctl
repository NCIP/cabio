-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch1.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch2.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch3.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch4.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch5.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch6.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch7.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch8.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch9.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch10.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch11.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch12.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch13.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch14.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch15.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch16.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch17.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch18.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch19.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch20.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch21.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch22.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_chX.flat.out.ref'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_chY.flat.out.ref'
 
APPEND
 
INTO TABLE URL_source_reference 
REENABLE DISABLED_constraints
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
( source_reference_TYPE CONSTANT "URL",
  DBSNP_RS_ID filler POSITION(1),
  source_URL char(10000),
  REFERENCE char(10000),
  ID SEQUENCE(MAX,1)
)

INTO TABLE source_reference 
REENABLE DISABLED_constraints
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
( source_reference_TYPE CONSTANT "URL",
  DBSNP_RS_ID filler POSITION(1),
  source_URL filler,
  REFERENCE char(10000),
  source_reference_ID SEQUENCE(MAX,1)
)

INTO TABLE provenance 
REENABLE DISABLED_constraints
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
( evidence_code CONSTANT "EV-AS-TAS",
  IMMEDIATE_source_ID CONSTANT "5",
  SUPPLYING_source_ID CONSTANT "2",
  ORIGINAL_source_ID CONSTANT "5",
  FULLY_QUALIFIED_CLASS_NAME CONSTANT "gov.nih.nci.cabio.domain.snp",
  OBJECT_IDENTIFIER SEQUENCE(MAX,1),
  ID SEQUENCE(MAX,1),
  source_reference_ID SEQUENCE(MAX,1)
)
