LOAD DATA 
 
INFILE "c:/dev/cabio_data/temp/drugbank/out_drug_targets.txt"
 
REPLACE
 
INTO TABLE zstg_drugbank_drug_targets

FIELDS TERMINATED BY X'9'
 
TRAILING NULLCOLS
(
  Target_Id,
  Drug_Id,
  PubMed_Id
)
