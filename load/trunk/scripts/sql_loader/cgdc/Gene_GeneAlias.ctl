LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/cgdc/gene_genealias.dat'
 
APPEND
 
INTO TABLEzstg_gene_genealias_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
gene_ID,
ALIAS,
gene_ID_AGAIN filler,
chromosome_ID filler,
TAX_ID filler
)
