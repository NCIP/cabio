LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/unigene2gene/Homo_sapiens.gene_info'
INFILE '$CABIO_DATA_DIR/unigene2gene/Mus_musculus.gene_info'
 
APPEND
 
INTO TABLE zstg_entrez_gene 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "**" 
TRAILING NULLCOLS
(tax_id "DECODE(:tax_id, 9606,5,10090,6)",
entrez_id,
symbol,
locus_tag,
synonyms,
dbxref,
chr,
chr_map_location,
description,
type_of_gene,
symbol_from_nom_auth,
fullname_from_nom_auth,
nomenclature_status,
other_designations filler char(50000),
modification_date filler
)

