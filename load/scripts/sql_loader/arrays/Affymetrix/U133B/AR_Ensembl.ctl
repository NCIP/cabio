LOAD DATA 
 
--INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/ensembl_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/ensembl_out_2.txt'
 
APPEND
 
INTO TABLE ar_ensembl_tmp

FIELDS TERMINATED BY "|"
TRAILING NULLCOLS

(Probe_Set_ID,
ENSEMBL_ID,
genechip_array)
