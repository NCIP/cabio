LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/RNA_probesets_out_1.txt'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/U133B/RNA_probesets_out_2.txt'
 
APPEND
 
INTO TABLE ar_rna_probesets_affy_tmp 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(ID	sequence(MAX,1),
Probe_Set_ID,
GeneChip_Array_name,
Species_Scientific_Name,
annotation_data,
genome_version
)
