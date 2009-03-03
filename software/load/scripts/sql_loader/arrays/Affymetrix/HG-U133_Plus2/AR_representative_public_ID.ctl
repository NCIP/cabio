LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133_Plus2/representative_public_ID_out.txt'
 
APPEND
 
INTO TABLE AR_Representative_Public_Id 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Representative_Public_ID,
genechip_array)
