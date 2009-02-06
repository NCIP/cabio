LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/genelink.dat'
 
APPEND
 
INTO TABLE zstg_gene_identifiers 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(gene_ID,
  data_source,
  IDENTIFIER)
