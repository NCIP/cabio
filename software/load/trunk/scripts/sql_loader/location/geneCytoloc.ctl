-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/ncbi_unigene/geneCytoPhyloc.txt'
 
APPEND

INTO TABLE cytogenic_location_cytoband 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( gene_ID_ filler POSITION(1),
  STARTCYTO filler,
  chrid filler,
  gene_ID,
  chromosome_ID,
  START_cytoband_LOC_ID,
  END_cytoband_LOC_ID,
  CYTOGENIC_LOCATION_ID "cyto_loc_cytoid.nextval" 
)
