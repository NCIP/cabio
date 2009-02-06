LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/OMIM_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/OMIM_out_2.txt'
 
APPEND
 
INTO TABLE ar_omim_id_tmp
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
OMIM_ID,
genechip_array)
