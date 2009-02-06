LOAD DATA 

-- NCBI Gene Alias
-- HUGO 

INFILE '/cabio/cabiodb/cabio_data/temp/unigene2gene/geneAlias.out'
INFILE '/cabio/cabiodb/cabio_data/temp/unigene2gene/hgncgeneAlias.out'
 
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

