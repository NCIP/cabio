-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/pid/Reactome/InteractionComponentConditions.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/BioCarta/InteractionComponentConditions.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/NCI_Nature/InteractionComponentConditions.txt'
 
APPEND
 
INTO TABLE zstg_InteractionCondition
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( interaction_id,
  source_id,
  condition_type,
  condition 
)
