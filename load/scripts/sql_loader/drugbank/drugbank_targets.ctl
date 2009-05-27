LOAD DATA 
 
INFILE "c:/dev/cabio_data/temp/drugbank/out_targets.txt"
 
REPLACE
 
INTO TABLE zstg_drugbank_targets

FIELDS TERMINATED BY X'9'
 
TRAILING NULLCOLS
(
  Target_Id,
  Species_Abbr,
  Gene_Name,
  GenAtlas_ID,
  GeneCard_ID,
  SwissProt_ID,
  HGNC_ID
)
