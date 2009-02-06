LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/unigene2gene/gene2accession.txt'

APPEND
 
INTO TABLE zstg_gene2ACCESSION 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
TRAILING NULLCOLS
(tax_id,
GeneID,
status,
RNA_nucleotide_acc,
RNA_nucleotide_gi,
protein_accession,
protein_gi,
genomic_nucleotide_acc,
genomic_nucleotide_gi,
start_position,
end_positon,
orientation)
