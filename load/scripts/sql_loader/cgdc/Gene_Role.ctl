LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/cgdc/gene_role.dat'
 
APPEND
 
INTO TABLE zstg_gene_role_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
role_ID
)
