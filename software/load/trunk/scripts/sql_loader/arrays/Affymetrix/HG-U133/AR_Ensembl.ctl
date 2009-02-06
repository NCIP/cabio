LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/ensembl_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/ensembl_out_2.txt'
 
APPEND
 
INTO TABLE ar_ensembl_tmp

FIELDS TERMINATED BY "|"
TRAILING NULLCOLS

(Probe_Set_ID,
ENSEMBL_ID,
genechip_array)
