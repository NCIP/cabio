LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/go_molecular_function_out.txt'
 
APPEND
 
INTO TABLE AR_go_molecular_function
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(probe_set_ID,
accession_number,
description,
evidence,
genechip_array)
