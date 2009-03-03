LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/clonetaxon.dat'
 
APPEND
 
INTO TABLE clone_taxon 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
CLONE_ID,
taxon_ID  
)
