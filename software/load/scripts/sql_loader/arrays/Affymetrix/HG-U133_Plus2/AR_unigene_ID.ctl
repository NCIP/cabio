LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133_Plus2/unigene_ID_out.txt'
 
APPEND
 
INTO TABLE AR_Unigene_ID
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
unigene_ID,
genechip_array)
