LOAD DATA
INFILE '/cabio/cabiodb/cabio_data/ncbi_unigene/geneIdDs2.dat'
APPEND
INTO TABLE database_cross_reference
REENABLE DISABLED_constraints
FIELDS TERMINATED BY "%|"
TRAILING NULLCOLS
(
ID SEQUENCE(MAX,1),
gene_ID,
data_source filler,
CROSS_REFERENCE_ID,
TYPE CONSTANT "gov.nih.nci.cabio.domain.Gene",
source_NAME CONSTANT "LOCUS_LINK_ID",
source_TYPE CONSTANT "Entrez gene"
)

