LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/marker/UniSTS.aliases'

APPEND
 
INTO TABLE zstg_marker_alias 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
(id SEQUENCE(MAX,1),
marker_ID,
NAME
)
