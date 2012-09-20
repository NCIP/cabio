LOAD DATA  
 
INFILE '$CABIO_DATA_DIR/pid/dump/uniprot_pathway.dat' 
  
APPEND 
  
INTO TABLE zstg_protein_pathway_from_pid
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|" 
trailing nullcols 
( protein_id,
  short_name,
  long_name
) 
