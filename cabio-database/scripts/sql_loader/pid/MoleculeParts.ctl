-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/MoleculeParts.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/MoleculeParts.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/MoleculeParts.txt'
 
APPEND
 
INTO TABLE zstg_moleculeparts
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( 
  molecule_id,
  mtype,
  source_id,
  whole_molecule_id,
  part_molecule_id,
  mstart,
  mstop 
)
