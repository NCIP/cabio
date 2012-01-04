LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/OMIM_out_3.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/OMIM_out_2.txt'
 
APPEND
 
INTO TABLE ar_omim_id_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
OMIM_ID,
genechip_array)
