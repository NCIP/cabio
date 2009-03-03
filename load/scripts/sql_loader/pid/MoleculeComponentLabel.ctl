-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/MoleculeComponentLabels.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/MoleculeComponentLabels.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/MoleculeComponentLabels.txt'
 
APPEND
 
INTO TABLE zstg_moleculecomponentlabels
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( 
  molecule_id,
  mtype,
  molecule_id_ref,
  source_id,
  label_type,
  value 
)
