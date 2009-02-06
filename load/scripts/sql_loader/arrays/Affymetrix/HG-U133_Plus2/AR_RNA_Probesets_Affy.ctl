LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/RNA_probesets_out.txt'
 
APPEND
 
INTO TABLE ar_rna_probesets_affy 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(ID	sequence(MAX,1),
Probe_Set_ID,
GeneChip_Array_name,
Species_Scientific_Name,
annotation_data
)
