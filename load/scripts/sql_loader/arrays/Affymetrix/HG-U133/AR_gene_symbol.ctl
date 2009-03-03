LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/gene_symbol_out.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/gene_symbol_out_2.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/gene_symbol_out_3.txt'
 
APPEND
 
INTO TABLE AR_Gene_Symbol_tmp 
when GENECHIP_ARRAY <> 'GeneChip Array'
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Gene_Symbol,
genechip_array)
