LOAD DATA 

-- NCBI Gene Alias
-- HUGO 

INFILE '$CABIO_DATA_DIR/temp/unigene2gene/geneAlias.out'
INFILE '$CABIO_DATA_DIR/temp/unigene2gene/hgncgeneAlias.out'
 
REPLace
 
INTO TABLE zstg_geneALIAS
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
LOCUSLINKID,
Symbol, 
Synonyms,
TYPE 
)

