LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/go_cellular_component_out.txt'
 
APPEND
 
INTO TABLE AR_go_cellular_component
 
FIELDS TERMINATED BY "|"
 
TRAILING NULLCOLS
(probe_set_ID,
accession_number,
description,
evidence,
genechip_array)
