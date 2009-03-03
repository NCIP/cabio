LOAD DATA 
 
--INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/entrez_gene_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/entrez_gene_out_2.txt'
 
APPEND
 
INTO TABLE AR_Entrez_Gene_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Entrez_Gene,
genechip_array)
