-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio_fut/cabio_futdb/cabio_fut_data/temp/relativeLocation/relLoc2.txt'
 
APPEND 

INTO TABLE relative_location_ch  
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
(
  BIG_ID,	 
  ID,
  ORIENTATION,
  TYPE, 	
  DISTANCE, 
  gene_ID, 
  SNP_ID,
  PROBE_SET_ID,
  DISCRIMINATOR
)


INTO TABLE relative_location  
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
(
  BIG_ID,	 
  ID,
  ORIENTATION,
  TYPE filler, 	
  DISTANCE, 
  gene_ID filler, 
  SNP_ID,
  PROBE_SET_ID filler,
  DISCRIMINATOR filler
)
