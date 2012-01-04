LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/entrez_gene_out.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/entrez_gene_out_2.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/entrez_gene_out_3.txt'
 
APPEND
 
INTO TABLE AR_Entrez_Gene_tmp
when GENECHIP_ARRAY <> 'GeneChip Array'
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Entrez_Gene,
genechip_array)
