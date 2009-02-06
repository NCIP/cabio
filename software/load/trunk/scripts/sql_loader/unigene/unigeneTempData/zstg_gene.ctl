LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/gene.dat'
 
APPEND
 
INTO TABLE zstg_gene 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(gene_ID,
  HUGO_SYMBOL filler,
  gene_SYMBOL,
  gene_TITLE	char(2000),
  chromosome_ID,
  taxon_ID,
cytoband,
start_cytoband, 
end_cytoband 
)
