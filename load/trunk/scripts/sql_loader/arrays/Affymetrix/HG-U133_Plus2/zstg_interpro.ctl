LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/interpro_out.txt'
 
APPEND
 
INTO TABLE ZSTG_INTERPRO
 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
 
(PROBE_SET_ID,
 ACCESSION_NUMBER,
 DESCRIPTION char(2000),
 SCORE,
genechip_array)


