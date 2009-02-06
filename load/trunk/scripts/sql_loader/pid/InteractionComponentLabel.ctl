-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/pid/Reactome/InteractionComponentLabels.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/BioCarta/InteractionComponentLabels.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/NCI_Nature/InteractionComponentLabels.txt'
 
APPEND
 
INTO TABLE zstg_InteractionComponentLabel
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( interaction_id,
  source_id,
  molecule_id,
  role_type,
  label_type,
  value 
)
