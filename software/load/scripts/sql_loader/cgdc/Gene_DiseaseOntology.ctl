LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/gene_disease.dat'
 
APPEND
 
INTO TABLE zstg_gene_diseaseonto_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
disease_ID
)
