LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/rolecodes.dat'
 
APPEND
 
INTO TABLE zstg_rolecode_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
rolecode,
ID)
