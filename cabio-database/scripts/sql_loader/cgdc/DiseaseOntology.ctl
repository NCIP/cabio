LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/cgdc/diseaseontology.dat'
 
APPEND
 
INTO TABLE zstg_diseaseontology_cgid 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(
diseaseontology,
ID,
EVS_ID,
gene_ID filler,
CHR_ID filler,
TAX_ID filler
)
