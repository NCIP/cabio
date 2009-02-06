LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/interpro_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/interpro_out_2.txt'
 
APPEND
 
INTO TABLE ZSTG_INTERPRO_TMP
 
FIELDS TERMINATED BY "|"
TRAILING NULLCOLS
 
(PROBE_SET_ID,
 ACCESSION_NUMBER,
 DESCRIPTION char(2000),
 SCORE,
genechip_array)


