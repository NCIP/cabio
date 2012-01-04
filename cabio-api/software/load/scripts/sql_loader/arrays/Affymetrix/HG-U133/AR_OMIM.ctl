LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/OMIM_out.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/OMIM_out_2.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/OMIM_out_3.txt'
 
APPEND
 
INTO TABLE ar_omim_id_tmp
when GENECHIP_ARRAY <> 'GeneChip Array'
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
OMIM_ID,
genechip_array)
