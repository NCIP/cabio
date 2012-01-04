LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/ensembl_out_3.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/ensembl_out_2.txt'
 
APPEND
 
INTO TABLE ar_ensembl_tmp

FIELDS TERMINATED BY "|"
TRAILING NULLCOLS

(Probe_Set_ID,
ENSEMBL_ID,
genechip_array)
