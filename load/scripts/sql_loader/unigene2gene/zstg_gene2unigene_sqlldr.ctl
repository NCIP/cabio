LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/unigene2gene/gene2unigene.txt'
 
APPEND
 
INTO TABLE zstg_gene2UNIGENE
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(GeneID,	
UniGene_cluster
)
