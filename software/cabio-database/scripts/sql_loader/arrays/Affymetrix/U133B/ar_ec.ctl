LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/EC_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/EC_out_2.txt'
 
APPEND
 
INTO TABLE AR_EC_TMP
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
EC,
genechip_array)
