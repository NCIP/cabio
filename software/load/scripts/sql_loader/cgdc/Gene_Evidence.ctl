LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/gene_evidence.dat'
 
APPEND
 
INTO TABLE zstg_gene_evidence_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
evidence_ID,
evidencecode_ID
)
