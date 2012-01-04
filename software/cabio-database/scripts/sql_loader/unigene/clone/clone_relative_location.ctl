LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/clone_seq_end.dat'
 
APPEND
 
INTO TABLE clone_relative_location 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
  CLONE_ID,
  nucleic_acid_sequence_ID,
  type,
  ID SEQUENCE(MAX,1)
  )
