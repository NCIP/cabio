LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/histo/gene_histo.txt'
APPEND
 
INTO TABLE gene_histopathology 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( gene_ID,
  context_CODE
)
