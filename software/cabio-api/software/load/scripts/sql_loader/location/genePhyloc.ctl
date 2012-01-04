-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/ncbi_unigene/phylocGene.txt'
APPEND
 
INTO TABLE physical_location 
FIELDS TERMINATED BY "#"
TRAILING NULLCOLS
( gene_ID POSITION(1),
  SYMBOL filler,
  CHROMOSOMAL_START_POSITION,
  FTYPE filler,
  GLABEL filler,
  gene_ID_AGAIN filler,
  SYMBOL_AGAIN filler,
  UCLUSTER filler,
  taxon_ID filler,
  chromosome_ID,
  CHR_START_POSITION filler,
  CHROMOSOMAL_END_POSITION,
  ID SEQUENCE(MAX,1)
)

INTO TABLE location_ch 
FIELDS TERMINATED BY "#"
TRAILING NULLCOLS
( gene_ID POSITION(1),
  SYMBOL filler,
  CHROMOSOMAL_START_POSITION,
  FTYPE filler,
  GLABEL filler,
  gene_ID_AGAIN filler,
  SYMBOL_AGAIN filler,
  UCLUSTER filler,
  taxon_ID filler,
  chromosome_ID,
  CHR_START_POSITION filler,
  CHROMOSOMAL_END_POSITION,
  FEATURE_TYPE,
  ASSEMBLY,
  DISCRIMINATOR CONSTANT "GenePhysicalLocation",
  ID SEQUENCE(MAX,1)
)


INTO TABLE location_tv 
FIELDS TERMINATED BY "#"
TRAILING NULLCOLS
( gene_ID POSITION(1),
  SYMBOL filler,
  CHROMOSOMAL_START_POSITION filler,
  FTYPE filler,
  GLABEL filler,
  gene_ID_AGAIN filler,
  SYMBOL_AGAIN filler,
  UCLUSTER filler,
  taxon_ID filler,
  chromosome_ID,
  CHR_START_POSITION filler,
  CHROMOSOMAL_END_POSITION filler,
  ID SEQUENCE(MAX,1)
)

