LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133_Plus2/gene_title_out.txt'
 
APPEND
 
INTO TABLE AR_Gene_Title 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Gene_Title,
genechip_array)
