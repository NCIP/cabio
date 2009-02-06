LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/EC_out.txt'
 
APPEND
 
INTO TABLE AR_EC
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
EC,
genechip_array)
