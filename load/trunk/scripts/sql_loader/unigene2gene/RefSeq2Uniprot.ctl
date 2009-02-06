LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/unigene2gene/gene_refseq_uniprotkb_collab.txt'
 
APPEND
 
INTO TABLE ZSTG_REFSEQ2UNIPROT
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(
REFSEQ_PROTID,
UNIPROT_ACCNO 
)

