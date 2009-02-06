-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch1.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch2.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch3.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch4.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch5.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch6.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch7.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch8.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch9.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch10.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch11.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch12.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch13.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch14.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch15.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch16.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch17.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch18.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch19.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch20.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch21.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_ch22.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_chX.flat.out.phyloc'
INFILE '/cabio/cabiodb/cabio_data/temp/NCBI_SNP/ds_flat_chY.flat.out.phyloc'
 
APPEND
 
INTO TABLE physical_location 
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
( DBSNP_RS_ID filler POSITION(1),
  chromosome_ID,
  CHROMOSOMAL_START_POSITION,
  CHROMOSOMAL_END_POSITION,
  ASSEMBLY filler,
  SNP_ID,
  ID SEQUENCE(MAX,1)
)

INTO TABLE location_ch 
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
( DBSNP_RS_ID filler POSITION(1),
  chromosome_ID,
  CHROMOSOMAL_START_POSITION,
  CHROMOSOMAL_END_POSITION,
  ASSEMBLY,
  SNP_ID, 
  DISCRIMINATOR CONSTANT "SNPPhysicalLocation",
  FEATURE_TYPE CONSTANT "SNP",
  ID SEQUENCE(MAX,1)
)


INTO TABLE location_tv 
FIELDS TERMINATED BY ","
TRAILING NULLCOLS
( DBSNP_RS_ID filler POSITION(1),
  chromosome_ID,
  CHROMOSOMAL_START_POSITION filler,
  CHROMOSOMAL_END_POSITION filler,
  ASSEMBLY filler,
  SNP_ID,
  ID SEQUENCE(MAX,1)
)

