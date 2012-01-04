LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/evidencecode.dat'
 
APPEND
 
INTO TABLE evidence_code 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
evidence_code,
ID)
