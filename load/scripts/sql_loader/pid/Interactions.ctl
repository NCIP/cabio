-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/pid/Reactome/Interactions.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/BioCarta/Interactions.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/NCI_Nature/Interactions.txt'
 
APPEND
 
INTO TABLE zstg_Interactions
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( interaction_type,
  interaction_id,
  pathway_idref,
  pathway_name,
  external_pathway_id,
  source_id,
  source_name
)
