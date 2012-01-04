LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/refseq/hs_refseq.dat'
INFILE '$CABIO_DATA_DIR/refseq/mm_refseq.dat'
 
APPEND
 
INTO TABLE ZSTG_REFSEQ_MRNA
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
  REFSEQ_ACCESSION,
  GI_ACCESSION,
  description, 
  taxon,
  seq char(500000)
  )
  

