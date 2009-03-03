LOAD DATA 
 
--INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/go_biological_process_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/go_biological_process_out_2.txt'
 
APPEND
 
INTO TABLE AR_go_biological_process_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(probe_set_ID,
accession_number,
description,
evidence,
genechip_array)
