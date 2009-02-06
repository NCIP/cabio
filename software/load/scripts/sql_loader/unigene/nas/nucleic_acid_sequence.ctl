LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/nas.dat_nas_hsmm_revised.dat'
 
APPEND
 
INTO TABLE nucleic_acid_sequence 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
  ACCESSION_NUMBER,
  sequence_type_FILLER filler,
  description, 
  length,
  value char(500000), 
  ID,
  ACCESSION_NUMBER_FILLER filler,
  VERSION,
  sequence_type,
  DISCRIMINATOR,
  CLONE_ID,
  REFFIELD1 filler,
  REFFIELD2 filler
  )
