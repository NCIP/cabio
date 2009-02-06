LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/genesequence.dat'
 
APPEND
 
INTO TABLE gene_nucleic_acid_sequence 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
 
TRAILING NULLCOLS
(gene_ID,
  gene_SEQUENCE_ID)
