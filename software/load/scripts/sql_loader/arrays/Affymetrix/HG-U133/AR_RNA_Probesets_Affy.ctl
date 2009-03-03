LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/RNA_probesets_out.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/RNA_probesets_out_2.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HG-U133A/RNA_probesets_out_3.txt'
 
APPEND
 
INTO TABLE ar_rna_probesets_affy_tmp 
when GENECHIP_ARRAY_Name <> 'GeneChip Array' 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(ID	sequence(MAX,1),
Probe_Set_ID,
GeneChip_Array_name,
Species_Scientific_Name,
annotation_data
)
