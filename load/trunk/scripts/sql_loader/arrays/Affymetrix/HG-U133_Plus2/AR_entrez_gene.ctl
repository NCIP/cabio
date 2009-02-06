LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/entrez_gene_out.txt'
 
APPEND
 
INTO TABLE AR_Entrez_Gene
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Entrez_Gene,
genechip_array)
