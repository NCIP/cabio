LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/geneMarker.dat'
 
APPEND
 
INTO TABLE zstg_gene_markers 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(gene_ID,
filler_field filler,
marker_ID)
