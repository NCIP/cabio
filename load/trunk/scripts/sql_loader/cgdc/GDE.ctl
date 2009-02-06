LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/cgdc/gde.dat'
 
APPEND
 
INTO TABLE zstg_gene_disease_evid_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
disease_ID,
evidence_ID,
role_ID
)
