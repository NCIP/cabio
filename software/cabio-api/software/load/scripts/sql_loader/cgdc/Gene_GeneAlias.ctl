LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/gene_genealias.dat'
 
APPEND
 
INTO TABLE zstg_gene_genealias_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
ALIAS,
gene_ID_AGAIN filler,
chromosome_ID filler,
TAX_ID filler
)
