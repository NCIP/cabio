LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/go_molecular_function_out.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/go_molecular_function_out_2.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/go_molecular_function_out_3.txt'
 
APPEND
 
INTO TABLE AR_go_molecular_function_tmp
when GENECHIP_ARRAY <> 'GeneChip Array'
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(probe_set_ID,
accession_number,
description,
evidence,
genechip_array)
