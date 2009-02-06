LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/histo/gene_histo.txt'
APPEND
 
INTO TABLE gene_histopathology 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
( gene_ID,
  context_CODE
)
