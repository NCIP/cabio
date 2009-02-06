LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/sequence.dat'
 
APPEND
 
INTO TABLE zstg_hsmm_seq
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(ID,
  ACCESSION_NUMBER,
  VERSION,
  sequence_type,
  DISCRIMINATOR filler,
  CLONE_ID
  )
