LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/cgdc/MissingAgentEVSIds.dat'
 
APPEND
 
into table zstg_missing_agent_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
DRUG,
MATCHING_concept,
EVS_ID
)
