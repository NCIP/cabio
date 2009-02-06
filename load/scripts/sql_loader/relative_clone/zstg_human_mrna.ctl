LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/all_mrna_human_stage.dat'
 
APPEND
 
INTO TABLE zstg_human_mrna 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
(qname, tname, tstart, tend, chromosome_no, chromosome_id)

