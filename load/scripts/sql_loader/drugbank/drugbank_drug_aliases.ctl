LOAD DATA 
 
INFILE "c:/dev/cabio_data/temp/drugbank/out_drug_aliases.txt"
 
REPLACE
 
INTO TABLE zstg_drugbank_drug_aliases

FIELDS TERMINATED BY X'9'
 
TRAILING NULLCOLS
(
  Drug_Id,
  Alias_Type,
  Alias_Name
)
