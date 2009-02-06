-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/pid/Reactome/PathwayCurators.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/BioCarta/PathwayCurators.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/pid/NCI_Nature/PathwayCurators.txt'
 
APPEND
 
INTO TABLE zstg_pathwaycurators
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( pathway_id,
  source_id,
  curator_name
)
