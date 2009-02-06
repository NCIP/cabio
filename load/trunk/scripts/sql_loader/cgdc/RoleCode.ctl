LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/cgdc/rolecodes.dat'
 
APPEND
 
INTO TABLE zstg_rolecode_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
rolecode,
ID)
