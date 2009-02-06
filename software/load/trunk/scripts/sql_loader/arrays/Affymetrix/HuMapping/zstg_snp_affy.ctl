LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/annotations_Mapping50K_Hind240.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/annotations_Mapping50K_Xba240.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/annotations_Mapping250K_Nsp.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/annotations_Mapping250K_Sty.dat'
 
APPEND
 
INTO TABLE ZSTG_SNP_AFFY 
 
REENABLE DISABLED_CONSTRAINTS 
FIELDS TERMINATED BY "," optionally enclosed by '"'
 
(array_name,
Probe_Set_ID,
Affy_SNP_ID,
dbSNP_RS_ID,
Chromosome,
Physical_Position,
Strand,
ChrX_pseudo_autosomal_region,
Cytoband "replace(upper(:chromosome)||:Cytoband,'_','.')",
Flank,
Allele_A,
Allele_B,
Associated_Gene	char(40000),
Genetic_Map char(1000),
Microsatellite,
Fragment_Length_start_stop,
Allele_Freq char(1000),
Het_Freq char(1000),
Num_Chrm char(1000),
In_HAPMAP,
Strand_vs_dbSNP,
Copy_Num_Variation char(4000)
)

