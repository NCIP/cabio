LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/geneTv.dat'
 
APPEND
INTO TABLE gene_tv 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(gene_ID,
  HUGO_SYMBOL,
  SYMBOL,
  FULL_NAME	char(2000),
  chromosome_ID,
  taxon_ID,
  cytoband filler,
  start_cytoband filler,
  end_cytoband filler,
  gene_ID_frm_geneidentifiers filler,
  data_source filler,
  CLUSTER_ID,
  REFFIELD1 filler char(50000),
  REFFIELD2 filler char(50000))
