LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/representative_public_ID_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/representative_public_ID_out_2.txt'
 
APPEND
 
INTO TABLE AR_Rep_Public_Id_tmp 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Representative_Public_ID,
genechip_array)
