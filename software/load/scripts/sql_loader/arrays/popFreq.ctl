-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/population_frequency/popFreq.txt'
 
APPEND 

INTO TABLE population_frequency  
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
(
  probeid filler,
  ethnic filler,
  allelefreq filler,
  SNP_PROBESET_AFFY_ID, 
  ETHNICITY,
  MAJOR_FREQUENCY,
  MINOR_FREQUENCY,
  HETEROZYGOUS_FREQUENCY,  
  MAJOR_ALLELE,
  MINOR_ALLELE,
  dbsnpid filler,
  SNP_ID,
  TYPE CONSTANT 'allele',    
  ID SEQUENCE(MAX, 1)  
)
