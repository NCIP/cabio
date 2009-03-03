LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/genelink.dat'
 
APPEND
 
INTO TABLE zstg_gene_identifiers 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(gene_ID,
  data_source,
  IDENTIFIER)
