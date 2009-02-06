LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/protein/new_protein.dat'
 
APPEND
 
INTO TABLE new_protein 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(PROTEIN_ID "TRIM(:PROTEIN_ID)",
  PRIMARY_ACCESSION "TRIM(:PRIMARY_ACCESSION)",
  UNIPROTCODE "TRIM(:UNIPROTCODE)",
  Name char(2000) "TRIM(:NAME)",
  COPYRIGHTSTATEMENT constant 'This Swiss-Prot entry is copyright. There are no  restrictions on  its use as long as its content is in no way modified and this statement is not removed.')


