-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/MoleculeNames.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/MoleculeNames.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/MoleculeNames.txt'
 
APPEND
 
INTO TABLE zstg_moleculeNames
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( 
  molecule_id,
  mtype,
  source_id,
  name_type,
  long_name_type,
  value
)
