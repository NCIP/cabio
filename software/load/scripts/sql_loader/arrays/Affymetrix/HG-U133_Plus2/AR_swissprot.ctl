LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/swissprot_out.txt'
 
APPEND
 
INTO TABLE ar_swissprot
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
swissprot_ID,
genechip_array)
