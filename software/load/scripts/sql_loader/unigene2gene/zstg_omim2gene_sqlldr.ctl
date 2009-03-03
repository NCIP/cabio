LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/unigene2gene/mim2gene.txt'
 
APPEND
 
INTO TABLE zstg_omim2gene
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(omim_number,
GeneID,
Type)
