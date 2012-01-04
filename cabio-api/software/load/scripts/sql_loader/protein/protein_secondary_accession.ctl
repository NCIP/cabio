LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/protein/protein_secondary_accession.dat'
 
APPEND
 
INTO TABLE protein_secondary_accession 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(ID	sequence(MAX,1),
  PROTEIN_ID "TRIM(:PROTEIN_ID)",
  SECONDARY_ACCESSION "TRIM(:SECONDARY_ACCESSION)")
