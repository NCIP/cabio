LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/population_freq_Mapping50K_Hind240.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/population_freq_Mapping50K_Xba240.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/population_freq_Mapping250K_Nsp.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HuMapping/population_freq_Mapping250K_Sty.dat'
 
APPEND
 
INTO TABLE ZSTG_POP_FREQUENCY
 
REENABLE DISABLED_CONSTRAINTS 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
 
(PROBE_SET_ID,
  ETHNICITY,
  ALLELE_A_FREQUENCY,
  ALLELE_B_FREQUENCY,
  HETEROZYGOUS_FREQUENCY)
