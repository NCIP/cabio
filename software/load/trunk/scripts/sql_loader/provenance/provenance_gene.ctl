LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/geneTv.dat'
 
APPEND
 
INTO TABLE gene_tv 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(gene_ID,
  SYMBOL,
  FULL_NAME	char(2000),
  chromosome_ID,
  taxon_ID,
  cytoband filler,
  gene_ID_frm_geneidentifiers filler,
  data_source filler,
  CLUSTER_ID)
