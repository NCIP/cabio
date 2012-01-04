-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/InteractionEvidences.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/InteractionEvidences.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/InteractionEvidences.txt'
 
APPEND
 
INTO TABLE zstg_InteractionEvidence
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( interaction_id,
  source_id,
  evidencecode,
  evidencecodeagain filler 
)
