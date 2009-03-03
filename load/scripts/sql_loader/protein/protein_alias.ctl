LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/protein/protein_alias.dat'
 
APPEND
 
INTO TABLE protein_alias 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(ID	sequence(MAX,1),
  protein_ID "TRIM(:PROTEIN_ID)",
  NAME "TRIM(:NAME)")
