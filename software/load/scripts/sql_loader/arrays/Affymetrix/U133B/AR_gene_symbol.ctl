LOAD DATA 
 
--INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/gene_symbol_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/gene_symbol_out_2.txt'
 
APPEND
 
INTO TABLE AR_Gene_Symbol_tmp 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Gene_Symbol,
genechip_array)
