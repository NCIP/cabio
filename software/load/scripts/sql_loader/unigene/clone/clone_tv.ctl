LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/clone.dat'
 
APPEND
 
INTO TABLE clone_tv 
REENABLE DISABLED_constraints  
WHEN (library_ID <> '') 
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(
taxon_id filler,
CLONE_ID,
CLONE_NAME,
unigene_library_ID filler,
relative_type filler,
library_ID,
TYPE "DECODE(SUBSTR(:CLONE_NAME,1,5), 'IMAGE', 'IMAGE', NULL)" 
  )
