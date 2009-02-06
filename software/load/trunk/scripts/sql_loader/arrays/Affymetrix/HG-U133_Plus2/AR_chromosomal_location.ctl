LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/arrays/Affymetrix/HG-U133_Plus2/chromosomal_location_out.txt'
 
APPEND
 
INTO TABLE ar_chromosomal_location
 
FIELDS TERMINATED BY ","
 
TRAILING NULLCOLS
(Probe_Set_ID,
buffer_field filler,
chromosomal_location,
cyto_start ,
cyto_stop ,
chromosome_number,
trim_chr,
assembly,
genechip_array,
chromosome_id)
