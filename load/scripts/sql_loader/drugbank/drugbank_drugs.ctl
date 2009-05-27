LOAD DATA 
 
INFILE "c:/dev/cabio_data/temp/drugbank/out_drugs.txt"
 
REPLACE
 
INTO TABLE zstg_drugbank_drugs

FIELDS TERMINATED BY X'9'
 
TRAILING NULLCOLS
(  
  Drug_Id,
  Generic_Name,
  Absorption char(500000),
  Biotransformation char(500000),
  CAS_Registry_Number char(500000),
  Chemical_Formula char(500000),
  Half_Life char(500000),
  Indication char(500000),
  Chemical_IUPAC_Name char(500000),
  Mechanism_Of_Action char(500000),
  Molecular_Weight_Avg,
  Pharmacology char(500000),
  Protein_Binding char(500000),
  PubChem_Compound_ID,
  PubChem_Substance_ID,
  Smiles_String_canonical char(500000),
  Toxicity char(500000),
  EVS_Id
)
