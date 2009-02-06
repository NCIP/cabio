LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/clonetaxon.dat'
 
APPEND
 
INTO TABLE clone_taxon 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
CLONE_ID,
taxon_ID  
)
