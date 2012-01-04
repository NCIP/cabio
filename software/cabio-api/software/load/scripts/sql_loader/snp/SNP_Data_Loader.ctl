-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch1.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch2.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch3.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch4.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch5.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch6.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch7.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch8.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch9.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch10.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch11.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch12.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch13.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch14.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch15.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch16.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch17.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch18.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch19.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch20.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch21.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_ch22.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_chX.flat.out'
INFILE '$CABIO_DATA_DIR/temp/NCBI_SNP/ds_flat_chY.flat.out'
 
APPEND
 
INTO TABLE snp_tv
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY ","
Trailing nullcols
( DB_SNP_ID POSITION(1),
  SPECIES_NAME filler,
  VALIDATION_STATUS,
  chromosome_NUMBER filler,
  LOCATION filler,
  ALLELE_A,
  ALLELE_B, 
  chromosome_ID,
  ASSEMBLY filler,
  ID
)
