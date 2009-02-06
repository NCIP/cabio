LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/refseq_protein_id_out.txt'
 
APPEND
 
INTO TABLE AR_Refseq_Protein
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Refseq_Protein_ID,
genechip_array)
