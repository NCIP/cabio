LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/arrays/Illumina/HumanHap550K/HumanHap550v3_Gene_Annotation.txt'
 
APPEND
 
INTO TABLE ZSTG_SNP_ILLUMINA
 
REENABLE DISABLED_CONSTRAINTS 
FIELDS TERMINATED BY "\t"
TRAILING NULLCOLS

(
DBSNP_RS_ID,
CHROMOSOME,
COORDINATE,
GENOME_BUILD,
GENE_SYMBOL,
GENE_ACCESSION,
LOCATION "decode(:LOCATION,'flanking_3UTR', 'downstream', 'flanking_5UTR', 'upstream', 'coding', 'CDS', :LOCATION)",
LOCATION_RELATIVE_TO_GENE "decode (substr(:location_relative_to_gene,0,1),'-', substr(:location_relative_to_gene,2),:location_relative_to_gene)",
CODING_STATUS "decode(:coding_status, '-1', null, :coding_status)",
AMINO_ACID_CHANGE "decode(:amino_acid_change,'-1',null,:amino_acid_change)",
ID_WITH_MOUSE,
PHAST_CONSERVATION "decode(:phast_conservation,'-1',null,:phast_conservation)"
)
