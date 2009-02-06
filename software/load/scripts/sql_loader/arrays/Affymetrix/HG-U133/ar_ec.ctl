LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/EC_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/EC_out_2.txt'
 
APPEND
 
INTO TABLE AR_EC_TMP
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
EC,
genechip_array)
