LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/protein/zstg_protein_embl.dat'
 
APPEND
 
INTO TABLE zstg_protein_embl 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(ID	sequence(MAX,1),
 PROTEIN_ID "TRIM(:PROTEIN_ID)",
 ACC_NUM "TRIM(:ACC_NUM)"
)
