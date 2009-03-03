-- replicates snp_tv_LD PL/SQL
-- Adds data from SNP to provenance, url_source_reference, source_reference, etc
-- Replicates provenance_SNP_LD
LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/pid/Reactome/MoleculeFamilies.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/BioCarta/MoleculeFamilies.txt'
INFILE '$CABIO_DATA_DIR/temp/pid/NCI_Nature/MoleculeFamilies.txt'
 
APPEND
 
INTO TABLE zstg_moleculefamilies
REENABLE DISABLED_constraints 
FIELDS TERMINATED BY "|"
Trailing nullcols
( 
  molecule_id,
  mtype,
  source_id,
  family_molecule_id,
  member_molecule_id
)
