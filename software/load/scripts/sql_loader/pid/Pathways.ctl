-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/Pathways.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/Pathways.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/Pathways.txt'
 
APPEND
 
INTO TABLE zstg_pathways
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( organism,
  pathway_id,
  subnet,
  longname,
  shortname,
  source_id
)
