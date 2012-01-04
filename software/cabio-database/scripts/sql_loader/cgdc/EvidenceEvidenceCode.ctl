LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/evidence_evidencecode.dat'
 
APPEND
 
INTO TABLE evidence_evidence_code 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
evidence_ID,
evidence_code_ID
)
