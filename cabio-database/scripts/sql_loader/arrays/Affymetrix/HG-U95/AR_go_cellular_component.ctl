LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/go_cellular_component_out_3.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/go_cellular_component_out_2.txt'
 
APPEND
 
INTO TABLE AR_go_cellular_component_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(probe_set_ID,
accession_number,
description,
evidence,
genechip_array)
