LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/refseq_protein_id_out_3.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U95/refseq_protein_id_out_2.txt'
 
APPEND
 
INTO TABLE AR_Refseq_Protein_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Refseq_Protein_ID,
genechip_array)
