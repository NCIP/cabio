LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/gene_symbol_out.txt'
 
APPEND
 
INTO TABLE AR_Gene_Symbol 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Gene_Symbol,
genechip_array)
