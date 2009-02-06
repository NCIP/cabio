LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/entrez_gene_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/entrez_gene_out_2.txt'
 
APPEND
 
INTO TABLE AR_Entrez_Gene_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Entrez_Gene,
genechip_array)
