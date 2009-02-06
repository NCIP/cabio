LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/ensembl_out.txt'
 
APPEND
 
INTO TABLE ar_ensembl

FIELDS TERMINATED BY "|"
TRAILING NULLCOLS

(Probe_Set_ID,
ENSEMBL_ID,
genechip_array)
