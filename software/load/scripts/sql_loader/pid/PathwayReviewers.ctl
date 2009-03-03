-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/PathwayReviewers.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/PathwayReviewers.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/PathwayReviewers.txt'
 
APPEND
 
INTO TABLE zstg_pathwayreviewers
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( pathway_id,
  source_id,
  reviewer_name
)
