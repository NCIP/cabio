LOAD DATA 
 
INFILE 'MissingAgentEVSIds_NSC.dat'
 
APPEND
 
into table zstg_missing_agent_cgid_evs 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
NSC_NUMBER,
DRUG,
EVS_ID
)
