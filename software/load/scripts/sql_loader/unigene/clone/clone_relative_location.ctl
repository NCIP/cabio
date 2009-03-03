LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/nas.dat_nas_hsmm_revised.dat_clone_nas_revised.dat'
 
APPEND
 
INTO TABLE clone_relative_location 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
  ACCESSION_NUMBER filler,
  sequence_type_FILLER filler,
  description filler, 
  length filler,
  value filler char(500000), 
  nucleic_acid_sequence_ID,
  ACCESSION_NUMBER_FILLER filler,
  VERSION filler,
  sequence_type filler,
  DISCRIMINATOR filler,
  CLONE_IDD filler,
  FILLER_FIELD filler,	
  REFFIELD1 filler,
  REFFIELD2 filler,
  taxon_id filler,
  CLONE_ID,
  CLONE_NAME filler,
  unigene_library_ID filler,
  type,
  library_id filler,
  ID SEQUENCE(MAX,1)
  )
