LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/gene_agent.dat'
 
APPEND
 
INTO TABLE zstg_gene_agent_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
agent_ID,
Filler_field filler
)
