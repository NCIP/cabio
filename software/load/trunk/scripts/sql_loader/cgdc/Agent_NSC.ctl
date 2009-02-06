LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/cgdc/agents.txt'
 
APPEND
 
INTO TABLE zstg_agents_nsc 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY ","
 
TRAILING NULLCOLS
(
NSC_NUMBER,
agent_NAME
)
