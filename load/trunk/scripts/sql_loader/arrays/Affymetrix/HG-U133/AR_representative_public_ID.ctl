LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/representative_public_ID_out.txt'
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133/representative_public_ID_out_2.txt'
 
APPEND
 
INTO TABLE AR_Rep_Public_Id_tmp 
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(Probe_Set_ID,
Representative_Public_ID,
genechip_array)
