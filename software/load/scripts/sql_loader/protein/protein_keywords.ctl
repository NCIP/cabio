LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/protein/protein_keywords.dat'
 
APPEND
 
INTO TABLE protein_keywords 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(ID	sequence(MAX,1),
  PROTEIN_ID "TRIM(:PROTEIN_ID)",
KEYWORD "TRIM(:KEYWORD)")
