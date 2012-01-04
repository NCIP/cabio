LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/genetic_map_Mapping50K_Hind240.dat'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/genetic_map_Mapping50K_Xba240.dat'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/genetic_map_Mapping250K_Nsp.dat'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/genetic_map_Mapping250K_Sty.dat'
 
APPEND
 
INTO TABLE ZSTG_GENETIC_MAP
 
REENABLE DISABLED_CONSTRAINTS 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
 
(PROBE_SET_ID,
  DISTANCE,
  FIRST_MARKER_ID,
  FIRST_MARKER_NAME,
  SECOND_MARKER_ID,
  SECOND_MARKER_NAME,
  FIRST_SNP_TSC_ID,
  SECOND_SNP_TSC_ID,
  TYPE)