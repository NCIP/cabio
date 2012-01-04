LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/gae.dat'
 
APPEND
 
INTO TABLE zstg_gene_agent_evidence_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
agent_ID,
evidence_ID,
role_ID
)
