LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/clone.dat'
 
APPEND
 
INTO TABLE zstg_clone 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(taxon_id,
CLONE_ID,
CLONE_NAME,
unigene_library_ID,
relative_type,
library_id
  )
