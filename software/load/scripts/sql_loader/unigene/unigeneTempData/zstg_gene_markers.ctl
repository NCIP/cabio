LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/geneMarker.dat'
 
APPEND
 
INTO TABLE zstg_gene_markers 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(gene_ID,
filler_field filler,
marker_ID)
