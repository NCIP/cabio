LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/protein/protein_sequence.dat'
 
APPEND
 
INTO TABLE protein_sequence 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(ID sequence(MAX, 1),
DALTONWEIGHT "TRIM(:DALTONWEIGHT)",
  CHECKSUM "TRIM(:CHECKSUM)",
  PROTEIN_ID "TRIM(:PROTEIN_ID)",
  VALUE		char(50000) ,
  LENGTH "TRIM(:LENGTH)")
