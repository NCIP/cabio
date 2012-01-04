LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/unigene2gene/gene2go.txt'

APPEND
 
INTO TABLE zstg_gene2go 
REENABLE DISABLED_constraints  
WHEN TAX_ID = '9606' 
FIELDS TERMINATED BY "	"
TRAILING NULLCOLS
(tax_id POSITION(1) "DECODE(:tax_id,9606,5,10090,6)",
entrez_geneid,
go_id,
evidence,
qualifier,
go_term,
pubmed,
category
)

INTO TABLE zstg_gene2go 
REENABLE DISABLED_constraints  
WHEN TAX_ID = '10090' 
FIELDS TERMINATED BY "	"
TRAILING NULLCOLS
(tax_id POSITION(1) "DECODE(:tax_id,9606,5,10090,6)",
entrez_geneid,
go_id,
evidence,
qualifier,
go_term,
pubmed,
category
)

