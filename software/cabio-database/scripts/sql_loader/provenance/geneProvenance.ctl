LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/ncbi_unigene/geneTv.dat'
 
APPEND
INTO TABLE source_reference 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(gene_ID filler,
  SYMBOL filler,
  FULL_NAME	filler char(2000),
  chromosome_ID filler,
  taxon_ID filler,
  cytoband filler,
  gene_ID_frm_geneidentifiers filler,
  data_source filler,
  CLUSTER_ID filler,
  REFERENCE char(50000),
  source_reference_FILLER filler char(50000),
  source_reference_TYPE CONSTANT "URL",
  source_reference_ID SEQUENCE(MAX,1))
 
INTO TABLE URL_source_reference 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(gene_ID filler POSITION(1),
  SYMBOL filler,
  FULL_NAME filler char(2000),
  chromosome_ID filler,
  taxon_ID filler,
  cytoband filler,
  gene_ID_frm_geneidentifiers filler,
  data_source filler,
  CLUSTER_ID filler,
  source_URL char(50000),
  REFERENCE char(50000),
  source_reference_TYPE CONSTANT "URL",
  ID SEQUENCE(MAX,1))

INTO TABLE provenance 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
( evidence_code CONSTANT "EV-AS-TAS",
  IMMEDIATE_source_ID CONSTANT "3",
  SUPPLYING_source_ID CONSTANT "2",
  ORIGINAL_source_ID CONSTANT "3",
  FULLY_QUALIFIED_CLASS_NAME CONSTANT "gov.nih.nci.cabio.domain.Gene", 
  OBJECT_IDENTIFIER POSITION(1),
  SYMBOL filler,
  FULL_NAME filler char(2000),
  chromosome_ID filler,
  taxon_ID filler,
  cytoband filler,
  gene_ID_frm_geneidentifiers filler,
  data_source filler,
  CLUSTER_ID filler,
  source_URL filler char(50000),
  REFERENCE filler char(50000),
  ID SEQUENCE(MAX,1),
  source_reference_ID SEQUENCE(MAX,1))

