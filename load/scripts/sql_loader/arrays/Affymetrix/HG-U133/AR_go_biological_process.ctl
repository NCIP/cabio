LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/go_biological_process_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/go_biological_process_out_2.txt'
 
APPEND
 
INTO TABLE AR_go_biological_process_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(probe_set_ID,
accession_number,
description,
evidence,
genechip_array)
