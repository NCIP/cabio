LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/cgdc/agent.dat'
 
APPEND
 
INTO TABLE zstg_agent_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
DRUG,
ID,
EVS_ID,
gene_ID filler,
CHR_ID filler,
TAX_ID filler
)
