-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/pid/Reactome/PathwayComponent.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/BioCarta/PathwayComponent.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/NCI_Nature/PathwayComponent.txt'
 
APPEND
 
INTO TABLE zstg_pathwaycomponents
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( pathway_id,
  source_id,
  interaction_id 
)
