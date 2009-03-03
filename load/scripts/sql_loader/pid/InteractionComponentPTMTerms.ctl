-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/InteractionComponentPTMTerms.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/InteractionComponentPTMTerms.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/InteractionComponentPTMTerms.txt'
 
APPEND
 
INTO TABLE zstg_InteractionCompPTMTerms
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( interaction_id,
  source_id,
  molecule_id, 
  role_type,
  protein,
  position,
  aa,
  modification
)
