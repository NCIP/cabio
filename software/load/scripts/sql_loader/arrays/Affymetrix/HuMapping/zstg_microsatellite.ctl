LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/microsatellite_Mapping50K_Hind240.dat'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/microsatellite_Mapping50K_Xba240.dat'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/microsatellite_Mapping250K_Nsp.dat'
INFILE '$CABIO_DATA_DIR/temp/arrays/Affymetrix/HuMapping/microsatellite_Mapping250K_Sty.dat'
 
APPEND
 
INTO TABLE ZSTG_MICROSATELLITE
 
REENABLE DISABLED_CONSTRAINTS 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
 
(PROBE_SET_ID,
  DISTANCE,
  MARKER,
  RELATIVE_POSITION)
  