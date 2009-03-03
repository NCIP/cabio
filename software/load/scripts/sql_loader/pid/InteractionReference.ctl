-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/InteractionReferences.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/InteractionReferences.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/InteractionReferences.txt'
 
APPEND
 
INTO TABLE zstg_InteractionReference
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( interaction_id,
  source_id,
  reference,
  pmid 
)
